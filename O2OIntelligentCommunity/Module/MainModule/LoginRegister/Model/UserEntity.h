//
//  UserEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface UserEntity : BaseEntity
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *loginType;

@property (nonatomic, copy) NSString *sal;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *registerType;
@property (nonatomic, copy) NSString *orgcode;

@property (nonatomic, copy) NSString *memberId;

@end
