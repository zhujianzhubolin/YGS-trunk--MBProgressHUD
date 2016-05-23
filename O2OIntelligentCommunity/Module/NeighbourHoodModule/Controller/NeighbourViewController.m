//
//  NeighbourViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NeighbourViewController.h"
#import "SDCycleScrollView.h"
#import "NeightbourHoodCell.h"
#import "TopicViewController.h"
#import "TopicDetailsViewController.h"
#import "PostedViewController.h"
#import "MyCommentViewController.h"
//#import "ZYTextField.h"
#import <MJRefresh.h>
#import "UserManager.h"
#import "SearchVC.h"
#import "ZJWebProgrssView.h"


//获取话题列表接口类
#import "HuaTiListHandler.h"
#import "HuaTiListModel.h"
#import "ZJLongPressGesture.h"
#import "ReportVC.h"

@interface NeighbourViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    SDCycleScrollView *adScrollView;
    NSArray *segcontrollerArray;
    
    NSInteger type;
    NSArray *bntImageArray;
    //ZYTextField *SearchField;
    UISearchBar *searchBar;
    UITableView *TableView;
    NSUInteger selectedRow;
    
    ZJWebProgrssView *progressV;
    HuaTiListHandler *huatiListH;
}

@end

@implementation NeighbourViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ReportBtn btnInstance] removeReportBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self initData];
    [self initUI];
    [progressV startAnimation];
}

- (void)isCommunityChangee {
    huatiListH.isHuaTiNeedUpdate = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_NOTI_COMMUNITY_CHANGE object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
    
    if (!TableView.header.isRefreshing &&
        ([NSArray isArrEmptyOrNull:huatiListH.htArray] ||
         huatiListH.isHuaTiNeedUpdate)){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [progressV startAnimation];
                [self startNetworkGetShopsIsHeader:YES];
            });
    }
}

-(void)initData
{
    huatiListH.isHuaTiNeedUpdate = YES;
    NSLog(@"%f--%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    segcontrollerArray = [[NSArray alloc]initWithObjects:@"我的话题",@"我的评论",@"我要发帖", nil];
    bntImageArray =[[NSArray alloc]initWithObjects:@"HuaTi",@"PingLun",@"FaTie", nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isCommunityChangee) name:k_NOTI_COMMUNITY_CHANGE object:nil];
    huatiListH =[HuaTiListHandler new];
}

-(void)initUI
{
    self.navigationItem.title = @"邻里";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStyleBordered target:self action:@selector(SearchArr)];
    self.navigationController.navigationBar.translucent=YES;
    CGFloat headViweHeigth = 130;
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, headViweHeigth)];
    headView.backgroundColor=[AppUtils colorWithHexString:@"ECECEC"];
    
    adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headViweHeigth)
                                                      delegate:self
                                              placeholderImage:[UIImage imageNamed:@"ScrollView.jpg"]];
    adScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    adScrollView.currentPageDotColor = [UIColor whiteColor];
    adScrollView.autoScroll=NO;
    adScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [headView addSubview:adScrollView];
    

    TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    TableView.dataSource =self;
    TableView.delegate =self;
    TableView.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    TableView.tableHeaderView=headView;
    TableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:TableView];
    TableView.tableFooterView = [AppUtils tableViewsFooterView];
    [self viewDidLayoutSubviewsForTableView:TableView];
    
     __block __typeof(self)weakSelf = self;
    [TableView addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakSelf startNetworkGetShopsIsHeader:YES];
    }];

    [TableView addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakSelf startNetworkGetShopsIsHeader:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(TableView.frame.origin.x,
                                                                   headView.frame.size.height+40,
                                                                   TableView.frame.size.width,
                                                                   self.view.frame.size.height - headView.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.tabBarController.tabBar.frame.size.height-40)];
    [TableView addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf startNetworkGetShopsIsHeader:YES];
    };
}

- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
        HuaTiListModel *hutiM =[HuaTiListModel new];
    
        hutiM.pageNumber =huatiListH.currentPage;
        hutiM.pageSize=@"10";
        hutiM.orderBy = @"dateCreated";
        hutiM.orderType = @"desc";
    
#ifdef SmartComJYZX
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"type",
                                 @"3",@"status",
                                 [UserManager shareManager].comModel.wyId,@"wyNo",
                                 nil];

#elif SmartComYGS
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"type",
                                 @"3",@"status",
                                 APP_version,@"version",
                                 nil];

#else
    
#endif

                hutiM.queryMap = queryMapDic;
        
        [huatiListH PostHuatiList:hutiM success:^(id obj) {
            huatiListH.isHuaTiNeedUpdate = NO;
            [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:huatiListH.htArray]];
            
            [AppUtils tableViewEndMJRefreshWithTableV:TableView];
            [TableView reloadData];
        } failed:^(id obj) {
            huatiListH.isHuaTiNeedUpdate = YES;
            [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:huatiListH.htArray]];
            
            [AppUtils tableViewEndMJRefreshWithTableV:TableView];
        } isHeader:isHeader];
    
}

-(void)SearchArr {
    NSLog(@"搜索");
    
    SearchVC *searchVC = [SearchVC new];
    __block __typeof(searchVC)weakSearchVC = searchVC;
    
    //设置UI刷新
    [searchVC searchForCustomCellWithCellClassName:[NeightbourHoodCell class]
                                            cellID:SYSTEM_CELL_ID
                                        cellHeight:0
                                             isNib:NO
                          tableViewCellConfigufate:^(id cell, SearchCellEntity *entity) {
                              NeightbourHoodCell *huatiCell = cell;
                              [huatiCell sethuatidic:entity.dataSource isShowAll:NO];
                          }];
    //跳转
    searchVC.clickBlock = ^(SearchCellEntity *searchE) {
        HuaTiListModel *huatiM = searchE.dataSource;
        TopicDetailsViewController *topicDetails = [[TopicDetailsViewController alloc]init];
        topicDetails.huatiM =huatiM;
        [self.navigationController pushViewController:topicDetails animated:YES];
    };

    //网络搜索
    searchVC.webBlock =  ^(NSString *searchString) {
        [AppUtils showProgressMessage:@"正在努力搜索中"];
        HuaTiListHandler *hutiH =[HuaTiListHandler new];
        HuaTiListModel   *huatiM =[HuaTiListModel new];
        huatiM.pageNumber=@"1";
        huatiM.pageSize=@"100";
        NSLog(@"[UserManager shareManager].comModel.xqNo==%@",[UserManager shareManager].comModel.xqNo);
        huatiM.orderBy=@"dateCreated";
        huatiM.orderType=@"desc";
        
#ifdef SmartComJYZX
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",
                                     @"3",@"status",
                                     [UserManager shareManager].comModel.wyId,@"wyNo",
                                     searchString,@"title",
                                     nil];

#elif SmartComYGS
        NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",
                                     @"3",@"status",
                                     APP_version,@"version",
                                     searchString,@"title",
                                     nil];

#else
        
#endif

        huatiM.queryMap=queryMapDic;

        NSMutableArray *searchArr = [NSMutableArray array];
        [hutiH PostHuatiList:huatiM success:^(id obj) {
            NSMutableArray *recvArr = obj;
            if ([NSArray isArrEmptyOrNull:recvArr]) {
                [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
                [weakSearchVC reloadWebSearchData:searchArr];
                return;
            }

            [recvArr enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
                HuaTiListModel *hutiM = (HuaTiListModel *)obj1;
                SearchCellEntity *searchE = [SearchCellEntity new];
                searchE.dataSource = hutiM;
                [searchArr addObject:searchE];
            }];
            [AppUtils dismissHUD];
            [weakSearchVC reloadWebSearchData:searchArr];

        } failed:^(id obj) {
            if (self.viewIsVisible)
            {
                [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
            }
            else
            {
                [AppUtils dismissHUD];
            }
        } isHeader:YES];
    };
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:searchVC animated:YES];
}

////隐藏多余的分割线
//- (void)setExtraCellLineHidden: (UITableView *)tableView{
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//}

#pragma mark -  搜索按钮响应事件
-(void)SearButtonArr
{
    NSLog(@"搜素");
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 自定义UISegmentedcontrol事件
-(void)selectArr:(UIButton *)but
{
    [[ReportBtn btnInstance] removeReportBtn];
    type = but.tag-100;
    for(int i = 0; i < 4;i++)
    {
        UIButton *b = (UIButton *)[self.view viewWithTag:100 + i];
        if(but.tag == b.tag)
        {
            b.selected = YES;
            //b.backgroundColor=[UIColor grayColor];
        }
        else
        {
            b.selected = NO;
            //b.backgroundColor=[UIColor whiteColor];
        }
    }
    
    if (type == 0)
    {
        TopicViewController * topic = [[TopicViewController alloc]init];
        [self.navigationController pushViewController:topic animated:YES];
    }
    else if (type == 1)
    {
        MyCommentViewController *comment = [[MyCommentViewController alloc]init];
        [self.navigationController pushViewController:comment animated:YES];
    }
    else if (type ==2)
    {
        PostedViewController *postedVC = [[PostedViewController alloc]init];
        postedVC.postSucBlock = ^{
            huatiListH.isMyHtNeedUpdate=YES;
            huatiListH.isHuaTiNeedUpdate=YES;
        };
        [self.navigationController pushViewController:postedVC animated:YES];
    }
}



#pragma mark - 滚动视图部分
- (NSInteger)numberOfPages {
    return 1;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:adScrollView.bounds];
    imgView.image = [UIImage imageNamed:@"ScrollView"];
    return imgView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [AppUtils tableViewFooterPromptWithPNumber:huatiListH.currentPage.integerValue
                                    withPCount:huatiListH.pageCount.integerValue
                                     forTableV:TableView];

    return huatiListH.htArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
    headV.backgroundColor=[AppUtils colorWithHexString:@"ECECEC"];
    
    UIImageView *backgroudImg =[[UIImageView alloc]initWithFrame:CGRectMake(20,10 , IPHONE_WIDTH-40, 20)];
    backgroudImg.backgroundColor=[UIColor grayColor];
    [headV addSubview:backgroudImg];
    for (int i = 0; i< segcontrollerArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(i*self.view.frame.size.width/3+1, 0, self.view.frame.size.width/3-1, 40);
        button.tag=100+i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.backgroundColor=[AppUtils colorWithHexString:@"ECECEC"];
        
        [button setTitle:[NSString stringWithFormat:@"%@",[segcontrollerArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[bntImageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [headV addSubview:button];
        [button addTarget:self action:@selector(selectArr:) forControlEvents:UIControlEventTouchUpInside];
    }
    return headV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NeightbourHoodCell cellHigth:huatiListH.htArray[indexPath.row]
                               isShowAll:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NeightbourHoodCellID";
    NeightbourHoodCell *neightourCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    neightourCell.cellType=@"neightour";
    if (neightourCell == nil) {
        neightourCell = [[NeightbourHoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return neightourCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NeightbourHoodCell *neightourCell = (NeightbourHoodCell *)cell;
    if (indexPath.row == selectedRow) {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *subVC = obj;
            if ([subVC isKindOfClass:[TopicDetailsViewController class]]) {
                TopicDetailsViewController *topicDetails = obj;
                topicDetails.huatiM = huatiListH.htArray[selectedRow];
                *stop = YES;
            }
        }];
    }
    
    if (indexPath.row < huatiListH.htArray.count) {
        [neightourCell sethuatidic:huatiListH.htArray[indexPath.row] isShowAll:NO];
    }
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:neightourCell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:indexPath.row];
    };
    [neightourCell.contentView addGestureRecognizer:pressGesture];
}

- (void)pushToReportVC:(NSUInteger)dataIndex {
    HuaTiListModel *entity = huatiListH.htArray[dataIndex];
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:entity.ID.intValue];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}


-(void)selectorBut:(UIButton *)button
{
    NSLog(@"%ld",button.tag);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [[ReportBtn btnInstance] removeReportBtn];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    selectedRow = indexPath.row;
    TopicDetailsViewController *topicDetails = [[TopicDetailsViewController alloc]init];
    NSLog(@"indx.row = %ld   huatiListH.htArray.count =%ld",indexPath.row,huatiListH.htArray.count);
    topicDetails.commentChangeBlock= ^() {
        //huatiListH.isHuaTiNeedUpdate=YES;
        [self startNetworkGetShopsIsHeader:YES];
    };

    if (indexPath.row < huatiListH.htArray.count)
    {
        topicDetails.huatiM =huatiListH.htArray[indexPath.row];
        [self.navigationController pushViewController:topicDetails animated:YES];
    }  
}



#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
