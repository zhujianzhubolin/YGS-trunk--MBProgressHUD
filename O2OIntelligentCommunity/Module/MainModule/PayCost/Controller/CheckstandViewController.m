//
//  CheckstandViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define CHARGE_TEST @"1"
#import "CheckstandViewController.h"
#import <SVProgressHUD.h>
#import "ChargeOrderE.h"
#import "ChargeOrderH.h"
#import "UserManager.h"
#import "PaySucViewController.h"
#import "WeChatPayClass.h"
#import "TrafficSubmmitOrderE.h"
#import "TrafficOrderE.h"
#import "TrafficFinesH.h"
#import "LocalUtils.h"
#import "MoneyBagPayHandler.h"
#import "ZSDPaymentView.h"
#import "PaymentInAdvanceHeaderV.h"
#import "OpenMoneyBagVC.h"
#import "UserManager.h"

@interface CheckstandViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation CheckstandViewController
{
    NSArray *section1Arr;
    NSArray *section2LabelArr;
    NSArray *section2ImgArr;
    IBOutlet UITableView *checkstandTableView;
    UIView *bgV;
    UIView *buttomV;
    PayType currentPayType;
}

//分割线靠边界
-(void)viewDidLayoutSubviews{
    [self viewDidLayoutSubviewsForTableView:checkstandTableView];
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    self.title = @"收银台";
    
    if ([WXApi isWXAppInstalled]) {
        section2LabelArr = @[@"钱包支付",@"微信支付"];
    }
    else {
        section2LabelArr = @[@"钱包支付"];
    }
    section2ImgArr = @[@"myPay",@"weChatPay"];
    
    switch (self.chargeType) {
        case ChargeTypePhone: {
            section1Arr = @[@"缴费内容: ",@"手机号码: ",@"归  属  地: ",@"缴费金额: "];
        }
            break;
        case ChargeTypeProperty:
        case ChargeTypePark:
        {
            section1Arr = @[@"缴费内容: ",@"当前小区: ",@"缴费金额: "];
        }
            break;
        case ChargeTypeTraffic:
        {
            section1Arr = @[@"缴费内容: ",@"车  牌  号: ",@"缴费金额: "];
        }
            break;
        case ChargeTypeCoal:
        case ChargeTypeElec:
        case ChargeTypeWater:
        {
            if (![NSString isEmptyOrNull:self.wecE.prepaIdFlag] && [self.wecE.prepaIdFlag isEqualToString:@"1"]) { //预缴费
                section1Arr = [NSArray array];
                PaymentInAdvanceHeaderV *headerV = [[PaymentInAdvanceHeaderV alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 161)];
                [headerV configurateOweAcount:self.payCount
                                      balance:self.wecE.prepayBal
                                   chargeType:self.chargeType];
                checkstandTableView.tableHeaderView = headerV;
                break;
            }
            section1Arr = @[@"缴费内容: ",@"用户编号: ",@"缴费金额: "];
        }
            break;
        default:
            break;
    }
}

- (void)initUI {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.tableView.frame.size.width, 60)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat interval = 15;
    footerButton.frame = CGRectMake(interval, 10, self.tableView.frame.size.width - interval * 2, footer.frame.size.height - 10 *2);
    [footerButton setTitle:@"立即支付" forState:UIControlStateNormal];
    footerButton.layer.cornerRadius = 5;
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    
    [footerButton setBackgroundColor:[AppUtils colorWithHexString:@"fc6c22"]];
    [footerButton addTarget:self action:@selector(immediatePayClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:footerButton];
    
    checkstandTableView.tableFooterView = footer;
    UITapGestureRecognizer *endEdtingtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingForSelf)];
    [self.tableView addGestureRecognizer:endEdtingtap];
}

- (void)endEditingForSelf {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PayType)payTypeForSelectedIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return PayTypeQianBao;
        case 1:
            return PayTypeWeiXin;
        default:
            break;
    }
    return 0;
}

- (void)accessoryBtnClick:(UIButton *)btn {
    for (int i = 10; i < 10 + section2LabelArr.count; i++) {
        UIButton *eachButton = (UIButton *)[checkstandTableView viewWithTag:i];
        eachButton.selected = NO;
    }
    btn.selected = YES;
    currentPayType = [self payTypeForSelectedIndex:btn.tag - 10];
}

- (void)immediatePayClick {
    [self.view endEditing:YES];
    
    if (currentPayType == PayTypeQianBao && self.payCount.floatValue > 5000) {
        [AppUtils showAlertMessage:@"亲，支付金额不能超过5000元哦"];
        return;
    }
    
    NSString *showMessage = nil;
    if (self.chargeType == ChargeTypePhone) {
        showMessage = @"正在充值中,请稍等";
    }
    else {
        showMessage = @"正在缴费中,请稍等";
    }
    
    
    if (currentPayType == PayTypeQianBao && ![UserManager shareManager].isOpenWallet) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"亲,您尚未开通钱包,请前往 我的->钱包开通" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];
        alertV.delegate = self;
        [alertV show];
        return;
    }
    
    [AppUtils showProgressMessage:showMessage];
    switch (self.chargeType) {
        case ChargeTypePhone: {
            ChargeOrderE *phoneOrderE = [ChargeOrderE new];
            if (currentPayType == PayTypeWeiXin) {
                phoneOrderE.saleAmount      = [NSString stringWithFormat:@"%.0f",self.payCount.floatValue * 100];
            }
            else {
                phoneOrderE.saleAmount      = self.payCount;
            }
            phoneOrderE.usernumber      = self.phone;
            phoneOrderE.memberInfoPid   = [UserManager shareManager].userModel.memberId;
            phoneOrderE.spbillCreateIp  = [AppUtils deviceIPAdress]; //@"192.168.188.104"
            phoneOrderE.tradeType       = @"APP";
            phoneOrderE.body            = [LocalUtils chargeBodyForCharegeType:ChargeTypePhone];
            phoneOrderE.totalFee        = phoneOrderE.saleAmount;
            phoneOrderE.pay_method      = [LocalUtils payTypeStrForPayType:currentPayType];
            phoneOrderE.wyNo            = [UserManager shareManager].comModel.wyId;
            phoneOrderE.orderSource     = @"APP";
            phoneOrderE.attach          = ENVIRONMENT;
            
            ChargeOrderH *phoneOrderH = [ChargeOrderH new];
            [phoneOrderH executePhoneChargeTaskWithOrder:phoneOrderE
                                                 payType:currentPayType
                                                 success:^(id obj) {
                                                     [AppUtils showSuccessMessage:@"支付成功"];
                                                     [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pushNextVC) userInfo:nil repeats:NO];
                                                 } failed:^(id obj) {
                                                     if (self.viewIsVisible) {
                                                         [AppUtils showAlertMessageTimerClose:obj];
                                                     }
                                                     else {
                                                         [AppUtils dismissHUD];
                                                     }
                                                 }];
        }
            break;
        case ChargeTypeProperty: {
            NSMutableArray *paraArr = [NSMutableArray array];
            [self.idsArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PropertyChargeE *propertyE = (PropertyChargeE *)obj;
                ChargeOrderE *propertyOrderE = [ChargeOrderE new];
                
                propertyOrderE.endDate             = propertyE.endDate;
                propertyOrderE.infoId              = propertyE.ids;
                propertyOrderE.memberInfoPid       = [UserManager shareManager].userModel.memberId;
                
                if (currentPayType == PayTypeWeiXin) {
                    propertyOrderE.totalFee            = [NSString stringWithFormat:@"%.0f",propertyE.saleAmount.floatValue * 100];
                    propertyOrderE.domesticWasteFee    = [NSString stringWithFormat:@"%.0f",propertyE.domesticWasteFee.floatValue * 100];
                    propertyOrderE.ontologyGold        = [NSString stringWithFormat:@"%.0f",propertyE.ontologyGold.floatValue * 100];
                    propertyOrderE.dischargeFee        = [NSString stringWithFormat:@"%.0f",propertyE.dischargeFee.floatValue * 100];
                    propertyOrderE.managementFee       = [NSString stringWithFormat:@"%.0f",propertyE.managementFee.floatValue * 100];
                    propertyOrderE.electricity         = [NSString stringWithFormat:@"%.0f",propertyE.electricity.floatValue * 100];
                    propertyOrderE.water               = [NSString stringWithFormat:@"%.0f",propertyE.water.floatValue * 100];
                    propertyOrderE.coal                = [NSString stringWithFormat:@"%.0f",propertyE.coal.floatValue * 100];
                    propertyOrderE.overdueFine         = [NSString stringWithFormat:@"%.0f",propertyE.overdueFine.floatValue * 100];
                }
                else {
                    propertyOrderE.totalFee            = [NSString stringWithFormat:@"%.2f",propertyE.saleAmount.floatValue];
                    propertyOrderE.domesticWasteFee    = propertyE.domesticWasteFee;
                    propertyOrderE.ontologyGold        = propertyE.ontologyGold;
                    propertyOrderE.dischargeFee        = propertyE.dischargeFee;
                    propertyOrderE.managementFee       = propertyE.managementFee;
                    propertyOrderE.electricity         = propertyE.electricity;
                    propertyOrderE.water               = propertyE.water;
                    propertyOrderE.coal                = propertyE.coal;
                    propertyOrderE.overdueFine         = propertyE.overdueFine;
                }
                propertyOrderE.saleAmount          = propertyOrderE.totalFee;
                propertyOrderE.xqNo                = propertyE.xqNo;
                propertyOrderE.wyNo                = propertyE.wyID;
                propertyOrderE.buildNo             = propertyE.buildNo;
                propertyOrderE.unitNo              = propertyE.unitNo;
                propertyOrderE.houseNo             = propertyE.houseNo;
                propertyOrderE.tradeType           = @"APP";
                propertyOrderE.attach              = ENVIRONMENT;
                propertyOrderE.body                = [LocalUtils chargeBodyForCharegeType:ChargeTypeProperty];
                propertyOrderE.spbillCreateIp      = [AppUtils deviceIPAdress];
                propertyOrderE.payType             = [LocalUtils payTypeStrForPayType:currentPayType];
                propertyOrderE.orderSource         = @"APP";
                propertyOrderE.cityNo              = propertyE.cityNo;
                
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                propertyOrderE.saleAmount,@"saleAmount",
                                                propertyOrderE.totalFee,@"total_fee",
                                                propertyOrderE.endDate,@"endDate",
                                                propertyOrderE.infoId,@"infoId",
                                                propertyOrderE.memberInfoPid,@"memberInfoPid",
                                                propertyOrderE.domesticWasteFee,@"domesticWasteFee",
                                                propertyOrderE.ontologyGold,@"ontologyGold",
                                                propertyOrderE.dischargeFee,@"dischargeFee",
                                                propertyOrderE.managementFee,@"managementFee",
                                                propertyOrderE.electricity,@"electricity",
                                                propertyOrderE.water,@"water",
                                                propertyOrderE.coal,@"coal",
                                                propertyOrderE.overdueFine,@"overdueFine",
                                                propertyOrderE.xqNo,@"xqNo",
                                                propertyOrderE.wyNo,@"wyNo",
                                                propertyOrderE.buildNo,@"buildNo",
                                                propertyOrderE.unitNo,@"unitNo",
                                                propertyOrderE.houseNo,@"houseNo",
                                                propertyOrderE.tradeType,@"trade_type",
                                                propertyOrderE.attach,@"attach",
                                                propertyOrderE.body,@"body",
                                                propertyOrderE.spbillCreateIp,@"spbill_create_ip",
                                                propertyOrderE.payType,@"payType",
                                                propertyOrderE.orderSource,@"orderSource",
                                                propertyOrderE.cityNo,@"cityNo",
                                                nil];
                [paraArr addObject:paraDic];
            }];
            
            if (paraArr.count <= 0) {
                [AppUtils showAlertMessageTimerClose:@"未获取到缴费列表"];
                return;
            }
            
            ChargeOrderH *propertyOrderH = [ChargeOrderH new];
            [propertyOrderH executePropertyChargeTaskWithArr:paraArr payType:currentPayType success:^(id obj) {
                [AppUtils showSuccessMessage:@"支付成功"];
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pushNextVC) userInfo:nil repeats:NO];
            } failed:^(id obj) {
                if (self.viewIsVisible) {
                    [AppUtils showAlertMessageTimerClose:obj];
                }
                else {
                    [AppUtils dismissHUD];
                }
            }];
        }
            break;
        case ChargeTypePark: {
            ChargeOrderE *parkOrderE = [ChargeOrderE new];
            parkOrderE.licenseNumber    = self.licenseNumber;
            parkOrderE.memberInfoPid    = [UserManager shareManager].userModel.memberId;
            parkOrderE.spbillCreateIp   = [AppUtils deviceIPAdress]; //@"192.168.188.104"
            parkOrderE.tradeType        = @"APP";
            parkOrderE.body             = [LocalUtils chargeBodyForCharegeType:ChargeTypePark];
            
            if (currentPayType == PayTypeWeiXin) {
                parkOrderE.totalFee         = [NSString stringWithFormat:@"%.0f",self.payCount.floatValue * 100];
                parkOrderE.monthlyFee       = [NSString stringWithFormat:@"%.0f",self.monthlyFee.floatValue * 100];
            }
            else {
                parkOrderE.totalFee         = self.payCount;
                parkOrderE.monthlyFee       = self.monthlyFee;
            }
            parkOrderE.mouths           = self.mouths;
            parkOrderE.parkingType      = self.parkingType;
            parkOrderE.xqNo             = self.xqNo;
            parkOrderE.wyNo             = self.wyNo;
            parkOrderE.cityNo           = self.cityNo;
            parkOrderE.orderSource      = @"APP";
            parkOrderE.infoNo           = self.infoNo;
            parkOrderE.payType          = [LocalUtils payTypeStrForPayType:currentPayType];
            parkOrderE.attach           = ENVIRONMENT;
            
            ChargeOrderH *propertyOrderH = [ChargeOrderH new];
            [propertyOrderH executeParkChargeTaskWithOder:parkOrderE payType:currentPayType success:^(id obj) {
                [AppUtils showSuccessMessage:@"支付成功"];
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pushNextVC) userInfo:nil repeats:NO];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj
                                    isShow:self.viewIsVisible];
            }];
        }
            break;
        case ChargeTypeTraffic: {
            NSMutableArray *paraArr = [NSMutableArray array];
            [self.idsArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                TrafficOrderE *orderE = (TrafficOrderE *)obj;
                TrafficSubmmitOrderE *trafficE = [TrafficSubmmitOrderE new];
                trafficE.carnumber = orderE.carnumber;
                trafficE.cardrivenumber = orderE.cardrivenumber;
                trafficE.carcode = orderE.carcode;
                trafficE.Archive = orderE.code;
                if (currentPayType == PayTypeWeiXin) {
                    trafficE.count = [NSString stringWithFormat:@"%.2f",orderE.count.floatValue * 100];
                    trafficE.poundage = [NSString stringWithFormat:@"%.2f",orderE.poundage.floatValue * 100];
                }
                else {
                    trafficE.count = [NSString stringWithFormat:@"%.2f",orderE.count.floatValue];
                    trafficE.poundage = orderE.poundage;
                }
                trafficE.Location   = orderE.location;
                trafficE.reason     = orderE.reason;
                trafficE.secondaryUniqueCode = orderE.SecondaryUniqueCode;
                trafficE.time       = orderE.time;
                trafficE.degree = orderE.Degree;
                trafficE.memberInfoPid = [UserManager shareManager].userModel.memberId;
                trafficE.body       = [LocalUtils chargeBodyForCharegeType:ChargeTypeTraffic];
                trafficE.trade_type = @"APP";
                trafficE.spbill_create_ip = [AppUtils deviceIPAdress];
                trafficE.total_fee  = [NSString stringWithFormat:@"%.2f",orderE.count.floatValue + orderE.poundage.floatValue];
                trafficE.code       = @"0000";
                trafficE.pay_method = [LocalUtils payTypeStrForPayType:currentPayType];
                trafficE.wyNo       = [UserManager shareManager].comModel.wyId;
                trafficE.orderSource = @"APP";
                trafficE.merchantName = @"交通罚款";
                trafficE.xqNo       = [UserManager shareManager].comModel.xqNo;
                trafficE.wyNo       = [UserManager shareManager].comModel.wyId;
                trafficE.cityId     = [UserManager shareManager].comModel.cityid;
                trafficE.attach     = ENVIRONMENT;
                
                NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                trafficE.carnumber,@"carnumber",
                                                trafficE.cardrivenumber,@"cardrivenumber",
                                                trafficE.carcode,@"carcode",
                                                trafficE.Archive,@"archive",
                                                trafficE.count,@"count",
                                                trafficE.Location,@"location",
                                                trafficE.poundage,@"poundage",
                                                trafficE.reason,@"reason",
                                                trafficE.secondaryUniqueCode,@"secondaryuniquecode",
                                                trafficE.degree,@"degree",
                                                trafficE.time,@"time",
                                                //                                                trafficE.sn,@"sn",
                                                trafficE.memberInfoPid,@"memberInfoPid",
                                                trafficE.body,@"body",
                                                trafficE.trade_type,@"trade_type",
                                                trafficE.spbill_create_ip,@"spbill_create_ip",
                                                trafficE.total_fee,@"total_fee",
                                                //                                                trafficE.pay_company,@"pay_company",
                                                trafficE.pay_method,@"payType",
                                                trafficE.code,@"code",
                                                trafficE.orderSource,@"orderSource",
                                                trafficE.merchantName,@"merchantName",
                                                trafficE.xqNo,@"xqNo",
                                                trafficE.wyNo,@"wyNo",
                                                trafficE.cityId,@"cityId",
                                                trafficE.attach,@"attach",
                                                nil];
                [paraArr addObject:paraDic];
            }];
            
            if (paraArr.count <= 0) {
                [AppUtils showAlertMessageTimerClose:@"未获取到缴费列表"];
                return;
            }
            
            ChargeOrderH *propertyOrderH = [ChargeOrderH new];
            [propertyOrderH executeTrafficFinesChargeTaskWithUser:paraArr payType:currentPayType success:^(id obj) {
                [AppUtils showSuccessMessage:@"支付成功"];
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pushNextVC) userInfo:nil repeats:NO];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj
                                    isShow:self.viewIsVisible];
            }];
        }
            break;
        case ChargeTypeWater:
        case ChargeTypeElec:
        case ChargeTypeCoal: {
            ChargeOrderE *wecOrderE = [ChargeOrderE new];
            if (![NSString isEmptyOrNull:self.wecE.prepaIdFlag] && [self.wecE.prepaIdFlag isEqualToString:@"1"]) { //预缴费
                PaymentInAdvanceHeaderV *headerV = (PaymentInAdvanceHeaderV *)checkstandTableView.tableHeaderView;
                CGFloat payOweMoneyCount = [headerV getOweMoneyAount].floatValue;
                self.payCount = [headerV getInputChargeAcount];
                
                if (self.payCount.floatValue < 1) {
                    [AppUtils showAlertMessage:@"预缴金额必须大于1元"];
                    return;
                }
                
                if (self.payCount.floatValue < payOweMoneyCount) {
                    [AppUtils showAlertMessage:@"预缴金额必须大于欠费金额"];
                    return;
                }
                
                if (self.payCount.floatValue > 50000) {
                    [AppUtils showAlertMessage:@"尊敬的用户,为了您的资金安全,暂不支持金额大于5000的交易"];
                    return;
                }
            }
            
            wecOrderE.sdmType = [LocalUtils chargeStrForChargeType:self.chargeType];
            wecOrderE.memberInfoPid = [UserManager shareManager].userModel.memberId;
            wecOrderE.userNumber = self.userNum;
            if (currentPayType == PayTypeWeiXin) {
                wecOrderE.payAmount = [NSString stringWithFormat:@"%.0f",self.payCount.floatValue * 100];
            }
            else {
                wecOrderE.payAmount = self.payCount;
            }

            wecOrderE.usernumber            = [UserManager shareManager].userModel.phone;
            wecOrderE.attach                = ENVIRONMENT;
            wecOrderE.spbillCreateIp        = [AppUtils deviceIPAdress]; //@"192.168.188.104"
            wecOrderE.tradeType             = @"APP";
            wecOrderE.body                  = [LocalUtils chargeBodyForCharegeType:ChargeTypeCoal];
            wecOrderE.totalFee              = wecOrderE.payAmount;
            wecOrderE.pay_method            = [LocalUtils payTypeStrForPayType:currentPayType];
            wecOrderE.orderSource           = @"APP";
            wecOrderE.wyNo                  = [UserManager shareManager].comModel.wyId;
            wecOrderE.buildNo               = self.buildingNo;
            wecOrderE.houseNo               = self.houseNo;
            wecOrderE.xqNo                  = self.xqNo;
            wecOrderE.prepaIdFlag           = self.wecE.prepaIdFlag;
            wecOrderE.contentNo             = self.wecE.contentNo;
            wecOrderE.contNo                = self.wecE.contNo;
            wecOrderE.chargeUnit            = self.wecE.BizIncrSdmTestname;
            wecOrderE.cityNo                = self.cityNo;
            wecOrderE.userName              = self.wecE.sdmName;
            wecOrderE.address               = self.wecE.address;
            
            ChargeOrderH *wecOrderH = [ChargeOrderH new];
            [wecOrderH executeWECTaskWithOder:wecOrderE payType:currentPayType success:^(id obj) {
                [AppUtils showSuccessMessage:@"支付成功"];
                [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(pushNextVC)
                                               userInfo:nil
                                                repeats:NO];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj
                                    isShow:self.viewIsVisible];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)pushNextVC {
    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    PaySucViewController *paySuccessVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"PaySucViewControllerID"];
    paySuccessVC.payType = [LocalUtils titleForChargeType:self.chargeType];
    paySuccessVC.payCount = self.payCount;
    
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return section1Arr.count;
    }
    else if (section == 1) {
        return section2LabelArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],[LocalUtils titleForChargeType:self.chargeType]];
                break;
            case 1: {
                if (self.chargeType == ChargeTypePhone) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],self.phone];
                }
                else if (self.chargeType == ChargeTypeProperty){
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],self.community];
                }
                else if (self.chargeType == ChargeTypePark){
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],self.xqName];
                }
                else if (self.chargeType == ChargeTypeTraffic) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],self.licenseNumber];
                }
                else if (self.chargeType == ChargeTypeWater || self.chargeType == ChargeTypeElec || self.chargeType == ChargeTypeCoal) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],self.userNum];
                }
            }
                break;
            case 2: {
                if (self.chargeType == ChargeTypePhone) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",section1Arr[indexPath.row]];
                    if (![NSString isEmptyOrNull:self.attribution]) {
                        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",section1Arr[indexPath.row],self.attribution];
                    }
                }
                break;
            }
                break;
            default:
                break;
        }
        
        if (indexPath.row == section1Arr.count - 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@元",section1Arr[indexPath.row],self.payCount];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(5, str.length - 5)];
            cell.textLabel.attributedText = str;
        }
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",section2LabelArr[indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:section2ImgArr[indexPath.row]];
        
        UIButton *accessotyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        accessotyBtn.frame = CGRectMake(0, 0, 15, 15);
        accessotyBtn.tag = indexPath.row + 10;
        [accessotyBtn addTarget:self action:@selector(accessoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [accessotyBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
        [accessotyBtn setImage:[UIImage imageNamed:@"gou_h"] forState:UIControlStateSelected];
        
        if (indexPath.row == 0) {
            currentPayType = [self payTypeForSelectedIndex:indexPath.row];
            accessotyBtn.selected = YES;
        }
        cell.accessoryView = accessotyBtn;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *accessotyBtn = (UIButton *)[self.tableView viewWithTag:10 + indexPath.row];
    [self accessoryBtnClick:accessotyBtn];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"   请选择支付方式";
    }
    return nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        OpenMoneyBagVC *openMoneyVC = [OpenMoneyBagVC new];
        [self.navigationController pushViewController:openMoneyVC animated:YES];
    }
}

@end
