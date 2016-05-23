//
//  AboutViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"关于";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initUI];
}

-(void)initUI {
    UIImageView *logoimg;
    if (VIEW_IPhone4_INCH)
    {
        logoimg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-165/2, 80, 165, 77)];
    }
    else
    {
        logoimg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-165/2, 80, 165, 77)];
    }
    logoimg.image =[UIImage imageNamed:@"ZYlogoimg"];
    [self.view addSubview:logoimg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 100)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = @"移公社,\"O2O智能社区平台\"领跑者！我们以自主研发的综合管理系统为载体，以整合移动互联网应用与物联网技术为手段，针对这区家庭日常生活和消费，打造2公里生活圈。公司通过与物业（地产公司）合作，整合垂直商家，为消费者提供便民缴费，门禁停车，社区沟通与分享，周边购物，外送服务，上门家政，网购团购等各种综合服务。我们让\"社区因我不同\"。";
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    if (VIEW_IPhone4_INCH)
    {
       label.frame =CGRectMake(10,CGRectGetMaxY(logoimg.frame)-20, self.view.frame.size.width-20, size.height);
    }
    else
    {
        label.frame =CGRectMake(10,CGRectGetMaxY(logoimg.frame), self.view.frame.size.width-20, size.height);
    }
    
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    
    UIView *logoimage;
    if (VIEW_IPhone4_INCH)
    {
        logoimage= [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)-30, IPHONE_WIDTH-20, 100)];
    }
    else
    {
        logoimage = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame), IPHONE_WIDTH-20, 100)];
    }
    
    //logoimage.backgroundColor=[UIColor redColor];
    
    UIImageView *weixinImg  =[[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 60, 60)];
    weixinImg.image=[UIImage imageNamed:@"lfweixin"];
    [logoimage addSubview:weixinImg];
    
    UILabel *weixinName =[[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(weixinImg.frame), 100, 30)];
    weixinName.text=@"移公社微信";
    [logoimage addSubview:weixinName];
    
    UIImageView *weiboImg =[[UIImageView alloc]initWithFrame:CGRectMake(logoimage.frame.size.width-110, 0, 70, 70)];
    weiboImg.image =[UIImage imageNamed:@"lfxinlangweibo"];
    [logoimage addSubview:weiboImg];
    UILabel *weiboName =[[UILabel alloc]initWithFrame:CGRectMake(logoimage.frame.size.width-120, CGRectGetMaxY(weiboImg.frame)-10, 100, 30)];
    weiboName.text=@"移公社微博";
    [logoimage addSubview:weiboName];
    [self.view addSubview:logoimage];
    
    UILabel *TheCompanyName;
    if (VIEW_IPhone4_INCH)
    {
        TheCompanyName = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-130, self.view.frame.size.height-40, 260, 25)];

    }
    else
    {
        TheCompanyName = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-130, self.view.frame.size.height-70, 260, 25)];
    }
    TheCompanyName.text = @"深圳市移联天下电子商务有限公司";
    TheCompanyName.textAlignment = NSTextAlignmentCenter;
    TheCompanyName.font = [UIFont systemFontOfSize:14];
    
    UIButton *offialBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(TheCompanyName.frame) - 10 -35, IPHONE_WIDTH, 25)];
    [offialBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [offialBtn setTitle:URL_YGS forState:UIControlStateNormal];
    offialBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [offialBtn addTarget:self action:@selector(officalBtnClick) forControlEvents:UIControlEventTouchDown];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version;
#ifdef DEBUG
    app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
#else
    app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
#endif
   

    UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(offialBtn.frame)-45, IPHONE_WIDTH, 25)];
    versionLab.text=[NSString stringWithFormat:@"当前版本号： v%@",app_Version];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.textColor=[UIColor lightGrayColor];
    versionLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:versionLab];
    
    
    
    [self.view addSubview:offialBtn];
    //[self.view addSubview:TheCompanyCom];
    [self.view addSubview:TheCompanyName];
}

- (void)officalBtnClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_YGS]];
}

@end
