//
//  OrderSearchModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface OrderSearchModel : BaseEntity

@property(nonatomic,copy) NSString * pageNumber;

@property(nonatomic,copy) NSString * pageSize;

@property(nonatomic,copy) NSString * OrderNo;


@end
