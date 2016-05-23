//
//  MapViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "MapViewController.h"
#import "APIConfig.h"

@interface MapViewController ()<UIWebViewDelegate>

{
    UIWebView * webView;
}

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家地址";
    webView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT -10)];
    webView.scalesPageToFit = YES;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.delegate = self;
    
    NSString * adress = [self.dataDict[@"entity"][@"storeAddress"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * name = [self.dataDict[@"entity"][@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * telePhone = [NSString stringWithFormat:@"%@",self.dataDict[@"entity"][@"phone"]];
    NSString * longtatueX = [NSString stringWithFormat:@"%@",self.dataDict[@"entity"][@"longitude"]];
    NSString * latueY = [NSString stringWithFormat:@"%@",self.dataDict[@"entity"][@"latitude"]];
    
    
    //NSString * urlstr = [NSString stringWithFormat:@"http://%@10013/baiduMap.html?pointX=%@&pointY=%@&markerArrTitle=%@&markerArrContent=%@,tel:%@",A_HOST_MDM,longtatueX,latueY,name,adress,telePhone];//X大些
    
    NSString * urlstr;
    
    #ifdef DEBUG
        urlstr = [NSString stringWithFormat:@"http://%@10013/baiduMap.html?pointX=%@&pointY=%@&markerArrTitle=%@&markerArrContent=%@,tel:%@",A_HOST_MDM,longtatueX,latueY,name,adress,telePhone];//X大些
    #else
        urlstr = [NSString stringWithFormat:@"http://images.ygs001.com/map/baiduMap.html?pointX=%@&pointY=%@&markerArrTitle=%@&markerArrContent=%@,tel:%@",longtatueX,latueY,name,adress,telePhone];//X大些
    #endif
    
    

    
    [self loadWebPageWithString:urlstr];
    [self.view addSubview:webView];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSLog(@"连接地址>>>>>%@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"Start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"Finish");
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"load failed");
}

@end
