//
//  ShangChengGoodsModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ShangChengGoodsModel : BaseEntity

@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSNumber * catalogId;
@property(nonatomic,copy) NSString * pageNumber;
@property(nonatomic,copy) NSString * pageSize;

@end
