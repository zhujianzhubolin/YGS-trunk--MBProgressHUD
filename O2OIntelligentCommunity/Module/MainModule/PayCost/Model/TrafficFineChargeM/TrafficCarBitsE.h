//
//  TrafficCarBitsE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TrafficCarBitsE : BaseEntity

//参数
@property (nonatomic, copy) NSString *province;//省份
@property (nonatomic, copy) NSString *city;//城市


//返回
@property (nonatomic, copy) NSNumber *carCodeLen;//车架号
@property (nonatomic, copy) NSNumber *carEngineLen;//发动机号

@end

