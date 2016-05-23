//
//  WebVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "WebVC.h"
#import "NSString+wrapper.h"
#import "ZJWebProgrssView.h"    

@interface WebVC () <UIWebViewDelegate>

@end

@implementation WebVC
{
    UIWebView *webV;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + 5)];
    webV.delegate = self;
    webV.scalesPageToFit = YES;

    [self.view addSubview:webV];
    
    if (![NSString isEmptyOrNull:self.webURL]) {
        [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
    }
    else if (![NSString isEmptyOrNull:self.HTMLStr]) {
        [webV loadHTMLString:self.HTMLStr baseURL:nil];
    }
    else {
        
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
