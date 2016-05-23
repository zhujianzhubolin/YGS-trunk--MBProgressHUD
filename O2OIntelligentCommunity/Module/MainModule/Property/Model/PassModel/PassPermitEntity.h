//
//  PassEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface PassPermitEntity : BaseEntity

@property (nonatomic, copy) NSString *community;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *validity;

@end
