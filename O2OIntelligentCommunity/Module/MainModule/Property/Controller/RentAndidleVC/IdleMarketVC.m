//
//  IdleMarketVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#define BTN_START_TAG 10
#define CELL_HEIGHT 115

#import "IdleMarketVC.h"
#import "TopTabControl.h"
#import "ZJWebProgrssView.h"
#import "RentOrIdleH.h"
#import "UserManager.h"
#import "RentCell.h"
#import "RentDetail.h"
#import "SearchMultiTypeVC.h"
#import "TiaoZaoSearchHandel.h"
#import "NSDictionary+wrapper.h"
#import "UpLoadNewRentInfor.h"

@interface IdleMarketVC () <UITableViewDataSource,
                            UITableViewDelegate,
                            TopTabControlDataSource,
                            FreshTableView>

@end

@implementation IdleMarketVC
{
    UITableView *idleSellTB;
    UITableView *idleBuyTB;
    
    TopTabControl *myTabCon;
    IdleMarketType idleType;
    
    ZJWebProgrssView *progressV;
    NSArray *_itemArr;
    RentOrIdleH *rentOrIdleH;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self hidetabbar];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
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
}

- (void)initData {
    rentOrIdleH = [RentOrIdleH new];
    _itemArr = @[@"出售",@"求购"];
    idleType = IdleMarketTypeSell;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTheRefreshParameter) name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initUI {
    
    
    #ifdef SmartComJYZX
    self.title = @"跳蚤市场";
    #elif SmartComYGS
    self.title = @"闲置交易";
    #else
        
    #endif
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fangdajing"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick)];

    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fabu"] style:UIBarButtonItemStylePlain target:self action:@selector(postSubmmitMessageVC)];
    
     UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
                                
    self.navigationItem.rightBarButtonItems = @[rightBar,search];
    
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
        [weakSelf getDataFromServerIsHeader:YES];
    };
    [myTabCon addSubview:progressV];
}

- (void)postSubmmitMessageVC{
    UpLoadNewRentInfor * newInfor = [UpLoadNewRentInfor new];
    newInfor.freshdele = self;
    newInfor.vcType = VCTypeIdle;
    newInfor.idleType = idleType;
    [self.navigationController pushViewController:newInfor animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)resetTheRefreshParameter {
    rentOrIdleH.isIdleSellNeedUpdate = YES;
    rentOrIdleH.isIdleBuyNeedUpdate = YES;
}

- (void)serveiceChangeClick:(UIButton *)sender {
    for (int i = BTN_START_TAG; i < BTN_START_TAG + _itemArr.count; i++) {
        UIButton *btn = (UIButton *)[myTabCon viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.selected = NO;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    
    idleType = sender.tag - BTN_START_TAG;
    [self resetTheRefreshParameter];
    [self refreshData];
}

- (void)refreshData {
    if (idleType == IdleMarketTypeSell &&
        !idleSellTB.header.isRefreshing) {
        if (rentOrIdleH.isIdleSellNeedUpdate || [NSArray isArrEmptyOrNull:rentOrIdleH.idleSellArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
    else if (idleType == IdleMarketTypeWantedBuy &&
             !idleBuyTB.header.isRefreshing) {
        if (rentOrIdleH.isIdleBuyNeedUpdate || [NSArray isArrEmptyOrNull:rentOrIdleH.idleBuyArr]) {
            [progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
}

- (void)getDataFromServerIsHeader:(BOOL)isHeader {
    RentOrIdleM * model = [RentOrIdleM new];
    model.pageSize = @"10";
    model.type = @"6";
    model.status = @"3";
    model.orderBy = @"dateCreated";
    model.orderType = @"desc";
    
    #ifdef SmartComJYZX
    
    model.wyNo = [UserManager shareManager].comModel.wyId;
    model.version = @"";
    
    #elif SmartComYGS
    
    model.wyNo = @"";
    model.version = @"YGS";
    
    #else
    #endif
    
    
    if (idleType == IdleMarketTypeSell) {
        model.pageNumber = rentOrIdleH.idleSellPNumber;
        model.fleaMarketType =  @"1";
        
        [rentOrIdleH excuteRequestIdelForSell:model success:^(id obj) {
            rentOrIdleH.isIdleSellNeedUpdate = NO;
            [idleSellTB reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:idleSellTB];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.idleSellArr]];
        } failed:^(id obj) {
            rentOrIdleH.isIdleSellNeedUpdate = YES;
            [AppUtils tableViewEndMJRefreshWithTableV:idleSellTB];
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.idleSellArr]];
        } isHeader:isHeader];
    }
    else {
        model.pageNumber = rentOrIdleH.idleBuyPNumber;
        model.fleaMarketType =  @"2";
        
        [rentOrIdleH excuteRequestIdelForWantedBuy:model success:^(id obj) {
            rentOrIdleH.isIdleBuyNeedUpdate = NO;
            [idleBuyTB reloadData];
            [AppUtils tableViewEndMJRefreshWithTableV:idleBuyTB];
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.idleBuyArr]];
        } failed:^(id obj) {
            rentOrIdleH.isIdleBuyNeedUpdate = YES;
            [AppUtils tableViewEndMJRefreshWithTableV:idleBuyTB];
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.idleBuyArr]];
        } isHeader:isHeader];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//搜索信息
- (void)searchClick{
    SearchMultiTypeVC * search = [[SearchMultiTypeVC alloc] init];
    
    NSString *keyForSell = @"atiaozaochushou";
    NSString *keyForWantedBuy = @"btiaozaiqiugou";
    
    search.typeDic = @{keyForSell:@"出售",
                       keyForWantedBuy:@"求购"};
    
    if (idleType == IdleMarketTypeSell) {
        search.selectedDic = @{keyForSell:@"出售"};
    }
    else {
        search.selectedDic = @{keyForWantedBuy:@"求购"};
    }

    __block __typeof(search)weakSearchVC = search;
    
    //设置UI刷新
    [search searchForCustomCellWithCellClassName:[RentCell class]
                                          cellID:@"rentCell"
                                      cellHeight:0
                                           isNib:YES
                        tableViewCellConfigufate:^(id cell, SearchCellEntity *entity,NSString *typeKey) {
                            
                            if ([NSString isEmptyOrNull:typeKey]) {
                                return;
                            }
                            
                            //在此处往Cell里面传数据进去设置UI界面
                            RentCell * myrent = cell;
                            [myrent setCellInformation:entity.dataSource];
                        }];
    
    
    //接口搜索
    search.webBlock =  ^(NSString *searchString,NSString *typeKey) {
        TiaoZaoSearch * model = [TiaoZaoSearch new];
        TiaoZaoSearchHandel * handel = [TiaoZaoSearchHandel new];
        model.pageNumber = @"1";
        model.pageSize = @"100";
        model.status = @"3";
        model.type = @"6";
        model.orderType = @"desc";
        model.orderBy = @"dateCreated";
        model.title = searchString;
        
        #ifdef SmartComJYZX
        model.version = @"";
        #elif SmartComYGS
        model.version = @"YGS";

        #else
                
        #endif
        
        if ([typeKey isEqualToString:keyForSell]) {//跳蚤出售
            model.fleaMarketType = @"1";
        }
        
        if ([typeKey isEqualToString:keyForWantedBuy]) {//跳蚤求购
            model.fleaMarketType = @"2";
        }
        
        NSMutableArray *searchArr = [NSMutableArray array];
        [handel TiaoZaoSearch:model success:^(id obj) {
            NSLog(@"查询结果>>>>%@",obj);
            if ([NSArray isArrEmptyOrNull:[obj[@"list"] copy]]) {
                [AppUtils showErrorMessage:W_ALL_NO_DATA_SEARCH];
                [weakSearchVC reloadWebSearchData:searchArr];
                return;
            }
            
            for (NSDictionary * dict in obj[@"list"]) {
                SearchCellEntity *searchE = [SearchCellEntity new];
                searchE.dataSource = dict;
                [searchArr addObject:searchE];
            }
            
            [AppUtils dismissHUD];
            [weakSearchVC reloadWebSearchData:searchArr];
            
        } failed:^(id obj) {
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
            [weakSearchVC reloadWebSearchData:searchArr];
        }];
    };
    
    search.clickBlock = ^(SearchCellEntity *searchE,NSString *typeKey) {
        RentDetail * detail = [RentDetail new];
        detail.dataSocure = searchE.dataSource;
        detail.vcType = VCTypeIdle;
        [self.navigationController pushViewController:detail animated:YES];
    };
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat totalFloat = 0;
    if (tableView == idleSellTB) {//卖dataSocure
        if ([NSDictionary isDicEmptyOrNull:rentOrIdleH.idleSellArr[indexPath.section]] ) {
            return 0;
        }

        NSArray * imageArray = rentOrIdleH.idleSellArr[indexPath.section][@"imgPath"];
        
        CGFloat imageHeight = 0;
        if (imageArray.count > 0) {
            imageHeight = 70;
        }

        NSString *showText = [NSString stringWithFormat:@"%@",rentOrIdleH.idleSellArr[indexPath.section][@"activityContent"]];;
        CGSize constraint = CGSizeMake(IPHONE_WIDTH - 79,MAXFLOAT);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:showText
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGFloat heightC = 0;
        if (rect.size.height > 80) {
            heightC = 80;
        }else{
            heightC = rect.size.height;
        }
        totalFloat = MAX(heightC + imageHeight + 45, CELL_HEIGHT);
        return totalFloat;
        
    }else {
        if ([NSDictionary isDicEmptyOrNull:rentOrIdleH.idleBuyArr[indexPath.section]] ) {
            return 0;
        }
        
        NSArray * imageArray = rentOrIdleH.idleBuyArr[indexPath.section][@"imgPath"];
        
        CGFloat imageHeight = 0;
        
        if (imageArray.count > 0) {
            imageHeight = 70;
        }
        
        NSString *showText = [NSString stringWithFormat:@"%@",rentOrIdleH.idleBuyArr[indexPath.section][@"activityContent"]];;
        CGSize constraint = CGSizeMake(IPHONE_WIDTH - 79,MAXFLOAT);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:showText
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGFloat heightC = 0;
        if (rect.size.height > 80) {
            heightC = 80;
        }else{
            heightC = rect.size.height;
        }
        totalFloat = MAX(heightC + imageHeight + 45, CELL_HEIGHT);
        return totalFloat;
    }
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == idleSellTB) {
        [AppUtils tableViewFooterPromptWithPNumber:rentOrIdleH.idleSellPNumber.integerValue
                                        withPCount:rentOrIdleH.idleSellPCount.integerValue
                                         forTableV:idleSellTB];
        return rentOrIdleH.idleSellArr.count;
    }
    else {
        [AppUtils tableViewFooterPromptWithPNumber:rentOrIdleH.idleBuyPNumber.integerValue
                                        withPCount:rentOrIdleH.idleBuyPCount.integerValue
                                         forTableV:idleBuyTB];
        return rentOrIdleH.idleBuyArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RentCell * rentCell = [tableView dequeueReusableCellWithIdentifier:@"rentCell"];
    if (rentCell == nil) {
        rentCell = [[[NSBundle mainBundle] loadNibNamed:@"RentCell" owner:self options:nil] lastObject];
    }

    return rentCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RentCell * rentCell = (RentCell *)cell;
    if (tableView == idleSellTB) {
        [rentCell setCellInformation:rentOrIdleH.idleSellArr[indexPath.section]];
    }
    else {
        [rentCell setCellInformation:rentOrIdleH.idleBuyArr[indexPath.section]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RentDetail * detail = [[RentDetail alloc] initWithNibName:@"RentDetail" bundle:nil];
    detail.vcType = VCTypeIdle;
    
    
    if (tableView == idleSellTB) {
        detail.dataSocure = rentOrIdleH.idleSellArr[indexPath.section];
    }
    else {
        detail.dataSocure = rentOrIdleH.idleBuyArr[indexPath.section];
    }
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - TopTabControlDataSource
- (CGFloat)TopTabHeight:(TopTabControl *)tabCtrl {
    return TAB_ITEM_HEIGHT;
}

- (CGFloat)TopTabWidth:(TopTabControl *)tabCtrl {
    return tabCtrl.frame.size.width / _itemArr.count;
}

- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl {
    return _itemArr.count;
}

- (TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl
                      itemAtIndex:(NSUInteger)index {
    TopTabMenuItem *item = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width / 2, TAB_ITEM_HEIGHT)];
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.frame = item.bounds;
    itemBtn.userInteractionEnabled = NO;
    itemBtn.tag = BTN_START_TAG + index;
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:G_TAB_ITEM_FONT];
    [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [itemBtn addTarget:self action:@selector(serveiceChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [itemBtn setTitle:_itemArr[index] forState:UIControlStateNormal];
    if (index == 0) {
        itemBtn.selected = YES;
    }

    [item addSubview:itemBtn];
    return item;
}

- (TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl
                  pageAtIndex:(NSUInteger)index {
    TopTabPage *tabV = [[TopTabPage alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width,tabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
    switch (index) {
        case 0: {
            idleSellTB = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            idleSellTB.tableFooterView = [AppUtils tableViewsFooterView];
            [idleSellTB registerNib:[UINib nibWithNibName:@"RentCell" bundle:nil] forCellReuseIdentifier:@"rentCell"];
            idleSellTB.delegate = self;
            idleSellTB.dataSource = self;
            __block __typeof(self)weakSelf = self;
            [idleSellTB addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [idleSellTB addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            [self viewDidLayoutSubviewsForTableView:idleSellTB];
            [tabV addSubview:idleSellTB];
        }
            break;
        case 1: {
            idleBuyTB = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            idleBuyTB.tableFooterView = [AppUtils tableViewsFooterView];
            [idleBuyTB registerNib:[UINib nibWithNibName:@"RentCell" bundle:nil] forCellReuseIdentifier:@"rentCell"];
            idleBuyTB.delegate = self;
            idleBuyTB.dataSource = self;
            __block __typeof(self)weakSelf = self;
            [idleBuyTB addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [idleBuyTB addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            [self viewDidLayoutSubviewsForTableView:idleBuyTB];
            [tabV addSubview:idleBuyTB];
        }
            break;
        default:
            break;
    }
    
    return tabV;
}

#pragma mark - FreshTableView
- (void)freshWitchTable:(NSInteger)index {
    NSLog(@"返回过来的index>>>>>%d",index);

    if (index == 0) {
        rentOrIdleH.isIdleSellNeedUpdate = YES;
    }else {
        rentOrIdleH.isIdleBuyNeedUpdate = YES;
    }
}
@end
