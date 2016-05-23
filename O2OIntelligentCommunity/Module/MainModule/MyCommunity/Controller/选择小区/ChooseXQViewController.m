//
//  ChooseXQViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ChooseXQViewController.h"
//#import "ZYTextField.h"
#import "ChooseXQCell.h"
#import "AppUtils.h"
#import "CommunityViewCotroller.h"
#import "SVProgressHUD.h"

//接口类
#import "addXQHandler.h"
#import "AddXQModel.h"

#import "getXQListModel.h"
#import "getXQListHandler.h"

//切换小区接口类

#import "SwitchXQHandler.h"
#import "AppDelegate.h"
#import "O2OLoginViewController.h"
#import "UserEntity.h"
#import "UserHandler.h"

@implementation ChooseXQViewController
 {
    UISearchBar *SearchField;
    
     NSMutableArray *searchVisibleArr;
     UIView *myTBSuperView; //没有所搜到结果的显示图
}

- (id)init {
    self = [super init];
    if (self) {
        self.myXQArr = [NSArray array];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allXQArray =[NSArray array];
    searchVisibleArr = [NSMutableArray array];
    [self initUI];
    
    if ([NSArray isArrEmptyOrNull:self.allXQArray]) {
        [self getXQList];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self hidetabbar];
    UIButton *searchBtn = (UIButton *)[self.view viewWithTag:10];
    [searchBtn setTitle:@"点击搜索" forState:UIControlStateNormal];
    SearchField.showsCancelButton = YES;
}

//获取所有小区列表
-(void)getXQList
{
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    getXQListModel *xqM =[getXQListModel new];
    getXQListHandler *xqH =[getXQListHandler new];
    xqM.pageNumber  =@"1";
    xqM.pageSize    =@"1000";
    xqM.orderBy     =@"dateCreated";
    xqM.orderType   =@"desc";
    
#ifdef SmartComJYZX
    xqM.comapyanyId = P_WYID;
#elif SmartComYGS
    xqM.isCustomized = P_IS_CUSTOMIZED;
#else
    
#endif
    
    [xqH postXQList:xqM success:^(id obj) {
        NSArray *recvArr = obj;

        //过滤已经添加的小区
        NSMutableArray *xqArr = [NSMutableArray array];
        [recvArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BingingXQModel *recvM = obj;
            __block BOOL isExist = NO;
            [self.myXQArr enumerateObjectsUsingBlock:^(id  _Nonnull myXQObj, NSUInteger myXQIdx, BOOL * _Nonnull myXQStop) {
                BingingXQModel *bindM = myXQObj;
//                NSLog(@"recvM.xqNo.integerValue = %d,recvMname= %@,bindM.xqNo.integerValue = %d,bindMname= %@",recvM.xqNo.integerValue,recvM.xqName,bindM.xqNo.integerValue,bindM.xqName);
                if (recvM.xqNo.integerValue == bindM.xqNo.integerValue ) {
                    isExist = YES;
                }
            }];
            
            if (!isExist) {
                [xqArr addObject:recvM];
            }
        }];
        
        self.allXQArray = [xqArr copy];
        searchVisibleArr = [self.allXQArray mutableCopy];
        
        if ([NSArray isArrEmptyOrNull:self.allXQArray]) {
            [AppUtils showAlertMessageTimerClose:@"未获取到小区列表"];
            return;
        }
        
        [_TableView reloadData];
        [AppUtils dismissHUD];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
    }];
}

-(void)initUI
{
    SearchField = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width *2 /3, self.navigationController.navigationBar.frame.size.height)];
    [SearchField.layer setMasksToBounds:YES];
    [SearchField.layer setCornerRadius:5];
    SearchField.placeholder=@"输入小区名称";
    SearchField.delegate=self;
    SearchField.showsCancelButton = YES;
    self.navigationItem.titleView = SearchField;
    
    _TableView = [[UITableView alloc]init];
    _TableView.frame =CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
    _TableView.dataSource =self;
    _TableView.delegate=self;
    _TableView.tableFooterView = [AppUtils tableViewsFooterView];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_TableView];
    
    myTBSuperView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              self.TableView.frame.size.width,
                                                              self.view.frame.size.height- CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    myTBSuperView.backgroundColor = [AppUtils colorWithHexString:@"f5f4f4"];
    [_TableView addSubview:myTBSuperView];
    
    CGFloat  narrowWidth = MIN(self.view.frame.size.width, self.view.frame.size.height);
    CGFloat btnHeight = narrowWidth *2/5;
    CGFloat btnWidth  = btnHeight /187 *218;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake((myTBSuperView.frame.size.width - btnWidth) /2, (myTBSuperView.frame.size.height - btnHeight) /2, btnWidth, btnHeight);
    searchBtn.tag = 10;
    searchBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;

    [searchBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -30, 0)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_noData"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchDown];
    searchBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [myTBSuperView addSubview:searchBtn];
    myTBSuperView.hidden = YES;
    [_TableView addSubview:myTBSuperView];
}

- (void)startSearch {
    [AppUtils closeKeyboard];
    [self searchBarSearchButtonClicked:SearchField];
}

-(void)backButArr
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchVisibleArr.count == 0) {
        myTBSuperView.hidden = NO;
    }
    else {
        myTBSuperView.hidden = YES;
    }
    
    return searchVisibleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseXQCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell ==nil) {
        cell =[[ChooseXQCell alloc]initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:SYSTEM_CELL_ID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BingingXQModel *xqM =[searchVisibleArr objectAtIndex:indexPath.row];
    ChooseXQCell *xqCell = (ChooseXQCell *)cell;
    [xqCell getXQListDictionary:xqM];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    BingingXQModel *xqM =[searchVisibleArr objectAtIndex:indexPath.row];
    
    AddXQModel *addxqM =[AddXQModel new];
    addXQHandler *addxqH = [addXQHandler new];
    addxqM.xqNo=[NSNumber numberWithLong:[xqM.xqNo intValue]];
    addxqM.memberId=[UserManager shareManager].userModel.memberId;
   
    [addxqH addXQ:addxqM success:^(id obj) {
        //从登陆页面跳入添加小区页面
        if ([self.navigationController.viewControllers count] > 0 && [self.navigationController.viewControllers[0] isKindOfClass:[O2OLoginViewController class]]) {
            BingingXQModel *switchM =[BingingXQModel new];
            SwitchXQHandler *switchH = [SwitchXQHandler new];
            switchM.merberId =[UserManager shareManager].userModel.memberId;
            switchM.xqNo = xqM.xqNo;
            
            //切换小区
            [switchH switchXQH:switchM success:^(id obj1) {
                //获取并修改用户信息
                [UserHandler executeGetUserInfoSuccess:^(id obj) {
                    [AppUtils showSuccessMessage:obj1];
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_COMMUNITY_CHANGE object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [O2OLoginViewController presentToMainVCWithAnimation:YES
                                                          fromViewController:self];
                    });
                    NSLog(@"success [UserManager shareManager].comModel =%@ xqM.wyId = %@",[UserManager shareManager].comModel.wyId,xqM.wyId);
                } failed:^(id obj) {
                    [UserManager shareManager].comModel = xqM;
                    [AppUtils showSuccessMessage:obj1];
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_COMMUNITY_CHANGE object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [O2OLoginViewController presentToMainVCWithAnimation:YES
                                                          fromViewController:self];
                    });
                    NSLog(@"fail [UserManager shareManager].comModel =%@ xqM.wyId = %@",[UserManager shareManager].comModel.wyId,xqM.wyId);
                }];
            } failed:^(id obj1) {
                [AppUtils showErrorMessage:obj1
                                    isShow:self.viewIsVisible];
            }];
        }
        else {
            [AppUtils dismissHUD];
            __block BOOL isPopComVC = NO;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIViewController *subVC = (UIViewController *)obj;
                if ([subVC isKindOfClass:[CommunityViewCotroller class]]) {
                    [self.navigationController popToViewController:subVC animated:YES];
                    if (self.comAddFinishedBlock) {
                        self.comAddFinishedBlock();
                    }
                    isPopComVC = YES;
                    *stop = YES;
                }
            }];
            
            if (!isPopComVC) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([NSString isEmptyOrNull:searchBar.text]) {
        searchVisibleArr = [self.allXQArray mutableCopy];
        [self.TableView reloadData];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([NSString isEmptyOrNull:searchBar.text]) {
        searchVisibleArr = [self.allXQArray mutableCopy];
        [self.TableView reloadData];    
        [AppUtils showAlertMessageTimerClose:@"请输入搜索内容"];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.xqName CONTAINS %@",searchBar.text];
   
    searchVisibleArr = [[self.allXQArray filteredArrayUsingPredicate:predicate] mutableCopy];
    NSSet *set = [NSSet setWithArray:searchVisibleArr];
        
    searchVisibleArr = [[set allObjects] mutableCopy];
    if ([set allObjects].count <= 0) {
        UIButton *searchBtn = (UIButton *)[self.view viewWithTag:10];
        [searchBtn setTitle:@"未搜索到内容，点击搜索" forState:UIControlStateNormal];
        [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
    }
    
    [searchBar resignFirstResponder];
    [self.TableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    searchVisibleArr = [self.allXQArray mutableCopy];
    [self.TableView reloadData];
    [searchBar resignFirstResponder];
}

@end
