//
//  RentalMessageVC.m
//  O2OIntelligentCommunityb
//
//  Created by apple on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentalMessageVC.h"
#import "RentalMessageCell.h"
#import "UserManager.h"
#import "RentDetail.h"
#import "ZJWebProgrssView.h"
#import "ZJLongPressGesture.h"
#import "ReportVC.h"
#import "QueryCommentHandler.h"
#import "QueryCommentModel.h"

#import "DeleteCommentModel.h"
#import "deleteCommentHandler.h"

#import "RentalHandler.h"
#import "ShengSJDataE.h"



@interface RentalMessageVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation RentalMessageVC
{
    UITableView *rentalmessageTB;
    ZJWebProgrssView *progressV;
    QueryCommentHandler *querCommentH;
    RentalHandler *rentalH;
    
    NSMutableArray *detailsArray;
    
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

- (void)initData {
    querCommentH = [QueryCommentHandler new];
    rentalH = [RentalHandler new];
    detailsArray = [NSMutableArray array];
    querCommentH.ismyRentalCommentUpdate = YES;
    querCommentH.ismyBadyCommentUpdate = YES;
}

- (void)viewDidLoadRefresh {
    [progressV startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent=YES;
    [[ReportBtn btnInstance] removeReportBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    [self hidetabbar];
}

-(void)initUI
{
    if (self.vcType == VCTypeRental) {
        self.navigationItem.title = @"发布的信息";
    }
    else {
        self.navigationItem.title = @"发布的信息";
    }

    
    
    rentalmessageTB=[[UITableView alloc]init];
    rentalmessageTB.frame=self.view.bounds;
    rentalmessageTB.dataSource=self;
    rentalmessageTB.delegate=self;
    rentalmessageTB.separatorStyle = UITableViewCellAccessoryNone;
    rentalmessageTB.backgroundColor=[AppUtils colorWithHexString:@"F7F7F7"];
    [self.view addSubview:rentalmessageTB];
    
    __block __typeof(self)weakTableView = self;
    [rentalmessageTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakTableView startNetworkGetShopsIsHeader:YES];
    }];
    
    [rentalmessageTB addLegendFooterWithRefreshingBlock:^{//上拉加载更多
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
    queryM.pageSize=@"10";
    queryM.orderBy = @"dateCreated";
    queryM.orderType = @"desc";
    
    if (self.vcType == VCTypeRental) {
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"status",
                                     @"HOUSESALE",@"complaintType",
                                     [UserManager shareManager].userModel.memberId,@"memberId",
                                     nil];
        
        queryM.queryMap = queryMapDic;
        [querCommentH queryRentalComment:queryM success:^(id obj) {
            querCommentH.ismyRentalCommentUpdate=NO;
            NSLog(@"querCommentH.myRentalDataArr].count = %@",querCommentH.myRentalDataArr);
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:querCommentH.myRentalDataArr]];
            
            [AppUtils tableViewEndMJRefreshWithTableV:rentalmessageTB];
            [rentalmessageTB reloadData];
        } failed:^(id obj) {
            querCommentH.ismyRentalCommentUpdate=YES;
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:querCommentH.myRentalDataArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:rentalmessageTB];
        } isHeader:isHeader];
       
        
    }
    else
    {
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"status",
                                     @"FLEAMARKET",@"complaintType",
                                     [UserManager shareManager].userModel.memberId,@"memberId",
                                     nil];
        queryM.queryMap = queryMapDic;
        [querCommentH queryBadyComment:queryM success:^(id obj) {
            querCommentH.ismyBadyCommentUpdate=NO;
            NSLog(@"querCommentH.myBadyDataArr].count = %lu",(unsigned long)querCommentH.myBadyDataArr.count );
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:querCommentH.myBadyDataArr]];
            
            [AppUtils tableViewEndMJRefreshWithTableV:rentalmessageTB];
            [rentalmessageTB reloadData];
        } failed:^(id obj) {
            querCommentH.ismyBadyCommentUpdate=YES;
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:querCommentH.myBadyDataArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:rentalmessageTB];
        } isHeader:isHeader];
   }
    
}



-(void)getXianZhiDetails:(NSString *)detId
{
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"6",@"type",
                                 @"3",@"status",
                                ENVIRONMENT,@"version",
                                 detId,@"id",
                                 nil];
   
    ShengSJDataE * mode = [ShengSJDataE new];
    mode.pageSize    = @"10";
    mode.pageNumber  = @"1";
    mode.orderType   = @"desc";
    mode.orderBy     =@"dateCreated";
    mode.queryMap    = queryMapDic;
    
    
    
    [rentalH queryXianZhiDetails:mode success:^(id obj) {
        ShengSJDataE *SJDataM = obj;
        [SJDataM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [detailsArray addObject:obj];
        }];
        
        NSLog(@"%@",detailsArray);
        ShengSJDataE *shensjM = nil;
        if(detailsArray.count<=0)
        {
            [AppUtils showAlertMessageTimerClose:@"无法找到闲置详情，可能已删除"];
            return ;
        }
        if (self.vcType == VCTypeRental) {
            
            RentDetail *rentdetailvc =[[RentDetail alloc]init];
            shensjM = detailsArray[0];
            if (![shensjM.status isEqualToString:@"1"]){
                rentdetailvc.dataSocure= shensjM.dataDict;
                rentdetailvc.vcType = self.vcType;
                [self.navigationController pushViewController:rentdetailvc animated:YES];
            }
        }
        else {
            RentDetail *rentdetailvc =[[RentDetail alloc]init];
            shensjM = detailsArray[0];
            if (![shensjM.status isEqualToString:@"1"]){
                rentdetailvc.dataSocure= shensjM.dataDict;
                rentdetailvc.vcType = self.vcType;
                [self.navigationController pushViewController:rentdetailvc animated:YES];
            }
        }

    } failed:^(id obj) {
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.vcType == VCTypeRental) {
        return querCommentH.myRentalDataArr.count;
    }
    return querCommentH.myBadyDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"rentalcell";
    RentalMessageCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell =[[RentalMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    QueryCommentModel *queryM = nil;
    if (self.vcType == VCTypeRental) {
        queryM = querCommentH.myRentalDataArr[indexPath.section];
    }
    else {
        queryM = querCommentH.myBadyDataArr[indexPath.section];
    }
    
    [cell setcellData:queryM];
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:cell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:indexPath.row];
    };
    [cell.contentView addGestureRecognizer:pressGesture];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        QueryCommentModel *queryM = nil;
        if (self.vcType == VCTypeRental) {
            queryM = querCommentH.myRentalDataArr[indexPath.section];

            //[querCommentH.myRentalDataArr removeObjectAtIndex:indexPath.section];
        }
        else {
            queryM = querCommentH.myBadyDataArr[indexPath.section];
            //[querCommentH.myBadyDataArr removeObjectAtIndex:indexPath.section];
        }

        
        DeleteCommentModel *delectctCommentM =[DeleteCommentModel new];
        deleteCommentHandler *delectctCommentH =[deleteCommentHandler new];
        delectctCommentM.ID =queryM.ID;
        
        [delectctCommentH deleteComment:delectctCommentM success:^(id obj) {
            if (self.vcType == VCTypeRental) {
                [querCommentH.myRentalDataArr removeObjectAtIndex:indexPath.section];
            }else {
                [querCommentH.myBadyDataArr removeObjectAtIndex:indexPath.section];
            }
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
            if (self.vcType == VCTypeRental) {
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:querCommentH.myRentalDataArr ]];
            }else {
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:querCommentH.myBadyDataArr]];
            }
            [AppUtils showSuccessMessage:obj];
        } failed:^(id obj) {
            
            [AppUtils showAlertMessageTimerClose:obj];
        }];
        
    }
}

- (void)pushToReportVC:(NSUInteger)dataIndex {
    QueryCommentModel *queryM = nil;
    if (self.vcType == VCTypeRental) {
        queryM = querCommentH.myRentalDataArr[dataIndex];
    }
    else {
        queryM = querCommentH.myBadyDataArr[dataIndex];
    }
    
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:queryM.ID.intValue];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中 house  goods
    [[ReportBtn btnInstance] removeReportBtn];
    QueryCommentModel *queryM = nil;
    if (self.vcType == VCTypeRental) {
        queryM = querCommentH.myRentalDataArr[indexPath.section];
        
        //[querCommentH.myRentalDataArr removeObjectAtIndex:indexPath.section];
    }
    else {
        queryM = querCommentH.myBadyDataArr[indexPath.section];
        //[querCommentH.myBadyDataArr removeObjectAtIndex:indexPath.section];
    }
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self getXianZhiDetails:queryM.complaintId];
    });

   

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}

@end
