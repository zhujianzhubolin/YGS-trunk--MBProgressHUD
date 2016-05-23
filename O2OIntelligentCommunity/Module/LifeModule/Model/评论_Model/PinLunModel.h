//
//  PinLunModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface PinLunModel : BaseEntity

@property(nonatomic,copy) NSNumber * pageNumber;

@property(nonatomic,copy) NSNumber * pageSize;

@property(nonatomic,copy) NSNumber * productId;

@property(nonatomic,copy) NSString * storeName;

@property(nonatomic,copy) NSString * optionId;

@property(nonatomic,copy) NSString * screening;

@property(nonatomic,copy) NSString * commId;

@property(nonatomic,copy) NSString * convenient;

@end
