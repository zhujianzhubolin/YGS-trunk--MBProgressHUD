//
//  AdActivityWebVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/7.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "AdActivityWebVC.h"
#import "NSString+wrapper.h"
#import "HYActivityView.h"
#import <UIImageView+AFNetworking.h>
#import "UMSocial.h"
#import "HYActivityView.h"
#import "WXApi.h"
#import "UIImage+wrapper.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "ZYTextInputBar.h"

NSString * const kAdWebActivity = @"Coupons"; //广告网页代金券活动

@interface AdActivityWebVC () <UIWebViewDelegate>
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation AdActivityWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hidetabbar];
    
    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    webV.delegate = self;
    webV.scalesPageToFit = YES;
    
    self.view = webV;
    NSLog(@"self.webURL = %@",self.webURL);
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
    
    self.view = webV;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@"#"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (funcStr.length <= 0) {
            return YES;
        }
        
        if ([NSString isEmptyOrNull:self.adTypeStr]) {
            return YES;
        }
        
        NSLog(@"arrFucnameAndParameter = %@",arrFucnameAndParameter);
        if ([self.adTypeStr isEqualToString:kAdWebActivity]) { //代金券活动
            if([funcStr isEqualToString:@"WebVouchersShareClick"])
            {
                [self webViewBackWithParameter:[arrFucnameAndParameter objectAtIndex:1]];
            }
        }
        
        return NO;
    };
    return YES;
}

- (void)webViewBackWithParameter:(NSString *)parameter {
    if (parameter.length > 0) {
        NSArray *paraComps = [parameter componentsSeparatedByString:@"__"];
        NSString *shareTitle;
        NSString *content;
        NSString *imgURL;
        NSString *url;
        
        if (![NSString isEmptyOrNull:paraComps[0]]) {
            shareTitle = paraComps[0];
        }
        
        if (![NSString isEmptyOrNull:paraComps[1]]) {
            content = paraComps[1];
        }
        
        if (![NSString isEmptyOrNull:paraComps[2]]) {
            imgURL = paraComps[2];
        }
        
        if (![NSString isEmptyOrNull:paraComps[3]]) {
            url = paraComps[3];
        }
        else {
            return;
        }
        
        if (!self.activityView) {
            UIImage *shareImg = [UIImage imageNamed:P_SHARE_IMAGE];
            NSString *title = [NSString stringWithString:[shareTitle stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *shareStr = [NSString stringWithString:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];;
            NSString *shareURL = [NSString stringWithFormat:@"%@%@",SHARE_API_HOST,url];
            
            self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:[UIApplication sharedApplication].keyWindow];
            //        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
            self.activityView.numberOfButtonPerLine = 2;
            
            ButtonView *bv = [[ButtonView alloc]init];
            //        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"lfxinlangweibo"] handler:^(ButtonView *buttonView){
            //            NSLog(@"点击新浪微博");
            //            [[UMSocialControllerService defaultControllerService] setShareText:shareStr shareImage:shareImg socialUIDelegate:self];        //设置分享内容和回调对象
            //            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            //        }];
            //        [self.activityView addButtonView:bv];
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                [UMSocialQQHandler setQQWithAppId:P_APPID_QQ appKey:P_APPKEY_QQ url:shareURL];
                bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"lfQQ"] handler:^(ButtonView *buttonView){
                    NSLog(@"QQ");
                    [UMSocialData defaultData].extConfig.qqData.title = title;
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"分享成功！");
                        }
                    }];
                }];
                [self.activityView addButtonView:bv];
            }
            
            if ([WXApi isWXAppInstalled]) {
                [UMSocialWechatHandler setWXAppId:P_APPID_WX appSecret:P_APPKEY_WX url:shareURL];
                bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"lfweixin"] handler:^(ButtonView *buttonView){
                    NSLog(@"微信");
                    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"分享成功！");
                        }
                    }];
                }];
                [self.activityView addButtonView:bv];
            }
            
            bv = [[ButtonView alloc]initWithText:@"短信" image:[UIImage imageNamed:@"lfduanxin"] handler:^(ButtonView *buttonView){
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:shareStr image:shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];
            }];
            [self.activityView addButtonView:bv];
        }
        [self.activityView show];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
