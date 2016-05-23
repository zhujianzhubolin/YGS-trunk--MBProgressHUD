//
//  WaterRateViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagcommunity = 1,
    ButtonTagUnit,
    ButtonTagAgreeCheck,
    ButtonTagChargeAlert,
    ButtonTagChargeProtocal,
    ButtonTagCalender,
    ButtonTagCharge
};

#import "WECViewController.h"
#import "NIDropDown.h"
#import "ChangePostionButton.h"
#import "UIView+wrapper.h"
#import "WECChargeH.h"
#import "BingingXQModel.h"  
#import "bindingHandler.h"
#import "UserManager.h"
#import "WECChargeE.h"
#import "WECPayConfirmTBVC.h"
#import "CheckstandViewController.h"    
#import "FeesPaidStorage.h"

@interface WECViewController () <UITextFieldDelegate,NIDropDownDelegate>
{
    __weak IBOutlet UILabel *communityLabel;
    __weak IBOutlet UILabel *chargeUnitLabel;
    __weak IBOutlet UITextField *userNumTF;
    __weak IBOutlet UIButton *checkButton;

    __weak IBOutlet UIButton *selectedComBtn;
    __weak IBOutlet UIButton *selectedUnitBtn;
    BingingXQModel *currentXqM; //当前选择小区的数据
    WECChargeE *currentJiaoFeiUnit; //当前缴费单位的数据
}

@end

@implementation WECViewController
{
    NSMutableArray *communityArr;
    NSMutableArray *chargeUnitArr;
}

- (IBAction)queryOrder:(id)sender {
    if (communityLabel.text.length <= 0 || ![communityLabel.textColor isEqual:[UIColor blackColor]]) {
        [AppUtils showAlertMessageTimerClose:@"请选择所在小区"];
        return;
    }
    
    if (chargeUnitLabel.text.length <= 0 || ![chargeUnitLabel.textColor isEqual:[UIColor blackColor]]) {
        [AppUtils showAlertMessageTimerClose:W_PARK_NO_INPUT_CHARGE_UNIT];
        return;
    }
    
    if (userNumTF.text.length == 0) {
        [AppUtils showAlertMessageTimerClose:W_PARK_NO_INPUT_USER_NUM];
        return;
    }
    
    if (userNumTF.text.length < 1 || userNumTF.text.length > 28) {
        [AppUtils showAlertMessageTimerClose:@"用户编号为1-28位"];
        return;
    }

    [self.view endEditing:YES];
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    WECChargeE *chargeOrderE = [WECChargeE new];
    chargeOrderE.sdmType        = [LocalUtils chargeStrForChargeType:self.chargeType];
    chargeOrderE.consNo         = userNumTF.text;
    chargeOrderE.sdmCompanyId   = currentJiaoFeiUnit.BizIncrSdmTestid;
    chargeOrderE.areaCity       = currentXqM.cityid;
    
    WECChargeH *chargeH = [WECChargeH new];
    [chargeH executeChaXunShoufeiOrderTaskWithUser:chargeOrderE success:^(id obj) {
        [FeesPaidStorage saveFeesPaidUserID:chargeOrderE.consNo];
        [AppUtils dismissHUD];
        WECChargeE *wecE = (WECChargeE *)obj;
        wecE.BizIncrSdmTestname     = currentJiaoFeiUnit.BizIncrSdmTestname;
        
        if (![NSString isEmptyOrNull:wecE.prepaIdFlag] && [wecE.prepaIdFlag isEqualToString:@"1"]) {
            UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
            CheckstandViewController *checkstandVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"CheckstandViewControllerID"];
            
            checkstandVC.chargeType     = self.chargeType;
            checkstandVC.payCount       = wecE.sdmMoney;
            checkstandVC.wecE           = wecE;
            checkstandVC.userNum        = chargeOrderE.consNo;
            checkstandVC.xqNo           = currentXqM.xqNo;
            checkstandVC.wyNo           = currentXqM.wyId;
            checkstandVC.cityNo         = currentXqM.cityid;
            checkstandVC.buildingNo     = currentXqM.floorNumber;
            checkstandVC.houseNo        = currentXqM.roomNumber;

            [self.navigationController pushViewController:checkstandVC animated:YES];
            return;
        }
        
        wecE.xqAddress = communityLabel.text;
        wecE.consNo = userNumTF.text;
        
        UIStoryboard *wecSTB = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        WECPayConfirmTBVC *wecPayVC = (WECPayConfirmTBVC *)[wecSTB instantiateViewControllerWithIdentifier:@"WECPayConfirmTBVCID"];
        wecPayVC.chargeType     = self.chargeType;
        wecPayVC.chargeE        = wecE;
        wecPayVC.xqNo           = currentXqM.xqNo;
        wecPayVC.wyNo           = currentXqM.wyId;
        wecPayVC.cityNo         = currentXqM.cityid;
        wecPayVC.buildingNo     = currentXqM.floorNumber;
        wecPayVC.houseNo        = currentXqM.roomNumber;
        wecPayVC.userNum        = chargeOrderE.consNo;
        
        [self.navigationController pushViewController:wecPayVC animated:YES];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

- (void)showUnit:(UIButton *)sender {
    if (chargeUnitArr.count > 0) {
        NSMutableArray *showArr = [NSMutableArray array];
        [chargeUnitArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WECChargeE *chargeRecvE = (WECChargeE *)obj;
            [showArr addObject:chargeRecvE.BizIncrSdmTestname];
        }];
        [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(sender.frame.size.width, 40 * (showArr.count > 5 ? 5 : showArr.count))
                                                 withButton:sender
                                                    withArr:showArr];
    }
    else {
        [self getChargeUnit];
    }
}

- (IBAction)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case ButtonTagcommunity:{
            if (communityArr.count > 0) {
                NSMutableArray *showArr = [NSMutableArray array];
                
                [communityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    BingingXQModel *xqM = (BingingXQModel *)obj;
                    [showArr addObject:[NSString stringWithFormat:@"%@",xqM.xqName]];
                }];

                [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(sender.frame.size.width, 40 * (showArr.count > 5 ? 5 : showArr.count))
                                                           withButton:sender
                                                              withArr:showArr];
            }
        }
            break;
        case ButtonTagUnit:{
            [self showUnit:sender];
        }
            break;
        case ButtonTagAgreeCheck: {
            sender.selected = !sender.selected ;
        }
            break;
        case ButtonTagChargeProtocal: {

        }
            break;
        case ButtonTagChargeAlert: {
            sender.selected = !sender.selected;
        }
            break;
        case ButtonTagCalender:  {

        }
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(startNetwork) userInfo:nil repeats:NO];
    // Do any additional setup after loading the view.
}

- (void)initData {
    communityArr = [NSMutableArray array];
    chargeUnitArr = [NSMutableArray array];
    self.title = [NSString stringWithFormat:@"缴%@",[LocalUtils titleForChargeType:self.chargeType]];
    
    if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqName]) {
        currentXqM = [UserManager shareManager].comModel;
    }
    else {
        currentXqM = [BingingXQModel new];
    }
    currentJiaoFeiUnit = [WECChargeE new];
    
    if (![NSString isEmptyOrNull:[FeesPaidStorage feesPaidUserID]]) {
        userNumTF.text = [FeesPaidStorage feesPaidUserID];
    }
}

- (void)initUI {
    checkButton.layer.cornerRadius = 5;
    [NIDropDown dropDownInstance].delegate = self;
    
    if (![NSString isEmptyOrNull:currentXqM.xqName]) {
        communityLabel.text = [NSString stringWithFormat:@"%@",currentXqM.xqName];
        communityLabel.textColor = [UIColor blackColor];
    }
}

- (void)startNetwork {
    //获取绑定小区列表
    if (communityArr.count > 0) {
        [communityArr removeAllObjects];
    }
    
    BingingXQModel *bindM =[BingingXQModel new];
    bindingHandler *bindH =[bindingHandler new];
    bindM.pageNumber    =   @"1";
    bindM.pageSize      =   @"100";
    bindM.merberId      =   [UserManager shareManager].userModel.memberId;
#ifdef SmartComJYZX
    bindM.isBinding     =   @"Y";
#elif SmartComYGS
    
#else
    
#endif
    
    bindM.orderType     =   @"asc";
    bindM.orderBy       =   @"dateCreated";
    bindM.wyId          =   [UserManager shareManager].comModel.wyId;
    
    [bindH requsetForGetCommunityDataForModel:bindM success:^(id obj) {
        NSArray *xqList = (NSArray *)obj;
        if (![NSArray isArrEmptyOrNull:xqList]) {
            communityArr = [NSMutableArray arrayWithArray:xqList];
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:@"未获取到小区列表"
                            isShow:self.viewIsVisible];
    }];
}

- (void)getChargeUnit {
    //获取缴费单位
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    WECChargeE *chargeE = [WECChargeE new];
    chargeE.sdmType     = [LocalUtils chargeStrForChargeType:self.chargeType];
    chargeE.areaCity    = currentXqM.cityid;
    
    WECChargeH *chargeH = [WECChargeH new];
    [chargeH executeChaXunShoufeiDanWeiTaskWithUser:chargeE success:^(id obj) {
        [AppUtils dismissHUD];
        NSArray *recvArr = (NSArray *)obj;
        [chargeUnitArr removeAllObjects];
        if (![NSArray isArrEmptyOrNull:recvArr]) {
            chargeUnitArr = [NSMutableArray arrayWithArray:recvArr];
            [self showUnit:selectedUnitBtn];
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button{
    if (button == selectedComBtn && index < communityArr.count) {
        BingingXQModel *xqM = communityArr[index];
        currentXqM = xqM;
        communityLabel.text = [NSString stringWithFormat:@"%@",currentXqM.xqName];
        communityLabel.textColor = [UIColor blackColor];
        [NetworkRequest cancelAllOperations];
        dispatch_async(dispatch_get_main_queue(), ^{
            chargeUnitLabel.text = @"选择收费单位";
            chargeUnitLabel.textColor = [UIColor lightGrayColor];
        });
        [chargeUnitArr removeAllObjects];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getChargeUnit];
        });
    }
    else if (button == selectedUnitBtn && index < chargeUnitArr.count) {
        WECChargeE *jiaofeiE = chargeUnitArr[index];
        currentJiaoFeiUnit = jiaofeiE;
        chargeUnitLabel.text = currentJiaoFeiUnit.BizIncrSdmTestname;
        chargeUnitLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    if (userNumTF.text.length < 8) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [string isEqualToString:filtered];
        return canChange;
    }
    return range.location < 28;
}

@end
