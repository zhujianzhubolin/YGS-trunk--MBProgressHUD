//
//  ShouCangGoods.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"


//商家跟商品公用一个model

@interface ShouCangGoods : BaseEntity

@property(nonatomic,copy) NSString * memberId;

@property(nonatomic,copy) NSString *productId;

//商家收藏专用
@property(nonatomic,copy) NSString * storeId;

@property(nonatomic,copy) NSString * isDeleted;


@end
