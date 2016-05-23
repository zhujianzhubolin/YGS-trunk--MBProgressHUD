//
//  WECChargeE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface WECChargeE : BaseEntity

@property (nonatomic, copy) NSString *xqNo;
@property (nonatomic, copy) NSString *sdmType; //获取缴费订单 缴费项目(编码表提供) 6011：水    6012：电    6013：燃
@property (nonatomic, copy) NSString *consNo; //缴费号码（户号或条形码）
@property (nonatomic, copy) NSString *sdmCompanyId; //公司id
@property (nonatomic, copy) NSString *memberInfoPid; //用户ID
@property (nonatomic, copy) NSString *areaCity; //城市ID

//信息确认的参数
@property (nonatomic, copy) NSString *xqAddress; //所在小区

//查询某个小区的缴费单位
@property (nonatomic, copy) NSString *BizIncrSdmTestname; //缴费单位
@property (nonatomic, copy) NSString *BizIncrSdmTestid; //缴费单位的ID

//查询某个小区对应的缴费单位的缴费信息
@property (nonatomic, copy) NSString *sdmMoney; //缴费金额
@property (nonatomic, copy) NSString *sdmName; //姓名
@property (nonatomic, copy) NSString *sdmRemarks; //备注
@property (nonatomic, copy) NSString *prepaIdFlag; //1.	预付费，用户可自行输入缴费金额 2.	后付费，根据欠费账单查询结果缴费
@property (nonatomic, copy) NSString *contNo; //缴费号码（户号或条形码）
@property (nonatomic, copy) NSString *contentNo; //明细id
@property (nonatomic, copy) NSString *address; //返回地址
@property (nonatomic, copy) NSString *prepayBal; //账户余额

@end
