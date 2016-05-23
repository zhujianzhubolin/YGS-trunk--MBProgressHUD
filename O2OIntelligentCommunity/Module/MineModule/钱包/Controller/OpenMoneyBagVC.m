//
//  OpenMoneyBagVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "OpenMoneyBagVC.h"
#import "OpenMoneyBagSetVC.h"

@implementation OpenMoneyBagVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    
    self.title=@"我的钱包";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *Buuton =[UIButton buttonWithType:UIButtonTypeCustom];
    Buuton.frame=CGRectMake(10, 70, IPHONE_WIDTH-20, 120);
    [Buuton setBackgroundImage:[UIImage imageNamed:@"kaitongqianbao"] forState:UIControlStateNormal];
    [Buuton addTarget:self action:@selector(openMoneyArr) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Buuton];
    
    UILabel *titleLabe =[[UILabel alloc]init];
    titleLabe.font=[UIFont systemFontOfSize:14];
    //titleLabe.backgroundColor=[UIColor redColor];
    titleLabe.text=[NSString stringWithFormat:@"钱包是您在%@的一个资金账户，可通过%@进行充值、购物、缴物业费和停车费等消费，等同现金使用。活动期内充值会有赠送哦，未来你还可以享受更多理财收益~~~",P_NMAE,P_NMAE];
    [titleLabe setNumberOfLines:0];
    CGFloat interval = 15;
    CGSize priceSize = [AppUtils sizeWithString:titleLabe.text font:titleLabe.font size:CGSizeMake(IPHONE_WIDTH - interval *2,200)];
    
    titleLabe.frame=CGRectMake(interval, 200, IPHONE_WIDTH - interval *2, priceSize.height);

    [self.view addSubview:titleLabe];
    
    
}

-(void)openMoneyArr
{
    OpenMoneyBagSetVC *openmoneybagset =[[OpenMoneyBagSetVC alloc]init];
    openmoneybagset.isPageBack=_isPaegBack;
    [self.navigationController pushViewController:openmoneybagset animated:YES];
}


@end
