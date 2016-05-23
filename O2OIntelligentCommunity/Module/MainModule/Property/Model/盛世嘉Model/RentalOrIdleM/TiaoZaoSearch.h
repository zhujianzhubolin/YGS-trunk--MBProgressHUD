//
//  TiaoZaoSearch.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TiaoZaoSearch : BaseEntity

@property(nonatomic,copy) NSString * pageNumber;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * orderBy;
@property(nonatomic,copy) NSString * orderType;
@property(nonatomic,copy) NSString * transactionType;
@property(nonatomic,copy) NSString * fleaMarketType;
@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * version;


@end
