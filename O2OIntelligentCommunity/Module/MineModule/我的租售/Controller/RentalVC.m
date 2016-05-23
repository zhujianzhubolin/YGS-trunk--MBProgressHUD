//
//  RentalVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



#import "RentalVC.h"
#import "RentalCell.h"
#import "RentDetail.h"
#import "UserManager.h"
#import "ZJWebProgrssView.h"
#import <MJRefresh.h>
#import "ManagerialReportH.h"
#import "RentalMessageVC.h"


//租售接口类
#import "ShengSJDataE.h"
#import "RentalHandler.h"
//删除接口类
#import "DelectRentalBadyHandler.h"



@interface RentalVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation RentalVC
{
    UITableView *rentalTB;
    ZJWebProgrssView *progressV;
    NSIndexPath *selectindexPath;
    RentalHandler *rentalH;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)initData
{
    rentalH=[RentalHandler new];
}

-(void)initUI
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rentalinfo"] style:UIBarButtonItemStyleBordered target:self action:@selector(rentalinfoArr)];
    
#ifdef SmartComJYZX
    if (self.vcType == VCTypeRental) {
        self.navigationItem.title = @"我的租售";
    }
    else {
        self.navigationItem.title = @"我的宝贝";
    }

#elif SmartComYGS
    if (self.vcType == VCTypeRental) {
        self.navigationItem.title = @"我的租售";
    }
    else {
        self.navigationItem.title = @"我的闲置";
    }

#else
    
#endif
    
    rentalTB =[[UITableView alloc]initWithFrame:self.view.bounds];
    rentalTB.dataSource=self;
    rentalTB.delegate=self;
    rentalTB.separatorStyle = UITableViewCellAccessoryNone;
    [self viewDidLayoutSubviewsForTableView:rentalTB];
    rentalTB.showsVerticalScrollIndicator =NO;
    rentalTB.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    [self.view addSubview:rentalTB];
    
    __block __typeof(self)weakTableView = self;
    [rentalTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakTableView startNetworkGetShopsIsHeader:YES];
    }];
    
    [rentalTB addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakTableView startNetworkGetShopsIsHeader:NO];
    }];

    progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:progressV];

   __block typeof(self)weakSelf = self;
    progressV.loadBlock = ^ {
        [weakSelf startNetworkGetShopsIsHeader:YES];
    };
}

-(void)rentalinfoArr
{
    RentalMessageVC *rentalmessage =[[RentalMessageVC alloc]init];
    rentalmessage.vcType = self.vcType;
    [self.navigationController pushViewController:rentalmessage animated:YES];
}

- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
    ShengSJDataE *ssjM =[ShengSJDataE new];
    ssjM.pageSize=@"10";
    ssjM.orderBy = @"dateUpdated";
    ssjM.orderType = @"desc";
    
    if (self.vcType == VCTypeRental)
    {
        ssjM.pageNumber =rentalH.rentaPNumber;
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",
                                     [UserManager shareManager].userModel.memberId,@"memberid",
                                     nil];
        ssjM.queryMap = queryMapDic;
        [rentalH queryRentalData:ssjM success:^(id obj) {
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentalH.rentaArray]];
            [rentalTB reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:rentalTB];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentalH.rentaArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:rentalTB];
        } isHeader:isHeader];
    }
    else
    {
        ssjM.pageNumber =rentalH.idlePNumber;
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"6",@"type",
                                     [UserManager shareManager].comModel.wyId,@"wyNo",
                                     [UserManager shareManager].userModel.memberId,@"memberid",
                                     nil];
        ssjM.queryMap = queryMapDic;
        [rentalH queryIdleData:ssjM success:^(id obj) {
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentalH.idleArray]];
            [rentalTB reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:rentalTB];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentalH.idleArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:rentalTB];
        } isHeader:isHeader];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    if (self.vcType == VCTypeRental) {
        
        [AppUtils tableViewFooterPromptWithPNumber:rentalH.rentaPNumber.integerValue
                                        withPCount:rentalH.rentaPCount.integerValue
                                         forTableV:rentalTB];

        return rentalH.rentaArray.count;
        
    }
    [AppUtils tableViewFooterPromptWithPNumber:rentalH.idlePNumber.integerValue
                                    withPCount:rentalH.idlePCount.integerValue
                                     forTableV:rentalTB];
    return rentalH.idleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentalCell *rentalCell = (RentalCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return rentalCell.frame.size.height;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 1;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"rentalcell";
    RentalCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell =[[RentalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ShengSJDataE *shengSJM = nil;
    if (self.vcType == VCTypeRental) {
        shengSJM = rentalH.rentaArray[indexPath.section];
    }
    else {
        shengSJM = rentalH.idleArray[indexPath.section];
    }
    [cell setRentalData:shengSJM imgIndex:indexPath.section % 3];
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressedAct:)];
    longPressed.minimumPressDuration = 1;
    [cell.contentView addGestureRecognizer:longPressed];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
   
    ShengSJDataE *shensjM = nil;
    if (self.vcType == VCTypeRental) {
        
        RentDetail *rentdetailvc =[[RentDetail alloc]init];
        shensjM = rentalH.rentaArray[indexPath.section];
        if (![shensjM.status isEqualToString:@"1"]){
            rentdetailvc.dataSocure= shensjM.dataDict;
            rentdetailvc.vcType = self.vcType;
            [self.navigationController pushViewController:rentdetailvc animated:YES];
        }
    }
    else {
        RentDetail *rentdetailvc =[[RentDetail alloc]init];
        shensjM = rentalH.idleArray[indexPath.section];
        if (![shensjM.status isEqualToString:@"1"]){
            rentdetailvc.dataSocure= shensjM.dataDict;
            rentdetailvc.vcType = self.vcType;
            [self.navigationController pushViewController:rentdetailvc animated:YES];
        }
    }
}
//CEll长按事件
-(void)longPressedAct:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint p = [gestureRecognizer locationInView:rentalTB];
        NSLog(@"p.x=%f   p.y=%f",p.x,p.y);
        selectindexPath = [rentalTB indexPathForRowAtPoint:p];
        if (selectindexPath == nil){
             NSLog(@"long press on table view but not on a row");
        }else{
            NSLog(@"long press on table view at row %ld", (long)selectindexPath.section);
            UIAlertView *alerV =[[UIAlertView alloc]initWithTitle:@"亲，你确定要删除该条信息吗？" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
            [alerV show];
        }
        
    }
    
}

#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ShengSJDataE *shensjMM=nil;
    if (buttonIndex==1)
    {
        if (self.vcType == VCTypeRental)
        {
           shensjMM =rentalH.rentaArray[selectindexPath.section];
        }
        else
        {
            shensjMM = rentalH.idleArray[selectindexPath.section];
        }
        DelectRentalBadyHandler *delectRBH =[DelectRentalBadyHandler new];
        ShengSJDataE  *delectRBM =[ShengSJDataE new];

        delectRBM.memberId=[UserManager shareManager].userModel.memberId;
        delectRBM.ID =shensjMM.ID;
        [delectRBH delectRentalBady:delectRBM success:^(id obj) {
            [AppUtils showAlertMessageTimerClose:obj];
            if (self.vcType == VCTypeRental)
            {
                [rentalH.rentaArray removeObjectAtIndex:selectindexPath.section];
                [rentalTB deleteSections:[NSIndexSet indexSetWithIndex:selectindexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            }
            else
            {
                [rentalH.idleArray removeObjectAtIndex:selectindexPath.section];
                [rentalTB deleteSections:[NSIndexSet indexSetWithIndex:selectindexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            }
            
            
        } failed:^(id obj) {
            [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
        }];
    }
}

@end
