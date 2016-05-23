//
//  TrafficFineChargeE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TrafficOrderE : BaseEntity

@property (nonatomic, copy) NSString *carnumber;//车牌号
@property (nonatomic, copy) NSString *carcode;//车辆识别码
@property (nonatomic, copy) NSString *cardrivenumber;//发动机号

@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, copy) NSString *code;//通知书编号,暂时使用CODE代替
@property (nonatomic, copy) NSString *location;//违章地点
@property (nonatomic, copy) NSString *reason;//违章原因
@property (nonatomic, copy) NSString *count;//罚款金额
@property (nonatomic, copy) NSString *Degree;//违章扣分
@property (nonatomic, copy) NSString *poundage;//手续费
@property (nonatomic, copy) NSString *canProcess;//是否可代缴
@property (nonatomic, copy) NSString *Archive; //通知书编号
@property (nonatomic, copy) NSString *LocationName; //违章地点

@property (nonatomic, copy) NSString *SecondaryUniqueCode;//违章记录ID

@end
