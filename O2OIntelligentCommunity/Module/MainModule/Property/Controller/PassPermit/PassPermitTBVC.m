//
//  PassPermitTBVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger,PropertyTag) {
    PropertyComName = 1,
    PropertyBuildingNum,
    PropertyRoomNum,
    PropertyInviter,
    PropertyPhone,
    PropertyDate
};

#import "PassPermitTBVC.h"
#import "NIDropDown.h"
#import "PassFooterView.h"
#import "PassPermitEntity.h"
#import "UserManager.h"
#import "NSString+wrapper.h"
#import "bindingHandler.h"
#import "UMSocial.h"
#import "HYActivityView.h"
#import "WXApi.h"
#import "UIImage+wrapper.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "ZYTextInputBar.h"

@interface PassPermitTBVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NIDropDownDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation PassPermitTBVC
{
    IBOutlet UITableView *infoTableView;
    NSArray *descArr;
    NSMutableArray *communityArr;
    NSMutableArray *validityArr;
    NSArray *infoArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:infoTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(startNetwork) userInfo:nil repeats:NO];
}

- (void)initData {
    self.title = @"访客通行";

    infoArr = @[@"小  区  名:",@"楼  栋  号:",@"房  间  号:",@"邀  请  人:",@"手  机  号:",@"截止日期:"];
    descArr = @[@"小区",@"请选择楼栋号",@"请输入房间号",@"请填写您的真实姓名",@"请输入您的手机号",@"请选择有效截止日期"];
    communityArr = [NSMutableArray array];
    validityArr = [NSMutableArray array];
    
    NSTimeInterval currentTimes = [AppUtils currentTimeSince1970];
    for (int i = 0; i < 15; i++) {
        NSTimeInterval addTimes = currentTimes;
        addTimes += 3600 * 24 * i * 1000;
        NSString *date = [AppUtils timeStringFromTimeInterval:addTimes];
        [validityArr addObject:[date substringToIndex:10]];
    }
}

- (void)initUI {
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    CGFloat interval = 15;
    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(interval, 0, headerV.frame.size.width - interval *2, headerV.frame.size.height)];
    infoL.text = @"请完成以下信息后分享给访客";
    infoL.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
    [headerV addSubview:infoL];
    infoTableView.tableHeaderView = headerV;
    
    PassFooterView *footer = [[[NSBundle mainBundle] loadNibNamed:@"PassFooterView" owner:self options:nil] lastObject];
    footer.frame = CGRectMake(0, 0, infoTableView.frame.size.width, 274);
    
    __block __typeof(footer)weakFooter = footer;
    footer.clickBlock = ^(NSUInteger btnTag) {
        
        __block BOOL isEmptyStr = NO;
        [descArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         UITextField *textF = (UITextField *)[infoTableView viewWithTag:idx + 1];
            if ([textF.text trim].length <= 0) {
                isEmptyStr = YES;
                *stop = YES;
            }
        }];
         
         if (isEmptyStr) {
             [AppUtils showAlertMessage:@"亲爱的,请填写完整的用户信息"];
             return;
         }
        
       
        UITextField *phoneTF = (UITextField *)[self.tableView viewWithTag:PropertyPhone];
        if (![AppUtils isMobileNumber:phoneTF.text]) {
            [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
            return;
        }

        PassPermitEntity *passE = [PassPermitEntity new];

        [descArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UITextField *textF = (UITextField *)[infoTableView viewWithTag:idx + 1];
            switch (textF.tag) {
                case PropertyComName:
                    passE.community = textF.text;
                    break;
                case PropertyBuildingNum:
                case PropertyRoomNum:
                    passE.community = [NSString stringWithFormat:@"%@ %@",passE.community,textF.text];
                    break;
                case PropertyInviter:
                    passE.userName = textF.text;
                    break;
                case PropertyPhone:
                    passE.phone = textF.text;
                    break;
                case PropertyDate:
                    passE.validity = textF.text;
                    break;
                default:
                    break;
            }
        }];
        
        if (btnTag == 10) {
            [weakFooter reloadDataWithModel:passE isGeneratePass:YES];
        }
        else if (btnTag == 20){
            [self shareClick];
        }
    };
    
    infoTableView.tableFooterView = footer;
    
    [NIDropDown dropDownInstance].delegate = self;
}

- (void)dealloc{
    UITextField *inviterTF = (UITextField *)[infoTableView viewWithTag:PropertyInviter];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                  name:@"UITextFieldTextDidChangeNotification"
                                                object:inviterTF];
}

- (void)textFiledEditChanged:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 5;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}

- (void)shareClick {
    if (!self.activityView) {
        UITextField *comTextF = (UITextField *)[infoTableView viewWithTag:PropertyComName];
        UITextField *buildTF = (UITextField *)[infoTableView viewWithTag:PropertyBuildingNum];
        UITextField *roomTF = (UITextField *)[infoTableView viewWithTag:PropertyRoomNum];
        UITextField *visitrorTF = (UITextField *)[infoTableView viewWithTag:PropertyInviter];
        UITextField *phoneTF = (UITextField *)[infoTableView viewWithTag:PropertyPhone];
        UITextField *dateTextF = (UITextField *)[infoTableView viewWithTag:PropertyDate];
        UIImage *shareImg = [UIImage imageNamed:P_SHARE_IMAGE];
        
        NSString *unicodeStr = [NSString stringWithFormat:@"访客通行证小区名:%@&楼栋号:%@&房间号:%@&邀请人:%@&手机号:%@&有效日期:%@",comTextF.text,buildTF.text,roomTF.text,visitrorTF.text,phoneTF.text,dateTextF.text];
        NSString *shareUnicodeStr = [unicodeStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *shareURL = [NSString stringWithFormat:@"%@%@",P_PASS_SHARE,shareUnicodeStr];
        
        NSLog(@"shareURL =  %@",shareURL);
        NSString *title = @"通行证";
        
        NSString *shareStr = [NSString stringWithFormat:@"%@通行证，有效期至%@",comTextF.text,dateTextF.text];
        
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:[UIApplication sharedApplication].keyWindow];
//        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 2;
        
        ButtonView *bv = [[ButtonView alloc]init];
//        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"lfxinlangweibo"] handler:^(ButtonView *buttonView){
//            NSLog(@"点击新浪微博");
//            [[UMSocialControllerService defaultControllerService] setShareText:shareStr shareImage:shareImg socialUIDelegate:self];        //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        }];
//        [self.activityView addButtonView:bv];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [UMSocialQQHandler setQQWithAppId:P_APPID_QQ appKey:P_APPKEY_QQ url:shareURL];
            bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"lfQQ"] handler:^(ButtonView *buttonView){
                NSLog(@"QQ");
                [UMSocialData defaultData].extConfig.qqData.title = title;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }];
            [self.activityView addButtonView:bv];
        }
        
        if ([WXApi isWXAppInstalled]) {
            [UMSocialWechatHandler setWXAppId:P_APPID_WX appSecret:P_APPKEY_WX url:shareURL];
            bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"lfweixin"] handler:^(ButtonView *buttonView){
                NSLog(@"微信");
                [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                    
                }];
                
            }];
            [self.activityView addButtonView:bv];
        }
        
        bv = [[ButtonView alloc]initWithText:@"短信" image:[UIImage imageNamed:@"lfduanxin"] handler:^(ButtonView *buttonView){
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }];
        [self.activityView addButtonView:bv];
    }
    [self.activityView show];
}

- (void)startNetwork {
    if (communityArr.count > 0) {
        [communityArr removeAllObjects];
    }
    
    BingingXQModel *bindM =[BingingXQModel new];
    bindingHandler *bindH =[bindingHandler new];
    
    bindM.pageNumber=@"1";
    bindM.pageSize = @"100";
    bindM.merberId=[UserManager shareManager].userModel.memberId;
    bindM.orderType = @"asc";
    bindM.orderBy = @"dateCreated";
    bindM.isBinding=@"Y";
    bindM.wyId = [UserManager shareManager].comModel.wyId;
    
    [bindH requsetForGetCommunityDataForModel:bindM success:^(id obj) {
        [AppUtils dismissHUD];
        NSArray *xqList = (NSArray *)obj;
        if (![NSArray isArrEmptyOrNull:xqList]) {
            [xqList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BingingXQModel *recvbinDingM = obj;
                if (![NSString isEmptyOrNull:recvbinDingM.pass] && [recvbinDingM.pass isEqualToString:@"Y"]) {
                    [communityArr addObject:recvbinDingM];
                }
            }];
        }
        else {
           [AppUtils showAlertMessageTimerClose:@"亲，没有获取到小区哦"];
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseCommunity:(UIButton *)button {
    [self.view endEditing:YES];
    if (communityArr.count > 0) {
        NSMutableArray *showArr = [NSMutableArray array];
        [communityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            BingingXQModel *xqM = (BingingXQModel *)obj;
            [showArr addObject:[NSString stringWithFormat:@"%@%@",xqM.xqName,xqM.xqHouse]];
        }];
        
        [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(button.superview.frame.size.width, 40 * (showArr.count > 5 ? 5 : showArr.count))
                                                 withButton:button
                                                    withArr:showArr];
    }
}

- (void)chooseDateOfvalidity:(UIButton *)button{
    [self.view endEditing:YES];
    [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(button.superview.frame.size.width, 40 * (validityArr.count > 5 ? 5 : validityArr.count))
                                             withButton:button
                                                withArr:validityArr];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = infoArr[indexPath.row];
    
    CGFloat interval = 15;
    CGFloat textXPoint = 100;
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(textXPoint, 5, tableView.frame.size.width - interval - textXPoint,35)];
    textF.inputAccessoryView = [ZYTextInputBar shareInstance];
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.borderStyle = UITextBorderStyleRoundedRect;
    textF.delegate = self;
    textF.tag = indexPath.row + 1;
    textF.placeholder = descArr[indexPath.row];
    [cell.contentView addSubview:textF];
    
    if (indexPath.row == PropertyComName - 1) {
        if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqName]) {
            textF.text = [UserManager shareManager].comModel.xqName;
        }
        
        UIButton *accessoryButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        accessoryButton1.frame = CGRectMake(0, 0, textF.frame.size.width, textF.frame.size.height);
        accessoryButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        accessoryButton1.tag = 20 + PropertyComName;
        [accessoryButton1 setTitle:@" " forState:UIControlStateNormal];
        [accessoryButton1 setImage:[UIImage imageNamed:@"communityName"] forState:UIControlStateNormal];
        [accessoryButton1 addTarget:self action:@selector(chooseCommunity:) forControlEvents:UIControlEventTouchUpInside];
        [textF addSubview:accessoryButton1];
    }
    else if (indexPath.row == PropertyBuildingNum - 1) {
        if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqName]) {
            
            if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.unitName]) {
                textF.text = [NSString stringWithFormat:@"%@",[UserManager shareManager].comModel.floorName];
            }
            else {
                textF.text = [NSString stringWithFormat:@"%@ %@",[UserManager shareManager].comModel.floorName,[UserManager shareManager].comModel.unitName];
            }
        }
    }
    else if (indexPath.row == PropertyRoomNum - 1) {
        if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqName]) {
            textF.text = [UserManager shareManager].comModel.roomNumber;
        }
    }
    else if (indexPath.row == PropertyInviter - 1) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:textF];
        if (![NSString isEmptyOrNull:[UserManager shareManager].userModel.realName]) {
            textF.text = [UserManager shareManager].userModel.realName;
        }
        
    }
    else if (indexPath.row == PropertyPhone - 1) {
        textF.keyboardType = UIKeyboardTypePhonePad;
        if (![NSString isEmptyOrNull:[UserManager shareManager].userModel.phone]) {
            textF.text = [UserManager shareManager].userModel.phone;
        }
    }
    else if (indexPath.row == PropertyDate - 1) {
        UIButton *accessoryButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
        accessoryButton6.frame = CGRectMake(0, 0, textF.frame.size.width, textF.frame.size.height);
        accessoryButton6.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        accessoryButton6.tag = 20 + PropertyDate;
        [accessoryButton6 setTitle:@" " forState:UIControlStateNormal];
        [accessoryButton6 setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [accessoryButton6 addTarget:self action:@selector(chooseDateOfvalidity:) forControlEvents:UIControlEventTouchUpInside];
        [textF addSubview:accessoryButton6];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == PropertyComName ||
        textField.tag == PropertyBuildingNum ||
        textField.tag == PropertyRoomNum ||
        textField.tag == PropertyDate) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == PropertyInviter && ![AppUtils isNotLanguageEmoji]) {
        return NO;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    if (textField.tag == PropertyInviter) { //用户名
        NSUInteger nameLength = 10;
        return range.location < nameLength;
    }

    if (textField.tag == PropertyPhone) { //手机号码
        return range.location < PHONE_INPUT_BITS;
    }
    
    return YES;
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button {
    button.selected = NO;
    if (button.tag == 20 + PropertyComName) {
        UITextField *xqF = (UITextField *)[infoTableView viewWithTag:PropertyComName];
        UITextField *loudongF = (UITextField *)[infoTableView viewWithTag:PropertyBuildingNum];
        UITextField *fangjianF = (UITextField *)[infoTableView viewWithTag:PropertyRoomNum];
        BingingXQModel *xqM = communityArr[index];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            xqF.text = xqM.xqName;
            if ([NSString isEmptyOrNull:xqM.unitName]) {
                loudongF.text = [NSString stringWithFormat:@"%@",xqM.floorName];
            }
            else {
                loudongF.text = [NSString stringWithFormat:@"%@ %@",xqM.floorName,xqM.unitName];
            }
            fangjianF.text = xqM.roomNumber;
        });
    }
    else if (button.tag == 20 + PropertyDate) {
        UITextField *textF = (UITextField *)[infoTableView viewWithTag:PropertyDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            textF.text = validityArr[index];
        });
    }
}

@end
