//
//  LogisticsVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "LogisticsVC.h"
#import "ZJWebProgrssView.h"

@interface LogisticsVC ()<UIWebViewDelegate>
{
    UIWebView *webV;
    ZJWebProgrssView *progressV;
}

@end
@implementation LogisticsVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    self.navigationController.navigationBar.translucent=NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent=YES;
}

-(void)initUI
{
    
    self.title=@"物流";
    
    webV =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
     webV.scalesPageToFit=YES;
    webV.delegate =self;
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:progressV];
    
    NSString *urlStr =[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@#result",_deliveryMerchantType,_aliasOrderNo];
    
    __block __typeof(self)weakSelf = self;
    progressV.loadBlock = ^ {
        [weakSelf loadWebWithURL:urlStr];
    };
    [self loadWebWithURL:urlStr];
    
    
}

- (void)loadWebWithURL:(NSString *)urlStr {
    NSURL *url =[[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webV loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [progressV startAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view addSubview:webV];
    [progressV stopAnimationNormalIsNoData:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [progressV stopAnimationFailIsNoData:YES];
}
@end
