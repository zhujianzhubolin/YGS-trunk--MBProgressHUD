//
//  TopicViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicCell.h"
#import "UserManager.h"
#import "TopicDetailsViewController.h"
#import <MJRefresh.h>
#import "ZJWebProgrssView.h"

//获取话题列表接口类
#import "HuaTiListHandler.h"
#import "HuaTiListModel.h"

@implementation TopicViewController
{
    UITableView *TableView;
    NSMutableArray  *allhuatiArray;
      NSUInteger seletedSection;
    ZJWebProgrssView *progressV;
    HuaTiListHandler *huaTilistH;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self hidetabbar];
    [self refreshData];
}

- (void)refreshData {
    if (huaTilistH.isMyHtNeedUpdate) {
        [progressV startAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startNetworkGetShopsIsHeader:YES];
        });
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData {
    allhuatiArray =[NSMutableArray array];
    huaTilistH =[HuaTiListHandler new];
}

-(void)initUI
{
    
    self.title=@"我的话题";
    self.view.backgroundColor=[UIColor whiteColor];
    
    TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    TableView.dataSource =self;
    TableView.delegate =self;
    [self.view addSubview:TableView];
    TableView.tableFooterView = [AppUtils tableViewsFooterView];
    [self viewDidLayoutSubviewsForTableView:TableView];
    
    __block __typeof(self)weakTableView = self;
    [TableView addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakTableView startNetworkGetShopsIsHeader:YES];
    }];
    
    [TableView addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakTableView startNetworkGetShopsIsHeader:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:TableView.bounds];
    [self.view addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [weakTableView startNetworkGetShopsIsHeader:YES];
    };
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}
- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
    if (huaTilistH.myHtPNumber.intValue <= huaTilistH.myHtPCount.intValue)
    {
        HuaTiListModel *hutiM =[HuaTiListModel new];
        hutiM.pageNumber =huaTilistH.myHtPNumber;
        hutiM.pageSize=@"10";
        hutiM.orderBy = @"dateCreated";
        hutiM.orderType = @"desc";

        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UserManager shareManager].userModel.memberId,@"memberid",
                                     @"1",@"type",
                                     @"3",@"status",
                                     nil];
        hutiM.queryMap = queryMapDic;
        
        [huaTilistH postUserHuaTiList:hutiM success:^(id obj) {
            huaTilistH.isMyHtNeedUpdate=NO;
            [AppUtils tableViewEndMJRefreshWithTableV:TableView];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:huaTilistH.myHtArr]];
            [TableView reloadData];
        } failed:^(id obj) {
            huaTilistH.isMyHtNeedUpdate=YES;
            if (isHeader)
            {
                [allhuatiArray removeAllObjects];
                [TableView reloadData];
            }
            [AppUtils tableViewEndMJRefreshWithTableV:TableView];
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:huaTilistH.myHtArr]];
        } isHeader:isHeader];
    }
    else
    {
        [AppUtils tableViewEndMJRefreshWithTableV:TableView];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [AppUtils tableViewFooterPromptWithPNumber:huaTilistH.myHtPNumber.integerValue
                                    withPCount:huaTilistH.myHtPCount.integerValue
                                     forTableV:TableView];
    return huaTilistH.myHtArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 40;
    }
    else
    {
        TopicCell * cell = (TopicCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        HuaTiListModel *huatM =[huaTilistH.myHtArr objectAtIndex:indexPath.section];
        
        cell.textLabel.text=[NSString stringWithFormat:@"[%@] %@",huatM.activityType,huatM.title];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    else
    {
        if (indexPath.section == seletedSection) {
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIViewController *subVC = obj;
                if ([subVC isKindOfClass:[TopicDetailsViewController class]]) {
                    TopicDetailsViewController *topicDetails = obj;
                    NSLog(@"huaTilistH.htArray %ld",huaTilistH.htArray.count);
                    topicDetails.huatiM = huaTilistH.myHtArr[seletedSection];
                    *stop = YES;
                }
            }];
        }

    TopicCell *cell = [[TopicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    [cell setCellData:[huaTilistH.myHtArr objectAtIndex:indexPath.section]];
    return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    seletedSection = indexPath.section;
    TopicDetailsViewController *topicDetails = [[TopicDetailsViewController alloc]init];
    topicDetails.huatiM =[huaTilistH.myHtArr objectAtIndex:indexPath.section];
    topicDetails.commentChangeBlock= ^()
    {
        huaTilistH.isMyHtNeedUpdate = YES;
    };
    
    [self.navigationController pushViewController:topicDetails animated:YES];
}



@end
