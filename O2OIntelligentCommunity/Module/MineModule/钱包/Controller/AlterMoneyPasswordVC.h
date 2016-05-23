//
//  AlterMoneyPasswordVC.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



#import "O2OBaseViewController.h"

typedef NS_ENUM(NSUInteger, PasswordPage) {
    ModificatoryPassword,  //修改密码
    ForgetPassword//忘记密码
};


@interface AlterMoneyPasswordVC : O2OBaseViewController

@property (nonatomic,assign)PasswordPage isPasswordPage;

@end
