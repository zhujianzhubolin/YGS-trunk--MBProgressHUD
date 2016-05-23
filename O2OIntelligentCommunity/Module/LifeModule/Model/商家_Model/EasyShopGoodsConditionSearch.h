//
//  EasyShopGoodsConditionSearch.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface EasyShopGoodsConditionSearch : BaseEntity

@property(nonatomic,copy) NSNumber * pageNumber;
@property(nonatomic,copy) NSNumber * pageSize;
@property(nonatomic,copy) NSNumber * catalogId;
@property(nonatomic,copy) NSNumber * storeId;
@property(nonatomic,copy) NSNumber * categoryId;


@end
