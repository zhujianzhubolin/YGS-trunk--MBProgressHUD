    //
//  LifeCircleVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#define ITEM_COUNT 2
#define BTN_START_TAG 10
#define CELL_HEIGHT 90

#import "LifeCircleVC.h"
#import "TopTabControl.h"
#import "LifeCircleStoresCell.h"
#import "ChangePostionButton.h"
#import "LifeCircleH.h"
#import "UserManager.h"
#import <UIImageView+AFNetworking.h>
#import "SearchMultiTypeVC.h"   
#import "EasyDetail.h"  
#import "GoodsViewController.h"
#import "ZJWebProgrssView.h"
#import "TGShopDetailViewController.h"
#import "ChangePostionButton.h"
#import "NIDropDown.h"

@interface LifeCircleVC () <UITableViewDataSource,
                            UITableViewDelegate,
                            TopTabControlDataSource,NIDropDownDelegate>

@end

@implementation LifeCircleVC
{
    UITableView *aroundMerchantsTV;
    UITableView *publicServiceTV;
    NSMutableArray *storeCloseNameArray;
    NSMutableArray *storeCloseModelArray;
    
    TopTabControl *myTabCon;
    LifeCircleType circleType;
    
    ZJWebProgrssView *progressV;
    LifeCircleH *lifeH;
    LifeCircleE *lifeM;
    
    NSUInteger chickDropDomnIndex;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NIDropDown dropDownInstance].delegate = self;
    self.navigationController.navigationBar.translucent = NO;
    [self hidetabbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];

    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestSroreClose];
    });
    
    // Do any additional setup after loading the view.
}

- (void)initData {
    storeCloseNameArray = [NSMutableArray array];
    storeCloseModelArray = [NSMutableArray array];
    circleType = LifeCircleTypeAround;
    lifeH = [LifeCircleH new];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isCommunityChange)
                                                 name:k_NOTI_COMMUNITY_CHANGE
                                               object:nil];
}

- (void)isCommunityChange {
    lifeH.isAroundNeedUpdate = YES;
    lifeH.isPublicNeedUpdate = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick)];
    self.title = @"生活圈";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor lightGrayColor];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               50)];
    [self.view addSubview:headerV];
    
    myTabCon = [[TopTabControl alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height)];
    
    __block __typeof(self)weakSelf = self;
    myTabCon.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:10 + index];
        [weakSelf serveiceChangeClick:btn];
    };
    
    myTabCon.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:10 + index];
        [weakSelf serveiceChangeClick:btn];
    };
    
    myTabCon.datasource = self;
    myTabCon.showIndicatorView = YES;
    [myTabCon displayPageAtIndex:0];
    [self.view addSubview:myTabCon];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT, myTabCon.frame.size.width, myTabCon.frame.size.height - TAB_ITEM_HEIGHT)];
    
    progressV.loadBlock = ^{
        [weakSelf requestForGetAroundMerchants];
    };
    [myTabCon addSubview:progressV];
}

- (void)requestForGetAroundMerchants {
    if (lifeM == nil) {
        [self requestSroreClose];
    }
    else {
        [self getDataFromServerIsHeader:YES];
    }
}

- (void)searchClick {
    SearchMultiTypeVC *searchVC = [SearchMultiTypeVC new];
    NSString *keyForAround = @"peripheral_merchant";
    NSString *keyForPublic = @"convenient_service";
    searchVC.typeDic = @{keyForAround:@"周边商家",
                         keyForPublic:@"便民服务"};

    if (circleType == LifeCircleTypeAround) {
        searchVC.selectedDic = @{keyForAround:@"周边商家"};
    }
    else {
        searchVC.selectedDic = @{keyForPublic:@"便民服务"};
    }
    
    searchVC.placeholder = @"搜索商家/服务";
    __block __typeof(searchVC)weakSearchVC = searchVC;
    
    //设置UI刷新
    [searchVC searchForCustomCellWithCellClassName:[LifeCircleStoresCell class]
                                            cellID:@"LifeCircleStoresCellID"
                                        cellHeight:CELL_HEIGHT
                                             isNib:YES
                          tableViewCellConfigufate:^(id cell, SearchCellEntity *entity,NSString *typeKey) {
                              if ([NSString isEmptyOrNull:typeKey]) {
                                  return;
                              }
                              
                              LifeCircleStoresCell *circleCell = cell;
                              if ([typeKey isEqualToString:keyForAround]) {
                                  [circleCell reloadAroundMerchangtsWithModel:entity.dataSource];
                              }
                              else if ([typeKey isEqualToString:keyForPublic]) {
                                  [circleCell reloadPublicServiceWithModel:entity.dataSource];
                              }
                          }];
    
    //设置点击
    searchVC.clickBlock = ^(SearchCellEntity *searchE,NSString *typeKey) {
        LifeCircleE *circleE = searchE.dataSource;
        [self cellClickForModel:circleE];
    };
    
    //网络搜索
    searchVC.webBlock =  ^(NSString *searchString,NSString *typeKey) {
        [AppUtils showProgressMessage:W_ALL_PROGRESS];
        
        LifeCircleE * circleE = [LifeCircleE new];
        
        circleE.pageSize    = @"100";
        circleE.pageNumber  = @"1";
        circleE.storeName   = searchString;
        circleE.optionId    = @"2600";
        circleE.commId      = [UserManager shareManager].comModel.xqNo;
        circleE.companyId   = P_WYID;
        circleE.screening   = @"";
        circleE.convenient = typeKey;
        circleE.queryMap = [NSDictionary dictionaryWithObjectsAndKeys:circleE.storeName,@"storeName",
                            circleE.optionId,@"optionId",
                            circleE.commId,@"commId",
                            circleE.screening,@"screening",
                            circleE.convenient,@"convenient",
                            circleE.companyId,@"companyId",
                            nil];
        
        NSMutableArray *searchArr = [NSMutableArray array];
        [lifeH requestForSearchWithModel:circleE success:^(id obj) {
            NSArray *recvArr = (NSArray *)obj;
            if ([NSArray isArrEmptyOrNull:recvArr]) {
                [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
                [weakSearchVC reloadWebSearchData:searchArr];
                return;
            }
            
            [recvArr enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
                LifeCircleE * searchCircleE = obj1;
                SearchCellEntity *searchE = [SearchCellEntity new];
                searchE.dataSource = searchCircleE;
                [searchArr addObject:searchE];
            }];
            [AppUtils dismissHUD];
            [weakSearchVC reloadWebSearchData:searchArr];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:W_ALL_NO_DATA_SEARCH isShow:self.viewIsVisible];
            [weakSearchVC reloadWebSearchData:searchArr];
        }];
    };
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    LifeCircleType clickType = sender.tag - BTN_START_TAG;

    if (clickType == LifeCircleTypeAround)
    {
        if (circleType == clickType) {
            circleType = sender.tag - BTN_START_TAG;
            [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(0, 110, IPHONE_WIDTH,280) withButton:sender withArr:storeCloseNameArray withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentCenter isSelHide:YES];
            return;
        }
    }

    circleType = sender.tag - BTN_START_TAG;
    [self resetTheRefreshParameter];
    [self refreshData];
}

- (void)resetTheRefreshParameter {
    lifeH.isAroundNeedUpdate = YES;
    lifeH.isPublicNeedUpdate = YES;
}

- (void)refreshData {
    if (circleType == LifeCircleTypeAround &&
        !aroundMerchantsTV.header.isRefreshing) {
        if (lifeH.isAroundNeedUpdate || [NSArray isArrEmptyOrNull:lifeH.aroundArr]) {
            [progressV startAnimation];
            [self requestForGetAroundMerchants];
        }
    }
    else if (circleType == LifeCircleTypePublick &&
             !publicServiceTV.header.isRefreshing) {
        if (lifeH.isPublicNeedUpdate || [NSArray isArrEmptyOrNull:lifeH.publicArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
}

- (void)phoneClick:(UIButton *)sender {
    LifeCircleE *circleE = lifeH.publicArr[sender.tag - 1];
    if (![NSString isEmptyOrNull:circleE.phone]) {
        [AppUtils callPhone:circleE.phone];
    }
}

-(void)requestSroreClose
{
    [lifeH requestStoreCloseWithModel:nil success:^(id obj) {
         storeCloseModelArray =(NSMutableArray *)obj;
        for (int i =0; i<storeCloseModelArray.count; i++)
        {
            LifeCircleE *modeM =storeCloseModelArray[i];
            [storeCloseNameArray addObject:modeM.name];
        }
        
        if (![NSArray isArrEmptyOrNull:storeCloseModelArray]) {
            lifeM = storeCloseModelArray[0];
            [self getDataFromServerIsHeader:YES];
        }
    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:storeCloseModelArray]];
    }];
    
}

- (void)getDataFromServerIsHeader:(BOOL)isHeader
{
    LifeCircleE * circleE = [LifeCircleE new];
    
    circleE.pageSize    = @"10";
    circleE.storeName   = @"";
    circleE.commId      = [UserManager shareManager].comModel.xqNo;
    circleE.companyId   = P_WYID;
    circleE.screening   = @"AWAY_NEAREST";
    
    if (circleType == LifeCircleTypeAround) {
        circleE.convenient = @"peripheral_merchant";
        circleE.optionId   = [NSString stringWithFormat:@"%@",lifeM.ID];
    }
    else {
        circleE.convenient = @"convenient_service";
        circleE.optionId   = @" ";
    }
    
    circleE.queryMap = [NSDictionary dictionaryWithObjectsAndKeys:circleE.storeName,@"storeName",
                                                                    circleE.optionId,@"optionId",
                                                                    circleE.commId,@"commId",
                                                                    circleE.screening,@"screening",
                                                                    circleE.convenient,@"convenient",
                                                                    circleE.companyId,@"companyId",
                                                                    nil];
    
    if (circleType == LifeCircleTypeAround) {
        [lifeH requestForAroundMerchantsWithModel:circleE success:^(id obj) {
            lifeH.isAroundNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:lifeH.aroundArr]];
            [aroundMerchantsTV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:aroundMerchantsTV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:lifeH.aroundArr]];
            [AppUtils tableViewEndMJRefreshWithTableV:aroundMerchantsTV];
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                                isShow:self.viewIsVisible];
        } isHeader:isHeader];
    }
    else {
        [lifeH requestForPublicServiceWithModel:circleE success:^(id obj) {
            lifeH.isPublicNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:lifeH.publicArr]];
            [publicServiceTV reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:publicServiceTV];
        } failed:^(id obj) {
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:lifeH.publicArr]];

            [AppUtils tableViewEndMJRefreshWithTableV:publicServiceTV];
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                                isShow:self.viewIsVisible];
        } isHeader:isHeader];
    }
}

- (void)cellClickForModel:(LifeCircleE *)lifeE {
    TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
    detail.shopId = [NSString stringWithFormat:@"%@",lifeE.ID];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - NIDropDownDelegate
//下拉列表回调方法
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button{
    NSLog(@"index==%ld",(long)index);
    lifeM =storeCloseModelArray[index];
    
    UIButton *zhoubianBtn =(UIButton *)[myTabCon viewWithTag:chickDropDomnIndex];
    [zhoubianBtn setTitle:lifeM.name forState:UIControlStateSelected];

    [self getDataFromServerIsHeader:YES];
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
        return 0.1;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == aroundMerchantsTV) {
        [AppUtils tableViewFooterPromptWithPNumber:lifeH.aroundPNumber.integerValue
                                        withPCount:lifeH.aroundPCount.integerValue
                                         forTableV:aroundMerchantsTV];
        return lifeH.aroundArr.count;
    }
    else {
        [AppUtils tableViewFooterPromptWithPNumber:lifeH.publicPNumber.integerValue
                                        withPCount:lifeH.publicPCount.integerValue
                                         forTableV:publicServiceTV];
        return lifeH.publicArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LifeCircleStoresCell *circleCell = (LifeCircleStoresCell *)[tableView dequeueReusableCellWithIdentifier:@"LifeCircleStoresCellID"];
    return circleCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LifeCircleStoresCell *circleCell = (LifeCircleStoresCell *)cell;
    if (tableView == aroundMerchantsTV) {
        LifeCircleE *circleE = lifeH.aroundArr[indexPath.section];
        [circleCell reloadAroundMerchangtsWithModel:circleE];
    }
    else {
        LifeCircleE *circleE = lifeH.publicArr[indexPath.section];
        [circleCell reloadPublicServiceWithModel:circleE];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LifeCircleE *circleE;
    if (tableView == aroundMerchantsTV) {
        circleE = lifeH.aroundArr[indexPath.section];
    }
    else {
        circleE = lifeH.publicArr[indexPath.section];
    }
    
    [self cellClickForModel:circleE];
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
//            UIButton *merchantAroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            merchantAroundBtn.frame = item.bounds;
//            merchantAroundBtn.userInteractionEnabled = NO;
//            merchantAroundBtn.tag = BTN_START_TAG + index;
//            merchantAroundBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
//            [merchantAroundBtn setTitle:@"周边商家" forState:UIControlStateNormal];
//            [merchantAroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [merchantAroundBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//            [merchantAroundBtn addTarget:self action:@selector(serveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//            merchantAroundBtn.selected = YES;
//            [item addSubview:merchantAroundBtn];
//            return item;
            UIButton *merchantAroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            merchantAroundBtn.frame=item.bounds;
            merchantAroundBtn.userInteractionEnabled = NO;
            chickDropDomnIndex=BTN_START_TAG + index;
            merchantAroundBtn.tag = chickDropDomnIndex;
            merchantAroundBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [merchantAroundBtn setTitle:@"周边商家" forState:UIControlStateNormal];
            [merchantAroundBtn setImage:[UIImage imageNamed:@"listLight"] forState:UIControlStateNormal];
            [merchantAroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [merchantAroundBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [merchantAroundBtn addTarget:self action:@selector(serveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            [merchantAroundBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
            [merchantAroundBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
            merchantAroundBtn.selected = YES;
            [item addSubview:merchantAroundBtn];
            return item;
            
        }
            break;
        case 1: {
            UIButton *publicServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            publicServiceBtn.frame = item.bounds;
            publicServiceBtn.userInteractionEnabled = NO;
            publicServiceBtn.tag = BTN_START_TAG + index;
            publicServiceBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
            [publicServiceBtn setTitle:@"便民服务" forState:UIControlStateNormal];
            [publicServiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [publicServiceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [publicServiceBtn addTarget:self action:@selector(serveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
            publicServiceBtn.selected = NO;
            [item addSubview:publicServiceBtn];
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
            aroundMerchantsTV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            aroundMerchantsTV.tableFooterView = [AppUtils tableViewsFooterView];
            [aroundMerchantsTV registerNib:[UINib nibWithNibName:@"LifeCircleStoresCell" bundle:nil] forCellReuseIdentifier:@"LifeCircleStoresCellID"];
            aroundMerchantsTV.delegate = self;
            aroundMerchantsTV.dataSource = self;
            __block __typeof(self)weakSelf = self;
            
            NSLog(@"blockLifeM.ID==%@",lifeM.ID);
            [aroundMerchantsTV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [aroundMerchantsTV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            [self viewDidLayoutSubviewsForTableView:aroundMerchantsTV];
            [tabV addSubview:aroundMerchantsTV];
        }
            break;
        case 1: {
            publicServiceTV = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            publicServiceTV.tableFooterView = [AppUtils tableViewsFooterView];
            [publicServiceTV registerNib:[UINib nibWithNibName:@"LifeCircleStoresCell" bundle:nil] forCellReuseIdentifier:@"LifeCircleStoresCellID"];
            publicServiceTV.delegate = self;
            publicServiceTV.dataSource = self;
            __block __typeof(self)weakSelf = self;
            [publicServiceTV addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [publicServiceTV addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            [self viewDidLayoutSubviewsForTableView:publicServiceTV];
            [tabV addSubview:publicServiceTV];
        }
            break;
        default:
            break;
    }

    return tabV;
}
@end
