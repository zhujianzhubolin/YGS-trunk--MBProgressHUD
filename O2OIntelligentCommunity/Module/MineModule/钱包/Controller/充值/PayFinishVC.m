//
//  PayFinishVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PayFinishVC.h"
#import "MoneyBagVC.h"

@interface PayFinishVC ()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation PayFinishVC
{
    UITableView *payfinishTB;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}


-(void)initUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    
    if (_paystatus==0)
    {
        self.title=@"支付成功";
    }
    else if (_paystatus==-1)
    {
        self.title=@"支付失败";
    }
    else if (_paystatus==-2)
    {
        self.title=@"您已取消支付";
    }
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.backgroundColor=[AppUtils colorWithHexString:@"fa6900"];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(payfinish)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    UIView *handView =[[UIView alloc]init];
    handView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 150);
    handView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *imgV =[[UIImageView alloc]init];
    imgV.frame=CGRectMake(IPHONE_WIDTH/2-150, 30, 50, 50);
    imgV.image=[UIImage imageNamed:@"gouda"];
    [handView addSubview:imgV];
    
    UILabel *LAbe =[[UILabel alloc]init];
    LAbe.frame=CGRectMake(IPHONE_WIDTH/2-75, 30, 160, 30);
    if (_paystatus==0)
    {
        LAbe.text=@"恭喜您，支付成功";
    }
    else if (_paystatus==-1)
    {
        LAbe.text=@"支付失败";
    }
    else if (_paystatus==-2)
    {
        LAbe.text=@"您已取消支付";
    }

    [handView addSubview:LAbe];
    
    UILabel *lAbe2 =[[UILabel alloc]init];
    lAbe2.frame=CGRectMake(IPHONE_WIDTH/2-75, 60, 250, 25);
    lAbe2.text=[AppUtils currentDate];
    lAbe2.font=[UIFont systemFontOfSize:14];
    [handView addSubview:lAbe2];
    
    UILabel *lAbe3 =[[UILabel alloc]init];
    lAbe3.frame=CGRectMake(IPHONE_WIDTH/2-75, 90, 160, 25);
    lAbe3.text=[NSString stringWithFormat:@"支付金额: %@元",self.payAcount];
    lAbe3.font=[UIFont systemFontOfSize:14];
    [handView addSubview:lAbe3];
    
    
    payfinishTB =[[UITableView alloc]initWithFrame:self.view.bounds];
    payfinishTB.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    payfinishTB.separatorStyle = UITableViewCellAccessoryNone;
    payfinishTB.tableHeaderView=handView;
    [self.view addSubview:payfinishTB];
}

-(void)payfinish
{
    __block BOOL hasMonetyBagVC = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *subVC = obj;
        if ([subVC isKindOfClass:[MoneyBagVC class]]) {
            [self.navigationController popToViewController:subVC animated:YES];
            hasMonetyBagVC = YES;
            *stop = YES;
        }
    }];
    
    if (!hasMonetyBagVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"payfinishCell"];
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payfinishCell"];
    }
    return cell;
}

@end
