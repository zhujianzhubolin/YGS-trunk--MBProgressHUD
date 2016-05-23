//
//  PhoneChargeE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface PhoneChargeE : BaseEntity

@property (nonatomic, copy) NSString *saleAmount; //面额
@property (nonatomic, copy) NSString *memberInfoPid; //用户登录id
@property (nonatomic, copy) NSString *usernumber; //手机号码
@property (nonatomic, copy) NSString *payAmount; //用户支付的价格

@end
