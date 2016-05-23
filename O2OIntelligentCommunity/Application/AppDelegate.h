//
//  AppDelegate.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
typedef NS_ENUM(NSUInteger, WXPayStatus) {
    WXPaySuccess,
    WXPayFail,
    WXPayCancel,
    WXPayFailOther
};

typedef void (^WXPayCompleteBlock) (NSUInteger payStatus, NSString *prompt);

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "MyTabBarViewController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WXPayCompleteBlock wxPayBlock;
@property (strong, nonatomic) MyTabBarViewController *myTBVC;
@end

