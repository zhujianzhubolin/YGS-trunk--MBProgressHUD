//
//  PropertyChargeE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface PropertyChargeE : BaseEntity

@property (nonatomic, copy) NSString *membenInfoPid;//会员Id
@property (nonatomic, copy) NSString *consumeType;//6031：物业 6032：停车
@property (nonatomic, copy) NSString *xqNo;//小区Id
@property (nonatomic, copy) NSString *wyID;//物业Id
@property (nonatomic, copy) NSString *buildNo;//楼栋Id
@property (nonatomic, copy) NSString *unitNo;//单元Id
@property (nonatomic, copy) NSString *houseNo;//房屋Id
@property (nonatomic, copy) NSArray *list; //缴费列表

@property (nonatomic, copy) NSString *STATUS;//缴费状态  new
@property (nonatomic, copy) NSNumber *pageNumber;//页数
@property (nonatomic, copy) NSNumber *pageSize;//总页数
@property (nonatomic, copy) NSString *cityNo; //城市ID

@property (nonatomic, assign) BOOL isShow; //是否展开
@property (nonatomic, copy) NSString *domesticWasteFee; //垃圾处理费
@property (nonatomic, copy) NSString *ontologyGold; //本体金
@property (nonatomic, copy) NSString *dischargeFee; //排污费
@property (nonatomic, copy) NSString *managementFee; //管理费
@property (nonatomic, copy) NSString *electricity;
@property (nonatomic, copy) NSString *water;
@property (nonatomic, copy) NSString *coal;
@property (nonatomic, copy) NSString *overdueFine;//滞纳金
@property (nonatomic, copy) NSString *saleAmount; //某个区间的价格综合
@property (nonatomic, copy) NSString *chargeUnit; //收费单位

@property (nonatomic, copy) NSString *endDate; //结束时间
@property (nonatomic, copy) NSString *ids; //数据库ID
@property (nonatomic, copy) NSString *infoNo; //停车费ID

@property (nonatomic, copy) NSString *licenseNumber;//车牌号
@property (nonatomic, copy) NSString *parkingType;//车库类型
@property (nonatomic, copy) NSString *monthlyFee;//车库类型数额
@property (nonatomic, copy) NSString *mouths;//缴费时长
@end
