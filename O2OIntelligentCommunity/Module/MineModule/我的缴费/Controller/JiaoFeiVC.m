//
//  JiaoFeiVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "JiaoFeiVC.h"
#import "CommunityViewCotroller.h"
#import "PayCostCell.h"
#import "BillViewController.h"
#import "UserManager.h"
#import "ZJWebProgrssView.h"

//获取小区缴费数据
#import "PaycostHandler.h"
#import "PaycostModel.h"

@interface JiaoFeiVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation JiaoFeiVC
{
    BingingXQModel *XQM;
    UITableView    *TableView;
    NSMutableArray *alljiaofeiDataArray;//所有数据
    NSArray  *iconArray;
    
    ZJWebProgrssView *progressV;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self GetPaycost];
    });
}

-(void)initData
{
    alljiaofeiDataArray=[NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)initUI
{
    //设置导航栏文字颜色
    self.title=@"我的缴费";
    self.view.backgroundColor=[UIColor whiteColor];
    //self.automaticallyAdjustsScrollViewInsets=NO;
    
    TableView =[[UITableView alloc]init];
    TableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    TableView.dataSource=self;
    TableView.delegate=self;
    [self setExtraCellLineHidden:TableView];
    [self viewDidLayoutSubviewsForTableView:TableView];
    [self.view addSubview:TableView];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:progressV];
    
    __block typeof(self)weakSelf = self;
    progressV.loadBlock = ^ {
        [weakSelf GetPaycost];
    };
}
//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}

-(void)GetPaycost
{
    PaycostHandler *paycostH =[PaycostHandler new];
    PaycostModel   *paycostM =[PaycostModel new];
    paycostM.memberId=[UserManager shareManager].userModel.memberId;
    [paycostH Paycost:paycostM success:^(id obj) {
        alljiaofeiDataArray = (NSMutableArray *)obj;
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:alljiaofeiDataArray]];
        if ([NSArray isArrEmptyOrNull:alljiaofeiDataArray]) {
            //[AppUtils showAlertMessageTimerClose:@"您还没有缴费信息"];
        }
        else {
            [TableView reloadData];
        }

    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:alljiaofeiDataArray]];
        [AppUtils showErrorMessage:@"未获取到缴费数据" isShow:self.viewIsVisible];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return alljiaofeiDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PaycostModel *payM =[alljiaofeiDataArray objectAtIndex:section];
    return payM.array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PaycostModel *payM =[alljiaofeiDataArray objectAtIndex:section];

    UIView *forheaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
    forheaderView.backgroundColor=[AppUtils colorWithHexString:@"EFEFEB"];
    UILabel *yuefenLabe =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    yuefenLabe.textColor=[UIColor grayColor];
    //yuefenLabe.text=payM.consumeCycle;
    yuefenLabe.text=[NSString stringWithFormat:@"%@年%@月",[payM.consumeCycle substringWithRange:NSMakeRange(0, 4)],[payM.consumeCycle substringWithRange:NSMakeRange(4, 2)]];
    [forheaderView addSubview:yuefenLabe];
    return forheaderView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"PayCostCell1";
    PayCostCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell =[[PayCostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PaycostModel *payM =[alljiaofeiDataArray objectAtIndex:indexPath.section];
    [cell setpaycostData:[payM.array objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    PaycostModel *payM =[alljiaofeiDataArray objectAtIndex:indexPath.section];
    
    BillViewController *billVc =[[BillViewController alloc]init];
    billVc.payM=[payM.array objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:billVc animated:YES];
}


@end
