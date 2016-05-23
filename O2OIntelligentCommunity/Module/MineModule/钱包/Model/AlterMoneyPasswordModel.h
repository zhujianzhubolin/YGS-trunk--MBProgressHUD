//
//  AlterMoneyPasswordModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface AlterMoneyPasswordModel : BaseEntity
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *oldpayPassword;
@property(nonatomic,copy)NSString *payPassword;


@end
