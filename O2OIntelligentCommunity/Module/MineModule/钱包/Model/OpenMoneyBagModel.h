//
//  OpenMoneyBagModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface OpenMoneyBagModel : BaseEntity

@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *cardNo;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *payPassword;

@end
