//
//  UserManager.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BingingXQModel.h"
#import "UserOwnEntity.h"

@interface UserManager : NSObject
@property (nonatomic, assign,readonly) BOOL isLogin; //用户是否登陆
@property (nonatomic, assign,readonly) BOOL isBinding; //默认小区是否已绑定
@property (nonatomic, assign,readonly) BOOL isAuthenting; //默认小区是否正在认证中
@property (nonatomic, assign,readonly) BOOL isOpenWallet; //钱包是否开通

@property (nonatomic, assign) BOOL isFromLogin; //是否从登录进入

@property (nonatomic, strong) UserOwnEntity *userModel;
@property (nonatomic, strong) BingingXQModel *comModel;
/**
 *  单例
 *
 *  @return 单例
 */
+ (UserManager *)shareManager;

/**
 *  显示登录界面
 *
 *  @param controller root
 */
- (void)showLoginViewFromVC:(UIViewController *)controller;

//用户未绑定小区的判断提示
- (BOOL)showCommunityAlertIsBindingFromNav:(UINavigationController *)navVC;

@end
