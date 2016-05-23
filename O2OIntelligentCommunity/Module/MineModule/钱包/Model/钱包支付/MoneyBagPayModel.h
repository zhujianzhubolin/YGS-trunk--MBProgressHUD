//
//  MoneyBagPayModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/19.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface MoneyBagPayModel : BaseEntity

@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *payPassWord;//支付密码
@property(nonatomic,copy)NSString *amount;//金额
@property(nonatomic,copy)NSString *payOrderNo;//支付订单号

@end
