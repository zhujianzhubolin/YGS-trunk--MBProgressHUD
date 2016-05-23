//
//  MilletPlayerVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/14.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "MilletPlayerVC.h"
#import "ZJEditingSourceVC.h"

@interface MilletPlayerVC () <UIWebViewDelegate>

@end

@implementation MilletPlayerVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent=NO;
    self.title=@"小蜜媒体";
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)initUI
{
    UIWebView *webV =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    NSURL *url = [[NSURL alloc]initWithString:P_WEB_MEDIA];
    webV.scalesPageToFit = YES;
    [self.view addSubview:webV];
    
    [webV loadRequest:[NSURLRequest requestWithURL:url]];
    
#ifdef DEBUG
    
    #ifdef BETA
    
    #else
        CGFloat interval = 40;
        UIButton *releaseBtn =[UIButton addWithFrame:CGRectMake(interval, IPHONE_HEIGHT - interval*3, IPHONE_WIDTH-interval*2, interval-10)
                                           textColor:[UIColor whiteColor]
                                            fontSize:FONT_SIZE
                                             imgName:nil
                                                text:@"立即发布"];
        [releaseBtn setBackgroundColor:[AppUtils colorWithHexString:@"fa6900"]];
        releaseBtn.layer.masksToBounds=YES;
        releaseBtn.layer.cornerRadius=5;
        [releaseBtn addTarget:self action:@selector(clickBtnForImmediatelyPublish)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:releaseBtn];

        
    #endif
    
    
#else
    
#endif

}

-(void)clickBtnForImmediatelyPublish
{
    ZJEditingSourceVC *editingvc =[[ZJEditingSourceVC alloc]init];
    [self.navigationController pushViewController:editingvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
