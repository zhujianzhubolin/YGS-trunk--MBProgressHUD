//
//  HouseRentingVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/12/8.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#define BTN_START_TAG 10
#define CELL_HEIGHT 125

#import "HouseRentingVC.h"
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

@interface HouseRentingVC () <UITableViewDataSource,
                              UITableViewDelegate,
                              TopTabControlDataSource,FreshTableView>

@end

@implementation HouseRentingVC
{
    NSArray *_itemArr;
    UITableView *_rentRentHouseTB;
    UITableView *_rentBuyHouseTB;
    UITableView *_rentWantedBuyTB;
    
    TopTabControl *_myTabCon;
    RentType _rentType;
    ZJWebProgrssView *_progressV;
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
    // Do any additional setup after loading the view.
}

- (void)initData {
    rentOrIdleH = [RentOrIdleH new];
    _itemArr = @[@"租房",@"买房",@"求租"];
    _rentType = RentTypeRentHouse;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTheRefreshParameter) name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)initUI {
    self.title = @"房屋租售";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fangdajing"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchClick)];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fabu"] style:UIBarButtonItemStylePlain target:self action:@selector(postSubmmitMessageVC)];
    
    UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    
    self.navigationItem.rightBarButtonItems = @[rightBar,search];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               50)];
    [self.view addSubview:headerV];
    
    _myTabCon = [[TopTabControl alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height)];
    
    __block __typeof(self)weakSelf = self;
    _myTabCon.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:10 + index];
        [weakSelf serveiceChangeClick:btn];
    };
    
    _myTabCon.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:10 + index];
        [weakSelf serveiceChangeClick:btn];
    };
    
    _myTabCon.datasource = self;
    _myTabCon.showIndicatorView = YES;
    [_myTabCon displayPageAtIndex:0];
    [self.view addSubview:_myTabCon];
    
    _progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT, _myTabCon.frame.size.width, _myTabCon.frame.size.height - TAB_ITEM_HEIGHT)];
    _progressV.loadBlock = ^{
        [weakSelf getDataFromServerIsHeader:YES];
    };
    [_myTabCon addSubview:_progressV];
    [_progressV startAnimation];
}

- (void)postSubmmitMessageVC{
    UpLoadNewRentInfor * newInfor = [UpLoadNewRentInfor new];
    newInfor.freshdele = self;
    newInfor.vcType = VCTypeRental;
    newInfor.rentType = _rentType;
    [self.navigationController pushViewController:newInfor animated:YES];
}

- (void)resetTheRefreshParameter {
    rentOrIdleH.isRentBuyHouseNeedUpdate = YES;
    rentOrIdleH.isRentRentHouseNeedUpdate = YES;
    rentOrIdleH.isRentWantedRentNeedUpdate = YES;
}

- (void)serveiceChangeClick:(UIButton *)sender {
    for (int i = BTN_START_TAG; i < BTN_START_TAG + _itemArr.count; i++) {
        UIButton *btn = (UIButton *)[_myTabCon viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.selected = NO;
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    
    _rentType = sender.tag - BTN_START_TAG;
    [self resetTheRefreshParameter];
    [self refreshData];
}

- (void)refreshData {
    if (_rentType == RentTypeRentHouse &&
        !_rentRentHouseTB.header.isRefreshing) {
        if (rentOrIdleH.isRentRentHouseNeedUpdate || [NSArray isArrEmptyOrNull:rentOrIdleH.rentRentHouseArr]) {
            [_progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
    else if (_rentType == RentTypeBuyHouse &&
             !_rentBuyHouseTB.header.isRefreshing) {
        if (rentOrIdleH.isRentBuyHouseNeedUpdate || [NSArray isArrEmptyOrNull:rentOrIdleH.rentBuyHouseArr]) {
            [_progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
    else if (_rentType == RentTypeWantedRent &&
             !_rentWantedBuyTB.header.isRefreshing) {
        if (rentOrIdleH.isRentWantedRentNeedUpdate || [NSArray isArrEmptyOrNull:rentOrIdleH.rentWantedRentArr]) {
            [_progressV startAnimation];
            [self getDataFromServerIsHeader:YES];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

- (void)getDataFromServerIsHeader:(BOOL)isHeader {
    RentOrIdleM * model = [RentOrIdleM new];
    model.pageSize = @"10";
    model.type = @"2";
    model.status = @"3";
    model.orderBy = @"dateCreated";
    model.orderType = @"desc";
    model.wyNo = [UserManager shareManager].comModel.wyId;
    
    switch (_rentType) {
        case RentTypeRentHouse: {
            model.pageNumber = rentOrIdleH.rentRentHousePNumber;
            model.transactionType =  @"1";
            
            [rentOrIdleH excuteRequestRentRentHouseForModel:model success:^(id obj) {
                rentOrIdleH.isRentRentHouseNeedUpdate = NO;
                [_rentRentHouseTB reloadData];
                [AppUtils tableViewEndMJRefreshWithTableV:_rentRentHouseTB];
                [_progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.rentRentHouseArr]];
            } failed:^(id obj) {
                rentOrIdleH.isRentRentHouseNeedUpdate = YES;
                [AppUtils tableViewEndMJRefreshWithTableV:_rentRentHouseTB];
                [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
                [_progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.rentRentHouseArr]];
            } isHeader:isHeader];
        }
            break;
        case RentTypeBuyHouse: {
            model.pageNumber = rentOrIdleH.rentBuyHousePNumber;
            model.transactionType =  @"2";
            
            [rentOrIdleH excuteRequestRentBuyHouseForModel:model success:^(id obj) {
                rentOrIdleH.isRentBuyHouseNeedUpdate = NO;
                [_rentBuyHouseTB reloadData];
                [AppUtils tableViewEndMJRefreshWithTableV:_rentBuyHouseTB];
                [_progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.rentBuyHouseArr]];
            } failed:^(id obj) {
                rentOrIdleH.isRentBuyHouseNeedUpdate = YES;
                [AppUtils tableViewEndMJRefreshWithTableV:_rentBuyHouseTB];
                [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
                [_progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.rentBuyHouseArr]];
            } isHeader:isHeader];
        }
            break;
        case RentTypeWantedRent: {
            model.pageNumber = rentOrIdleH.rentWantedRentPNumber;
            model.transactionType =  @"3";
            
            [rentOrIdleH excuteRequestRentWantedRentForModel:model success:^(id obj) {
                rentOrIdleH.isRentWantedRentNeedUpdate = NO;
                [_rentWantedBuyTB reloadData];
                [AppUtils tableViewEndMJRefreshWithTableV:_rentWantedBuyTB];
                [_progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.rentWantedRentArr]];
            } failed:^(id obj) {
                rentOrIdleH.isRentWantedRentNeedUpdate = YES;
                [AppUtils tableViewEndMJRefreshWithTableV:_rentWantedBuyTB];
                [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
                [_progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:rentOrIdleH.rentWantedRentArr]];
            } isHeader:isHeader];
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//搜索信息
- (void)searchClick{
    SearchMultiTypeVC * search = [[SearchMultiTypeVC alloc] init];

    NSString *keyForRentHouse = @"houseZufang";
    NSString *keyForBuyHouse = @"houseMaifang";
    NSString *keyForWantedRent = @"houseQiuzu";
    
    search.typeDic = @{keyForRentHouse:@"租房",
                       keyForBuyHouse:@"买房",
                       keyForWantedRent:@"求租"};
    
    if (_rentType == RentTypeRentHouse) {
        search.selectedDic = @{keyForRentHouse:@"租房"};
    }
    else if (_rentType == RentTypeBuyHouse){
        search.selectedDic = @{keyForBuyHouse:@"买房"};
    }
    else {
        search.selectedDic = @{keyForWantedRent:@"求租"};
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
        model.type = @"2";
        model.orderType = @"desc";
        model.orderType = @"desc";
        model.orderBy = @"dateCreated";
        model.title = searchString;

        if ([typeKey isEqualToString:keyForBuyHouse]) {//房屋出售
            model.transactionType = @"2";
        }
        
        if ([typeKey isEqualToString:keyForRentHouse]) {//房屋出租
            model.transactionType = @"1";
        }
        
        if ([typeKey isEqualToString:keyForWantedRent]) {//房屋求租
            model.transactionType = @"3";
        }
        
        NSMutableArray *searchArr = [NSMutableArray array];
        [handel HouseSearch:model success:^(id obj) {
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
        detail.vcType = VCTypeRental;
        [self.navigationController pushViewController:detail animated:YES];
    };
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    }
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 2)];
    headerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _rentRentHouseTB) {
        [AppUtils tableViewFooterPromptWithPNumber:rentOrIdleH.rentRentHousePNumber.integerValue
                                        withPCount:rentOrIdleH.rentRentHousePCount.integerValue
                                         forTableV:_rentRentHouseTB];
        return rentOrIdleH.rentRentHouseArr.count;
    }else if (tableView == _rentBuyHouseTB){
        [AppUtils tableViewFooterPromptWithPNumber:rentOrIdleH.rentBuyHousePNumber.integerValue
                                        withPCount:rentOrIdleH.rentBuyHousePCount.integerValue
                                         forTableV:_rentBuyHouseTB];
        return rentOrIdleH.rentBuyHouseArr.count;
    }else {
        [AppUtils tableViewFooterPromptWithPNumber:rentOrIdleH.rentWantedRentPNumber.integerValue
                                        withPCount:rentOrIdleH.rentWantedRentPCount.integerValue
                                         forTableV:_rentWantedBuyTB];
        return rentOrIdleH.rentWantedRentArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _rentBuyHouseTB) {//卖dataSocure
        CGFloat totalFloat = 0;
        NSArray * imageArray = @[];
        imageArray = rentOrIdleH.rentBuyHouseArr[indexPath.section][@"imgPath"];
        CGFloat imageHeight = 0;
        if (imageArray.count > 0) {
            imageHeight = 70;
        }
        //标题高度。。。。。。26
        //动态计算lable的高度
        NSString *showText = [NSString stringWithFormat:@"%@",rentOrIdleH.rentBuyHouseArr[indexPath.section][@"activityContent"]];;
        CGSize constraint = CGSizeMake(IPHONE_WIDTH - 79, MAXFLOAT);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:showText
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
//        CGSize size = rect.size;
        
        CGFloat heightC = 0;
        if (rect.size.height > 80) {
            heightC = 80;
        }else{
            heightC = rect.size.height;
        }
        totalFloat = MAX(heightC + imageHeight + 45, 115);
        return totalFloat;
    }else if (tableView == _rentRentHouseTB) {//买dataSocure2
        CGFloat totalFloat = 0;
        NSArray * imageArray = rentOrIdleH.rentRentHouseArr[indexPath.section][@"imgPath"];
        CGFloat imageHeight = 0;
        if (imageArray.count > 0) {
            imageHeight = 70;
        }
        //标题高度。。。。。。26
        //动态计算lable的高度
        NSString * showText = [NSString stringWithFormat:@"%@",rentOrIdleH.rentRentHouseArr[indexPath.section][@"activityContent"]];
        CGSize constraint = CGSizeMake(IPHONE_WIDTH - 79, MAXFLOAT);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:showText
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
//        CGSize size = rect.size;
        
        CGFloat heightC = 0;
        if (rect.size.height > 80) {
            heightC = 80;
        }else{
            heightC = rect.size.height;
        }
        totalFloat = MAX(heightC + imageHeight + 45, 115);
        return totalFloat;
    }else{//求租dataSocure2
        CGFloat totalFloat = 0;
        NSArray * imageArray = rentOrIdleH.rentWantedRentArr[indexPath.section][@"imgPath"];
        CGFloat imageHeight = 0;
        if (imageArray.count > 0) {
            imageHeight = 70;
        }
        //标题高度。。。。。。26
        //动态计算lable的高度
        NSString * showText = [NSString stringWithFormat:@"%@",rentOrIdleH.rentWantedRentArr[indexPath.section][@"activityContent"]];
        
        CGSize constraint = CGSizeMake(IPHONE_WIDTH -79, MAXFLOAT);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:showText
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
//        CGSize size = rect.size;
        CGFloat heightC = 0;
        if (rect.size.height > 80) {
            heightC = 80;
        }else{
            heightC = rect.size.height;
        }
        
        totalFloat = MAX(heightC + imageHeight + 45, 115);
        return totalFloat;
    }
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
    if (tableView == _rentRentHouseTB) {
        [rentCell setCellInformation:rentOrIdleH.rentRentHouseArr[indexPath.section]];
    }
    else  if (tableView == _rentBuyHouseTB){
        [rentCell setCellInformation:rentOrIdleH.rentBuyHouseArr[indexPath.section]];
    }
    else {
        [rentCell setCellInformation:rentOrIdleH.rentWantedRentArr[indexPath.section]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RentDetail * detail = [[RentDetail alloc] initWithNibName:@"RentDetail" bundle:nil];
    detail.vcType = VCTypeRental;
    
    if (tableView == _rentRentHouseTB) {
        detail.dataSocure = rentOrIdleH.rentRentHouseArr[indexPath.section];
    }
    else  if (tableView == _rentBuyHouseTB){
        detail.dataSocure = rentOrIdleH.rentBuyHouseArr[indexPath.section];
    }
    else {
        detail.dataSocure = rentOrIdleH.rentWantedRentArr[indexPath.section];
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
            _rentRentHouseTB = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            _rentRentHouseTB.tableFooterView = [AppUtils tableViewsFooterView];
            [_rentRentHouseTB registerNib:[UINib nibWithNibName:@"RentCell" bundle:nil] forCellReuseIdentifier:@"rentCell"];
            _rentRentHouseTB.delegate = self;
            _rentRentHouseTB.dataSource = self;
            __block __typeof(self)weakSelf = self;
            [_rentRentHouseTB addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [_rentRentHouseTB addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            [self viewDidLayoutSubviewsForTableView:_rentRentHouseTB];
            [tabV addSubview:_rentRentHouseTB];
        }
            break;
        case 1: {
            _rentBuyHouseTB = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            _rentBuyHouseTB.tableFooterView = [AppUtils tableViewsFooterView];
            [_rentBuyHouseTB registerNib:[UINib nibWithNibName:@"RentCell" bundle:nil] forCellReuseIdentifier:@"rentCell"];
            _rentBuyHouseTB.delegate = self;
            _rentBuyHouseTB.dataSource = self;
            __block __typeof(self)weakSelf = self;
            [_rentBuyHouseTB addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [_rentBuyHouseTB addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            [self viewDidLayoutSubviewsForTableView:_rentBuyHouseTB];
            [tabV addSubview:_rentBuyHouseTB];
        }
            break;
        case 2: {
            _rentWantedBuyTB = [[UITableView alloc] initWithFrame:tabV.bounds style:UITableViewStylePlain];
            _rentWantedBuyTB.tableFooterView = [AppUtils tableViewsFooterView];
            [_rentWantedBuyTB registerNib:[UINib nibWithNibName:@"RentCell" bundle:nil] forCellReuseIdentifier:@"rentCell"];
            _rentWantedBuyTB.delegate = self;
            _rentWantedBuyTB.dataSource = self;
            __block __typeof(self)weakSelf = self;
            [_rentWantedBuyTB addLegendHeaderWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:YES];
            }];
            
            [_rentWantedBuyTB addLegendFooterWithRefreshingBlock:^{
                [weakSelf getDataFromServerIsHeader:NO];
            }];
            
            [self viewDidLayoutSubviewsForTableView:_rentWantedBuyTB];
            [tabV addSubview:_rentWantedBuyTB];
        }
            break;
        default:
            break;
    }
    
    return tabV;
}

#pragma mark - FreshTableView
- (void)freshWitchTable:(NSInteger)index {
    
    if (index == 0) {
        rentOrIdleH.isRentRentHouseNeedUpdate = YES;
    }else if (index == 1){
        rentOrIdleH.isRentBuyHouseNeedUpdate = YES;
    }
    else {
        rentOrIdleH.isRentWantedRentNeedUpdate = YES;
    }
}

@end
