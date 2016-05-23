//
//  LoginHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"
#import "O2OLoginViewController.h"

@interface UserHandler : BaseHandler

@property (nonatomic,assign) LoginMode loginMode;

/**
 *  用户登录业务逻辑处理
 *
 *  @param user
 *  @param success
 *  @param failed
 */
- (void)executeLoginTaskWithUser:(UserEntity *)user
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed;


//获取用户信息参数
+ (void)executeGetUserInfoSuccess:(SuccessBlock)success
                           failed:(FailedBlock)failed;
//退出
+ (void)logout;

+ (void)decodeLoginUser:(NSDictionary *)dicJson;
@end
