//
//  MyCommentViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MyCommentViewController.h"
#import "CommentCell.h"
#import "UserManager.h"
#import <MJRefresh.h>
#import "ZJWebProgrssView.h"
#import "ZYCommentDetailsVC.h"

//我的品论接口类
#import "QueryCommentHandler.h"
#import "QueryCommentModel.h"

#import "HuaTiListHandler.h"

@implementation MyCommentViewController
{
    UITableView *TableView;
    NSMutableArray *allCommentArray;
    
    NSMutableArray *cellArray;
    NSMutableArray *cellHigthArray;
    ZJWebProgrssView *progressV;
    QueryCommentHandler *queryCommentH;
    HuaTiListHandler *huatiH;
    
     NSUInteger selectedRow;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];

    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startNetworkGetShopsIsHeader:YES];
    });
}

-(void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
 
-(void)initData
{
    allCommentArray =[NSMutableArray array];
    cellArray =[NSMutableArray array];
    cellHigthArray = [NSMutableArray array];
    queryCommentH = [QueryCommentHandler new];
    huatiH = [HuaTiListHandler new];
}

-(void)initUI
{
    
    self.title=@"我的评论";
    self.view.backgroundColor=[AppUtils colorWithHexString:@"CDCDD2"];
    
    TableView  =[[UITableView alloc]initWithFrame:self.view.bounds];
    TableView.dataSource=self;
    TableView.delegate=self;
    TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:TableView];
    [self setExtraCellLineHidden:TableView];
    
    __block __typeof(self)weakTableView = self;
    [TableView addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakTableView startNetworkGetShopsIsHeader:YES];
    }];
    
    [TableView addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakTableView startNetworkGetShopsIsHeader:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [weakTableView startNetworkGetShopsIsHeader:YES];
    };
}

- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
    
        QueryCommentModel *queryM =[QueryCommentModel new];
        queryM.pageSize=@"5";
        queryM.orderBy = @"dateCreated";
        queryM.orderType = @"desc";
    
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UserManager shareManager].userModel.memberId,@"memberId",
                                     @"0",@"status",
                                     @"ACTIVITY",@"complaintType",
                                     nil];
        queryM.queryMap = queryMapDic;
        
        [queryCommentH queryComment:queryM success:^(id obj) {
            queryCommentH.isUserCommentUpdate=NO;
            allCommentArray =(NSMutableArray *)obj;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:queryCommentH.huatipinglunArr]];
            
            if ([NSArray isArrEmptyOrNull:allCommentArray])
            {
                [AppUtils showAlertMessageTimerClose:@"您还没有评论过该话题"];
            }
            else
            {
                [TableView reloadData];
            }

            [AppUtils tableViewEndMJRefreshWithTableV:TableView];
            
        } failed:^(id obj) {
            queryCommentH.isUserCommentUpdate=YES;
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:queryCommentH.huatipinglunArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:TableView];
        } isHeader:isHeader];
        
}

-(void)getHuaTiDetails:(NSString *)detId
{
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"type",
                                 @"3",@"status",
                                 ENVIRONMENT,@"version",
                                 detId,@"id",
                                 nil];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNumber",
                        @"10",@"pageSize",
                        @"dateUpdated",@"orderBy",
                        @"desc",@"orderType",
                        queryMapDic,@"queryMap",nil];
    
    [huatiH queryHuaTiDetails111:dic success:^(id obj) {
        HuaTiListModel *mode = obj;
        if ([NSArray isArrEmptyOrNull:mode.list])
        {
            [AppUtils showAlertMessageTimerClose:@"无法找到话题，可能已删除"];
        }
        else
        {
            ZYCommentDetailsVC *topicDetails = [[ZYCommentDetailsVC alloc]init];
            topicDetails.huatiM=[mode.list objectAtIndex:0];
            topicDetails.caozuoBlock =^{
                [self getHuaTiDetails2:detId];
            };
            [self.navigationController pushViewController:topicDetails animated:YES];
        }
    
    } failed:^(id obj) {
        [AppUtils showAlertMessageTimerClose:@"获取话题详情失败！"];
    }];

    
    
}
-(void)getHuaTiDetails2:(NSString *)detId
{
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"type",
                                 @"3",@"status",
                                 @"YGS",@"version",
                                 detId,@"id",
                                 nil];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNumber",
                        @"10",@"pageSize",
                        @"dateUpdated",@"orderBy",
                        @"desc",@"orderType",
                        queryMapDic,@"queryMap",nil];
    
    [huatiH queryHuaTiDetails111:dic success:^(id obj) {
        HuaTiListModel *mode = obj;
        ZYCommentDetailsVC *Details = [ZYCommentDetailsVC new];
        Details.huatiM = mode;
    } failed:^(id obj) {
        
        
    }];
    
    
    
}



//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [AppUtils tableViewFooterPromptWithPNumber:queryCommentH.currentPage.integerValue
                                    withPCount:queryCommentH.pageCount.integerValue
                                     forTableV:TableView];

    return queryCommentH.huatipinglunArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell =(CommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"";
    CommentCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell =[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCellData:[queryCommentH.huatipinglunArr objectAtIndex:indexPath.section]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    QueryCommentModel *model = [queryCommentH.huatipinglunArr objectAtIndex:indexPath.section];
    selectedRow = indexPath.section;
    
    [self getHuaTiDetails:model.complaintId];

}



@end
