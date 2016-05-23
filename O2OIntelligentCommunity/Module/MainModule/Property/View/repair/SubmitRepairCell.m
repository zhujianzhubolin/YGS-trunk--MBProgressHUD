//
//  SubmitRepairCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define POST_IMG_NAME @"postImg"
#define USER_LENTH 15

typedef NS_ENUM(NSUInteger, RepairButtonTag) {
    RepairButtonCommunity =1,
    RepairButtonType,
    RepairButtonImg,
    RepairButtonSubmit
};

#import "SubmitRepairCell.h"
#import "UITextField+wrapper.h"
#import "ImgCollectionCell.h"
#import "ComplaintEntity.h"
#import "ComplaintHandler.h"
#import "ComplaintSaveE.h"
#import "NSString+wrapper.h"    
#import "NSData+wrapper.h"
#import "FilePostE.h"
#import <SVProgressHUD.h>
#import "RepairSubmitSucVC.h"
#import "UserManager.h"
#import "bindingHandler.h"
#import "UIImage+wrapper.h"
#import "ZYTextInputBar.h"

@implementation SubmitRepairCell
{
    __weak IBOutlet UIView *collectionBelowView;
    __weak IBOutlet UICollectionView *imgCollectionV;
    __weak IBOutlet UIButton *chooseCommButton;
    __weak IBOutlet UIButton *repairTypeButton;
    __weak IBOutlet UITextView *repairTextV;
    __weak IBOutlet UILabel *chooseComLabel;
    __weak IBOutlet UILabel *chooseTypeLabel;
    __weak IBOutlet UITextField *usernameTF;
    __weak IBOutlet UITextField *userPhoneTF;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *submmitClickBtn;
    NSMutableArray *communityArr;
    NSMutableArray *typeArr;
    
    NSMutableArray *postImgArr;
    NSMutableString *imgIDStr;
    
    NSString *typeStr;
    BingingXQModel *currentXqM;
    
    NSUInteger imgCount;
    NSUInteger lengthDescInfo;
}

- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case RepairButtonCommunity: {
            [AppUtils closeKeyboard];
            if (communityArr.count > 0) {
                sender.selected = !sender.selected;
                repairTypeButton.selected = NO;
                
                NSMutableArray *showArr = [NSMutableArray array];

                [communityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    BingingXQModel *xqM = (BingingXQModel *)obj;
                    [showArr addObject:[NSString stringWithFormat:@"%@%@",xqM.xqName,xqM.xqHouse]];
                }];
                CGPoint btnPoint = [sender.superview convertPoint:sender.frame.origin toView:[UIApplication sharedApplication].keyWindow];
                [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(0, btnPoint.y + sender.frame.size.height, imgCollectionV.frame.size.width, 40 * (showArr.count > 5 ? 5 : showArr.count)) withButton:sender withArr:showArr withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentCenter isSelHide:YES];
            }
            else {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"亲,未获取到小区列表"]];
            }
            break;
        case RepairButtonType: {
            [AppUtils closeKeyboard];
            NSMutableArray *showArr = [NSMutableArray array];
            [typeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ComplaintEntity *entity = (ComplaintEntity *)obj;
                if (entity.enabled) {
                    [showArr addObject:entity.name];
                }
            }];
            
            if (showArr.count > 0) {
                sender.selected = !sender.selected;
                chooseCommButton.selected = NO;
                
                CGPoint btnPoint = [sender.superview convertPoint:sender.frame.origin toView:[UIApplication sharedApplication].keyWindow];
                [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(0, btnPoint.y + sender.frame.size.height, imgCollectionV.frame.size.width, 40 * (showArr.count > 5 ? 5 : showArr.count)) withButton:sender withArr:showArr withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentCenter isSelHide:YES];
            }
            else {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"未获取到%@类型",typeStr]];
            }
        }
            break;
        case RepairButtonImg: {
            [[GetImgFromSystem getImgInstance] getImgFromVC:self.getImgVC];
        }
            break;
        case RepairButtonSubmit: {
            [self endEditing:YES];

            if (chooseComLabel.text.length <= 0 || [chooseComLabel.text isEqualToString:[NSString stringWithFormat:@"请选择%@小区",typeStr]]) {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"请选择%@小区",typeStr]];
                return;
            }
            
            if (chooseTypeLabel.text.length <= 0 || [chooseTypeLabel.text isEqualToString:[NSString stringWithFormat:@"请选择%@类型",typeStr]]) {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"亲爱的忘记勾选%@类型了啦!",typeStr]];
                return;
            }
            
            if ([repairTextV.text trim].length <= 0) {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"亲爱的你的%@内容是什么呢?",typeStr]];
                return;
            }
            
            if ([usernameTF.text trim].length <= 0) {
                [AppUtils showAlertMessage:W_REPAIR_NO_USERNAME];
                return;
            }
            
            if ([userPhoneTF.text trim].length < 6) {
                [AppUtils showAlertMessage:@"电话号码最少为6位"];
                return;
            }
            
            if ([NSString isEmptyOrNull:currentXqM.wyId]) {
                [AppUtils showAlertMessageTimerClose:@"缺少该小区的信息"];
                return;
            }
            
            if (postImgArr.count > imgCount + 1) {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"最多只能上传%lu张图片",imgCount]];
                return;
            }
            
            [AppUtils showProgressMessage:@"提交中,请稍候"];
            [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(submmitClick) userInfo:nil repeats:NO];
          }
            break;
        default:
            break;
            }
        }
}

- (void)submmitClick {
    if (postImgArr.count == 1) {
        [self submmitAllPost];
        return;
    }
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("mySerailQueue", DISPATCH_QUEUE_CONCURRENT);
    __block NSUInteger finishCount = 0;
    
    imgIDStr = [NSMutableString new];
    [postImgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != postImgArr.count - 1) {
            UIImage *img = obj;
            ComplaintHandler *complainH = [ComplaintHandler new];
            FilePostE *imgPost = [FilePostE new];
            imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
            if (self.type == VCTypeComplain) {
                imgPost.entityType = [LocalUtils stringFotFilePostType:FilePostTypeComplaint];
            }
            else {
                imgPost.entityType = [LocalUtils stringFotFilePostType:FilePostTypeRepair];
            }
            
            imgPost.fileName = [NSString stringWithFormat:@"%@图片%lu.png",typeStr,postImgArr.count];
            
            dispatch_async(concurrentQueue, ^{
                [complainH excuteImgPostTask:imgPost success:^(id obj) {
                    FilePostE *fileE = (FilePostE *)obj;
                    if (imgIDStr.length <= 0) {
                        [imgIDStr appendFormat:@"%@",fileE.idID];
                    }else{
                        [imgIDStr appendFormat:@",%@",fileE.idID];
                    }
                    
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
                        [self submmitAllPost];
                    }
                } failed:^(id obj) {
                    finishCount ++;
                    if (finishCount == postImgArr.count - 1) {
                        [self submmitAllPost];
                    }
                }];
            });
        }
    }];
}

- (void)submmitAllPost {
    ComplaintHandler *handler = [ComplaintHandler new];
    ComplaintSaveE *saveE = [ComplaintSaveE new];
    
    [typeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ComplaintEntity *complaintE = (ComplaintEntity *)obj;
        if ([chooseTypeLabel.text isEqualToString:complaintE.name]) {
            saveE.complaintType = [NSString stringWithFormat:@"%@",complaintE.idID];
            *stop = YES;
        };
    }];
    
    saveE.memberid = [UserManager shareManager].userModel.memberId;
    saveE.wyNo = currentXqM.wyId;
    saveE.xqNo = currentXqM.xqNo;
    saveE.complaintTitle = typeStr;
    saveE.complaintContent = repairTextV.text;
    saveE.complaintStatus = @"1";
    saveE.contactPerson = usernameTF.text;
    saveE.contactPhone = userPhoneTF.text;
    saveE.contactAddress = chooseComLabel.text;
    saveE.fileId = imgIDStr;
    saveE.source = @"IOS";
    if (self.type == VCTypeComplain) {
        saveE.type = @"1";
    }
    else {
        saveE.type = @"2";
    }
    
    [handler executeSaveInfoTaskWithUser:saveE success:^(id obj) {
        ComplaintSaveE *saveE = (ComplaintSaveE *)obj;
        NSTimeInterval time = 0;
        if (self.type == VCTypeComplain) {
            [AppUtils showSuccessMessage:[NSString stringWithFormat:@"%@%@",W_COMPLAIN_SUC_SUB,saveE.idID]];
            time = 1.0f;
        }
        else {
            [AppUtils showSuccessMessage:[NSString stringWithFormat:@"%@%@",W_REPAIR_SUC_SUB,saveE.idID]];
            time = 2.0f;
        }

        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(pushSubmmitSucVC:)
                                       userInfo:saveE.idID
                                        repeats:NO];
    } failed:^(id obj) {
        if (self.getImgVC.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}

- (void)pushSubmmitSucVC:(NSTimer *)timer {
    NSNumber *saveId = timer.userInfo;
    UIStoryboard *mainStoryB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
    RepairSubmitSucVC *submitVC = [mainStoryB instantiateViewControllerWithIdentifier:@"RepairSubmitSucVCID"];
    submitVC.type = self.type;
    submitVC.orderNum = saveId;
    [self.getImgVC.navigationController pushViewController:submitVC animated:YES];
}

- (void)setType:(VCType)type {
    _type = type;
    if (_type == VCTypeComplain) {
        typeStr = @"投诉";
    }
    else {
        typeStr = @"报修";
    }

    [submmitClickBtn setTitle:[NSString stringWithFormat:@"提交%@",typeStr] forState:UIControlStateNormal];
    titleLabel.text = [NSString stringWithFormat:@"您%@的小区",typeStr];
    chooseTypeLabel.text = [NSString stringWithFormat:@"请选择%@类型",typeStr];
    chooseTypeLabel.textColor = [UIColor lightGrayColor];
    
    if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqName]) {
        chooseComLabel.text = [NSString stringWithFormat:@"%@%@",[UserManager shareManager].comModel.xqName,[UserManager shareManager].comModel.xqHouse];
        chooseComLabel.textColor = [UIColor blackColor];
        currentXqM = [UserManager shareManager].comModel;
    }
    else {
        chooseComLabel.text = [NSString stringWithFormat:@"请选择%@小区",typeStr];
        chooseComLabel.textColor = [UIColor lightGrayColor];
    }
    
    [repairTextV setPlaceHolder:[NSString stringWithFormat:@"请详细描述%@内容",typeStr] fontSize:15];
}

- (void)startNetwork {
     //获取小区列表
    if (communityArr.count > 0) {
        [communityArr removeAllObjects];
    }
   
    BingingXQModel *bindM =[BingingXQModel new];
    bindingHandler *bindH =[bindingHandler new];
    bindM.pageNumber=@"1";
    bindM.pageSize=@"100";
    bindM.merberId=[UserManager shareManager].userModel.memberId;
    bindM.isBinding=@"Y";
    bindM.orderType = @"desc";
    bindM.orderBy = @"dateCreated";
    bindM.wyId = [UserManager shareManager].comModel.wyId;
    
    __block BOOL xqIsSuc = NO;
    __block BOOL leixingIsSuc = NO;
    
    [bindH requsetForGetCommunityDataForModel:bindM success:^(id obj) {
        NSArray *xqList = (NSArray *)obj;
        if (![NSArray isArrEmptyOrNull:xqList]) {
            xqIsSuc = YES;
            [xqList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BingingXQModel *recvbinDingM = obj;
                if (self.type == VCTypeComplain) {
                    if (![NSString isEmptyOrNull:recvbinDingM.complaints] && [recvbinDingM.complaints isEqualToString:@"Y"]) {
                        [communityArr addObject:recvbinDingM];
                    }
                }
                else {
                    if (![NSString isEmptyOrNull:recvbinDingM.repair] && [recvbinDingM.repair isEqualToString:@"Y"]) {
                        [communityArr addObject:recvbinDingM];
                    }
                }
            }];
        }
        else {
            [AppUtils showAlertMessageTimerClose:@"未获取到小区列表"];
        }
        
        if (xqIsSuc && leixingIsSuc) {
            [AppUtils dismissHUD];
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:@"未获取到小区列表"
                            isShow:self.getImgVC.viewIsVisible];
    }];
    
    //获取类型
    if (typeArr.count > 0) {
        [typeArr removeAllObjects];
    }
    
    ComplaintEntity *complaintE = [ComplaintEntity new];
    if (_type == VCTypeComplain) {
        complaintE.type = @"1";
    }
    else {
        complaintE.type = @"2";
    }
    
    ComplaintHandler *complainH = [ComplaintHandler new];
    [typeArr removeAllObjects];
    [complainH executeGetTypeTaskWithUser:complaintE success:^(id obj) {
        typeArr = [(NSArray *)obj mutableCopy];
        if (![NSArray isArrEmptyOrNull:typeArr]) {
            leixingIsSuc = YES;
            [typeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ComplaintEntity *complantE = (ComplaintEntity *)obj;
                if (!complantE.enabled) {
                    [typeArr removeObject:obj];
                }
            }];
        }
        else {
            [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"未获取到%@类型",typeStr]];
        }
        
        if (xqIsSuc && leixingIsSuc) {
            [AppUtils dismissHUD];
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:[NSString stringWithFormat:@"未获取到%@类型",typeStr]
                            isShow:self.getImgVC.viewIsVisible];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextViewTextDidChangeNotification"
                                                 object:repairTextV];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:usernameTF];
}

- (void)textFiledEditChanged:(NSNotification*)obj{
    if ([obj.object isKindOfClass:[UITextField class]]) {
        UITextField *textTF = (UITextField *)obj.object;
        NSUInteger kMaxLength = USER_LENTH;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                   inTextField:textTF];
    }
    
    if ([obj.object isKindOfClass:[UITextView class]]) {
        UITextView *textV = (UITextView *)obj.object;
        NSUInteger kMaxLength = lengthDescInfo;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                    inTextView:textV];
    }
}

- (void)awakeFromNib {
    lengthDescInfo = 200;
    imgCount = 9;
    communityArr =  [NSMutableArray array];
    imgIDStr = [NSMutableString string];
    typeArr = [NSMutableArray array];

    postImgArr = [NSMutableArray arrayWithObject:[UIImage imageNamed:POST_IMG_NAME]];
    
    repairTextV.delegate = self;
    repairTextV.inputAccessoryView = [ZYTextInputBar new];
    [NIDropDown dropDownInstance].delegate = self;
    repairTextV.autocorrectionType=UITextAutocorrectionTypeNo;
    
    usernameTF.delegate = self;
    userPhoneTF.delegate = self;
    userPhoneTF.text = [UserManager shareManager].userModel.phone;
    usernameTF.text = [UserManager shareManager].userModel.realName;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:usernameTF];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:repairTextV];
    
    [GetImgFromSystem getImgInstance].delegate = self;
    imgCollectionV.delegate = self;
    imgCollectionV.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick)];
    [self addGestureRecognizer:tap];
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(startNetwork) userInfo:nil repeats:NO];
    // Initialization code
}

- (void)tableViewClick {
    [self endEditing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        return YES;
    }
    
    if (textView.attributedText.length >= lengthDescInfo || ![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView hidePlaceHolder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [textView hidePlaceHolder];
    }
    else {
        [textView showPlaceHolder];
    }
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button {
    button.selected = NO;
    if (button.tag == RepairButtonCommunity) {
        chooseComLabel.textColor = [UIColor blackColor];
        
        BingingXQModel *xqM = communityArr[index];
        chooseComLabel.text = [NSString stringWithFormat:@"%@%@",xqM.xqName,xqM.xqHouse];
        currentXqM = xqM;
    }
    else if (button.tag == RepairButtonType) {
        chooseTypeLabel.textColor = [UIColor blackColor];
        ComplaintEntity *complaintE = typeArr[index];
        chooseTypeLabel.text = complaintE.name;
    }
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    ImgCollectionCell * imgCell = (ImgCollectionCell *)cell;
    
    imgCell.imgButton.imageView.clipsToBounds=YES;
    imgCell.imgButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imgCell.imgButton setBackgroundImage:postImgArr[indexPath.row] forState:UIControlStateNormal];
    imgCell.imgButton.tag = indexPath.row + 1;
    imgCell.imgButton.backgroundColor = [UIColor redColor];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == usernameTF) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, - 160, self.frame.size.width, self.frame.size.height);
        }];
    }
    else if (textField == userPhoneTF) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, - 170, self.frame.size.width, self.frame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == usernameTF || textField == userPhoneTF) && self.frame.origin.y != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    //限定输入字符的属性
    if (textField == usernameTF) {
        return range.location <= USER_LENTH && [AppUtils isNotLanguageEmoji];
    }
    if (textField == userPhoneTF) {
        return range.location<= 20;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

#pragma mark - GetImgFromSystemDelegate
- (void)getFromImg:(NSArray *)imgArr {
    [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [postImgArr insertObject:obj atIndex:0];
    }];
    [imgCollectionV reloadData];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate && UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger imgNum = 4;
    CGFloat imgHeight = (IPHONE_WIDTH - G_INTERVAL * (imgNum + 1)) / imgNum;
    return CGSizeMake(imgHeight, imgHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger imgNum = 4;
    CGFloat imgHeight = (IPHONE_WIDTH - G_INTERVAL * (imgNum + 1)) / imgNum;
    
    NSUInteger rows = (postImgArr.count % imgNum > 0 ? (postImgArr.count / imgNum + 1) : (postImgArr.count / imgNum));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, collectionView.frame.origin.y + (imgHeight + G_INTERVAL) * rows + G_INTERVAL + collectionBelowView.frame.size.height);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        collectionView.frame=CGRectMake(collectionView.frame.origin.x, collectionView.frame.origin.y, collectionView.frame.size.width, (imgHeight + G_INTERVAL) * rows + G_INTERVAL);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        collectionBelowView.frame = CGRectMake(collectionBelowView.frame.origin.x, collectionView.frame.origin.y + collectionView.frame.size.height, collectionBelowView.frame.size.width, collectionBelowView.frame.size.height);
    });
    
    return postImgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *collectionCellID = SYSTEM_CELL_Col_ID;
    ImgCollectionCell * cell = (ImgCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID
                                                                                              forIndexPath:indexPath];
    if ([AppUtils systemVersion] < 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppUtils systemVersion] >= 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
}

- (IBAction)imgButtonClick:(UIButton *)sender {
    [self endEditing:YES];

    if (sender.tag == postImgArr.count) {
        if (postImgArr.count >= imgCount + 1) {
            [AppUtils showAlertMessage:[NSString stringWithFormat:@"最多只能上传%lu张图片",imgCount]];
        }else{
            NSUInteger MaxImage = imgCount + 1;
            [GetImgFromSystem getImgInstance].maxCount = MaxImage - postImgArr.count;
            [[GetImgFromSystem getImgInstance] getImgFromVC:self.getImgVC];
        }
        return;
    }
    
    NSMutableArray *imgArr = [postImgArr mutableCopy];
    [imgArr removeLastObject];
    
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.dataSource = self;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:sender.tag - 1 inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self.getImgVC];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return postImgArr.count - 1;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [postImgArr objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    
    ImgCollectionCell * cell = (ImgCollectionCell *)[imgCollectionV cellForItemAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    
    photo.toView = cell.imgButton.imageView;
    return photo;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [imgCollectionV reloadData];
}

@end
