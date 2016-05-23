//
//  HoneyTradeInfoModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface HoneyTradeInfoModel : BaseEntity
@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *pageNumber;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,strong)NSDictionary *queryMap;

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数

@property (nonatomic,strong)NSArray *list;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *point;//积分交易明细
@property (nonatomic,copy)NSString *changeDesc;//描述
@property (nonatomic,copy)NSString *changTime;//获得日期
@property (nonatomic,copy)NSString *beforeBusinessPoint;//交易前积分
@property (nonatomic,copy)NSString *afterBusinessPoint;//交易后积分
@property (nonatomic,copy)NSString *changeType;//类型

@property (nonatomic)NSNumber *integral;//积分兑换数

@property (nonatomic)NSString *reference;//多少积分对应一元


@end
