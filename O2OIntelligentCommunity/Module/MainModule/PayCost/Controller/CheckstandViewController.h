//
//  CheckstandViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseTableViewController.h"
#import "WECChargeE.h"

@interface CheckstandViewController : BaseTableViewController

@property (nonatomic, assign) ChargeType chargeType; //缴费类型
@property (nonatomic, copy) NSString *phone; //手机号 话费充值
@property (nonatomic, copy) NSString *attribution; //归属地 话费充值
@property (nonatomic, copy) NSString *community; //小区地址
@property (nonatomic, copy) NSString *xqName; //小区名称
@property (nonatomic, copy) NSString *payCount; //支付总金额
@property (nonatomic, copy) NSString *licenseNumber; //车牌号码
//@property (nonatomic, copy) NSString *prepaIdFlag; //水电燃是否预缴费的标志 


@property (nonatomic, strong) NSMutableArray *idsArr; //多个订单的订单数组

//@property (nonatomic, copy) NSString *chargeTime; //缴费时长，目前按月份算，停车费使用
@property (nonatomic, copy) NSString *monthlyFee; //当前类型的缴费金额，停车费使用
@property (nonatomic, copy) NSString *parkingType; //缴费类型，停车费使用
@property (nonatomic, copy) NSString *infoNo; //停车费ID
@property (nonatomic, copy) NSString *mouths; //缴费月数

@property (nonatomic, strong) WECChargeE *wecE; //水电燃缴费参数
@property (nonatomic, copy) NSString *userNum;//用户编号 水电燃

@property (nonatomic, copy) NSString *xqNo;//小区Id
@property (nonatomic, copy) NSString *wyNo; //物业Id
@property (nonatomic, copy) NSString *cityNo;//城市Id
@property (nonatomic, copy) NSString *buildingNo;//楼栋ID
@property (nonatomic, copy) NSString *houseNo;//房号ID

@end
