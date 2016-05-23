//
//  AppDelegate.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//


#import "AppDelegate.h"
#import <UIKit+AFNetworking.h>
#import <AFNetworking.h>
#import "NetworkRequest.h"  
#import "UserHandler.h"
#import <SVProgressHUD.h>
#import "UserManager.h"
//APP端签名相关头文件
#import "WeChatPayClass.h"
#import "AppManager.h"

#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)  //无网

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIStoryboard *mainTB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.myTBVC = [mainTB instantiateInitialViewController];

    //在顶上显示加载指示器
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
//    [self reachability];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setErrorImage:nil];
    
    //向微信注册
    [WXApi registerApp:P_APPID_WX withDescription:@"weixin"];
    [UMSocialData setAppKey:P_UM_KEY];

    return YES;
}

//- (void)reachability
//{
//    // 连接状态回调处理
//    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
//    __weak typeof(self) weakSelf = self;
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
//     {
//         switch (status)
//         {
//             case AFNetworkReachabilityStatusUnknown:
//                 [weakSelf showExceptionDialog:@"未识别的网络"];
//                 // 回调处理
//                 break;
//             case AFNetworkReachabilityStatusNotReachable:
//                 [weakSelf showExceptionDialog:@"不可达的网络(未连接)"];
//                 // 回调处理
//                 break;
//             case AFNetworkReachabilityStatusReachableViaWWAN:
//                 [weakSelf showExceptionDialog:@"2G,3G,4G...的网络"];
//                 // 回调处理
//                 break;
//             case AFNetworkReachabilityStatusReachableViaWiFi:
//                 [weakSelf showExceptionDialog:@"wifi的网络"];
//                 // 回调处理
//                 break;
//             default:
//                 break;
//         }
//     }];
//    
//    // 检测网络连接状态
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//}

//弹出网络错误提示框
- (void)showExceptionDialog:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示"
                                message:message
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:nil];
    [alertV show];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissAlertV:) userInfo:alertV repeats:NO];
}

- (void)dismissAlertV:(NSTimer *)timer {
    UIAlertView *alertV = timer.userInfo;
    [alertV dismissWithClickedButtonIndex:0 animated:YES];
}

//跳转到微信支付界面
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *string = [url absoluteString];
    
    if ([string hasPrefix:P_APPID_WX]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }

    if ([string hasPrefix:P_APPWB_ID]) {
        return  [UMSocialSnsService handleOpenURL:url];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *string = [url absoluteString];
    
    if ([string hasPrefix:P_APPID_WX]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }

    if ([string hasPrefix:P_APPWB_ID]) {
        return  [UMSocialSnsService handleOpenURL:url];
    }
    return YES;
}



//微信支付结回调
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                self.wxPayBlock(WXPaySuccess,@"支付成功");
                break;
            case -1:
                self.wxPayBlock(WXPayFail,@"支付失败");
                break;
            case -2:
                self.wxPayBlock(WXPayCancel,@"用户取消支付");
                break;
            default:
                self.wxPayBlock(WXPayFailOther,[NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr]);
                break;
        }
    }else{
        switch (resp.errCode) {
            case 0:
                [self alertWithTitle:@"分享提示" msg:@"分享成功"];
                break;
            case -1:
                [self alertWithTitle:@"分享提示" msg:@"分享失败"];
                break;
            case -2:
                [self alertWithTitle:@"分享提示" msg:@"取消分享"];
                break;
            default:
                break;
        }
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [AppUtils closeKeyboard];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([UserManager shareManager].userModel.memberId.length > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UserHandler executeGetUserInfoSuccess:^(id obj) {
            } failed:^(id obj) {
            }];
        });
    }

    [[AppManager shareManager] getSystemVersionInfo];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
