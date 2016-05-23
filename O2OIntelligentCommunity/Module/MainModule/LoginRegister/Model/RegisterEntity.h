//
//  RegisterEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface RegisterEntity : BaseEntity

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *registerType;
@property (nonatomic, copy) NSString *orgcode;
@property (nonatomic, copy) NSString *verCode; //验证码
@property (nonatomic, copy) NSString *recomPhone; //邀请人电话
@property (nonatomic, copy) NSString *phone; //电话号码
@property (nonatomic, copy) NSString *channel; //注册渠道

@end
