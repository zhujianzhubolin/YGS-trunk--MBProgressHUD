//
//  CommunityAffairsTBVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#define CELL_HEIGHT 44

#import "CommunityAffairsTBVC.h"
#import "CommunityAffairsH.h"   
#import "SearchVC.h"
#import "ComAffairsDetailVC.h"
#import "UserManager.h"
#import "ZJWebProgrssView.h"

@interface CommunityAffairsTBVC ()  <UITableViewDataSource,
                                     UITableViewDelegate>

@end

@implementation CommunityAffairsTBVC
{
    UITableView *infoTableView;
    ZJWebProgrssView *progressV;
    CommunityAffairsH *communityAffairsH;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)resetTheRefreshParameter {
    communityAffairsH.isAffairsNeedUpdate = YES;
}

- (void)initData {
    communityAffairsH = [CommunityAffairsH new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTheRefreshParameter) name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initUI {
    self.title = @"社区政务";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick)];
    
    self.view.backgroundColor = [UIColor redColor];
    infoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    infoTableView.delegate = self;
    infoTableView.dataSource = self;
    [infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SYSTEM_CELL_ID];
    infoTableView.tableFooterView = [AppUtils tableViewsFooterView];

    [self viewDidLayoutSubviewsForTableView:infoTableView];
    [self.view addSubview:infoTableView];
    
    __block __typeof(self)weakSelf = self;
    [infoTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDataFromServerIsHeader:YES];
    }];
    
    [infoTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataFromServerIsHeader:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    progressV.loadBlock = ^{
        [weakSelf getDataFromServerIsHeader:YES];
    };
    [self.view addSubview:progressV];
}

- (void)searchClick {
    SearchVC *searchVC = [SearchVC new];
    searchVC.placeholder = @"请输入关键词";
    __block __typeof(searchVC)weakSearchVC = searchVC;
    
    //设置UI刷新
    [searchVC searchForCustomCellWithCellClassName:[UITableViewCell class]
                                            cellID:SYSTEM_CELL_ID
                                        cellHeight:CELL_HEIGHT
                                             isNib:NO
                          tableViewCellConfigufate:^(id cell, SearchCellEntity *entity) {
                              UITableViewCell *affairCell = cell;
                              ShengSJDataE *affairE = entity.dataSource;
                              affairCell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                              affairCell.textLabel.text = affairE.title;
                          }];
    
    //设置点击返回
    searchVC.clickBlock = ^(SearchCellEntity *searchE) {
        ShengSJDataE *affairE = searchE.dataSource;
        ComAffairsDetailVC *communityDetailVC = [ComAffairsDetailVC new];
        communityDetailVC.detailE = affairE;
        [self.navigationController pushViewController:communityDetailVC animated:YES];
    };

    //网络搜索
    searchVC.webBlock =  ^(NSString *searchString) {
        [AppUtils showProgressMessage:W_ALL_PROGRESS];
        
        ShengSJDataE *requestE = [ShengSJDataE new];
        requestE.pageSize   = @"100";
        requestE.orderBy    = @"dateCreated";
        requestE.orderType  = @"desc";
        requestE.title      = searchString;
        
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"type",
                                     [UserManager shareManager].comModel.xqNo,@"xqNo",
                                     requestE.title,@"title",
                                     @"3",@"status",
                                     nil];
        requestE.queryMap = queryMapDic;
        NSMutableArray *searchArr = [NSMutableArray array];
        [communityAffairsH requestForCommunityAffairsWithModel:requestE success:^(id obj) {
            NSArray *recvArr = (NSArray *)obj;
            if ([NSArray isArrEmptyOrNull:recvArr]) {
                [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
                [weakSearchVC reloadWebSearchData:searchArr];
                return;
            }
            
            [recvArr enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
                ShengSJDataE *affairE = (ShengSJDataE *)obj1;
                SearchCellEntity *searchE = [SearchCellEntity new];
                searchE.dataSource = affairE;
                [searchArr addObject:searchE];
            }];
            [AppUtils dismissHUD];
            [weakSearchVC reloadWebSearchData:searchArr];
        } failed:^(id obj) {
            if (self.viewIsVisible) {
                [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
            }
            else {
                [AppUtils dismissHUD];
            }
            
            [weakSearchVC reloadWebSearchData:searchArr];
        } isHeader:YES];
    };
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)getDataFromServerIsHeader:(BOOL)isHeader {
    ShengSJDataE *requestE = [ShengSJDataE new];
    requestE.pageSize   = @"10";
    requestE.orderBy    = @"dateCreated";
    requestE.orderType  = @"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"5",@"type",
                                 [UserManager shareManager].comModel.xqNo,@"xqNo",
                                 @"3",@"status",
                                 nil];
    requestE.queryMap = queryMapDic;
    
    [communityAffairsH requestForCommunityAffairsWithModel:requestE success:^(id obj) {
        communityAffairsH.isAffairsNeedUpdate = NO;
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:communityAffairsH.affairsArr]];
        [infoTableView reloadData];
        [AppUtils tableViewEndMJRefreshWithTableV:infoTableView];
    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:communityAffairsH.affairsArr]];
        [AppUtils tableViewEndMJRefreshWithTableV:infoTableView];
    } isHeader:isHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
    headerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];;
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [AppUtils tableViewFooterPromptWithPNumber:communityAffairsH.affairsPNumber.integerValue
                                    withPCount:communityAffairsH.affairsPCount.integerValue
                                     forTableV:tableView];
    return communityAffairsH.affairsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ShengSJDataE *affairE = communityAffairsH.affairsArr[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.text = affairE.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShengSJDataE *affairE = communityAffairsH.affairsArr[indexPath.row];
    ComAffairsDetailVC *communityDetailVC = [ComAffairsDetailVC new];
    communityDetailVC.detailE = affairE;
    communityDetailVC.title = @"社区政务详情";
    [self.navigationController pushViewController:communityDetailVC animated:YES];
}

@end
