//
//  WECPayConfirmViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseTableViewController.h"
#import "WECChargeE.h"
@interface WECPayConfirmTBVC : BaseTableViewController

@property (nonatomic, assign) ChargeType chargeType; //缴费类型
@property (nonatomic, strong) WECChargeE *chargeE; //用户的缴费信息
@property (nonatomic, copy) NSString *xqNo;//小区Id
@property (nonatomic, copy) NSString *wyNo; //物业Id
@property (nonatomic, copy) NSString *cityNo;//城市Id
@property (nonatomic, copy) NSString *buildingNo;//楼栋ID
@property (nonatomic, copy) NSString *houseNo;//房号ID
@property (nonatomic, copy) NSString *userNum;//用户编号 水电燃
@end
