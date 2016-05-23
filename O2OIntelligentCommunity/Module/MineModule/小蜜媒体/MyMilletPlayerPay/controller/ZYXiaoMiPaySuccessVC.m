//
//  ZYXiaoMiPaySuccessVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/6.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define interval 15

#import "ZYXiaoMiPaySuccessVC.h"
#import "ZYXiaoMiPaySuccessCell.h"

@interface ZYXiaoMiPaySuccessVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZYXiaoMiPaySuccessVC
{
    UITableView *paySuccessTB;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    self.title = @"支付成功";
   
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doNothing)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishDo)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    UIView *footoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    UILabel *tishiLab =[[UILabel alloc]initWithFrame:CGRectMake(interval, interval, IPHONE_WIDTH-interval*2, 25)];
    tishiLab.text=@"我们会在3个工作日内对内容进行审核，届时会通知到您审核结果：";
    tishiLab.font=[UIFont systemFontOfSize:14];
    tishiLab.numberOfLines=2;
    CGSize contentSize =[AppUtils sizeWithString:tishiLab.text font:tishiLab.font size:CGSizeMake(IPHONE_WIDTH- interval*2, 0)];
    dispatch_async(dispatch_get_main_queue(), ^{
        tishiLab.frame = CGRectMake(interval, interval, IPHONE_WIDTH-interval*2, contentSize.height);
        [footoView addSubview:tishiLab];
        
        UILabel *jieguoLab = [[UILabel alloc]initWithFrame:CGRectMake(interval, CGRectGetMaxY(tishiLab.frame), IPHONE_WIDTH-interval*2, 25)];
        jieguoLab.font=[UIFont systemFontOfSize:14];
        jieguoLab.text=@"您可到 我的 >媒体查看进度";
        [footoView addSubview:jieguoLab];

    });
    
    paySuccessTB = [[UITableView alloc]initWithFrame:self.view.bounds];
    paySuccessTB.dataSource=self;
    paySuccessTB.delegate=self;
    paySuccessTB.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    [paySuccessTB registerNib:[UINib nibWithNibName:@"ZYXiaoMiPaySuccessCell" bundle:nil] forCellReuseIdentifier:@"ZYXiaoMiPaySuccessCell"];
    paySuccessTB.separatorStyle=UITableViewCellSelectionStyleNone;
    paySuccessTB.tableFooterView=footoView;
    [self.view addSubview:paySuccessTB];

}

-(void)finishDo
{
    NSLog(@"完成");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)doNothing
{}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdent =@"ZYXiaoMiPaySuccessCell";
    ZYXiaoMiPaySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if (cell == nil)
    {
        cell = [[ZYXiaoMiPaySuccessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    [cell celltext:_moneyStr];
    return cell;
}

@end
