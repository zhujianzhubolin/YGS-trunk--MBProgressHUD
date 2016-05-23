//
//  ComplaintEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ComplaintEntity : BaseEntity

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSNumber *idID;
@property (nonatomic, copy) NSString *optionGroupId;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *enabled;

@end
