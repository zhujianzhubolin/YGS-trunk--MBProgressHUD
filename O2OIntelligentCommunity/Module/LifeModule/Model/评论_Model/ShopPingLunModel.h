//
//  ShopPingLunModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/25.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ShopPingLunModel : BaseEntity

@property(nonatomic,copy) NSString * storeId;
@property(nonatomic,copy) NSString * storeType;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * pageNumber;


@end
