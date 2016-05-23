//
//  ConsultationServiceTBVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define ITEM_COUNT 3
#define BTN_START_TAG 10

#import "ConsultationServiceTBVC.h"
#import "TopTabControl.h"
#import "ConsultationServiceCell.h"
#import <MJRefresh.h>
#import "ShengSJDataE.h"
#import "WebVC.h"
#import "ConsultationServiceH.h"
#import "ComAffairsDetailVC.h"
#import "ConsultationDetailTBVC.h"
#import "UserManager.h" 
#import "ZJWebProgrssView.h"

@interface ConsultationServiceTBVC () <UITableViewDataSource,
                                        UITableViewDelegate,
                                        TopTabControlDataSource>

@end

@implementation ConsultationServiceTBVC
{
    UITableView *legalTableV;
    UITableView *taxTableV;
    UITableView *financialTableV;
    
    TopTabControl *myTabCon;
    ConsultationType consultationType;
    
    ZJWebProgrssView *progressV;
    ConsultationServiceH *consultationServiceH;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
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

- (void)resetTheRefreshParameter {
    consultationServiceH.isLegalNeedUpdate = YES;
    consultationServiceH.isTaxNeedUpdate = YES;
    consultationServiceH.isFinancialNeedUpdate = YES;
}

- (void)initData {
    consultationServiceH = [ConsultationServiceH new];
    consultationType = ConsultationTypeLegal;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTheRefreshParameter) name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initUI {
    self.title = @"咨询服务";
    
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
        [weakSelf serviceChangeClick:btn];
    };
    
    myTabCon.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:BTN_START_TAG + index];
        [weakSelf serviceChangeClick:btn];
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

- (void)refreshData {
    if (consultationType == ConsultationTypeLegal &&
        !legalTableV.header.isRefreshing) {
        if (consultationServiceH.isLegalNeedUpdate || [NSArray isArrEmptyOrNull:consultationServiceH.legalArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
    else if (consultationType == ConsultationTypeTax &&
             !taxTableV.header.isRefreshing) {
        if (consultationServiceH.isTaxNeedUpdate || [NSArray isArrEmptyOrNull:consultationServiceH.taxArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
    else if (consultationType == ConsultationTypeFinancial &&
             !financialTableV.header.isRefreshing) {
        if (consultationServiceH.isFinancialNeedUpdate || [NSArray isArrEmptyOrNull:consultationServiceH.financialArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
}

- (void)serviceChangeClick:(UIButton *)sender {
    for (int i = BTN_START_TAG; i < BTN_START_TAG + ITEM_COUNT; i++) {
        UIButton *btn = (UIButton *)[myTabCon viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.selected = NO;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    
    switch (sender.tag) {
        case BTN_START_TAG + 0:
            consultationType = ConsultationTypeLegal;
            break;
        case BTN_START_TAG + 1:
            consultationType = ConsultationTypeTax;
            break;
        case BTN_START_TAG + 2:
            consultationType = ConsultationTypeFinancial;
            break;
        default:
            break;
    }

    [self resetTheRefreshParameter];
    [self refreshData];
}

- (void)getDataFromServerIsHeader:(BOOL)isHeader {
    ShengSJDataE *requestE = [ShengSJDataE new];
    requestE.pageSize   = @"10";
    requestE.orderBy    = @"dateCreated";
    requestE.orderType  = @"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"type",
                                 [NSString stringWithFormat:@"%lu",(unsigned long)consultationType],@"consultationType",
                                 [UserManager shareManager].comModel.wyId,@"wyNo",
                                 @"3",@"status",
                                 nil];
    requestE.queryMap = queryMapDic;
    
    if (consultationType == ConsultationTypeLegal) {
        [consultationServiceH requestForLegalServiceWithModel:requestE success:^(id obj) {
            consultationServiceH.isLegalNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:consultationServiceH.legalArr]];
            [legalTableV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:legalTableV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:consultationServiceH.legalArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:legalTableV];
        } isHeader:isHeader];
    }
    else if (consultationType == ConsultationTypeTax) {
        [consultationServiceH requestForTaxServiceWithModel:requestE success:^(id obj) {
            consultationServiceH.isTaxNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:consultationServiceH.taxArr]];
            [taxTableV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:taxTableV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:consultationServiceH.taxArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:taxTableV];
        } isHeader:isHeader];
    }
    else if (consultationType == ConsultationTypeFinancial){
        [consultationServiceH requestForFinancialServiceWithModel:requestE success:^(id obj) {
            consultationServiceH.isFinancialNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:consultationServiceH.financialArr]];
            [financialTableV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:financialTableV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:consultationServiceH.financialArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:financialTableV];
        } isHeader:isHeader];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
    headerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == legalTableV) {
        [AppUtils tableViewFooterPromptWithPNumber:consultationServiceH.legalPNumber.integerValue
                                        withPCount:consultationServiceH.legalPCount.integerValue
                                         forTableV:legalTableV];
        return consultationServiceH.legalArr.count;
    }
    else if (tableView == taxTableV) {
        [AppUtils tableViewFooterPromptWithPNumber:consultationServiceH.taxPNumber.integerValue
                                        withPCount:consultationServiceH.taxPCount.integerValue
                                         forTableV:taxTableV];
        return consultationServiceH.taxArr.count;
    }
    else if (tableView == financialTableV) {
        [AppUtils tableViewFooterPromptWithPNumber:consultationServiceH.financialPNumber.integerValue
                                        withPCount:consultationServiceH.financialPCount.integerValue
                                         forTableV:financialTableV];
        return consultationServiceH.financialArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == legalTableV) {
        ConsultationServiceCell *cell = (ConsultationServiceCell *)[tableView dequeueReusableCellWithIdentifier:@"ConsultationServiceCellID"];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        }
        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == legalTableV) {
        ShengSJDataE *reportE = [consultationServiceH.legalArr objectAtIndex:indexPath.row];
        ConsultationServiceCell *consultCell = (ConsultationServiceCell *)cell;
        [consultCell reloadDataWithModel:reportE];
    }
    else if (tableView == taxTableV) {
        ShengSJDataE *reportE = [consultationServiceH.taxArr objectAtIndex:indexPath.row];
        cell.textLabel.text = reportE.title;
    }
    else if (tableView == financialTableV) {
        ShengSJDataE *reportE = [consultationServiceH.financialArr objectAtIndex:indexPath.row];
        cell.textLabel.text = reportE.title;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == legalTableV) {
        return 148;
    }

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == legalTableV) {
        ConsultationDetailTBVC *legalDetalVC = [ConsultationDetailTBVC new];
        legalDetalVC.detailE = [consultationServiceH.legalArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:legalDetalVC animated:YES];
    }
    else if (tableView == taxTableV) {
        ComAffairsDetailVC *detailVC = [ComAffairsDetailVC new];
        detailVC.title = @"税务详情";
        detailVC.detailE = [consultationServiceH.taxArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (tableView == financialTableV) {
        ComAffairsDetailVC *detailVC = [ComAffairsDetailVC new];
        detailVC.title = @"财务详情";
        detailVC.detailE = [consultationServiceH.financialArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - TopTabControlDataSource
- (CGFloat)TopTabHeight:(TopTabControl *)tabCtrl {
    return TAB_ITEM_HEIGHT;
}

- (CGFloat)TopTabWidth:(TopTabControl *)tabCtrl {
    return tabCtrl.frame.size.width / ITEM_COUNT;
}

- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl {
    return ITEM_COUNT;
}

- (TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl
                      itemAtIndex:(NSUInteger)index {
    TopTabMenuItem *item = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width / 2, TAB_ITEM_HEIGHT)];
    switch (index) {
        case 0: {
            UIButton *legalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            legalBtn.frame = item.bounds;
            legalBtn.userInteractionEnabled = NO;
            legalBtn.tag = BTN_START_TAG + index;
            legalBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [legalBtn setTitle:@"法务咨询" forState:UIControlStateNormal];
            [legalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [legalBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [legalBtn addTarget:self action:@selector(serviceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            legalBtn.selected = YES;
            [item addSubview:legalBtn];
        }
            break;
        case 1: {
            UIButton *taxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            taxBtn.frame = item.bounds;
            taxBtn.userInteractionEnabled = NO;
            taxBtn.tag = BTN_START_TAG + index;
            taxBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [taxBtn setTitle:@"税务咨询" forState:UIControlStateNormal];
            [taxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [taxBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [taxBtn addTarget:self action:@selector(serviceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            taxBtn.selected = NO;
            [item addSubview:taxBtn];
        }
            break;
        case 2: {
            UIButton *financialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            financialBtn.frame = item.bounds;
            financialBtn.userInteractionEnabled = NO;
            financialBtn.tag = BTN_START_TAG + index;
            financialBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [financialBtn setTitle:@"财务咨询" forState:UIControlStateNormal];
            [financialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [financialBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [financialBtn addTarget:self action:@selector(serviceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            financialBtn.selected = NO;
            [item addSubview:financialBtn];
        }
            break;
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
            legalTableV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            __block __typeof(self)weakSelf = self;
            [legalTableV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [legalTableV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            legalTableV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
            legalTableV.delegate = self;
            legalTableV.dataSource = self;
            [legalTableV registerNib:[UINib nibWithNibName:@"ConsultationServiceCell" bundle:nil] forCellReuseIdentifier:@"ConsultationServiceCellID"];
            legalTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
            legalTableV.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:legalTableV];
            [tabV addSubview:legalTableV];
            return tabV;
        }
            break;
        case 1: {
            taxTableV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            __block __typeof(self)weakSelf = self;
            [taxTableV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [taxTableV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            taxTableV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
            taxTableV.delegate = self;
            taxTableV.dataSource = self;
            [taxTableV registerNib:[UINib nibWithNibName:@"ConsultationServiceCell" bundle:nil] forCellReuseIdentifier:@"ConsultationServiceCellID"];
            taxTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            taxTableV.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:taxTableV];
            [tabV addSubview:taxTableV];
            return tabV;
        }
            break;
        case 2: {
            financialTableV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            __block __typeof(self)weakSelf = self;
            [financialTableV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [financialTableV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            financialTableV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
            financialTableV.delegate = self;
            financialTableV.dataSource = self;
            [financialTableV registerNib:[UINib nibWithNibName:@"ConsultationServiceCell" bundle:nil] forCellReuseIdentifier:@"ConsultationServiceCellID"];
            financialTableV.tableFooterView = [AppUtils tableViewsFooterView];
            financialTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self viewDidLayoutSubviewsForTableView:financialTableV];
            [tabV addSubview:financialTableV];
            return tabV;
        }
            break;
        default:
            return nil;
            break;
    }
}

@end
