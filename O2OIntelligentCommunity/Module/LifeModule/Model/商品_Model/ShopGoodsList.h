//
//  ShopGoodsList.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ShopGoodsList : BaseEntity

@property(nonatomic,copy) NSNumber * pageNumber;

@property(nonatomic,copy) NSNumber * pageSize;

@property(nonatomic,copy) NSString * storeId;

@property(nonatomic,copy) NSString * catalogId;

@property(nonatomic,copy) NSString * categoryId;

@property(nonatomic,copy) NSString * Sort;

@property(nonatomic,copy) NSString * productName;

@property(nonatomic,copy) NSString * memberId;


//companyId 物业ID
@property(nonatomic,copy) NSString * companyId;

@end
