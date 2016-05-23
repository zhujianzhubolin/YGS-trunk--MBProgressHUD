//
//  StoreViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/15.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#import "StoreViewController.h"
#import "BaseEntity.h"
//#import "CycleScrollView.h"
#import "ShoppingCar.h"
#import "ShangchengCell.h"

//滚动视图
#import "TopTabControlDefine.h"
#import "ShangChengGoodsDeatil.h"

#import "ShangChengMuLu.h"
#import "Life_First.h"
#import "ShangChengGoodsModel.h"
#import "ShoppingCarDataSocure.h"
#import "StoreSearchViewController.h"
#import "ZJWebProgrssView.h"
#import "UserManager.h"

@interface StoreViewController ()<TopTabControlDataSource,UITableViewDataSource,UITableViewDelegate,ChangeCarNum>
{
    UIButton * shoppingCarbtn;
    NSMutableArray * muluArray;
    //添加商品滚动
    TopTabControl * mytabCtrl;
    NSMutableArray * allGoodsListArray;
    NSMutableArray * muluIDArray;
    long shopCarNumber;
    UILabel * shoppingCarlable;
    
    NSMutableArray *itemArr;
    ZJWebProgrssView *progressV;
    ZJWebProgrssView *muLuProgressV;
    NSUInteger showIndex;
    
    BOOL isNotFirstSelect;
}

@end

@implementation StoreViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
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
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    showIndex = 0;
    
#ifdef SmartComJYZX
    self.title = @"家园购";
#elif SmartComYGS
    self.title = @"网上商城";
#else
    
#endif

    
    itemArr = [NSMutableArray array];
    muluArray = [NSMutableArray array];
    allGoodsListArray = [NSMutableArray array];
    muluIDArray = [NSMutableArray array];

    UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchInfor)];
    self.navigationItem.rightBarButtonItem = search;
    __block typeof(self)weakSelf = self;
    
    muLuProgressV = [[ZJWebProgrssView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:muLuProgressV];
    muLuProgressV.loadBlock = ^ {
        [weakSelf getMuLuOfShangCheng];
    };
    
    [muLuProgressV startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getMuLuOfShangCheng) userInfo:nil repeats:NO];
}

- (void)getMuLuOfShangCheng{
    [allGoodsListArray removeAllObjects];
    [muluArray removeAllObjects];
    
    Life_First * handel = [Life_First new];
    HuiTuanGouMuLuModel * model = [HuiTuanGouMuLuModel new];
    
    model.catalogId = [NSNumber numberWithInt:[P_CATEGORY_ID intValue]];
    
    model.languageId = [NSNumber numberWithLong:1];
    model.parentCategoryId = [NSNumber numberWithLong:0];
    [handel MuLuLieBiao:model success:^(id obj) {
        
        NSArray * contentArray = obj[@"list"];

        
        if (contentArray.count <= 0) {
            [muLuProgressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:muluArray]];
            return ;
        }else{
            @synchronized(self) {
                for (NSDictionary * dict in contentArray) {
                    [muluArray addObject:dict[@"name"]];
                    [muluIDArray addObject:dict[@"id"]];
                    NSArray *singleArr = [NSArray array];
                    [allGoodsListArray addObject:singleArr];
                }
            }
        }
        

        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   64,
                                                                   self.view.frame.size.width,
                                                                   50)];
        [self.view addSubview:headerV];
        
        mytabCtrl = [[TopTabControl alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.view.frame.size.width,
                                                                    self.view.frame.size.height - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height + 64)];
        
        mytabCtrl.backgroundColor =[UIColor whiteColor];
        __block typeof(self)weakSelf = self;
        
        mytabCtrl.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index) {
            UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:index + 1000];
            [weakSelf testBtn:btn];
        };
        
        mytabCtrl.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
            UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:index + 1000];
            if (btn != nil) {
                [weakSelf testBtn:btn];
            }
            else {
                [weakSelf startBlockAnimation];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:index + 1000];
                    [weakSelf testBtn:btn];
                });
            }
        };
        
        mytabCtrl.datasource = self;
        mytabCtrl.showIndicatorView = YES;
        [self.view addSubview:mytabCtrl];
        
        progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT, mytabCtrl.frame.size.width, mytabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
        progressV.loadBlock = ^{
            [weakSelf clickGetList];
        };
        [mytabCtrl addSubview:progressV];

        //悬浮购物车
        shoppingCarbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shoppingCarbtn.frame = CGRectMake(20, IPHONE_HEIGHT-160, 50, 50);
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
        
        [muLuProgressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:muluArray]];
        shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
        
        if (shopCarNumber <= 0) {
            shoppingCarlable.hidden = YES;
        }else{
            shoppingCarlable.hidden = NO;
            shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
        }
        
        [mytabCtrl reloadData];
        
        if (![NSArray isArrEmptyOrNull:muluArray]) {
            shoppingCarbtn.hidden = NO;
        }
        else {
            shoppingCarbtn.hidden = YES;
        }
        //获取商品列表
        [progressV startAnimation];
        [self clickGetList];
    } failed:^(id obj) {
        if ([NSArray isArrEmptyOrNull:muluArray]) {
            shoppingCarbtn.hidden = YES;
        }
        else {
            shoppingCarbtn.hidden = NO;
        }
        
        [muLuProgressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:muluArray]];
    }];
}

- (void)startBlockAnimation {
    [progressV startAnimation];
}

- (void)clickGetList {
    UITableView *tableV = (UITableView *)[self.view viewWithTag:100 + showIndex];
    NSLog(@"clickGetList tableV = %@",tableV);
    Life_First * handel = [Life_First new];
    ShopGoodsList * list = [ShopGoodsList new];
    list.pageSize = [NSNumber numberWithLong:1000];
    list.pageNumber = [NSNumber numberWithLong:1];
    list.storeId = @"";
    list.categoryId = [muluIDArray objectAtIndex:showIndex];
    
    list.companyId = P_WYID;
    list.catalogId = P_CATEGORY_ID;

    list.Sort  =@"LATEST_SHELVES";
    list.productName = @"";
    [handel getShopAllGoods:list success:^(id obj) {
        NSLog(@"index 列表返回>>>>%@",obj);
        allGoodsListArray[showIndex] = obj[@"list"];
        if (tableV == nil) {
            [mytabCtrl reloadContentData];
        }
        else {
            [tableV reloadData];
        }
        
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:allGoodsListArray[showIndex]]];
        [AppUtils tableViewEndMJRefreshWithTableV:tableV];
    } failed:^(id obj) {
        [AppUtils tableViewEndMJRefreshWithTableV:tableV];
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:allGoodsListArray[showIndex]]];
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
}


- (void)testBtn:(UIButton *)btn{
    
    isNotFirstSelect = YES;

    showIndex = btn.tag - 1000;
    //    [mytabCtrl reloadContentData];
    for (int i = 0; i < muluArray.count ; i++) {
        UIButton * mybtn = (UIButton *)[mytabCtrl viewWithTag:1000 + i];
        mybtn.selected = NO;
    }
    btn.selected = YES;
    
    [progressV startAnimation];
    [self clickGetList];
    
    [mytabCtrl displayPageAtIndex:showIndex];
}

#pragma mark - TopTabControlDataSource
//商品滚动回调方法
- (CGFloat)TopTabHeight:(TopTabControl *)tabCtrl{
    return TAB_ITEM_HEIGHT;
}

- (CGFloat)TopTabWidth:(TopTabControl *)tabCtrl{
    
    if (muluArray.count <= 0) {
        return self.view.frame.size.width;
    }else if (muluArray.count > 0 && muluArray.count <= 4){
        return IPHONE_WIDTH/muluArray.count +1;
    }else{
        return 80;
    }
//    return 80;
    
}

- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl{
    return muluArray.count;
}

- (TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl itemAtIndex:(NSUInteger)index{
    CGFloat topwideth;
    
    if (muluArray.count <= 0) {
        topwideth =  self.view.frame.size.width;
    }else if (muluArray.count > 0 && muluArray.count <= 4){
        topwideth = IPHONE_WIDTH/muluArray.count;
    }else{
        topwideth = 80;
    }
    
    TopTabMenuItem *topItem = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, topwideth, TAB_ITEM_HEIGHT)];
    
    UIButton * mybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mybtn.frame = topItem.bounds;
    mybtn.tag = index + 1000;
    [mybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mybtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    mybtn.userInteractionEnabled = NO;
    [mybtn setTitle:[muluArray objectAtIndex:index] forState:UIControlStateNormal];
    mybtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topItem addSubview:mybtn];
    
    if (isNotFirstSelect) {
        
    }else{
        if (mybtn.tag == 1000) {
            mybtn.selected = YES;
        }
    }
    


    [mybtn setTitle:[muluArray objectAtIndex:index] forState:UIControlStateNormal];
    return topItem;
}

//商品列表滚动视图
- (TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl pageAtIndex:(NSUInteger)index{
    TopTabPage *page = [[TopTabPage alloc] initWithFrame:CGRectMake(0,0,tabCtrl.frame.size.width,tabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
    UITableView * tableView = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
    tableView.tag = index + 100;

    tableView.delegate = self;
    tableView.dataSource = self;
    __block typeof(self)weakSelf = self;
    [tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf clickGetList];
    }];
    
    
    [tableView registerNib:[UINib nibWithNibName:@"ShangchengCell" bundle:nil] forCellReuseIdentifier:@"SHANGCHENGCELL"];
    [self viewDidLayoutSubviewsForTableView:tableView];

    tableView.showsVerticalScrollIndicator = NO;
    [tableView reloadData];
    [page addSubview:tableView];
    [self setExtraCellLineHidden:tableView];

    return page;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
//表格回调方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [allGoodsListArray[tableView.tag - 100] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShangchengCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SHANGCHENGCELL"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShangchengCell" owner:self options:nil] lastObject];
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
//            tableView.userInteractionEnabled = NO;
            imgV.center = shoppingCarbtn.center;
            imgV.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
//            tableView.userInteractionEnabled = YES;
            [imgV removeFromSuperview];
        }];
    };
    
    [cell getDataFromeController:allGoodsListArray[tableView.tag - 100][indexPath.row]];
    cell.numDele = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShangChengGoodsDeatil * detail = [[ShangChengGoodsDeatil alloc] initWithNibName:@"ShangChengGoodsDeatil" bundle:nil];
    
    NSDictionary * dict = allGoodsListArray[tableView.tag - 100][indexPath.row];
    detail.productId = dict[@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}


//前往购物车
- (void)goToShoppingCar:(UIButton *)sender{

    ShoppingCar * car = [[ShoppingCar alloc] initWithNibName:@"ShoppingCar" bundle:nil];
    car.isMine = NO;
    [self.navigationController pushViewController:car animated:YES];
}


//点击购物车，修改购物车数量
- (void)setNewNum{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(RestGoodsNum) userInfo:nil repeats:NO];
}

- (void)RestGoodsNum{
    shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
    
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
    
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//商品模糊搜索
- (void)searchInfor{
    StoreSearchViewController * search = [[StoreSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}




@end
