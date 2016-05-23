//
//  ZJAdPublishVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/22.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

NSString * const notiForComChange = @"NotiForComChange";

#define BGCOLOR [AppUtils colorWithHexString:@"edeeea"]
#define ROWHEIGHT 30
#define TEXTVIEW_HEIGHT 120 //留言框的高度
#define SECTIONLAST_HEIGHT 120 //最后一段视图的高度

#define KMAXLEN_LEAVEWORDS 500

#import "ZJXiaoMiPublishTBVC.h"
#import "ZJXiaoMiRuleDelegate.h"
#import "ZJXiaoMiRuleHeaderV.h"
#import "ZJXiaoMiRuleFooterV.h"
#import "UserManager.h"
#import "ZYTextInputBar.h"
#import "ZJXiaoMiSubmmitSecFooter.h"
#import "ZJAdvertisementModel.h"
#import "ZJAdvertisementHandler.h"
#import "ZJEditingSourceVC.h"
#import "NSString+wrapper.h"
#import "ZYXiaoMiPayVC.h"
#import "ZJNoDeviceDelegate.h"
#import "ZJWebProgrssView.h"

typedef NS_ENUM(NSUInteger,InputTag) {
    InputTagPublishTitle = 110,
    InputTagPublishName,
    InputTagPublishPhone,
    InputTagPublishTextV,
    InputTagPublishWordNumber
};

@interface ZJXiaoMiPublishTBVC () <UITableViewDataSource,
                                    UITableViewDelegate,
                                    ChickActionDelegate>

@property (nonatomic,strong) UITableView *publishTb;
@property (nonatomic,strong) UITableView *noDeviceTb;
@property (nonatomic,strong) UITableView *ruleTb;
@property (nonatomic,strong) ZJXiaoMiRuleHeaderV *ruleHeaderV;
@property (nonatomic,strong) ZJXiaoMiRuleFooterV *ruleFooterV;
@property (nonatomic,strong) ZJXiaoMiRuleDelegate *ruleManager;
@property (nonatomic,strong) ZJNoDeviceDelegate   *noDevdiceManager;

@property (nonatomic,strong) UITextView *leaveWordTextV;
@property (nonatomic,strong) UITextField *titleTF;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UITextField *phoneTF;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *numberL;

@property (nonatomic,strong) NSArray *xiaoMiJiQiArr;
@property (nonatomic,strong) BingingXQModel *qComModel;
@property (nonatomic,strong) ZJWebProgrssView *progressV;

@end

@implementation ZJXiaoMiPublishTBVC
{
    CGFloat tbContentHeight;
    ZJAdvertisementHandler *advertisementH;
}

-(void)initData
{
    advertisementH = [ZJAdvertisementHandler new];
    self.qComModel = [UserManager shareManager].comModel;
}

- (void)setupBackBarItem {
    __weak typeof(self)weakSelf = self;
    [self.navigationItem addLeftItemWithImgName:@"backIcon" action:^{
        [weakSelf clickForNavigationItemBack];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setQComModel:(BingingXQModel *)qComModel {
    _qComModel = qComModel;
    self.titleTF.text = [NSString stringWithFormat:@"%@小蜜媒体发布",qComModel.xqName];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_leaveWordTextV];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_titleTF];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_nameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_phoneTF];
}

- (void)cancelNotification {
    UITextField *titleTF = (UITextField *)[_publishTb viewWithTag:InputTagPublishTitle];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:titleTF];
    
    UITextField *nameTF = (UITextField *)[_publishTb viewWithTag:InputTagPublishName];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:nameTF];
    
    UITextField *phoneTF = (UITextField *)[_publishTb viewWithTag:InputTagPublishPhone];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:phoneTF];
    
    UITextView *leaveWordsTextV = (UITextView *)[_publishTb viewWithTag:InputTagPublishTextV];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:leaveWordsTextV];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布小蜜";
    [self initData];
    [self setupBackBarItem];
    
    [self.progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tbContentHeight = self.publishTb.contentSize.height;
        [self updateUIForNumbelL:self.leaveWordTextV.text.length];
        [self updateUIForComInfo:self.qComModel];
        [self xiaoMiJiQiArr];
        [self requestForJiQiNumberWithXqM:self.qComModel];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comChangeClick:) name:notiForComChange object:nil];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notiForComChange object:nil];
    _publishTb = nil;
    _ruleTb = nil;
    _noDeviceTb = nil;
    _ruleHeaderV = nil;
    _ruleFooterV = nil;
    _ruleManager = nil;
    _leaveWordTextV = nil;
    _titleTF = nil;
    _nameTF = nil;
    _phoneTF = nil;
    _lineView = nil;
    _qComModel = nil;
    _numberL = nil;
}

#pragma mark - Lazy loading
- (ZJWebProgrssView *)progressV {
    if (!_progressV) {
        _progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
        
        __weak typeof(self) weakSelf = self;
        _progressV.loadBlock = ^(){
            [weakSelf requestForJiQiNumberWithXqM:weakSelf.qComModel];
        };
        [self.view addSubview:_progressV];
    }
    return _progressV;
}

-(UITableView *)noDeviceTb
{
    if (_noDeviceTb == nil)
    {
        _noDevdiceManager = [[ZJNoDeviceDelegate alloc]init];
        _noDeviceTb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        _noDeviceTb.dataSource=_noDevdiceManager;
        _noDeviceTb.delegate=_noDevdiceManager;
        _noDeviceTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noDeviceTb.scrollEnabled = NO;
        _noDevdiceManager.noDeviceTB = _noDeviceTb;
    }
    return _noDeviceTb;
}

- (ZJXiaoMiRuleDelegate *)ruleManager {
    if (_ruleManager == nil) {
        _ruleManager = [[ZJXiaoMiRuleDelegate alloc] init];
        
        __block typeof (self)weakSelf = self;
        _ruleManager.getRuleBlock = ^{
            [weakSelf requestForRuleList];
        };
    }
    return _ruleManager;
}

- (ZJXiaoMiRuleHeaderV *)ruleHeaderV {
    if (_ruleHeaderV == nil) {
        _ruleHeaderV = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZJXiaoMiRuleHeaderV class]) owner:self options:nil] lastObject];
        _ruleHeaderV.tmpM = self.templateM;
    }
    return _ruleHeaderV;
}

- (ZJXiaoMiRuleFooterV *)ruleFooterV {
    if (_ruleFooterV == nil) {
        _ruleFooterV = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZJXiaoMiRuleFooterV class]) owner:self options:nil] lastObject];
    }
    return _ruleFooterV;
}

- (UITableView *)publishTb {
    if (_publishTb == nil) {
        _publishTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame))
                                                  style:UITableViewStyleGrouped];
        _publishTb.allowsSelection = NO;
        [AppUtils addTapCloseKeyboardInView:_publishTb];
        _publishTb.dataSource = self;
        _publishTb.delegate = self;
        [_publishTb registerClass:[UITableViewCell class] forCellReuseIdentifier:SYSTEM_CELL_ID];
        _publishTb.showsHorizontalScrollIndicator = NO;
    }
    
    return _publishTb;
}

- (UILabel *)numberL{
    if (_numberL.text == nil) {
        CGFloat wordsWidth = 60;
        CGFloat wordsHeight = 20;
        _numberL = [[UILabel alloc] initWithFrame:CGRectMake(self.publishTb.frame.size.width - G_INTERVAL - wordsWidth,
                                                             TEXTVIEW_HEIGHT - G_INTERVAL/2 - wordsHeight,
                                                             wordsWidth,
                                                             wordsHeight)];
        _numberL.textColor = [UIColor orangeColor];
        _numberL.tag = InputTagPublishWordNumber;
        _numberL.font = [UIFont systemFontOfSize:12];
        _numberL.textAlignment = NSTextAlignmentRight;
    }
    return _numberL;
}

- (UITextView *)leaveWordTextV {
    if (_leaveWordTextV == nil) {
        _leaveWordTextV = [[UITextView alloc] initWithFrame:CGRectMake(G_INTERVAL, 0, self.publishTb.frame.size.width - G_INTERVAL *2, TEXTVIEW_HEIGHT)];
        _leaveWordTextV.tag = InputTagPublishTextV;
        _leaveWordTextV.inputAccessoryView = [ZYTextInputBar shareInstance];
    }
    return _leaveWordTextV;
}


- (NSArray *)xiaoMiJiQiArr{
    if(_xiaoMiJiQiArr == nil)
    {
        _xiaoMiJiQiArr = [NSArray array];
    }
    return _xiaoMiJiQiArr;
}

- (UITextField *)titleTF {
    if (_titleTF == nil) {
        _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(G_INTERVAL, 0, self.publishTb.frame.size.width - G_INTERVAL*2, ROWHEIGHT)];
        _titleTF.font = [UIFont systemFontOfSize:FONT_SIZE];
        _titleTF.textColor = [UIColor grayColor];
        _titleTF.tag = InputTagPublishTitle;
        _titleTF.inputAccessoryView = [ZYTextInputBar shareInstance];
    }
    return _titleTF;
}

- (UITextField *)nameTF {
    if (_nameTF == nil) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(G_INTERVAL, 0, self.publishTb.frame.size.width,ROWHEIGHT)];
        _nameTF.inputAccessoryView = [ZYTextInputBar shareInstance];
        _nameTF.placeholder = @"请输入";
        _nameTF.backgroundColor = [UIColor whiteColor];
        _nameTF.tag = InputTagPublishName;
        _nameTF.leftViewMode = UITextFieldViewModeAlways;
        _nameTF.leftView = [UILabel addWithFrame:CGRectMake(0, 0, 40, self.nameTF.frame.size.height)
                                       textColor:[UIColor blackColor]
                                        fontSize:FONT_SIZE
                                            text:@"姓名:"];
        _nameTF.text = [[UserManager shareManager].userModel.realName trim];
    }
    return _nameTF;
}

- (UITextField *)phoneTF {
    if (_phoneTF == nil) {
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(self.nameTF.frame.origin.x, CGRectGetMaxY(self.lineView.frame), self.nameTF.frame.size.width,self.nameTF.frame.size.height)];
        _phoneTF.inputAccessoryView = [ZYTextInputBar shareInstance];
        _phoneTF.backgroundColor = [UIColor whiteColor];
        _phoneTF.tag = InputTagPublishPhone;
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.leftView = [UILabel addWithFrame:self.nameTF.leftView.bounds
                                        textColor:[UIColor blackColor]
                                         fontSize:FONT_SIZE
                                             text:@"电话:"];
        _phoneTF.text = [UserManager shareManager].userModel.phone;
    }
    return _phoneTF;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameTF.frame), self.publishTb.frame.size.width, G_INTERVAL /2)];
        _lineView.backgroundColor = BGCOLOR;
    }
    return _lineView;
}

#pragma mark - Event
- (void)clickForNavigationItemBack {
    __block BOOL isPop = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZJEditingSourceVC class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            isPop = YES;
            *stop = YES;
        }
    }];
    
    if (!isPop) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark -  Request
-(void)requestForRuleList
{
    ZJAdvertisementModel *advertisementM = [ZJAdvertisementModel new];

    advertisementM.pageSize =@"1000";
    advertisementM.wyNo=self.qComModel.wyId;
    advertisementM.xqNo=self.qComModel.xqNo;

    [advertisementH queryAdvertisementListInfo:advertisementM success:^(id obj) {
        NSArray *ruleArr = [obj copy];
        self.ruleManager.ruleType = RuleShowTypeNone;
        self.ruleManager.ruleArr = [ruleArr mutableCopy];
        
        [self updateUIForRuleTb:ruleArr];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.publishTb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            tbContentHeight = self.publishTb.contentSize.height;
            NSLog(@"queryAdvertisementListInfo contentSizeHeight = %f",tbContentHeight);
        });
    } failed:^(id obj) {
        self.ruleManager.ruleArr = [NSMutableArray array];
        self.ruleManager.ruleType = RuleShowTypeGetFail;
        
        [self updateUIForRuleTb:[NSArray array]];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.publishTb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } isHeader:YES];
}

-(void)requestForJiQiNumberWithXqM:(BingingXQModel *)comM
{
    static NSInteger count = 1;
    NSLog(@"requestForJiQiNumberWithXqM = %d",count++);
    ZJAdvertisementModel *modelM = [ZJAdvertisementModel new];
    modelM.pageNumber=@"1";
    modelM.pageSize=@"1000";
    modelM.wyNo=comM.wyId;
    modelM.xqNo=comM.xqNo;
    [advertisementH requestXiaoMiNumber:modelM success:^(id obj) {
        [self.view addSubview:self.noDeviceTb];
        NSDictionary *recvDic = obj;
        self.xiaoMiJiQiArr = recvDic[@"list"];
        [self.ruleFooterV updateDataForXiaoMiJiQiNum:_xiaoMiJiQiArr.count];
        if ([NSArray isArrEmptyOrNull:self.xiaoMiJiQiArr]) {
            [self.view addSubview:self.noDeviceTb];
            [self.noDevdiceManager updateUIForPromptInformation:recvDic[@"keyword"]];
            [self.noDevdiceManager updateUIForComInfo:self.qComModel];
        }
        else {
            [self.view addSubview:self.publishTb];
            [self.ruleHeaderV updateUIForComInfo:self.qComModel];
            [self.ruleHeaderV updateUIForXiaoMiJiQiNum:_xiaoMiJiQiArr.count];
            [self updateUIForComInfo:self.qComModel];
            [self requestForRuleList];
        }
        
        if (!self.progressV.hidden) {
            [self.progressV stopAnimationNormalIsNoData:YES];
            self.progressV.hidden = YES;
        }
        
        NSLog(@"_xiaoMiJiQiArr.count = %lu",(unsigned long)_xiaoMiJiQiArr.count);
    } failed:^(id obj) {
        self.xiaoMiJiQiArr = [NSArray array];
        
        [self.ruleHeaderV updateUIForComInfo:self.qComModel];
        [self.view addSubview:self.noDeviceTb];
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
        
        if (!self.progressV.hidden) {
            [self.progressV stopAnimationFailIsNoData:YES];
            self.progressV.hidden = YES;
        }
    }];
}

#pragma mark - notification
- (void)keyboardWasShown:(NSNotification *)obj {
    NSLog(@"keyboardWasShown");
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    NSDictionary *info = [obj userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [self.publishTb setContentSize:CGSizeMake(_publishTb.contentSize.width, tbContentHeight + keyboardSize.height)];

    switch (firstResponder.tag) {
        case InputTagPublishTextV: {
            CGFloat textVContentY = [self.publishTb rectForSection:0].size.height +
            [self.publishTb rectForSection:1].size.height +
            [self.publishTb rectForSection:2].size.height;
            
            [self.publishTb setContentOffset:CGPointMake(self.publishTb.contentOffset.x,textVContentY)              animated:YES];
        }
            break;
        case InputTagPublishTitle:
            [self.publishTb setContentOffset:CGPointMake(self.publishTb.contentOffset.x,[self.publishTb rectForSection:0].size.height)
                                    animated:YES];
            break;
        case InputTagPublishName:
            [self.publishTb setContentOffset:CGPointMake(self.publishTb.contentOffset.x,[self.publishTb rectForSection:0].size.height +[self.publishTb rectForSection:1].size.height)
                                    animated:YES];
            break;
        case InputTagPublishPhone:
            [self.publishTb setContentOffset:CGPointMake(self.publishTb.contentOffset.x,[self.publishTb rectForSection:0].size.height +[self.publishTb rectForSection:1].size.height)
                                    animated:YES];
            break;
        default:
            break;
    }
}

- (void)keyboardWasHidden:(NSNotification *)obj {
    [self.publishTb setContentSize:CGSizeMake(_publishTb.contentSize.width, tbContentHeight)];
    if (fabs(self.publishTb.contentOffset.y - 0) >= 1e-7) {
        [self.publishTb setContentOffset:CGPointZero animated:YES];
    }
}

- (void)textFieldEditChanged:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    if (textField.tag == InputTagPublishTitle) {
        NSUInteger kMaxLenTitle = 20;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLenTitle
                                   inTextField:textField];
    }
    else if (textField.tag == InputTagPublishName) {
        NSUInteger kMaxLenName = 10;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLenName
                                   inTextField:textField];
    }
    else if (textField.tag == InputTagPublishPhone) {
        NSUInteger kMaxLenPhone = 11;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLenPhone
                                   inTextField:textField];
    }
}

- (void)textViewEditChanged:(NSNotification*)obj{
    UITextView *textV = (UITextView *)obj.object;
    
    if (textV.tag == InputTagPublishTextV) {
        [AppUtils textFieldLimitChinaMaxLength:KMAXLEN_LEAVEWORDS
                                    inTextView:textV];
        [self updateUIForNumbelL:textV.text.length];
    }
}

- (void)comChangeClick:(NSNotification *)obj {
    BingingXQModel *comM = obj.object;
    self.qComModel = comM;
    [self requestForJiQiNumberWithXqM:comM];
}

#pragma mark - UPDATE
- (void)updateUIForComInfo:(BingingXQModel *)comM {
    UITextField *publishTextF = (UITextField *)[self.publishTb viewWithTag:InputTagPublishTitle];
    publishTextF.text = [NSString stringWithFormat:@"%@小蜜媒体发布",comM.xqName];
}

- (void)updateUIForNumbelL:(NSUInteger)textLentth {
    self.numberL.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textLentth,KMAXLEN_LEAVEWORDS];
}

- (void)updateUIForRuleTb:(NSArray *)ruleArr {
    if (_ruleTb) {
        [_ruleTb removeFromSuperview];
        _ruleTb = nil;
    }
    
    NSUInteger ruleNum = 1;
    if (ruleArr.count == 0) {
        ruleNum ++;
    }

    self.ruleTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.publishTb.frame.size.width, self.ruleHeaderV.frame.size.height + self.ruleFooterV.frame.size.height + (ruleArr.count + ruleNum) * RuleCellRow)];
    self.ruleTb.tableHeaderView = self.ruleHeaderV;
    self.ruleTb.tableFooterView = self.ruleFooterV;
    self.ruleManager.infoTb = self.ruleTb;
    
    self.ruleTb.delegate = self.ruleManager;
    self.ruleTb.dataSource = self.ruleManager;
    self.ruleTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ruleTb.scrollEnabled = NO;
    
    [self.ruleTb reloadData];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return G_INTERVAL;
    }
    else {
        return ROWHEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 120;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.ruleTb.contentSize.height;
    }
    else if (indexPath.section == 1) {
        return ROWHEIGHT;
    }
    else if (indexPath.section == 2) {
        return ROWHEIGHT*2 +G_INTERVAL /2;
    }
    else if (indexPath.section == 3) {
        UITextView *textV = (UITextView *)[tableView viewWithTag:InputTagPublishTextV];
        return MAX(TEXTVIEW_HEIGHT, textV.frame.size.height);
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.ruleTb];
    }
    else if (indexPath.section == 1) {
        [cell.contentView addSubview:self.titleTF];
    }
    else if (indexPath.section == 2) {
        [cell.contentView addSubview:self.nameTF];
        [cell.contentView addSubview:self.lineView];
        [cell.contentView addSubview:self.phoneTF];
    }
    else if (indexPath.section == 3) {
        [cell.contentView addSubview:self.leaveWordTextV];
        [cell.contentView addSubview:self.numberL];
    }
    else {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.publishTb.frame.size.width, G_INTERVAL)];
        headerV.backgroundColor = BGCOLOR;
        return headerV;
    }
    else {
        UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.publishTb.frame.size.width, 30)];
        headerV.backgroundColor = BGCOLOR;
        UILabel *introduceL = [[UILabel alloc] initWithFrame:CGRectMake(G_INTERVAL, 0, headerV.frame.size.width - G_INTERVAL *2, headerV.frame.size.height)];
        introduceL.font = [UIFont systemFontOfSize:FONT_SIZE];
        if (section == 1) {
            introduceL.text = @"媒体标题:";
        }
        else if (section == 2) {
            introduceL.text = @"联系人信息:";
        }
        else if (section == 3) {
            introduceL.text = @"留言:";
        }
        [headerV addSubview:introduceL];
        return headerV;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        ZJXiaoMiSubmmitSecFooter *footerV = [[[NSBundle mainBundle] loadNibNamed:@"ZJXiaoMiSubmmitSecFooter" owner:self options:nil] lastObject];
        footerV.backgroundColor = BGCOLOR;
        footerV.delegate=self;
        return footerV;
    }
    return nil;
}

#pragma mark - ChickActionDelegate
-(void)submitAction
{
    [self.view endEditing:YES];
    
     if([NSString isEmptyOrNull:[self.ruleManager getRuleStr]])
     {
         [AppUtils showAlertMessageTimerClose:@"未选择播放规则！"];
         return;
     }
     
     if(_ruleFooterV.ruleDays==0)
     {
         [AppUtils showAlertMessageTimerClose:@"播放时间缺失，排期会延误噢！"];
         return;
     }
     
     UITextField *titleF =(UITextField *)[self.publishTb viewWithTag:InputTagPublishTitle];
     NSLog(@"titleF.text = %@",titleF.text);
     if ([NSString isEmptyOrNull:titleF.text])
     {
         [AppUtils showAlertMessageTimerClose:@"标题未填写！"];
         return;
     }
     
     UITextField *nameF =(UITextField *)[self.publishTb viewWithTag:InputTagPublishName];
     NSLog(@"nameF.text = %@",nameF.text);
     if ([NSString isEmptyOrNull:nameF.text])
     {
         [AppUtils showAlertMessageTimerClose:@"联系人未填写呢！"];
         return;
     }
     
     UITextField *phoneF =(UITextField *)[self.publishTb viewWithTag:InputTagPublishPhone];
     if (![NSString isPhone:phoneF.text])
     {
         [AppUtils showAlertMessageTimerClose:@"手机号不对喔！"];
         return;
     }
     
     if ([NSString isEmptyOrNull:_templateM.ID])//如果ID为空是原图
     {
         ZJSubmitOrdersModel *subM =[ZJSubmitOrdersModel new];
         NSDictionary * Dict;
         
         subM.tradeType=@"APP";
         subM.linkmanName=nameF.text;
         subM.chargeConfigId=[_ruleManager getRuleStr];
         subM.linkmanPhone=phoneF.text;
         subM.ggText1=@"";
         subM.ytOrTemplate=@"yt";
         subM.ggServiceDateEnd=[_ruleFooterV getEndDateStr];
         subM.ggServiceDateStart=[_ruleFooterV getStartDateStr];
         subM.ggImgSrcBefore=_templateM.filePathDisk;
         subM.memberId=[UserManager shareManager].userModel.memberId;
         subM.ggTitle=titleF.text;
         subM.remarkUser=self.leaveWordTextV.text;
         
         Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                 subM.tradeType,@"tradeType",
                 subM.linkmanName,@"linkmanName",
                 subM.chargeConfigId,@"chargeConfigId",
                 subM.linkmanPhone,@"linkmanPhone",
                 subM.ggText1,@"ggText1",
                 subM.ytOrTemplate,@"ytOrTemplate",
                 subM.ggServiceDateEnd,@"ggServiceDateEnd",
                 subM.ggImgSrcBefore,@"ggImgSrcBefore",
                 subM.memberId,@"memberId",
                 subM.ggServiceDateStart,@"ggServiceDateStart",
                 subM.ggTitle,@"ggTitle",
                 subM.remarkUser,@"remarkUser",
                 nil];
         NSString *queryString = [NSString jsonStringWithDictionary:Dict];
         
         NSLog(@"queryStringFrom==%@",queryString);
         
         ZYXiaoMiPayVC *payVC = [[ZYXiaoMiPayVC alloc]init];
         payVC.money=[self.ruleFooterV getTotalCount];
         payVC.downOrderType=DownOrder;
         payVC.downOrderDic =Dict;
         payVC.typeClose =Artwork;
         
         [self.navigationController pushViewController:payVC animated:YES];
     }
     else
     {
         ZJSubmitOrdersModel *subM =[ZJSubmitOrdersModel new];
         NSDictionary * ytDict;
         subM.ID=_templateM.ID;
         subM.ggTitle=titleF.text;
         subM.chargeConfigId=[_ruleManager getRuleStr];
         subM.ggServiceDateEnd=[_ruleFooterV getEndDateStr];
         subM.ggServiceDateStart=[_ruleFooterV getStartDateStr];
         subM.linkmanName=nameF.text;
         subM.linkmanPhone=phoneF.text;
         //subM.remarkUser=self.leaveWordTextV.text;
         
         ytDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   subM.ID,@"id",
                   subM.ggTitle,@"ggTitle",
                   subM.chargeConfigId,@"chargeConfigId",
                   subM.ggServiceDateEnd,@"ggServiceDateEnd",
                   subM.ggServiceDateStart,@"ggServiceDateStart",
                   subM.linkmanName,@"linkmanName",
                   subM.linkmanPhone,@"linkmanPhone",
                   subM.remarkUser,@"remarkUser",
                   nil];
         
         NSString *title = [NSString jsonStringWithDictionary:ytDict];
         
         NSLog(@"ytDict==%@",title);
         
         ZYXiaoMiPayVC *payVC = [[ZYXiaoMiPayVC alloc]init];
         payVC.money=[self.ruleFooterV getTotalCount];
         payVC.downOrderType=DownOrder;
         payVC.downOrderDic =ytDict;
         payVC.typeClose =Template;
         [self.navigationController pushViewController:payVC animated:YES];
     }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
