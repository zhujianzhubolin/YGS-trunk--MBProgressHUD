//
//  RepairsViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger,MatterType) {
    MatterTypeRepair,
    MatterTypeComplaint,
    MatterTypeAdvice
};

#define TAB_ITEM_HEIGHT 40

#import "RepairsViewController.h"
#import "RepairsCell.h"
#import "DetailViewController.h"
#import "TopTabControl.h"
#import "UserManager.h"
#import <MJRefresh.h>
#import "AdviceVC.h"
#import "ZJWebProgrssView.h"

//#import "SubmitCommentVC.h"//该界面是通用的评论界面
#import "CommentViewControllr.h"

#import "BaoXiuTouSuModel.h"
#import "BaoXiuTouShuHandler.h"
//获取意见信息接口类
#import "ShengSJDataE.h"

@interface RepairsViewController ()<TopTabControlDataSource>

@end

@implementation RepairsViewController
{
    UITableView *repairTB;
    UITableView *complaintsTB;
    UITableView *adviceTB;
    TopTabControl *toptabCtrl;
    
    NSUInteger btnSelectClickIdex;
    ZJWebProgrssView *progressV;
    MatterType currentType;
    BaoXiuTouShuHandler *bxtsH;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航栏文字颜色
    
    self.view.backgroundColor=[UIColor whiteColor];
    currentType = MatterTypeRepair;
    self.title=@"我的报事";
    btnSelectClickIdex = 0;
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(startNetworkForType) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
    self.navigationController.navigationBar.translucent=YES;
}


-(void)initData
{
    bxtsH =[BaoXiuTouShuHandler new];
}
-(void)initUI
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                                               self.view.frame.size.width,
                                                               50)];
    [self.view addSubview:headerV];
    
    toptabCtrl = [[TopTabControl alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    toptabCtrl.datasource = self;
    toptabCtrl.showIndicatorView = YES;
    [toptabCtrl reloadData];
    [self.view addSubview:toptabCtrl];
    
    __block __typeof(self)weakSelf = self;
    toptabCtrl.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index)
    {
        
        NSLog(@"itemClickBlockcell = %@,index = %lu",cell,(unsigned long)index);
        UIButton *btn =(UIButton *)[weakSelf.view viewWithTag:1000+index];
        [weakSelf bxtsserveiceChangeClick:btn];
        btnSelectClickIdex = index;
    };
    
    toptabCtrl.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        NSLog(@"pageEndDeceleratingBlockcell = %@,index = %lu",cell,(unsigned long)index);
        UIButton *btn =(UIButton *)[weakSelf.view viewWithTag:1000+index];
        [weakSelf bxtsserveiceChangeClick:btn];
        btnSelectClickIdex = index;
    };

    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT, toptabCtrl.frame.size.width, toptabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
    [toptabCtrl addSubview:progressV];
    progressV.loadBlock = ^{
        [weakSelf startNetworkForType];
    };

}

- (void)startNetworkForType {
    switch (currentType) {
        case MatterTypeRepair: {
            [self startNetworkGetShopsIsHeader1:YES];
        }
            break;
        case MatterTypeComplaint: {
            [self startNetworkGetShopsIsHeader2:YES];
        }
            break;
        case MatterTypeAdvice: {
            [self startNetworkGetShopsIsHeader3:YES];
        }
            break;
        default:
            break;
    }
}

- (void)bxtsserveiceChangeClick:(UIButton *)sender {
    NSLog(@"bxtsserveiceChangeClick,sender.tag = %ld",(long)
          sender.tag);
    for (int i = 1000; i <1000+3; i++) {
        UIButton *btn = (UIButton *)[toptabCtrl viewWithTag:i];
        btn.selected = NO;
    }
    
    sender.selected = YES;
    
    if (sender.tag==1000 ) {
        currentType = MatterTypeRepair;
    }
    else if (sender.tag==1001){
        currentType = MatterTypeComplaint;
    }
    else if(sender.tag==1002){
        currentType = MatterTypeAdvice;
    }
    
    [progressV startAnimation];
    [self startNetworkForType];
}

- (void)startNetworkGetShopsIsHeader1:(BOOL)isHeader{
    BaoXiuTouSuModel *bxtsM =[BaoXiuTouSuModel new];
    bxtsM.pageNumber=@"1";
    bxtsM.pageSize=@"10";
    bxtsM.orderBy = @"dateCreated";
    bxtsM.orderType = @"desc";
    BaoXiuTouSuModel *bxtsMapM =[BaoXiuTouSuModel new];
    bxtsMapM.memberId=[UserManager shareManager].comModel.merberId;
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].userModel.memberId,@"memberid",
                                 @"2",@"type",
                                 nil];
    
    bxtsM.queryMap = queryMapDic;
    
    [bxtsH BaoXiuList:bxtsM success:^(id obj) {
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:bxtsH.bxArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:repairTB];
        [repairTB reloadData];
    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:bxtsH.bxArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:repairTB];
    } isHeader:isHeader];
    
}


- (void)startNetworkGetShopsIsHeader2:(BOOL)isHeader{
    BaoXiuTouSuModel *bxtsM =[BaoXiuTouSuModel new];
    bxtsM.pageNumber=@"1";
    bxtsM.pageSize=@"10";
    bxtsM.orderBy = @"dateCreated";
    bxtsM.orderType = @"desc";
    BaoXiuTouSuModel *bxtsMapM =[BaoXiuTouSuModel new];
    bxtsMapM.memberId=[UserManager shareManager].comModel.merberId;
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].userModel.memberId,@"memberid",
                                 @"1",@"type",
                                 nil];
    
    bxtsM.queryMap = queryMapDic;
    
    [bxtsH TousuList:bxtsM success:^(id obj) {
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:bxtsH.tsArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:complaintsTB];
        [complaintsTB reloadData];
    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:bxtsH.tsArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:complaintsTB];
    } isHeader:isHeader];
    
}

- (void)startNetworkGetShopsIsHeader3:(BOOL)isHeader{
    ShengSJDataE *ssjM =[ShengSJDataE new];
    ssjM.pageNumber =bxtsH.advicePNumber;
    ssjM.pageSize=@"10";
    ssjM.orderBy = @"dateCreated";
    ssjM.orderType = @"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"7",@"type",
                                 [UserManager shareManager].userModel.memberId,@"memberid",
                                 nil];
    ssjM.queryMap = queryMapDic;
    
    [bxtsH queryAdviceData:ssjM success:^(id obj) {
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:bxtsH.adviceArray]];
        [adviceTB reloadData];
        [AppUtils tableViewEndMJRefreshWithTableV:adviceTB];
    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:bxtsH.adviceArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:adviceTB];
    } isHeader:isHeader];
}

//商品滚动回调方法
- (CGFloat)TopTabHeight:(TopTabControl *)tabCtrl{
    return TAB_ITEM_HEIGHT;
}

- (CGFloat)TopTabWidth:(TopTabControl *)tabCtrl{
    
    return IPHONE_WIDTH/3;
}

- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl{
    
    return 3;
}

- (TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl itemAtIndex:(NSUInteger)index{
    TopTabMenuItem *topItem = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width / 2, TAB_ITEM_HEIGHT)];
    switch (index)
    {
        case 0:
        {
            UIButton *repairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            repairBtn.frame = topItem.bounds;
            repairBtn.userInteractionEnabled = NO;
            repairBtn.tag = 1000;
            repairBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [repairBtn setTitle:@"报修" forState:UIControlStateNormal];
            [repairBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [repairBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [repairBtn addTarget:self action:@selector(bxtsserveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            repairBtn.selected = YES;
            [topItem addSubview:repairBtn];
            return topItem;
        }
        break;
        case 1:
        {
            UIButton *complaintsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            complaintsBtn.frame = topItem.bounds;
            complaintsBtn.userInteractionEnabled = NO;
            complaintsBtn.tag = 1001;
            complaintsBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [complaintsBtn setTitle:@"投诉" forState:UIControlStateNormal];
            [complaintsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [complaintsBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [complaintsBtn addTarget:self action:@selector(bxtsserveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            complaintsBtn.selected = NO;
            [topItem addSubview:complaintsBtn];
            return topItem;
        }
        break;
        case 2:
        {
            UIButton *adviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            adviceBtn.frame = topItem.bounds;
            adviceBtn.userInteractionEnabled = NO;
            adviceBtn.tag = 1002;
            adviceBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [adviceBtn setTitle:@"建议" forState:UIControlStateNormal];
            [adviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [adviceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [adviceBtn addTarget:self action:@selector(bxtsserveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            adviceBtn.selected = NO;
            [topItem addSubview:adviceBtn];
            return topItem;
        }
        break;

        default:
            break;
    }
    return topItem;

}



//报修投诉建议列表滚动视图
- (TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl pageAtIndex:(NSUInteger)index{
    
    TopTabPage *page = [[TopTabPage alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width,tabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
    
    if (index == 0)
    {
        repairTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabCtrl.frame.size.height)];
        //TableView.backgroundColor=[UIColor redColor];
        repairTB.dataSource=self;
        repairTB.delegate=self;
        repairTB.separatorStyle =UITableViewCellAccessoryNone;
        [page addSubview:repairTB];
        
        __block __typeof(self)weakTableView = self;
        
        [repairTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
            [weakTableView startNetworkGetShopsIsHeader1:YES];
        }];
        
        [repairTB addLegendFooterWithRefreshingBlock:^{//上拉加载更多
            [weakTableView startNetworkGetShopsIsHeader1:NO];
        }];
    }
    else if(index==1)
    {
        complaintsTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabCtrl.frame.size.height)];
        //TableView.backgroundColor=[UIColor redColor];
        complaintsTB.dataSource=self;
        complaintsTB.delegate=self;
        complaintsTB.separatorStyle =UITableViewCellAccessoryNone;
        [page addSubview:complaintsTB];
        
        __block __typeof(self)weakTableView = self;
        
        [complaintsTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
            [weakTableView startNetworkGetShopsIsHeader2:YES];
        }];
        
        [complaintsTB addLegendFooterWithRefreshingBlock:^{//上拉加载更多
            [weakTableView startNetworkGetShopsIsHeader2:NO];
        }];
    }
    else if (index==2)
    {
        adviceTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabCtrl.frame.size.height)];
        adviceTB.dataSource=self;
        adviceTB.delegate=self;
        adviceTB.separatorStyle =UITableViewCellAccessoryNone;
        [page addSubview:adviceTB];
        __block __typeof(self)weakTableView = self;
        
        [adviceTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
            [weakTableView startNetworkGetShopsIsHeader3:YES];
        }];
        
        [adviceTB addLegendFooterWithRefreshingBlock:^{//上拉加载更多
            [weakTableView startNetworkGetShopsIsHeader3:NO];
        }];
    }
    
    return page;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (currentType == MatterTypeRepair)
    {
        [AppUtils tableViewFooterPromptWithPNumber:bxtsH.bxcurrentPage.integerValue
                                        withPCount:bxtsH.bxpageCount.integerValue
                                         forTableV:repairTB];
    }
    else if (currentType == MatterTypeComplaint)
    {
        [AppUtils tableViewFooterPromptWithPNumber:bxtsH.tscurrentPage.integerValue
                                        withPCount:bxtsH.tspageCount.integerValue
                                         forTableV:complaintsTB];
    }
    else if (currentType == MatterTypeAdvice)
    {
        [AppUtils tableViewFooterPromptWithPNumber:bxtsH.advicePNumber.integerValue
                                        withPCount:bxtsH.advicePCount.integerValue
                                         forTableV:adviceTB];

    }
   
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
    headerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == repairTB)
    {
        return bxtsH.bxArray.count;
    }
    else if(tableView ==complaintsTB)
    {
        return bxtsH.tsArray.count;
    }
    else if (tableView==adviceTB)
    {
        return bxtsH.adviceArray.count;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RepairsCell"];
    if (cell == nil)
    {
        cell = [[RepairsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RepairsCell"];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88, IPHONE_WIDTH, 1)];
        img.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
        [cell addSubview:img];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (tableView==repairTB)
    {
        BaoXiuTouSuModel *bxtsM =[bxtsH.bxArray objectAtIndex:indexPath.row];
        [cell getDataByDictionary:bxtsM];
        cell.evaluateBut.tag=indexPath.row;
        [cell.evaluateBut addTarget:self action:@selector(evaluateButArr:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (tableView==complaintsTB)
    {
        BaoXiuTouSuModel *bxtsM =[bxtsH.tsArray objectAtIndex:indexPath.row];
        [cell getDataByDictionary:bxtsM];
        cell.evaluateBut.tag=indexPath.row;
        [cell.evaluateBut addTarget:self action:@selector(evaluateButArr:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (tableView==adviceTB)
    {
        ShengSJDataE *shengSJM =[bxtsH.adviceArray objectAtIndex:indexPath.row];
        [cell getDataByDictionaryJianYi:shengSJM];
    }
   
    return cell;
    
}

-(void)evaluateButArr:(UIButton *)sender
{
//    UIStoryboard *mainStoryB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
//    SubmitCommentVC *submmitVC = [mainStoryB instantiateViewControllerWithIdentifier:@"SubmitCommentVCID"];
    CommentViewControllr *commentV =[[CommentViewControllr alloc]init];
    if (btnSelectClickIdex==0)
    {
        BaoXiuTouSuModel *bxtsM =[bxtsH.bxArray objectAtIndex:sender.tag];
        commentV.isSwitchPage=CommentPageRepairs;
        NSLog(@"%@",bxtsM.ID);
        commentV.idID = bxtsM.ID;
        commentV.complaintType=@"REPAIR";
        [self.navigationController pushViewController:commentV animated:YES];
    }
    else if (btnSelectClickIdex==1)
    {
        BaoXiuTouSuModel *bxtsM =[bxtsH.tsArray objectAtIndex:sender.tag];
        commentV.isSwitchPage=CommentPageComplain;
        commentV.idID = bxtsM.ID;
        commentV.complaintType=@"COMPLAINT";
        [self.navigationController pushViewController:commentV animated:YES];
    }
   //[self.navigationController pushViewController:commentV animated:YES];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%d",indexPath.row);
    if (btnSelectClickIdex==0)
    {
        BaoXiuTouSuModel *bxtsM =[bxtsH.bxArray objectAtIndex:indexPath.row];
        DetailViewController *detaill = [[DetailViewController alloc]init];
        detaill.isbaoxiuComplaint=@"1";
        detaill.bxtsM =bxtsM;
        [self.navigationController pushViewController:detaill animated:YES];
    }
    else if (btnSelectClickIdex==1)
    {
        BaoXiuTouSuModel *bxtsM =[bxtsH.tsArray objectAtIndex:indexPath.row];
        DetailViewController *detaill = [[DetailViewController alloc]init];
        detaill.isbaoxiuComplaint=@"2";
        detaill.bxtsM =bxtsM;
        [self.navigationController pushViewController:detaill animated:YES];
    }
    else if (btnSelectClickIdex==2)
    {
        ShengSJDataE *ssjM= [bxtsH.adviceArray objectAtIndex:indexPath.row];
        AdviceVC *advice = [[AdviceVC alloc]init];
        advice.jianyiM =ssjM;
        [self.navigationController pushViewController:advice animated:YES];

    }


    
//    if (tableView==repairTB)
//    {
//        BaoXiuTouSuModel *bxtsM =[bxtsH.bxArray objectAtIndex:indexPath.row];
//        DetailViewController *detaill = [[DetailViewController alloc]init];
//        detaill.isbaoxiuComplaint=@"1";
//        detaill.bxtsM =bxtsM;
//        [self.navigationController pushViewController:detaill animated:YES];
//    }
//    else if (tableView==complaintsTB)
//    {
//        BaoXiuTouSuModel *bxtsM =[bxtsH.tsArray objectAtIndex:indexPath.row];
//        DetailViewController *detaill = [[DetailViewController alloc]init];
//        detaill.isbaoxiuComplaint=@"2";
//        detaill.bxtsM =bxtsM;
//        [self.navigationController pushViewController:detaill animated:YES];
//    }
//    else if (tableView==adviceTB)
//    {
//        ShengSJDataE *ssjM= [[RentalHandler handlerInstance].rentaArray objectAtIndex:indexPath.row];
//        AdviceVC *advice = [[AdviceVC alloc]init];
//        advice.jianyiM =ssjM;
//        [self.navigationController pushViewController:advice animated:YES];
//    }

    
}





@end
