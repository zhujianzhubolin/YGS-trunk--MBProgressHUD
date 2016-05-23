//
//  ZJEditingSourceVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/14.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef NS_ENUM(NSUInteger,AlertViewTag) {
    AlertViewTagTmpSwitch = 1000,
    AlertViewTagBackVc,
    AlertViewTagNextNoEditing,
    AlertViewTagEditingImgLarger,
    AlertViewTagEditingImgLargerMax
};

#define ZJEditingColCellID @"ZJEditingTemplateCellID"
#define TEXTV_STARTTAG 1000 //文本框起始的tag
#define TEXTNUMBER_MAX 3 //文本输入框的个数，目前最大可设置3个
#define IMG_SIZE_LIMIT 5 //原图限制大小，多少M会有提示
#define IMG_SIZE_MAX_LIMIT 12 //原图限制最大可以传多大
#define TXT_ROW_HEIGHT 30 //一行文本的高度
#define TXT_ROW_INTEVER 3 //textView之间的间距

#import "ZJEditingSourceVC.h"
#import "ZJEditingTemplateCell.h"
#import "ZJEditingOriginalV.h"
#import "ZJEditingV.h"
#import "ZJEditingHandler.h"
#import "UserManager.h"
#import <UIImageView+AFNetworking.h>
#import "UITextView+wrapper.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import "ZYTextInputBar.h"
#import "ZJXiaoMiPublishTBVC.h"
#import "VPImageCropperViewController.h"

@interface ZJEditingSourceVC ()<UITableViewDataSource,
                                UITableViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout,
                                UIAlertViewDelegate,
                                UIImagePickerControllerDelegate,
                                VPImageCropperDelegate,
                                UIActionSheetDelegate,
                                UITextViewDelegate>

@property (nonatomic,strong) UICollectionView *headerCollectionV;
@property (nonatomic,strong) UITableView *editingTB;
@property (nonatomic,strong) ZJEditingV *editingV; //素材模板切换视图
@property (nonatomic,strong) ZJEditingOriginalV *originalV; //素材原图
@property (nonatomic,strong) UIButton *revokeBtn;  //撤销按钮
@property (nonatomic,strong) UIButton *previewBtn; //预览按钮
@property (nonatomic,strong) UIView *bottomUnfoldV; //底部展开视图
@property (nonatomic,strong) UIView *footerV; //包含撤销和预览的底部视图

@end

@implementation ZJEditingSourceVC
{
    NSMutableArray *adTemplateArr;
    CGFloat footerBtnWidth;
    CGFloat footerBtnHeight;
    NSIndexPath *tmpSeletedIndex; //点击的模版索引
    NSIndexPath *tmpEmaySeletedIndex; //点击后可能成为的模版索引
    
    MultiShowing *multiShow;
    ZJXiaoMiTemplateM *recvTmpM; //模板后台合成后生成的数据模型
    NSUInteger textVCount; //当前textView的个数
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    [self registerNotification];
    [self requestForGetTemplateListData];
    self.bottomUnfoldV.hidden = YES;
    self.footerV.hidden = YES;
}

- (void)dealloc {
    [_revokeBtn removeObserver:self forKeyPath:@"enabled"];
    
    for (int i = 0; i < TEXTNUMBER_MAX; i++) {
        UITextView *textV = (UITextView *)[_bottomUnfoldV viewWithTag:TEXTV_STARTTAG + i];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:textV];
    }
    _headerCollectionV = nil;
    _editingTB = nil;
    _editingV = nil;
    _originalV = nil;
    _revokeBtn = nil;
    _previewBtn = nil;
    _bottomUnfoldV = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    self.title = @"素材编辑";
    recvTmpM = [ZJXiaoMiTemplateM new];
    tmpSeletedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    tmpEmaySeletedIndex = [tmpSeletedIndex copy];
    footerBtnWidth = 70;
    footerBtnHeight = footerBtnWidth *2 /5;
    multiShow = [MultiShowing new];
    [self initDataForTemplateArr];
}

- (void)initDataForTemplateArr {
    ZJXiaoMiTemplateM *firstM = [ZJXiaoMiTemplateM new];
    firstM.templateImgSrcSlt = @"touxiang";
    adTemplateArr = [NSMutableArray arrayWithObject:firstM];
}

-(void)initUI
{
    [self setupNavinationItem];
    [self setupTBHeader];
    [self setupOriginalV];
    [self setupTBFooter];
}

- (void)setupNavinationItem {
    __weak typeof(self)weakSelf = self;
    [self.navigationItem addLeftItemWithImgName:@"backIcon" action:^{
        [weakSelf clickForNavigationItemBack];
    }];
    
    UIButton *rigthBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rigthBtn.frame =CGRectMake(0, 0, footerBtnWidth, footerBtnHeight);
    rigthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rigthBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rigthBtn setTitleColor:[UIColor orangeColor]
                   forState:UIControlStateNormal];
    [rigthBtn addTarget:self action:@selector(clickForBtnNextStep) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
}

- (void)setupTBFooter {
    CGFloat btnTitleFont = 14;

    self.revokeBtn = [UIButton addWithFrame:CGRectMake(G_INTERVAL, self.footerV.frame.size.height - footerBtnHeight, footerBtnWidth, footerBtnHeight)
                                     textColor:[AppUtils colorWithHexString:@"8acae0"]
                                      fontSize:0
                                       imgName:nil
                                          text:@"撤销"];
    
    self.revokeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:btnTitleFont];
    [self.revokeBtn addTarget:self action:@selector(clickForBtnRevoke) forControlEvents:UIControlEventTouchUpInside];
    self.revokeBtn.layer.masksToBounds=YES;
    self.revokeBtn.layer.cornerRadius=5;
    [self.revokeBtn.layer setBorderWidth:1];
    [self.revokeBtn addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    [self.footerV addSubview:self.revokeBtn];
    
    self.previewBtn = [UIButton addWithFrame:CGRectMake(self.view.frame.size.width - G_INTERVAL - footerBtnWidth, self.revokeBtn.frame.origin.y, self.revokeBtn.frame.size.width, self.revokeBtn.frame.size.height)
                                        textColor:[UIColor whiteColor]
                                         fontSize:0
                                          imgName:nil
                                             text:@"预览"];
    self.previewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:btnTitleFont];
    [self.previewBtn addTarget:self action:@selector(clickForBtnPreview) forControlEvents:UIControlEventTouchUpInside];
    self.previewBtn.layer.masksToBounds=YES;
    self.previewBtn.layer.cornerRadius=5;
    [self.previewBtn.layer setBorderWidth:1];
    [self.footerV addSubview:self.previewBtn];
    
    [self updateUIStateForRevocAndPreviewBtn];
    self.editingTB.tableFooterView=self.footerV;
}

- (void)setupTBHeader {
    UIView *headerV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self itemWidth] + G_INTERVAL *4)];
    self.editingTB.tableHeaderView=headerV;
    
    UICollectionViewFlowLayout *colLayout = [[UICollectionViewFlowLayout alloc] init];
    colLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    colLayout.minimumLineSpacing = G_INTERVAL;
    colLayout.minimumInteritemSpacing = G_INTERVAL;
    _headerCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, G_INTERVAL, self.view.frame.size.width, [self itemWidth] + G_INTERVAL*2) collectionViewLayout:colLayout];
    _headerCollectionV.bounces = NO;
    _headerCollectionV.backgroundColor = [UIColor whiteColor];
    _headerCollectionV.dataSource = self;
    _headerCollectionV.delegate = self;
    [_headerCollectionV registerNib:[UINib nibWithNibName:@"ZJEditingTemplateCell" bundle:nil]
         forCellWithReuseIdentifier:ZJEditingColCellID];
    _headerCollectionV.showsVerticalScrollIndicator = NO;
    _headerCollectionV.showsHorizontalScrollIndicator = NO;
    [self.editingTB.tableHeaderView addSubview:_headerCollectionV];
}

- (void)setupOriginalV {
    self.originalV = [[[NSBundle mainBundle] loadNibNamed:@"ZJEditingOriginalV" owner:nil options:nil] lastObject];
    self.originalV.frame = self.editingV.bounds;
    UITapGestureRecognizer *originalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickForTapAddOriginalImg)];
    [self.originalV addGestureRecognizer:originalTap];
    [self.editingV addSubview:self.originalV];
}

- (CGFloat)itemWidth {
    CGFloat eachRowCount = 4.7;
    CGFloat itemWidth = (self.view.frame.size.width - G_INTERVAL *(eachRowCount + 1)) / eachRowCount;
    return itemWidth;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectTemplateSwitchForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.editingTB.tableFooterView.hidden = NO;
        self.bottomUnfoldV.hidden= YES;
    }
    else {
        self.editingTB.tableFooterView.hidden = YES;
        self.bottomUnfoldV.hidden= NO;
    }
    
    tmpSeletedIndex = indexPath;
    ZJEditingTemplateCell *cell = (ZJEditingTemplateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [adTemplateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZJEditingTemplateCell *tmpCell = (ZJEditingTemplateCell *)[self.headerCollectionV cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:indexPath.section]];
        tmpCell.layer.borderWidth = 0;
    }];
    
    [self updateUIStateForColCell:cell forIndexPath:indexPath];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self updateUIStateForRevocAndPreviewBtn];
}

- (BOOL)textViewHasEdited {
    BOOL isTextVHasEdit = NO;
    for (int i = 0; i < textVCount; i++) {
        UITextView *textV = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG + i];
        if (textV && textV.text.length > 0) {
            isTextVHasEdit = YES;
            break;
        }
    }
    return isTextVHasEdit;
}

- (void)pushToUploadImgVCWithImg:(UIImage *)img {
    [AppUtils showProgressMessage:@"上传中"];
    ZJEditingHandler *zjEidingH = [ZJEditingHandler new];
    
    [zjEidingH ZJ_RequestForUploadImg:img success:^(id obj) {
        ZJXiaoMiTemplateM *tmpM = obj;
        ZJXiaoMiPublishTBVC *publishVC = [[ZJXiaoMiPublishTBVC alloc] init];
        publishVC.templateM = tmpM;
        [self.navigationController pushViewController:publishVC animated:YES];
        [AppUtils dismissHUD];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
    }];
}

- (void)pushToPublishVC {
    ZJXiaoMiPublishTBVC *publishVC = [ZJXiaoMiPublishTBVC new];
    publishVC.templateM = adTemplateArr[tmpSeletedIndex.row];
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Lazy loading
- (UIView *)footerV {
    if (!_footerV) {
        _footerV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, footerBtnHeight + G_INTERVAL)];
        _footerV.backgroundColor = [AppUtils colorWithHexString:@"efefeb"];
    }
    return _footerV;
}

- (UIView *)bottomUnfoldV {
    if (_bottomUnfoldV == nil) {
        _bottomUnfoldV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.editingTB.tableFooterView.frame.size.height, self.view.frame.size.width, self.editingTB.tableFooterView.frame.size.height)];
        _bottomUnfoldV.backgroundColor = [AppUtils colorWithHexString:@"eeefea"];
        
        UIButton *unfoldBtn = [UIButton addWithFrame:CGRectZero
                                           textColor:[UIColor orangeColor]
                                            fontSize:FONT_SIZE
                                             imgName:@"putAway"
                                                text:@"收起"];
        unfoldBtn.layer.cornerRadius = 5;
        unfoldBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        unfoldBtn.layer.borderWidth = 2;
        [unfoldBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, G_INTERVAL, 0, 0)];
        [unfoldBtn addTarget:self
                      action:@selector(clickForBtnUnfoldTextV:)
            forControlEvents:UIControlEventTouchDown];
        [_bottomUnfoldV addSubview:unfoldBtn];
        [self.view addSubview:_bottomUnfoldV];
        [self.view bringSubviewToFront:_bottomUnfoldV];
        
        unfoldBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSString *Hvfl = @"H:|-margin-[unfoldBtn]-margin-|";
        NSString *Vvfl = @"V:|-margin1-[unfoldBtn(unfoldHeight)]";
        
        NSDictionary *metrics = @{@"margin":@20,@"margin1":@5,@"unfoldHeight":@(_bottomUnfoldV.frame.size.height - G_INTERVAL)};
        
        NSDictionary *views = NSDictionaryOfVariableBindings(unfoldBtn);
        
        NSLayoutFormatOptions ops = NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllRight;
        
        NSArray *Hcostraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:ops metrics:metrics views:views];
        NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:ops metrics:metrics views:views];
        [_bottomUnfoldV addConstraints:Hcostraints];
        [_bottomUnfoldV addConstraints:Vconstraints];
        
    }
    return _bottomUnfoldV;
}

- (ZJEditingV *)editingV {
    if (_editingV == nil) {
        _editingV = [[[NSBundle mainBundle] loadNibNamed:@"ZJEditingV" owner:nil options:nil] lastObject];
        UITableViewCell *cell =[self.editingTB cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        _editingV.frame = cell.contentView.bounds;
        [AppUtils addTapCloseKeyboardInView:_editingV];
        [cell.contentView addSubview:_editingV];
    }
    return _editingV;
}

- (UITableView *)editingTB {
    if (_editingTB == nil) {
        _editingTB =[[UITableView alloc]initWithFrame:self.view.bounds];
        _editingTB.dataSource=self;
        _editingTB.delegate=self;
        _editingTB.showsVerticalScrollIndicator=NO;
        _editingTB.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
        [self.view addSubview:_editingTB];
    }
    return _editingTB;
}

#pragma mark - ALertView
- (void)alertViewForBtnTmpSwitch {
    UIAlertView *alertv = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"切换模版将丢失编辑的内容" delegate:self cancelButtonTitle:@"继续切换" otherButtonTitles:@"取消", nil];
    alertv.delegate = self;
    alertv.tag = AlertViewTagTmpSwitch;
    [alertv show];
}

- (void)alertViewForNavigationItemBackVc {
    UIAlertView *alertv = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未完成，编辑的素材将不保存哦" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续编辑", nil];
    alertv.delegate = self;
    alertv.tag = AlertViewTagBackVc;
    [alertv show];
}

- (void)alertViewForNavigationItemNextNoEditing {
    UIAlertView *alertv = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"素材空白部分将沿用素材底色" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"沿用底色", nil];
    alertv.delegate = self;
    alertv.tag = AlertViewTagNextNoEditing;
    [alertv show];
}

- (void)alertViewForEditingImgLarger {
    UIAlertView *alertv = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"图片超过%dM，压缩后上传?",IMG_SIZE_LIMIT] delegate:self cancelButtonTitle:@"原图上传" otherButtonTitles:@"压缩上传", nil];
    alertv.delegate = self;
    alertv.tag = AlertViewTagEditingImgLarger;
    [alertv show];
}

- (void)alertViewForEditingImgLargerMax {
    UIAlertView *alertv = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"图片超过%dM，压缩后上传?",IMG_SIZE_MAX_LIMIT] delegate:self cancelButtonTitle:@"重新编辑" otherButtonTitles:@"压缩上传", nil];
    alertv.delegate = self;
    alertv.tag = AlertViewTagEditingImgLargerMax;
    [alertv show];
}

#pragma mark - Request
- (void)requestForTemplateSynthesisIsNext:(BOOL)isNext { //模版合成图片的接口
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    ZJEditingHandler *editingH = [ZJEditingHandler new];

    UITextView *textV1 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG + 0];
    NSString *text1 = textV1.text;
        
    UITextView *textV2 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG + 1];
    NSString *text2 = textV2.text;
    
    UITextView *textV3 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG + 2];
    NSString *text3 = textV3.text;
    
    ZJXiaoMiTemplateM *temModel = adTemplateArr[tmpSeletedIndex.row];
    
    NSMutableDictionary *paraDic =  [@{@"tradeType":@"APP",
                                       @"ytOrTemplate":@"template",
                                       @"templateConfigId":temModel.ID,
                                       @"memberId":[UserManager shareManager].userModel.memberId} mutableCopy];
    NSString *paraStr = [NSString jsonStringWithDictionary:paraDic];
    
    NSLog(@"paraDic==%@",paraStr);
    
    if (text1.length > 0) {
        [paraDic setObject:text1 forKey:@"ggText1"];
    }
    if (text2.length > 0) {
        [paraDic setObject:text2 forKey:@"ggText2"];
    }
    if (text3.length > 0) {
        [paraDic setObject:text3 forKey:@"ggText3"];
    }
    
    NSLog(@"requestForTemplateSynthesis paraDic = %@",paraDic);
    [editingH ZJ_requestForGetTemplateSynthesisImg:paraDic success:^(id obj) {
        recvTmpM = obj;

        if (isNext) {
            ZJXiaoMiPublishTBVC *publishVC = [ZJXiaoMiPublishTBVC new];
            publishVC.templateM = recvTmpM;
            [self.navigationController pushViewController:publishVC animated:YES];
            [AppUtils dismissHUD];
        }
        else {
            [AppUtils dismissHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WebImage *webimg = [WebImage new];
                webimg.url = recvTmpM.templateImgSrc;
                NSArray *imgArr = @[webimg];
                [multiShow ShowImageGalleryFromView:self.view ImageList:[imgArr mutableCopy] ImgType:ImgTypeFromWeb Scale:1.0];
            });
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

- (void)requestForGetTemplateListData {
    ZJEditingHandler *editingH = [ZJEditingHandler new];
    ZJXiaoMiTemplateM *templateM = [ZJXiaoMiTemplateM new];
    templateM.pageNumber = @"1";
    templateM.pageSize = @"1000";
    templateM.xqNo = [UserManager shareManager].comModel.xqNo;
    templateM.wyNo = [UserManager shareManager].comModel.wyId;
    
    [editingH ZJ_requestForGetTemplateList:templateM success:^(id obj) {
        [self initDataForTemplateArr];
        NSArray *recvArr = obj;
        
        if ([NSArray isArrEmptyOrNull:recvArr]) {
            [AppUtils showAlertMessageTimerClose:@"未获取到模板列表"];
            return;
        }
        
        [recvArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [adTemplateArr addObject:obj];
        }];
        [self.headerCollectionV reloadData];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
    } isHeader:YES];
}

#pragma mark - Event
- (void)keyboardWasShown:(NSNotification *)obj {
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
        if ([firstResponder isKindOfClass:[UITextView class]]) {
            NSDictionary *info = [obj userInfo];
            NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
            CGSize keyboardSize = [value CGRectValue].size;
            UITextView *textV = (UITextView *)firstResponder;

            CGFloat bottomVOriginY = self.view.frame.size.height - keyboardSize.height - CGRectGetMaxY(textV.frame)-TXT_ROW_INTEVER;
            if (self.bottomUnfoldV.frame.origin.y != bottomVOriginY) {
                CGRect bottomVRect = self.bottomUnfoldV.frame;
                bottomVRect.origin.y = bottomVOriginY;
                self.bottomUnfoldV.frame = bottomVRect;
            }
        }
}

- (void)keyboardWasHidden:(NSNotification *)obj {
    CGFloat bottomVOrginUnfoldY = self.view.frame.size.height - self.bottomUnfoldV.frame.size.height;
    if (self.bottomUnfoldV.frame.origin.y != bottomVOrginUnfoldY) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect bottomVRect = self.bottomUnfoldV.frame;
            bottomVRect.origin.y = bottomVOrginUnfoldY;
            self.bottomUnfoldV.frame = bottomVRect;
        }];
    }
}

- (void)textViewEditChange:(NSNotification *)noti {
    [self updateUIStateForRevocAndPreviewBtn];
    
    if ([noti.object isKindOfClass:[UITextView class]]) {
        ZJXiaoMiTemplateM *temModel = adTemplateArr[tmpSeletedIndex.row];
        UITextView *textV = noti.object;
#ifdef DEBUG
//        temModel.textModel1.templateTextFontcount = 1000;
//        temModel.textModel2.templateTextFontcount = 1000;
//        temModel.textModel3.templateTextFontcount = 1000;
#else

#endif

        if (textV.tag == TEXTV_STARTTAG + 0) {
            NSInteger maxLength = temModel.textModel1.templateTextFontcount;
            [AppUtils textFieldLimitChinaMaxLength:maxLength inTextView:textV];
        }
        else if (textV.tag == TEXTV_STARTTAG + 1) {
            NSInteger maxLength = temModel.textModel2.templateTextFontcount;
            [AppUtils textFieldLimitChinaMaxLength:maxLength inTextView:textV];
        }
        else if (textV.tag == TEXTV_STARTTAG + 2) {
            NSInteger maxLength = temModel.textModel3.templateTextFontcount;
            [AppUtils textFieldLimitChinaMaxLength:maxLength inTextView:textV];
        }
        
        if (textV.text.length > 0) {
            [textV hidePlaceHolder];
        }
        else {
            [textV showPlaceHolder];
        }
        
        if (textV.contentSize.height > 70) {
            return;
        }
        
        if (textV.contentSize.height > TXT_ROW_HEIGHT &&
            textV.contentSize.height != textV.frame.size.height) {
            
            CGFloat interval = textV.contentSize.height - textV.frame.size.height;
            CGRect bottomVRect = self.bottomUnfoldV.frame;
            bottomVRect.origin.y = self.bottomUnfoldV.frame.origin.y - interval;
            bottomVRect.size.height = self.bottomUnfoldV.frame.size.height + interval;
            self.bottomUnfoldV.frame = bottomVRect;

            CGRect textVRect = textV.frame;
            textVRect.size.height = textV.contentSize.height;
            textV.frame = textVRect;
            
            if (textV.tag == TEXTV_STARTTAG) {
                UITextView *textV1 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG +1];
                if (textV1) {
                    CGRect textV1Rect = textV1.frame;
                    textV1Rect.origin.y = CGRectGetMaxY(textV.frame) + TXT_ROW_INTEVER;
                    textV1.frame = textV1Rect;
                    
                    UITextView *textV2 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG +2];
                    if (textV2) {
                        CGRect textV2Rect = textV2.frame;
                        textV2Rect.origin.y = CGRectGetMaxY(textV1.frame) + TXT_ROW_INTEVER;
                        textV2.frame = textV2Rect;
                    }
                }
            }
            else if (textV.tag == TEXTV_STARTTAG +1) {
                UITextView *textV1 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG +1];
                UITextView *textV2 = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG +2];
                if (textV2) {
                    CGRect textV2Rect = textV2.frame;
                    textV2Rect.origin.y = CGRectGetMaxY(textV1.frame) + TXT_ROW_INTEVER;
                    textV2.frame = textV2Rect;
                }
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    BOOL isEnable = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
    self.previewBtn.enabled = isEnable;
    self.footerV.hidden = !self.revokeBtn.enabled;
    if (isEnable) {
        [self.previewBtn setBackgroundColor:[UIColor orangeColor]];
        [self.previewBtn.layer setBorderColor:self.previewBtn.backgroundColor.CGColor];
        
        [self.revokeBtn setBackgroundColor:[UIColor whiteColor]];
        [self.revokeBtn.layer setBorderColor:[AppUtils colorWithHexString:@"40b0da"].CGColor];
    }
    else {
        UIColor *nonableColor = [UIColor lightGrayColor];
        [self.previewBtn setBackgroundColor:nonableColor];
        [self.previewBtn.layer setBorderColor:self.previewBtn.backgroundColor.CGColor];
        
        [self.revokeBtn setBackgroundColor:nonableColor];
        [self.revokeBtn.layer setBorderColor:self.revokeBtn.backgroundColor.CGColor];
    }
}

- (void)clickForNavigationItemBack {
    if (self.revokeBtn.enabled) {
        [self alertViewForNavigationItemBackVc];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickForBtnRevoke {
    if (tmpSeletedIndex.row == 0) {
        ZJXiaoMiTemplateM *temM = adTemplateArr[0];
        temM.photoImg = nil;
        
        ZJEditingTemplateCell *cell = (ZJEditingTemplateCell *)[self.headerCollectionV cellForItemAtIndexPath:tmpSeletedIndex];
        [self updateUIStateForColCell:cell forIndexPath:tmpSeletedIndex];
    }

    self.revokeBtn.enabled = NO;
}

- (void)clickForTapAddOriginalImg {
    if ([self.originalV.superview isEqual:self.editingV]) {
        [self UesrImageClicked];
    }
}

-(void)clickForBtnNextStep
{
    if (tmpSeletedIndex.row == 0) {
        if (!self.originalV.hidden) {
            [AppUtils showAlertMessage:@"未发现原图素材!\n请编辑内容。"];
            return;
        }
        
        self.editing = NO;
        [AppUtils showProgressMessage:W_ALL_PROGRESS];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ZJXiaoMiTemplateM *temM = adTemplateArr[0];
            NSData *imgData = UIImagePNGRepresentation(temM.photoImg);
            
//            NSData *imgData = [NSData dataTransformFromImg:self.editingV.editingImgV.image];
            NSLog(@"imgData = %.2fM，temM.photoImg ＝ %@",imgData.length /1024.0 /1024.0,NSStringFromCGSize(temM.photoImg.size));
            
            [AppUtils dismissHUD];
            NSUInteger maxImgLength = IMG_SIZE_MAX_LIMIT * 1024 *1024;
            if (imgData.length > maxImgLength) {
                [self alertViewForEditingImgLargerMax];
                return;
            }
            
            NSUInteger lagerImgLength = IMG_SIZE_LIMIT * 1024 *1024;
            if (imgData.length > lagerImgLength) {
                [self alertViewForEditingImgLarger];
                return;
            }
            
            self.editing = YES;
            [self pushToUploadImgVCWithImg:temM.photoImg];
        });
    }
    else {
        if (![self textViewHasEdited]) {
            [self alertViewForNavigationItemNextNoEditing];
            return;
        }
        
        [self requestForTemplateSynthesisIsNext:YES];
    }
}

- (void)clickForBtnPreview {
    [self.view endEditing:YES];

    if (tmpSeletedIndex.row == 0) {
        ZJXiaoMiTemplateM *temM = adTemplateArr[tmpSeletedIndex.row];
        if (temM.photoImg) {
            NSArray *imgArr = @[temM.photoImg];
            [multiShow ShowImageGalleryFromView:self.view ImageList:[imgArr mutableCopy] ImgType:ImgTypeFromImg Scale:1.0];
        }
    }
    else {
        [self requestForTemplateSynthesisIsNext:NO];
    }
}

- (void)clickForBtnUnfoldTextV:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"展开"]) {
        [btn setState:UIControlStateNormal
              imgName:@"putAway"
                 text:@"收起"];
        CGFloat bottomVOrginUnfoldY = self.view.frame.size.height - self.bottomUnfoldV.frame.size.height;
        if (self.bottomUnfoldV.frame.origin.y != bottomVOrginUnfoldY) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect bottomVRect = self.bottomUnfoldV.frame;
                bottomVRect.origin.y = bottomVOrginUnfoldY;
                self.bottomUnfoldV.frame = bottomVRect;
            }];
        }
    }
    else {
        [self.view endEditing:YES];
        [btn setState:UIControlStateNormal
              imgName:@"unfold"
                 text:@"展开"];
        CGFloat bottomVOrginUnfoldY = self.view.frame.size.height - self.editingTB.tableFooterView.frame.size.height;
        if (self.bottomUnfoldV.frame.origin.y != bottomVOrginUnfoldY) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect bottomVRect = self.bottomUnfoldV.frame;
                bottomVRect.origin.y = bottomVOrginUnfoldY;
                self.bottomUnfoldV.frame = bottomVRect;
            }];
        }
    }
}

- (void)UesrImageClicked
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:@"拍照"
                                    otherButtonTitles:@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:@"从相册选择"
                                   otherButtonTitles:nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

#pragma mark - updateDataSource And UI
- (void)updateUIStateForRevocAndPreviewBtn {
    if (tmpSeletedIndex.row == 0) {
        ZJXiaoMiTemplateM *tmpM = adTemplateArr[0];
        self.revokeBtn.enabled = tmpM.photoImg;
    }
    else {
        self.footerV.hidden = YES;
        self.revokeBtn.enabled = [self textViewHasEdited];
    }
}

- (void)updateUIStateForColCell:(ZJEditingTemplateCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textL.text = @"原 图";
        ZJXiaoMiTemplateM *temModel = adTemplateArr[indexPath.row];
        cell.imgV.image = [UIImage imageNamed:temModel.templateImgSrcSlt];
    }
    else {
        ZJXiaoMiTemplateM *temModel = adTemplateArr[indexPath.row];
        cell.textL.text = temModel.templatename;
        [cell.imgV setImageWithURL:[NSURL URLWithString:temModel.templateImgSrcSlt]];
    }
    
    
    if (indexPath.row == tmpSeletedIndex.row) {
        cell.layer.borderWidth = 2;
        cell.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [self.bottomUnfoldV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextView class]]) {
                UIView *subV = obj;
                [subV removeFromSuperview];
            };
        }];
        
        if (indexPath.row == 0) {
            ZJXiaoMiTemplateM *temModel = adTemplateArr[indexPath.row];
            if (temModel.photoImg) {
                self.editingV.editingImgV.image = temModel.photoImg;
                self.originalV.hidden = YES;
            }
            else {
                self.originalV.hidden = NO;
            }
        }
        else {
            self.editingV.editingImgV.image = ImageNamed(@"enLargeImg");
            self.originalV.hidden = YES;
            ZJXiaoMiTemplateM *temModel = adTemplateArr[indexPath.row];
            [self.editingV.editingImgV setImageWithURL:[NSURL URLWithString:temModel.templateImgSrc]];
            NSLog(@"temModel.textModel1.templateText = %@\n temModel.textModel2.templateText = %@ \ntemModel.textModel3.templateText = %@",temModel.textModel1.templateText,temModel.textModel2.templateText,temModel.textModel3.templateText);
            textVCount = 0;
            for (int i = 0; i < TEXTNUMBER_MAX; i++) {
                ZJXiaoMiTemTextM *textM;
                if (i == 0) {
                    if ([NSString isEmptyOrNull:temModel.textModel1.templateText]) {
                        continue;
                    }
                    textM = temModel.textModel1;
                }
                else if (i == 1) {
                    if ([NSString isEmptyOrNull:temModel.textModel2.templateText]) {
                        continue;
                    }
                    textM = temModel.textModel2;
                }
                else if (i == 2) {
                    if ([NSString isEmptyOrNull:temModel.textModel3.templateText]) {
                        continue;
                    }
                    textM = temModel.textModel3;
                }
                else {
                    continue;
                }
                
                textVCount ++;
                CGRect textVRect = CGRectMake(G_INTERVAL,i*(TXT_ROW_HEIGHT + TXT_ROW_INTEVER) + self.editingTB.tableFooterView.frame.size.height,self.bottomUnfoldV.frame.size.width - G_INTERVAL*2,TXT_ROW_HEIGHT);

                NSLog(@"textV%dRect =%@",i,NSStringFromCGRect(textVRect));
                UITextView *textV = [[UITextView alloc] initWithFrame:textVRect];
                textV.returnKeyType = UIReturnKeyDone;
                textV.delegate = self;
                textV.layer.cornerRadius = 5;
                textV.alpha = 0.5;
                textV.tag = TEXTV_STARTTAG + i;
                [textV setPlaceHolder:textM.templateText fontSize:FONT_SIZE];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChange:) name:UITextViewTextDidChangeNotification object:textV];
            
                [self.bottomUnfoldV addSubview:textV];
                
                CGRect bottomRect = self.bottomUnfoldV.frame;
                bottomRect.size.height = CGRectGetMaxY(textV.frame) + G_INTERVAL;
                bottomRect.origin.y = self.view.frame.size.height - bottomRect.size.height;
                self.bottomUnfoldV.frame = bottomRect;
            }
        }
    }
    else {
        cell.layer.borderWidth = 0;
    }
}

#pragma mark <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IPHONE_HEIGHT-tableView.tableHeaderView.frame.size.height-tableView.tableFooterView.frame.size.height-CGRectGetMaxY(self.navigationController.navigationBar.frame) - G_INTERVAL;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        cell.backgroundColor = [AppUtils colorWithHexString:@"e6e6e6"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return adTemplateArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJEditingTemplateCell *cell = (ZJEditingTemplateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ZJEditingColCellID forIndexPath:indexPath];
    if ([AppUtils systemVersion] < 8.0) {
        [self updateUIStateForColCell:cell forIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJEditingTemplateCell *tempCell = (ZJEditingTemplateCell *)cell;
    if ([AppUtils systemVersion] >= 8.0) {
        [self updateUIStateForColCell:tempCell forIndexPath:indexPath];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(G_INTERVAL, G_INTERVAL, G_INTERVAL, G_INTERVAL);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    tmpEmaySeletedIndex = indexPath;
    [AppUtils closeKeyboard];
    if ([self textViewHasEdited] &&
        tmpEmaySeletedIndex.row != tmpSeletedIndex.row) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self alertViewForBtnTmpSwitch];
        });
        return;
    }

    [self collectionView:collectionView didSelectTemplateSwitchForIndexPath:tmpEmaySeletedIndex];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self itemWidth], [self itemWidth]);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewTagTmpSwitch) {
        if (buttonIndex == 0) {
            [self collectionView:self.headerCollectionV didSelectTemplateSwitchForIndexPath:tmpEmaySeletedIndex];
        }
    }
    else if (alertView.tag == AlertViewTagBackVc) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == AlertViewTagNextNoEditing) {
        if (buttonIndex == 0) {
            
        }
        else {
            [self requestForTemplateSynthesisIsNext:YES];
        }
    }
    else if (alertView.tag == AlertViewTagEditingImgLarger) {
        if (buttonIndex == 0) {
             ZJXiaoMiTemplateM *temM = adTemplateArr[0];
            [self pushToUploadImgVCWithImg:temM.photoImg];
        }
        else {
            ZJXiaoMiTemplateM *temM = adTemplateArr[0];
            NSData *imageData = UIImageJPEGRepresentation(temM.photoImg, 0.9);
            NSLog(@"AlertViewTagEditingImgLarger thumbImageData = %.2fM",imageData.length /1024.0/1024);
            [self pushToUploadImgVCWithImg:[UIImage imageWithData:imageData]];
        }
    }
    else if (alertView.tag == AlertViewTagEditingImgLargerMax) {
        if (buttonIndex == 0) {
           
        }
        else {
            ZJXiaoMiTemplateM *temM = adTemplateArr[0];
            NSData *imageData = UIImageJPEGRepresentation(temM.photoImg, 0.9);
            NSLog(@"AlertViewTagEditingImgLargerMax  thumbImageData = %.2fM",imageData.length /1024.0/1024);
            [self pushToUploadImgVCWithImg:[UIImage imageWithData:imageData]];
        }
    }
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0://相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1://相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage* editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = [NSData dataTransformFromImg:editedImage];
    NSLog(@"data = %fM",data.length /1000.0 /1000.0);
    
    VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:editedImage cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width * 1312/1080) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [self presentViewController:imgCropperVC animated:YES completion:^{
        // TO DO
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    ZJXiaoMiTemplateM *temM = adTemplateArr[0];
    temM.photoImg = editedImage;
    [adTemplateArr replaceObjectAtIndex:0 withObject:temM];
    NSIndexPath *refreshIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    ZJEditingTemplateCell *cell = (ZJEditingTemplateCell *)[self.headerCollectionV cellForItemAtIndexPath:refreshIndex];
    [self updateUIStateForColCell:cell forIndexPath:refreshIndex];
    [self updateUIStateForRevocAndPreviewBtn];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        for (int i = 0; i < textVCount; i++) {
            if (i == textVCount - 1) {
                [self.view endEditing:YES];
                return NO;
            }
            
            if (textView.tag == TEXTV_STARTTAG + i) {
                UITextView *nextTextV = (UITextView *)[self.bottomUnfoldV viewWithTag:TEXTV_STARTTAG + i + 1];
                if (nextTextV) {
                    [nextTextV becomeFirstResponder];
                }
                else {
                    [textView resignFirstResponder];
                }
                return NO;
            }
        }
        // Return NO so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return YES so that the text gets added to the view
    return YES;
}

@end
