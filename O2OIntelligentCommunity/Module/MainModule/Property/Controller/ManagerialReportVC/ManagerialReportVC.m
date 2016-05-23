//
//  ManagerialReportVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define ITEM_COUNT 2
#define BTN_START_TAG 10

#import "ManagerialReportVC.h"
#import "TopTabControl.h"
#import <MJRefresh.h>
#import "ManagerialReportH.h"
#import "ShengSJDataE.h"
#import "ComAffairsDetailVC.h"
#import "UserManager.h"
#import "ZJWebProgrssView.h"

@interface ManagerialReportVC () <UITableViewDataSource,
                                  UITableViewDelegate,
                                  TopTabControlDataSource>

@end

@implementation ManagerialReportVC
{
    UITableView *propertyTableV;
    UITableView *expendituresTableV;

    TopTabControl *myTabCon;
    ReportType reportType;
    ZJWebProgrssView *progressV;
    ManagerialReportH *managerReportH;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
    [self resetTheRefreshParameter];
    [self refreshData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDataFromServerIsHeader:YES];
    });

    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initData {
    managerReportH = [ManagerialReportH new];
    reportType = ReportTypeProperty;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTheRefreshParameter) name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)resetTheRefreshParameter {
    managerReportH.isExpendituresNeedUpdate = YES;
    managerReportH.isPropertyNeedUpdate = YES;
}

- (void)initUI {
    self.title = @"管理报告";
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                                               self.view.frame.size.width,
                                                               50)];
    [self.view addSubview:headerV];
    
    myTabCon = [[TopTabControl alloc] initWithFrame:CGRectMake(0,
                                                               self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height)];
    
    __block __typeof(self)weakSelf = self;
    myTabCon.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:BTN_START_TAG + index];
        [weakSelf serveiceChangeClick:btn];
    };
        
    myTabCon.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:BTN_START_TAG + index];
        [weakSelf serveiceChangeClick:btn];
    };
    
    myTabCon.datasource = self;
    myTabCon.showIndicatorView = YES;
    [myTabCon displayPageAtIndex:0];
    [self.view addSubview:myTabCon];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT, myTabCon.frame.size.width, myTabCon.frame.size.height - TAB_ITEM_HEIGHT)];
    progressV.loadBlock = ^{
        [weakSelf getDataFromServerIsHeader:YES];
    };
    
    [myTabCon addSubview:progressV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    if (reportType == ReportTypeProperty &&
        !propertyTableV.header.isRefreshing) {
        if (managerReportH.isPropertyNeedUpdate || [NSArray isArrEmptyOrNull:managerReportH.propertyArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
    else if (reportType == ReportTypeExpenditures &&
             !expendituresTableV.header.isRefreshing) {
        if (managerReportH.isExpendituresNeedUpdate || [NSArray isArrEmptyOrNull:managerReportH.expendituresArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
}

- (void)serveiceChangeClick:(UIButton *)sender {
    for (int i = BTN_START_TAG; i < BTN_START_TAG + ITEM_COUNT; i++) {
        UIButton *btn = (UIButton *)[myTabCon viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.selected = NO;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    
    reportType = ITEM_COUNT - (sender.tag - BTN_START_TAG);
    [self resetTheRefreshParameter];
    [self refreshData];
}

- (void)getDataFromServerIsHeader:(BOOL)isHeader {
    ShengSJDataE *requestE = [ShengSJDataE new];
    requestE.pageSize   = @"10";
    requestE.orderBy    = @"dateCreated";
    requestE.orderType  = @"desc";

    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"4",@"type",
                                 @"3",@"status",
                                [NSString stringWithFormat:@"%d",reportType],@"reportType",
                                [UserManager shareManager].comModel.xqNo,@"xqNo",
                                nil];
    requestE.queryMap = queryMapDic;
    
    if (reportType == ReportTypeProperty) {
        [managerReportH requestForPropertyReportWithModel:requestE success:^(id obj) {
            managerReportH.isPropertyNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:managerReportH.propertyArr]];
            [propertyTableV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:propertyTableV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:managerReportH.propertyArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:propertyTableV];
        } isHeader:isHeader];
    }
    else {
        [managerReportH requestForExpendituresReportWithModel:requestE success:^(id obj) {
            managerReportH.isExpendituresNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:managerReportH.expendituresArr]];
            [expendituresTableV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:expendituresTableV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:managerReportH.expendituresArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:expendituresTableV];
        } isHeader:isHeader];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == propertyTableV) {
        [AppUtils tableViewFooterPromptWithPNumber:managerReportH.propertyPNumber.integerValue
                                        withPCount:managerReportH.propertyPCount.integerValue
                                         forTableV:propertyTableV];
        return managerReportH.propertyArr.count;
    }
    else if (tableView == expendituresTableV) {
        [AppUtils tableViewFooterPromptWithPNumber:managerReportH.expendituresPNumber.integerValue
                                        withPCount:managerReportH.expendituresPCount.integerValue
                                         forTableV:expendituresTableV];
        return managerReportH.expendituresArr.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
    headerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    return headerV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.imageView.image = [UIImage imageNamed:@"managerReport"];
    
    if (tableView == propertyTableV) {
        ShengSJDataE *reportE = [managerReportH.propertyArr objectAtIndex:indexPath.section];
        cell.textLabel.text = reportE.title;
    }
    else if (tableView == expendituresTableV) {
        ShengSJDataE *reportE = [managerReportH.expendituresArr objectAtIndex:indexPath.section];
        cell.textLabel.text = reportE.title;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ComAffairsDetailVC *detailVC = [ComAffairsDetailVC new];
    if (tableView == propertyTableV) {
        detailVC.title = @"详情";
        detailVC.detailE = [managerReportH.propertyArr objectAtIndex:indexPath.section];
    }
    else if (tableView == expendituresTableV) {
        detailVC.title = @"详情";
        detailVC.detailE = [managerReportH.expendituresArr objectAtIndex:indexPath.section];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - TopTabControlDataSource
- (CGFloat)TopTabHeight:(TopTabControl *)tabCtrl{
    return TAB_ITEM_HEIGHT;
}

- (CGFloat)TopTabWidth:(TopTabControl *)tabCtrl {
    return tabCtrl.frame.size.width / 2;
}

- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl {
    return 2;
}

- (TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl
                      itemAtIndex:(NSUInteger)index {
    TopTabMenuItem *item = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width / 2, TAB_ITEM_HEIGHT)];
    switch (index) {
        case 0: {
            UIButton *merchantAroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            merchantAroundBtn.frame = item.bounds;
            merchantAroundBtn.userInteractionEnabled = NO;
            merchantAroundBtn.tag = BTN_START_TAG + index;
            merchantAroundBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [merchantAroundBtn setTitle:@"管理服务报告" forState:UIControlStateNormal];
            [merchantAroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [merchantAroundBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [merchantAroundBtn addTarget:self action:@selector(serveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            merchantAroundBtn.selected = YES;
            [item addSubview:merchantAroundBtn];
        }
            break;
        case 1: {
            UIButton *publicServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            publicServiceBtn.frame = item.bounds;
            publicServiceBtn.userInteractionEnabled = NO;
            publicServiceBtn.tag = BTN_START_TAG + index;
            publicServiceBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [publicServiceBtn setTitle:@"财务收支报告" forState:UIControlStateNormal];
            [publicServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [publicServiceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [publicServiceBtn addTarget:self action:@selector(serveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            publicServiceBtn.selected = NO;
            [item addSubview:publicServiceBtn];
        }
        default:
            break;
    }
    return item;
}

- (TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl
                  pageAtIndex:(NSUInteger)index {
    TopTabPage *tabV = [[TopTabPage alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width,tabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
    
    switch (index) {
        case 0: {
            propertyTableV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            __block __typeof(self)weakSelf = self;
            [propertyTableV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [propertyTableV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            propertyTableV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
            propertyTableV.delegate = self;
            propertyTableV.dataSource = self;
            propertyTableV.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:propertyTableV];
            [tabV addSubview:propertyTableV];
            return tabV;
        }
            break;
        case 1: {
            expendituresTableV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            __block __typeof(self)weakSelf = self;
            [expendituresTableV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [expendituresTableV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            expendituresTableV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
            expendituresTableV.delegate = self;
            expendituresTableV.dataSource = self;
            expendituresTableV.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:expendituresTableV];
            [tabV addSubview:expendituresTableV];
            return tabV;
        }
            break;
        default:
            return nil;
            break;
    }
}

@end
