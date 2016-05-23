//
//  TGPayDoneViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TGPayDoneViewController.h"
#import "DES3EncryptUtil.h"
#import "TGQCell.h"
#import "WTZhouBianKuaiSong.h"
#import "MoreLife.h"
#import "LifeCircleVC.h"
#import "BuyViewController.h"
#import "CollectionViewtroller.h"

@interface TGPayDoneViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *payDoneGoods;
}

@end

@implementation TGPayDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor  whiteColor];
    [self viewDidLayoutSubviewsForTableView:payDoneGoods];
    [self setExtraCellLineHidden:payDoneGoods];
    
    self.title = @"支付成功";
    
    NSLog(@"支付完成订单号>>>>>%@",self.orderArray);
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doNothing)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishDo)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    payDoneGoods.delegate = self;
    payDoneGoods.dataSource = self;
    [payDoneGoods registerNib:[UINib nibWithNibName:@"TGQCell" bundle:nil] forCellReuseIdentifier:@"QUAN"];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH/2 - 30, 20, 60, 60)];
    imageView.image = [UIImage imageNamed:@"gouda"];
    [view addSubview:imageView];
    
    UILabel * successLable = [UILabel addlable:view frame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 10, IPHONE_WIDTH, 30) text:@"支付成功!" textcolor:[UIColor blackColor]];
    successLable.textAlignment = NSTextAlignmentCenter;
    successLable.font = [UIFont systemFontOfSize:17];
    
    payDoneGoods.tableHeaderView = view;
    
    UIView * foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 150)];
    
    UILabel * lable1 =[UILabel addlable:foot frame:CGRectMake(10, 10, IPHONE_WIDTH - 20, 20) text:@"到店消费请出示团购券号" textcolor:[AppUtils colorWithHexString:@"787878"]];
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont systemFontOfSize:15];
    
    UILabel * lable2 =[UILabel addlable:foot frame:CGRectMake(10, lable1.frame.origin.y + lable1.frame.size.height + 10, IPHONE_WIDTH - 20, 20) text:@"您可以在 我的>订单 查看团购券号" textcolor:[AppUtils colorWithHexString:@"787878"]];
    lable2.font = [UIFont systemFontOfSize:15];
    lable2.backgroundColor = [UIColor clearColor];
    payDoneGoods.tableFooterView = foot;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.orderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TGQCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QUAN"];
    if (cell == nil) {
        cell = [[TGQCell alloc] init];
    }
    
    [cell tgOrder:self.orderArray[indexPath.row]];
    
    return cell;
}

- (void)doNothing{

}

+ (BOOL)payFinishedForGeneralPush:(UIViewController *) fromPopVC{
    BOOL isPop = NO;
    for (UIViewController * controller in fromPopVC.navigationController.viewControllers) {
        
    }
    return isPop;
}

- (void)finishDo{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        //团购列表进来
        if ([controller isKindOfClass:[WTZhouBianKuaiSong class]]) {
            WTZhouBianKuaiSong * store = (WTZhouBianKuaiSong *)controller;
            [self.navigationController popToViewController:store animated:YES];
            return;
        }
        
        //从我的订单进来
        if ([controller isKindOfClass:[BuyViewController class]]) {
            BuyViewController * myBuy = (BuyViewController *)controller;
            myBuy.ifShopOrTuanGou = taunGouClass;
            [self.navigationController popToViewController:myBuy animated:YES];
            return;
        }
        
        //从我的收藏进来
        if ([controller isKindOfClass:[CollectionViewtroller class]]) {
            CollectionViewtroller * mycoll = (CollectionViewtroller *)controller;
            [self.navigationController popToViewController:mycoll animated:YES];
            return;
        }
        
        // 从生活圈进来
        if ([controller isKindOfClass:[LifeCircleVC class]]) {
            LifeCircleVC * mycoll = (LifeCircleVC *)controller;
            [self.navigationController popToViewController:mycoll animated:YES];
            return;
        }
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
    [tableView setTableFooterView:view];
}

@end
