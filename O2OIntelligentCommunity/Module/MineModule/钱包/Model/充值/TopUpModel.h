//
//  TopUpModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TopUpModel : BaseEntity

@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *appid;//公众账号ID
@property(nonatomic,copy)NSString *attach;//附加数据
@property(nonatomic,copy)NSString *body;//描述
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *mch_id;//商户号
@property(nonatomic,copy)NSString *openid;//用户标识
@property(nonatomic,copy)NSString *payType;
@property(nonatomic,copy)NSString *spbill_create_ip;//终端IP
@property(nonatomic,copy)NSString *total_fee;//总金额
@property(nonatomic,copy)NSString *trade_type;//交易类型













@end
