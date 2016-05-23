//
//  LoginStorage.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/18.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserArchive.h"

@interface LoginStorage : NSObject


/**
 *  获取登录用户名
 *
 *  @return
 */
+ (NSString *)userName;

/**
 *  保存登录用户名
 *
 *  @param userName
 */
+ (void)saveUserName:(NSString *)userName;

/**
 *  获取用户ID
 *
 *  @return
 */
+ (NSString *)userID;
/**
 *  保存用户ID
 *
 *  @param uid
 */
+ (void)saveUid:(NSString *)uid;

//保存、获取获取用户账号
+ (void)savePhone:(NSString *)phone;
+ (NSString *)userPhone;

//保存、获取用户参数
+ (void)saveUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)userInfo;

//用户是否第一次登录
+ (void)saveUserNoFirstUse:(BOOL)isFirst;
+ (BOOL)userNoFisrtUse;

+ (void)encodeUserDic:(NSDictionary *)dicJson;
+ (NSDictionary *)decodeUserDic;
@end
