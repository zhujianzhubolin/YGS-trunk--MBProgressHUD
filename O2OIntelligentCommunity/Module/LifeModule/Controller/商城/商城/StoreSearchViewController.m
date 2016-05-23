//
//  StoreSearchViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/7.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "StoreSearchViewController.h"
#import "JFTagListView.h"
#import "HotSearchModel.h"
#import "HotSearchHandel.h"
#import "Life_First.h"
#import "ShopGoodsList.h"
#import "UserManager.h"
#import "ShangchengCell.h"
#import "ShangChengGoodsDeatil.h"
#import "ShoppingCarDataSocure.h"
#import "ShoppingCar.h"
#import "ZJWebProgrssView.h"
//设备屏幕尺寸
#define JF_Screen_Height       ([UIScreen mainScreen].bounds.size.height)
#define JF_Screen_Width        ([UIScreen mainScreen].bounds.size.width)

@interface StoreSearchViewController ()<JFTagListDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ChangeCarNum>

{
    UITextField * searchField;
    UIScrollView * myScrollView;
    __weak IBOutlet UITableView *tableViewList;
    NSMutableArray * dataSocure;
    UIButton * shoppingCarbtn;
    UILabel * shoppingCarlable;
    long shopCarNumber;
    UIButton * nodataBtn;
    ZJWebProgrssView *progressV;
    int viewwidth;
    int viewheight;
}

@property (strong, nonatomic) JFTagListView    *tagList;     //自定义标签Viwe

@property (strong, nonatomic) JFTagListView    *historylist;     //历史记录

@property (strong, nonatomic) NSMutableArray   *tagArray;    //Tag数组

@property (strong, nonatomic) NSMutableArray   *historyArray;    //Tag数组


@property (assign, nonatomic) TagStateType     tagStateType; //标签的模式状态（显示、选择、编辑）

@end

@implementation StoreSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
    
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self hideKeyBoard];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.historyArray = [NSMutableArray array];
    self.tagArray = [NSMutableArray array];
    tableViewList.delegate = self;
    tableViewList.dataSource = self;
    [self setExtraCellLineHidden:tableViewList];
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, JF_Screen_Width, JF_Screen_Height -64)];
    myScrollView.contentSize = CGSizeMake(JF_Screen_Width, JF_Screen_Height + 100);
    myScrollView.pagingEnabled = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
    self.title = @"搜索";
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, JF_Screen_Width - 120, 30)];
    self.navigationItem.titleView = searchField;
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.placeholder = @"搜索商品";
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.layer.cornerRadius = 5;
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    //搜索框底部
    UIView * backsearchview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
    backsearchview.backgroundColor = [UIColor clearColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 1, 23, 23)];
    imageView.image = [UIImage imageNamed:@"sousuo"];
    [backsearchview addSubview:imageView];
    
    searchField.leftView = backsearchview;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [myScrollView addGestureRecognizer:tap];
    [tableViewList registerNib:[UINib nibWithNibName:@"ShangchengCell" bundle:nil] forCellReuseIdentifier:@"SHANGCHENGCELL"];
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(hotSearchWithWords) userInfo:nil repeats:NO];
    [self getHistoryKeyWords];
    
    if (VIEW_IPhone4_INCH) {
        viewwidth = 320;
        viewheight = 480;
    }else if (VIEW_IPhone5_INCH){
        viewwidth = 320;
        viewheight = 568;
    }else if (VIEW_IPhone6_INCH){
        viewwidth = 375;
        viewheight = 667;
    }else{
        viewwidth = 414;
        viewheight = 736;
    }
    
    __block typeof(searchField)weaksearchField = searchField;
    __block typeof(self)weakSelf = self;
    progressV = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf searchWithWords:[weaksearchField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [weaksearchField resignFirstResponder];
    };
    
    progressV.hidden = YES;
}


- (void)getHistoryKeyWords{

    self.historyArray = [self readData];
    
    //创建一个txt文件
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self writeData:[NSMutableArray arrayWithArray:self.historyArray]];
    });
}


- (void)hideKeyBoard{
    [searchField resignFirstResponder];
}

-(void)creatUI{
    
    UILabel * lableName1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, JF_Screen_Width, 30)];
    lableName1.text = @"热门搜索";
    lableName1.font = [UIFont systemFontOfSize:15];
    lableName1.textAlignment = NSTextAlignmentLeft;
    [myScrollView addSubview:lableName1];
    self.tagStateType = TagStateSelect;//单单显示模式
    
    //TagView
    self.tagList = [[JFTagListView alloc] initWithFrame:CGRectMake(0, lableName1.frame.origin.y + lableName1.frame.size.height + 10, JF_Screen_Width, JF_Screen_Height)];
    self.tagList.delegate = self;
    [self.tagList creatUI:_tagArray];   //传入Tag数组初始化界面
    [myScrollView addSubview:self.tagList];
    
    //以下属性是可选的
    self.tagList.tagArrkey = @"name";   //如果传的是字典的话，那么key为必传得
    self.tagList.is_can_addTag = NO;    //如果是要有最后一个按钮是添加按钮的情况，那么为Yes
    self.tagList.tagCornerRadius = 3;  //标签圆角的大小，默认10
    self.tagList.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    //刷新数据
    [self.tagList reloadData:_tagArray andTime:0];
    
    
    //灰色分割线
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.tagList.frame.size.height +self.tagList.frame.origin.y, JF_Screen_Width, 10)];
    view.backgroundColor = [AppUtils colorWithHexString:@"#DCDCDC"];
    [myScrollView addSubview:view];
    

    
    UILabel * lableName2 = [[UILabel alloc] initWithFrame:CGRectMake(10, view.frame.size.height + view.frame.origin.y, JF_Screen_Width, 30)];
    lableName2.text = @"历史搜索";
    lableName2.font = [UIFont systemFontOfSize:15];
    lableName2.textAlignment = NSTextAlignmentLeft;
    [myScrollView addSubview:lableName2];

    self.tagStateType = TagStateSelect;//单单显示模式
    //TagView
    self.historylist = [[JFTagListView alloc] initWithFrame:CGRectMake(0, lableName2.frame.origin.y + lableName2.frame.size.height + 10, JF_Screen_Width, JF_Screen_Height)];
    self.historylist.delegate = self;
    [self.historylist creatUI:_historyArray];   //传入Tag数组初始化界面
    [myScrollView addSubview:self.historylist];
    
    //以下属性是可选的
    self.historylist.tagArrkey = @"name";   //如果传的是字典的话，那么key为必传得
    self.tagList.is_can_addTag = NO;    //如果是要有最后一个按钮是添加按钮的情况，那么为Yes
    self.historylist.tagCornerRadius = 3;  //标签圆角的大小，默认10
    self.historylist.tagStateType = self.tagStateType;  //标签模式，默认显示模式
    //刷新数据
    [self.historylist reloadData:_historyArray andTime:0];
    
    
    //购物车
    //悬浮购物车
    shoppingCarbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCarbtn.frame = CGRectMake(20, JF_Screen_Height-160, 50, 50);
    [shoppingCarbtn setImage:[UIImage imageNamed:@"shoppingCar"] forState:UIControlStateNormal];
    [shoppingCarbtn addTarget:self action:@selector(goToShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoppingCarbtn];
    
    [shoppingCarbtn bringSubviewToFront:self.view];
    shoppingCarlable = [UILabel addlable:shoppingCarbtn frame:CGRectMake(30, -5, 20, 20) text:@"" textcolor:[UIColor whiteColor]];
    shoppingCarlable.layer.cornerRadius = 10;
    shoppingCarlable.clipsToBounds = YES;

    shoppingCarlable.textAlignment = NSTextAlignmentCenter;
    shoppingCarlable.font = [UIFont systemFontOfSize:12];
    shoppingCarlable.backgroundColor = [UIColor redColor];
    shoppingCarbtn.hidden = YES;
    
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
    
}

//点击购物车，修改购物车数量
- (void)setNewNum{
    shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
}

//前往购物车
- (void)goToShoppingCar:(UIButton *)sender{
    
    ShoppingCar * car = [[ShoppingCar alloc] initWithNibName:@"ShoppingCar" bundle:nil];
    car.isMine = NO;
    [self.navigationController pushViewController:car animated:YES];
}

#pragma UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}

#pragma TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSocure.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ShangchengCell * cell = [tableViewList dequeueReusableCellWithIdentifier:@"SHANGCHENGCELL"];
    
    if (cell == nil) {
        
        cell = [[ShangchengCell alloc] init];
    }
    
    __block __typeof(cell)weakCell = cell;
    //动画
    cell.cellClickBlock = ^(CGPoint addGoodPoint) {
        CGPoint windowPoint = [weakCell convertPoint:addGoodPoint toView:self.view];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        imgV.image = [UIImage imageNamed:@"addGouWuChe"];
        imgV.center = windowPoint;
        [self.view addSubview:imgV];
        
        [UIView animateWithDuration:0.5f animations:^{
            tableView.userInteractionEnabled = NO;
            imgV.center = shoppingCarbtn.center;
            imgV.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            tableView.userInteractionEnabled = YES;
            [imgV removeFromSuperview];
        }];
    };

    
    cell.numDele = self;
    [cell getDataFromeController:dataSocure[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ShangChengGoodsDeatil * detail = [[ShangChengGoodsDeatil alloc] initWithNibName:@"ShangChengGoodsDeatil" bundle:nil];
    detail.productId = [NSString stringWithFormat:@"%@",dataSocure[indexPath.row][@"id"]];
    [self.navigationController pushViewController:detail animated:YES];
    
}

//标签的点击事件
-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [searchField becomeFirstResponder];
    
    if (taglist == self.tagList) {
        searchField.text = _tagArray[buttonIndex];
        NSLog(@"%@",_tagArray[buttonIndex]);
    }else{
        searchField.text = _historyArray[buttonIndex];
        NSLog(@"%@",_historyArray[buttonIndex]);
    }
}

#pragma UITextField return响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyBoard];
    [self searchWithWords:searchField.text];
    return YES;
}

//热搜接口
- (void)hotSearchWithWords{

    HotSearchHandel * handel = [HotSearchHandel new];
    HotSearchModel * model = [HotSearchModel new];
    
    model.pageNumber = @"1";
    model.pageSize = @"10";
    model.code = @"POPULAR_SEARCH";
    
    [handel getHotSearch:model success:^(id obj) {
        for (HotSearchModel * model in obj) {
            [self.tagArray addObject:model.name];
        }
        [self creatUI];
    } failed:^(id obj) {
        
    }];
}

- (void)searchWithWords:(NSString *)keyWord{
    
    if (keyWord.length <= 0) {
        [AppUtils showAlertMessageTimerClose:@"输入不能为空!"];
        return;
    }
    Life_First * handel = [Life_First new];
    ShopGoodsList * list = [ShopGoodsList new];
    list.pageSize = [NSNumber numberWithLong:1000];
    list.pageNumber = [NSNumber numberWithLong:1];
    list.storeId = @"";
    list.categoryId = @"";
    list.catalogId = P_CATEGORY_ID;
    list.Sort  =@"LATEST_SHELVES";
    list.companyId = P_WYID;
    list.productName = [NSString stringWithFormat:@"%@",keyWord];
    [handel getShopAllGoods:list success:^(id obj) {
        NSLog(@"商品good是>>>>>>%@",obj);
        
    [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:obj[@"list"]]];
        
        NSMutableArray * writeArray = [NSMutableArray array];
        
        if ([self.historyArray containsObject:keyWord]) {
            
        }else{
            [self.historyArray addObject:keyWord];
        }
        
        if (self.historyArray.count > 10) {
            for (int i = 0; i < 10; i ++) {
                [writeArray addObject:self.historyArray[i]];
            }
            
        }else{
            writeArray = _historyArray;
        }
        
        [self writeData:[NSMutableArray arrayWithArray:writeArray]];
        
        if ([obj[@"list"] count] <=0 || [obj[@"list"] isEqual:[NSNull null]]) {
            
            myScrollView.hidden = YES;
            tableViewList.hidden = NO;
            progressV.hidden = NO;
            [dataSocure removeAllObjects];
            [tableViewList reloadData];
            [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
        }else{
            
            dataSocure = obj[@"list"];
            shoppingCarbtn.hidden = NO;
            shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
            shoppingCarlable.text = [NSString stringWithFormat:@"%ld件",shopCarNumber];
            
            myScrollView.hidden = YES;
            tableViewList.hidden = NO;
            progressV.hidden = YES;
            [tableViewList reloadData];
        }
        
        
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA];
        }else{
            [SVProgressHUD dismiss];
        }
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:nil]];
    }];
}

//写TXT文件
-(void)writeData:(NSMutableArray *)dataArray{
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];

    NSLog(@"%@",newFielPath);
    [dataArray writeToFile:newFielPath atomically:YES];
}

//读TXT文件
- (NSMutableArray *)readData{
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:@"aa.txt"];
    NSMutableArray * dataArray = [NSMutableArray arrayWithContentsOfFile:newFielPath];
    return dataArray;
}



//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
