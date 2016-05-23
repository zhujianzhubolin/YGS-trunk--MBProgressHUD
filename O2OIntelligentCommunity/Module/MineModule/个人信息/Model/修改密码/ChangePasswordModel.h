//
//  ChangePasswordModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ChangePasswordModel : BaseEntity

@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *oldPassword;//原始密码
@property(nonatomic,copy)NSString *NewPassword;//新密码
@property(nonatomic,copy)NSString *salt;//加密因子
@property(nonatomic,copy)NSString *reference;
@property(nonatomic,copy)NSString *verifyName;//手机号

@end
