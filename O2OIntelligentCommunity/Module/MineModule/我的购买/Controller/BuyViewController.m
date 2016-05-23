//
//  BuyViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//


typedef NS_ENUM(NSUInteger, TuanGouType) {
    TuangouTypeAll = 0,
    TuangouTypeEnable
};



#import "BuyViewController.h"
#import "BuyCell.h"
#import "BuyGuiZongCell.h"
#import "BuyDeleteCheckCell.h"
#import "SVProgressHUD.h"
#import "LiJiFuKuanVC.h"
#import "UserManager.h"
#import "MineBuyGoodM.h"
#import "StayPaymentViewController.h"
#import <MJRefresh.h>
#import "TopTabControl.h"
#import "GoodsShopsCommentsVC.h"
#import "ZJWebProgrssView.h"
#import "WebVC.h"
#import "GrouponDetailsVC.h"

//接口类
#import "BuyHandel.h"
#import "MineBuyShopsM.h"
#import "MineBuyorderM.h"
#import "MineBuyShiGoodM.h"
//取消订单接口
#import "QuXiaoDindanModel.h"
#import "QuxiaoDindanHandler.h"
//删除订单和确认收货接口类
#import "DeleteDingdanHandler.h"
#import "DeleteDingdanModel.h"

@interface BuyViewController ()<TopTabControlDataSource,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation BuyViewController
{
    UITableView *allTB;
    UITableView *paymentTB;
    UITableView *goodsTB;
    UITableView *evaluateTB;
    TopTabControl *buytoptabCtrl;
     TuanGouType tgouType;

    UITableView *tuanGouAllTB;
    UITableView *tuanGouEnableTB;
    TopTabControl *tuanGoutabCtrl;
   
    UISegmentedControl *segmentedControl;
    
    
    MineBuyorderM *cancelorderM;//取消订单model
    MineBuyShopsM *shopsMM;//按钮响应传参model
    
    NSMutableArray *allOrderArray;//所有订单
    NSMutableArray *payMentOrderArray;//待支付
    NSMutableArray *goodsOrderArray;//待收货
    NSMutableArray *evaluateOrderArray;//待评价
    
    NSMutableArray *allTuanGouArray;
    NSMutableArray *evaluateTuanGouArray;
    
    NSUInteger selectedRow;
    
    UIAlertView *ConfirmAlertView;//确认收货
    UIAlertView *cancelOreder;//取消订单
    UIAlertView *wuLiuAlert;//查看物流
    
    
    
    ZJWebProgrssView *progrssV;
    BuyHandel *buyH;
    
    NSArray *segmentedArray;
    
}

- (id)init {
    self = [super init];
    if (self) {
        _ifShopOrTuanGou = ShopClass;
        tgouType = TuangouTypeAll;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    self.navigationController.navigationBar.translucent=YES;
    
    [progrssV startAnimation];
    
    segmentedControl.selectedSegmentIndex = _ifShopOrTuanGou;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self segmentAction:segmentedControl];
    });
    
        if (_ifShopOrTuanGou == ShopClass) {
            [buytoptabCtrl displayPageAtIndex:_currentType];
        }
        else if (_ifShopOrTuanGou == taunGouClass) {
             [buytoptabCtrl displayPageAtIndex:tgouType];
        }
}



-(void)initData
{
    segmentedArray     = [NSArray arrayWithObjects:@"商城",@"团购", nil];
    allTuanGouArray    = [NSMutableArray array];
    evaluateTuanGouArray = [NSMutableArray array];
    
    allOrderArray = [NSMutableArray array];
    payMentOrderArray  = [NSMutableArray array];
    goodsOrderArray    = [NSMutableArray array];
    evaluateOrderArray = [NSMutableArray array];
    
    buyH =[BuyHandel new];
    [self resetUpdate];
}


//订单
-(void)buyRefreshingNeedUpdate
{
    switch (_currentType) {
        case ShopTypeAll: {
            if (buyH.isAllBuyUpdate) {
                [progrssV startAnimation];
                [self startNetworkGetShopsIsHeader1:YES];
            }
        }
            break;
        case ShopTypeWaitPay: {
            if (buyH.isPaymentUpdate) {
                [progrssV startAnimation];
                [self startNetworkGetShopsIsHeader2:YES];
            }
        }
            break;
        case ShopTypeWaitShouhuo: {
            if (buyH.isGoodsUpdate) {
                [progrssV startAnimation];
                [self startNetworkGetShopsIsHeader2:YES];
            }
        }
            break;
        case ShopTypeWaitPingjia: {
            if (buyH.isEvaluatBuyUpdate) {
                [progrssV startAnimation];
                [self startNetworkGetShopsIsHeader4:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (NSArray *)orderArrForShopType {
    if (_ifShopOrTuanGou==ShopClass)
    {
        switch (_currentType) {
            case ShopTypeAll:
                return [allOrderArray copy];
            case ShopTypeWaitPay:
                return [payMentOrderArray copy];
            case ShopTypeWaitShouhuo:
                return [goodsOrderArray copy];
            case ShopTypeWaitPingjia:
                return [evaluateOrderArray copy];
            default:
                break;
        }
        return [NSMutableArray array];
    }
    else if (_ifShopOrTuanGou ==taunGouClass)
    {
        switch (tgouType) {
            case TuangouTypeAll:
                return [allTuanGouArray copy];
            case TuangouTypeEnable:
                return [evaluateTuanGouArray copy];
            default:
                break;
        }
        return [NSMutableArray array];
    }
    else
    {
        return 0;
    }
}

- (void)resetUpdate {
    buyH.isAllBuyUpdate = YES;
    buyH.isPaymentUpdate = YES;
    buyH.isGoodsUpdate = YES;
    buyH.isEvaluatBuyUpdate = YES;
    buyH.isAllTuanGouUpdate= YES;
    buyH.isEnableTuanGouUpdate=YES;
}

- (void)refreshData {
    [self resetUpdate];
    [NetworkRequest cancelAllOperations];
    if (_ifShopOrTuanGou == ShopClass)
    {
        [self buyRefreshingNeedUpdate];
    }
    else if (_ifShopOrTuanGou == taunGouClass)
    {
        [self tuanGouRefreshingNeedUpdate];
    }
}

//团购
-(void)tuanGouRefreshingNeedUpdate
{
    switch (tgouType) {
        case TuangouTypeAll: {
            if (buyH.isAllTuanGouUpdate) {
                [progrssV startAnimation];
                [self startNetworkGetTuanGouIsHeader:YES];
            }
        }
            break;
        case TuangouTypeEnable: {
            if (buyH.isEnableTuanGouUpdate) {
                [progrssV startAnimation];
                [self startNetworkGetTuanGouIsHeader2:YES];
            }
        }
            break;
        default:
            break;
    }
}


-(void)initUI
{
  
    __weak __typeof(self)weakSelf = self;
    [self.navigationItem addLeftItemWithImgName:@"backIcon" action:^{
        [weakSelf backRootVC];
    }];

    self.view.backgroundColor=[UIColor whiteColor];
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                                               self.view.frame.size.width,
                                                               50)];
    [self.view addSubview:headerV];
    self.navigationController.navigationBar.translucent=NO;
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.layer.masksToBounds=YES;
    segmentedControl.layer.cornerRadius=15;
    segmentedControl.layer.borderColor = [AppUtils colorWithHexString:@"20AADB"].CGColor;
    segmentedControl.layer.borderWidth = 1;
    segmentedControl.frame=CGRectMake(0, 0, 150, 30);
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.tintColor = [AppUtils colorWithHexString:@"20AADB"];
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    [self.navigationItem setTitleView:segmentedControl];
    
    buytoptabCtrl = [[TopTabControl alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    buytoptabCtrl.datasource = self;
    buytoptabCtrl.showIndicatorView = YES;
    [buytoptabCtrl reloadData];
    [self.view addSubview:buytoptabCtrl];
    
    
    tuanGoutabCtrl = [[TopTabControl alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    tuanGoutabCtrl.datasource = self;
    tuanGoutabCtrl.showIndicatorView = YES;
    [tuanGoutabCtrl reloadData];
    tuanGoutabCtrl.hidden=YES;
    [self.view addSubview:tuanGoutabCtrl];
    
    buytoptabCtrl.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index)
    {
        NSLog(@"itemClickBlockcell = %@,index = %lu",cell,(unsigned long)index);
        UIButton *btn =(UIButton *)[weakSelf.view viewWithTag:500+index];
        [weakSelf buyChangeClick:btn];
    };
    
    buytoptabCtrl.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        NSLog(@"pageEndDeceleratingBlockcell = %@,index = %lu",cell,(unsigned long)index);
        UIButton *btn =(UIButton *)[weakSelf.view viewWithTag:500+index];
        [weakSelf buyChangeClick:btn];
        
    };
    tuanGoutabCtrl.itemClickBlock = ^(UITableViewCell *cell,NSUInteger index)
    {
        NSLog(@"itemClickBlockcell = %@,index = %lu",cell,(unsigned long)index);
        UIButton *btn =(UIButton *)[weakSelf.view viewWithTag:6000+index];
        [weakSelf tuanGouChangeClick:btn];
    };
    
    tuanGoutabCtrl.pageEndDeceleratingBlock = ^(UITableViewCell *cell,NSUInteger index) {
        NSLog(@"pageEndDeceleratingBlockcell = %@,index = %lu",cell,(unsigned long)index);
        UIButton *btn =(UIButton *)[weakSelf.view viewWithTag:6000+index];
        [weakSelf tuanGouChangeClick:btn];
    };
    
    progrssV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT, buytoptabCtrl.frame.size.width, buytoptabCtrl.frame.size.height - TAB_ITEM_HEIGHT)];
    progrssV.loadBlock = ^{
        [weakSelf refreshData];
    };
    [buytoptabCtrl addSubview:progrssV];
}

-(void)backRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)segmentAction:(UISegmentedControl *)Seg
{
    [progrssV startAnimation];
    
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            buytoptabCtrl.hidden=NO;
            tuanGoutabCtrl.hidden=YES;
            _ifShopOrTuanGou =ShopClass;
            [buytoptabCtrl addSubview:progrssV];
        }
            NSLog(@"1");
            break;
        case 1:
        {
            tuanGoutabCtrl.hidden=NO;
            buytoptabCtrl.hidden=YES;
            _ifShopOrTuanGou =taunGouClass;
            [tuanGoutabCtrl addSubview:progrssV];
        }
            NSLog(@"2");
            break;
            
        default:
            break;
    }
    
    [self refreshData];
}

- (void)tuanGouChangeClick:(UIButton *)sender {
    NSLog(@"tuanGouChangeClick sender.tag = %ld",(long)sender.tag);
    for (int i = 6000; i <6000+2; i++) {
        UIButton *btn = (UIButton *)[tuanGoutabCtrl viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.selected = NO;
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    
    if (sender.tag==6000 )
    {
        tgouType = TuangouTypeAll;
    }
    else if (sender.tag==6001)
    {
        tgouType = TuangouTypeEnable;
    }
    
    [self resetUpdate];
    [self tuanGouRefreshingNeedUpdate];
}

- (void)buyChangeClick:(UIButton *)sender {
    NSLog(@"sender.tag = %d",sender.tag);
    for (int i = 500; i <500+4; i++) {
        UIButton *btn = (UIButton *)[buytoptabCtrl viewWithTag:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.selected = NO;
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
        
    if (sender.tag==500 )
    {
        _currentType = ShopTypeAll;
        buyH.isAllBuyUpdate = YES;
    }
    else if (sender.tag==501)
    {
        _currentType = ShopTypeWaitPay;
        buyH.isPaymentUpdate = YES;
    }
    else if(sender.tag==502)
    {
        _currentType = ShopTypeWaitShouhuo;
        buyH.isGoodsUpdate = YES;
    }
    else if (sender.tag==503)
    {
        _currentType = ShopTypeWaitPingjia;
        buyH.isEvaluatBuyUpdate = YES;
    }
    
    [self buyRefreshingNeedUpdate];
}




#pragma mark - Requesr
//团购订单查询
-(void)startNetworkGetTuanGouIsHeader2:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].userModel.memberId,@"memberNo",
                                 @"GROUP_BUY",@"orderType",
                                 @"0120",@"statusTotal",
                                 nil];
    buyM.queryMap =queryMapDic;
    
    [buyH postEnableTuanGouList:buyM success:^(id obj) {
        if (tgouType == TuangouTypeEnable) {
            buyH.isEnableTuanGouUpdate = NO;
            evaluateTuanGouArray =(NSMutableArray *)obj;
            [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:evaluateTuanGouArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:tuanGouEnableTB];
            [tuanGouEnableTB reloadData];
        }
    } failed:^(id obj) {
        if (tgouType == TuangouTypeEnable) {
            buyH.isEnableTuanGouUpdate = YES;
            [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:evaluateTuanGouArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:tuanGouEnableTB];
            
        }
        
    } isHeader:isHeader];
}

//团购订单查询
-(void)startNetworkGetTuanGouIsHeader:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].userModel.memberId,@"memberNo",
                                 @"GROUP_BUY",@"orderType",
                                 nil];
    buyM.queryMap =queryMapDic;
    
    [buyH postAllTuanGouList:buyM success:^(id obj) {
        if (tgouType == TuangouTypeAll) {
            buyH.isAllTuanGouUpdate = NO;
            allTuanGouArray =(NSMutableArray *)obj;
            [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:allTuanGouArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:tuanGouAllTB];
            [tuanGouAllTB reloadData];
        }
    } failed:^(id obj) {
        if (tgouType == TuangouTypeAll) {
            buyH.isAllTuanGouUpdate = YES;
            
            [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:allTuanGouArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:tuanGouAllTB];
        }
    } isHeader:isHeader];
}

-(void)startNetworkGetShopsIsHeader1:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [UserManager shareManager].userModel.memberId,@"memberNo",
                   @"GENERAL",@"orderType",//取实体订单
                   nil];

    buyM.queryMap =queryMapDic;
    [buyH postAllBuyList:buyM success:^(id obj) {
        if (_currentType == ShopTypeAll) {
            buyH.isAllBuyUpdate = NO;
            allOrderArray =(NSMutableArray *)obj;
            [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:allOrderArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:allTB];
            [allTB reloadData];
        }
    } failed:^(id obj) {
        if (_currentType == ShopTypeAll) {
            buyH.isAllBuyUpdate = YES;
            [AppUtils tableViewEndMJRefreshWithTableV:allTB];
            [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:allOrderArray]];
            
        }
    } isHeader:isHeader];
}

-(void)startNetworkGetShopsIsHeader2:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";

    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [UserManager shareManager].userModel.memberId,@"memberNo",
                   @"0130",@"statusTotal",
                   @"GENERAL",@"orderType",//取实体订单
                   nil];
    buyM.queryMap =queryMapDic;
    [buyH postAllBuyList:buyM success:^(id obj) {
        buyH.isAllBuyUpdate = NO;
        allOrderArray =(NSMutableArray *)obj;
        [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:allOrderArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:allTB];
        [allTB reloadData];

    } failed:^(id obj) {
        buyH.isAllBuyUpdate = YES;
        [AppUtils tableViewEndMJRefreshWithTableV:allTB];
        [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:allOrderArray]];
    } isHeader:isHeader];
}

-(void)startNetworkGetShopsIsHeader3:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    NSDictionary *queryMapDic;
    if (_currentType == ShopTypeAll)
    {
        queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [UserManager shareManager].userModel.memberId,@"memberNo",
                       @"GENERAL",@"orderType",//取实体订单
                       nil];
        
    }
    else if (_currentType == ShopTypeWaitPay)
    {
        queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [UserManager shareManager].userModel.memberId,@"memberNo",
                       @"0130",@"statusTotal",
                       @"GENERAL",@"orderType",//取实体订单
                       nil];
        
    }
    else if (_currentType == ShopTypeWaitShouhuo)
    {
        queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [UserManager shareManager].userModel.memberId,@"memberNo",
                       @"0170",@"statusTotal",
                       @"GENERAL",@"orderType",//取实体订单
                       nil];
        
    }
    else if (_currentType == ShopTypeWaitPingjia)
    {
        queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [UserManager shareManager].userModel.memberId,@"memberNo",
                       @"0180",@"statusTotal",
                       @"GENERAL",@"orderType",//取实体订单
                       nil];
    }
    
    buyM.queryMap =queryMapDic;
    [buyH postAllBuyList:buyM success:^(id obj) {
        if (_currentType == ShopTypeWaitShouhuo)
        {
            buyH.isGoodsUpdate = NO;
            goodsOrderArray =(NSMutableArray *)obj;
            [AppUtils tableViewEndMJRefreshWithTableV:goodsTB];
            [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:goodsOrderArray]];
            [goodsTB reloadData];
            
        }
    } failed:^(id obj) {
        if (_currentType == ShopTypeWaitShouhuo)
        {
            buyH.isGoodsUpdate = YES;
            [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:goodsOrderArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:goodsTB];
        }
    } isHeader:isHeader];
}

-(void)startNetworkGetShopsIsHeader4:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    NSDictionary *queryMapDic;
           queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [UserManager shareManager].userModel.memberId,@"memberNo",
                       @"0180",@"statusTotal",
                       @"GENERAL",@"orderType",//取实体订单
                       nil];
     buyM.queryMap =queryMapDic;
    [buyH postAllBuyList:buyM success:^(id obj) {
        if (_currentType == ShopTypeWaitPingjia)
        {
            buyH.isEvaluatBuyUpdate = NO;
            evaluateOrderArray =(NSMutableArray *)obj;
            [AppUtils tableViewEndMJRefreshWithTableV:evaluateTB];
            [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:evaluateOrderArray]];
            [evaluateTB reloadData];
        }
        
    } failed:^(id obj) {
        if (_currentType == ShopTypeWaitPingjia)
        {
            buyH.isEvaluatBuyUpdate = YES;
            [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:evaluateOrderArray]];
            [AppUtils tableViewEndMJRefreshWithTableV:evaluateTB];
        }
    } isHeader:isHeader];
}


#pragma mark -TopTabControl代理方法
//订单滚动回调方法
-(CGFloat)TopTabHeight:(TopTabControl *)tabCtrl
{
    return TAB_ITEM_HEIGHT;
}

-(CGFloat)TopTabWidth:(TopTabControl *)tabCtrl
{
    if (tabCtrl == tuanGoutabCtrl)
    {
        return IPHONE_WIDTH/2;
    }
    else
    {
        return IPHONE_WIDTH/4;
    }
    
}
- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl{
    
    if (tabCtrl==tuanGoutabCtrl)
    {
        return 2;
    }
    else
    {
        return 4;
    }
}

-(TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl itemAtIndex:(NSUInteger)index
{
    if (tabCtrl ==buytoptabCtrl)
    {
        TopTabMenuItem *topItem = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width / 4, TAB_ITEM_HEIGHT)];
        switch (index)
        {
            case ShopTypeAll:
            {
                UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                allBtn.frame = topItem.bounds;
                allBtn.userInteractionEnabled = NO;
                allBtn.tag = 500;
                allBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
                [allBtn setTitle:@"全部" forState:UIControlStateNormal];
                [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [allBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [allBtn addTarget:self action:@selector(buyChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//                allBtn.selected=YES;
                
                
                [topItem addSubview:allBtn];
                return topItem;
            }
                break;
            case ShopTypeWaitPay:
            {
                UIButton *paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                paymentBtn.frame = topItem.bounds;
                paymentBtn.userInteractionEnabled = NO;
                paymentBtn.tag = 501;
                paymentBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
                [paymentBtn setTitle:@"待付款" forState:UIControlStateNormal];
                [paymentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [paymentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [paymentBtn addTarget:self action:@selector(buyChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//                paymentBtn.selected=NO;
                

                [topItem addSubview:paymentBtn];
                return topItem;
            }
                break;
            case ShopTypeWaitShouhuo:
            {
                UIButton *goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                goodsBtn.frame = topItem.bounds;
                goodsBtn.userInteractionEnabled = NO;
                goodsBtn.tag = 502;
                goodsBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
                [goodsBtn setTitle:@"待收货" forState:UIControlStateNormal];
                [goodsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [goodsBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [goodsBtn addTarget:self action:@selector(buyChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//                goodsBtn.selected = NO;
                [topItem addSubview:goodsBtn];
                return topItem;
            }
                break;
            case ShopTypeWaitPingjia:
            {
                UIButton *evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                evaluateBtn.frame = topItem.bounds;
                evaluateBtn.userInteractionEnabled = NO;
                evaluateBtn.tag = 503;
                evaluateBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
                [evaluateBtn setTitle:@"待评价" forState:UIControlStateNormal];
                [evaluateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [evaluateBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [evaluateBtn addTarget:self action:@selector(buyChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//                evaluateBtn.selected = NO;
                [topItem addSubview:evaluateBtn];
                return topItem;
            }
                break;
            default:
                break;
        }
        return topItem;
        
    }
    else
    {
        TopTabMenuItem *tuanGouItem = [[TopTabMenuItem alloc] initWithFrame:CGRectMake(0, 0, tabCtrl.frame.size.width / 2, TAB_ITEM_HEIGHT)];
        switch (index)
        {
            case TuangouTypeAll:
            {
                UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                allBtn.frame = tuanGouItem.bounds;
                allBtn.userInteractionEnabled = NO;
                allBtn.tag = 6000;
                allBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
                [allBtn setTitle:@"全部" forState:UIControlStateNormal];
                [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [allBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [allBtn addTarget:self action:@selector(tuanGouChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//                allBtn.selected=YES;
                [tuanGouItem addSubview:allBtn];
                return tuanGouItem;
            }
                break;
            case TuangouTypeEnable:
            {
                UIButton *paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                paymentBtn.frame = tuanGouItem.bounds;
                paymentBtn.userInteractionEnabled = NO;
                paymentBtn.tag = 6001;
                paymentBtn.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
                [paymentBtn setTitle:@"可使用" forState:UIControlStateNormal];
                [paymentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [paymentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [paymentBtn addTarget:self action:@selector(tuanGouChangeClick:) forControlEvents:UIControlEventTouchUpInside];
//                paymentBtn.selected=NO;
                
                [tuanGouItem addSubview:paymentBtn];
                return tuanGouItem;
            }
                break;
            default:
                break;
        }
        return tuanGouItem;
        
    }
    
}

-(TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl pageAtIndex:(NSUInteger)index
{
    if (tabCtrl == buytoptabCtrl)
    {
        TopTabPage *page = [[TopTabPage alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        tabCtrl.frame.size.width,
                                                                        tabCtrl.frame.size.height - TAB_ITEM_HEIGHT
                                                                        )];
        
        //    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, page.frame.size.width, 2)];
        //    headview.backgroundColor = [UIColor lightGrayColor];
        if (index==0)
        {
            allTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStyleGrouped];
            allTB.dataSource=self;
            allTB.delegate=self;
            //allTB.tableHeaderView=headview;
            allTB.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:allTB];
            
            [page addSubview:allTB];
            
            __block __typeof(self)buyTableview =self;
            
            [allTB addLegendHeaderWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader1:YES];//下啦刷新
            }];
            
            [allTB addLegendFooterWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader1:NO];//上拉刷新
            }];
            
            
        }
        else if (index==1)
        {
            paymentTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStyleGrouped];
            paymentTB.dataSource=self;
            paymentTB.delegate=self;
            [page addSubview:paymentTB];
            //paymentTB.tableHeaderView=headview;
            [self viewDidLayoutSubviewsForTableView:paymentTB];
            paymentTB.tableFooterView = [AppUtils tableViewsFooterView];
            __block __typeof(self)buyTableview =self;
            
            [paymentTB addLegendHeaderWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader2:YES];//下啦刷新
            }];
            
            [paymentTB addLegendFooterWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader2:NO];//上拉刷新
            }];
            
        }
        else if (index==2)
        {
            goodsTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStyleGrouped];
            goodsTB.dataSource=self;
            goodsTB.delegate=self;
            [page addSubview:goodsTB];
            //goodsTB.tableHeaderView=headview;
            goodsTB.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:goodsTB];
            __block __typeof(self)buyTableview =self;
            
            [goodsTB addLegendHeaderWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader3:YES];//下啦刷新
            }];
            
            [goodsTB addLegendFooterWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader3:NO];//上拉刷新
            }];
            
        }
        else if (index==3)
        {
            evaluateTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStyleGrouped];
            
            evaluateTB.dataSource=self;
            evaluateTB.delegate=self;
            [page addSubview:evaluateTB];
            //evaluateTB.tableHeaderView=headview;
            [self viewDidLayoutSubviewsForTableView:evaluateTB];
            evaluateTB.tableFooterView = [AppUtils tableViewsFooterView];
            __block __typeof(self)buyTableview =self;
            
            [evaluateTB addLegendHeaderWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader4:YES];//下啦刷新
            }];
            
            [evaluateTB addLegendFooterWithRefreshingBlock:^{
                [buyTableview startNetworkGetShopsIsHeader4:NO];//上拉刷新
            }];
            
        }
        return page;
        
    }
    else if(tabCtrl == tuanGoutabCtrl)
    {
        TopTabPage *tuanGouPage = [[TopTabPage alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               tabCtrl.frame.size.width,
                                                                               tabCtrl.frame.size.height - TAB_ITEM_HEIGHT
                                                                               )];
        
        //    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, page.frame.size.width, 2)];
        //    headview.backgroundColor = [UIColor lightGrayColor];
        if (index==0)
        {
            tuanGouAllTB = [[UITableView alloc] initWithFrame:tuanGouPage.bounds style:UITableViewStyleGrouped];
            tuanGouAllTB.dataSource=self;
            tuanGouAllTB.delegate=self;
            //allTB.tableHeaderView=headview;
            tuanGouAllTB.tableFooterView = [AppUtils tableViewsFooterView];
            [self viewDidLayoutSubviewsForTableView:tuanGouAllTB];
            
            [tuanGouPage addSubview:tuanGouAllTB];
            
            __block __typeof(self)taunGouTableview =self;
            
            [tuanGouAllTB addLegendHeaderWithRefreshingBlock:^{
                [taunGouTableview startNetworkGetTuanGouIsHeader:YES];//下啦刷新
            }];
            
            [tuanGouAllTB addLegendFooterWithRefreshingBlock:^{
                [taunGouTableview startNetworkGetTuanGouIsHeader:NO];//上拉刷新
            }];
            
            
        }
        else if (index==1)
        {
            tuanGouEnableTB = [[UITableView alloc] initWithFrame:tuanGouPage.bounds style:UITableViewStyleGrouped];
            tuanGouEnableTB.dataSource=self;
            tuanGouEnableTB.delegate=self;
            [tuanGouPage addSubview:tuanGouEnableTB];
            //paymentTB.tableHeaderView=headview;
            [self viewDidLayoutSubviewsForTableView:tuanGouEnableTB];
            tuanGouEnableTB.tableFooterView = [AppUtils tableViewsFooterView];
            __block __typeof(self)taunGouTableview =self;
            
            [tuanGouEnableTB addLegendHeaderWithRefreshingBlock:^{
                [taunGouTableview startNetworkGetTuanGouIsHeader2:YES];//下啦刷新
            }];
            
            [tuanGouEnableTB addLegendFooterWithRefreshingBlock:^{
                [taunGouTableview startNetworkGetTuanGouIsHeader2:NO];//上拉刷新
            }];
            
        }
        return tuanGouPage;
        
    }
    else
    {
        return nil;
    }
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
//分割线靠边界
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_ifShopOrTuanGou == ShopClass)
    {
        if (tableView ==allTB)
        {
            [AppUtils tableViewFooterPromptWithPNumber:buyH.allcurrentPage.integerValue
                                            withPCount:buyH.allpageCount.integerValue
                                             forTableV:allTB];
            return allOrderArray.count;
        }
        else if (tableView==paymentTB)
        {
            [AppUtils tableViewFooterPromptWithPNumber:buyH.paymentcurrentPage.integerValue
                                            withPCount:buyH.paymentpageCount.integerValue
                                             forTableV:paymentTB];
            return payMentOrderArray.count;
        }
        else if (tableView==goodsTB)
        {  
            [AppUtils tableViewFooterPromptWithPNumber:buyH.goodscurrentPage.integerValue
                                            withPCount:buyH.goodspageCount.integerValue
                                                forTableV:goodsTB];
            return goodsOrderArray.count;
        }
        else
        {
            [AppUtils tableViewFooterPromptWithPNumber:buyH.evaluatecurrentPage.integerValue
                                            withPCount:buyH.evaluatepageCount.integerValue
                                             forTableV:evaluateTB];
            return evaluateOrderArray.count;
        }
        
    }
    else
    {
        if (tableView == tuanGouAllTB)
        {
            [AppUtils tableViewFooterPromptWithPNumber:buyH.allTuanGouPageCount.integerValue
                                            withPCount:buyH.allTuanGouPageCount.integerValue
                                             forTableV:tuanGouAllTB];
            return allTuanGouArray.count;
        }
        else if (tableView == tuanGouEnableTB)
        {
            [AppUtils tableViewFooterPromptWithPNumber:buyH.EnableTuanGouCurrentPage.integerValue
                                            withPCount:buyH.EnableTuanGouPageCount.integerValue
                                             forTableV:tuanGouEnableTB];
            return evaluateTuanGouArray.count;
        }
        else
        {
            return 0;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MineBuyShopsM *shopM;
    MineBuyorderM *orderM;
    if(_ifShopOrTuanGou == ShopClass)
    {
        if (tableView==allTB)
        {
            shopM = allOrderArray[section];
        }
        else if (tableView==paymentTB)
        {
            shopM = payMentOrderArray[section];
        }
        else if (tableView==goodsTB)
        {
            shopM = goodsOrderArray[section];
        }
        else if (tableView==evaluateTB)
        {
            shopM = evaluateOrderArray[section];
        }
        NSArray *shopArr = shopM.orderSubInfoList;
        if (![NSArray isArrEmptyOrNull:shopArr])
        {
            orderM = shopArr[0];
        }
        return orderM.orderItemInfoList.count+1;
        
    }
    else
    {
        return 1+1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MineBuyShopsM *shopsM;
    if (_ifShopOrTuanGou == ShopClass)
    {
        if (tableView==allTB)
        {
            shopsM =[allOrderArray objectAtIndex:section];
        }
        else if (tableView==paymentTB)
        {
            shopsM =[payMentOrderArray objectAtIndex:section];
        }
        else if (tableView==goodsTB)
        {
            shopsM =[goodsOrderArray objectAtIndex:section];
        }
        else if (tableView==evaluateTB)
        {
            shopsM =[evaluateOrderArray objectAtIndex:section];
        }
        
    }
    else
    {
        if (tableView == tuanGouAllTB)
        {
            shopsM = [allTuanGouArray objectAtIndex:section];
        }
        else if (tableView == tuanGouEnableTB)
        {
            shopsM = [evaluateTuanGouArray objectAtIndex:section];
        }
        else
        {
            return 0;
        }
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    view.backgroundColor = [AppUtils colorWithHexString:@"EDEFEB"];
    
    CGFloat dealstateLWidth = 120;
    CGFloat interval = 10;
    UILabel *dealstateLabe = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - dealstateLWidth - interval, 0, dealstateLWidth, 25)];
    //dealstateLabe.backgroundColor=[UIColor redColor];
    NSString *statusPayStr =[NSString stringWithFormat:@"%@",shopsM.statusTotal];
    if (_ifShopOrTuanGou == ShopClass)
    {
        dealstateLabe.text=[BuyHandel shopDinDanState:statusPayStr];
    }
    else
    {
        dealstateLabe.text=[BuyHandel grouponDinDanState:statusPayStr];
    }

    
    dealstateLabe.textColor=[AppUtils colorWithHexString:@"fa6900"];
    dealstateLabe.textAlignment=NSTextAlignmentRight;
    [view addSubview:dealstateLabe];
    
    UILabel *groupLabe = [[UILabel alloc]initWithFrame:CGRectMake(interval, 0, dealstateLabe.frame.origin.x - interval, dealstateLabe.frame.size.height)];
    
    if ([NSString isEmptyOrNull:shopsM.merchantName]) {
        groupLabe.text=@"未知";
    }
    else {
        groupLabe.text=shopsM.merchantName;
    }
    groupLabe.textColor=[AppUtils colorWithHexString:@"fa6900"];
    [view addSubview:groupLabe];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineBuyShopsM *shopsM;
    if (_ifShopOrTuanGou == ShopClass)
    {
        if (tableView==allTB)
        {
            shopsM =[allOrderArray objectAtIndex:indexPath.section];
        }
        else if (tableView==paymentTB)
        {
            shopsM =[payMentOrderArray objectAtIndex:indexPath.section];
        }
        else if (tableView==goodsTB)
        {
            shopsM =[goodsOrderArray objectAtIndex:indexPath.section];
        }
        else if (tableView==evaluateTB)
        {
            shopsM =[evaluateOrderArray objectAtIndex:indexPath.section];
        }
        
    }
    else if(_ifShopOrTuanGou == taunGouClass)
    {
        if(tableView == tuanGouAllTB)
        {
            shopsM = [allTuanGouArray objectAtIndex:indexPath.section];
        }
        else if(tableView == tuanGouEnableTB)
        {
            shopsM = [evaluateTuanGouArray objectAtIndex:indexPath.section];
        }
        
        
    }
    
    NSArray *shopArr = shopsM.orderSubInfoList;
    
    if (![NSArray isArrEmptyOrNull:shopArr]) {
        MineBuyorderM *orderM = shopArr[0];
        if (_ifShopOrTuanGou == ShopClass)
        {
            if (indexPath.row == orderM.orderItemInfoList.count)
            {
                return [self rowHeightForTypeStr:shopsM.statusTotal];
            }
            else {
                return 90;
            }

        }
        else
        {
            if (indexPath.row == 1)
            {
               return [self rowHeightForTypeStr:shopsM.statusTotal];
            }
            else {
                return 90;
            }

        }
    }
    return 0;
}

- (CGFloat)rowHeightForTypeStr:(NSString *)typeStr {
    NSString *statusStr =[NSString stringWithFormat:@"%@",typeStr];
    if ([statusStr isEqualToString:@"0130"] )//待付款
    {
        return 70;
    }
    else if ([statusStr isEqualToString:@"0131"])//已取消
    {
        return 30;
    }
    else if ([statusStr isEqualToString:@"0132"])//系统自动取消
    {
        return 30;
    }
    else if ([statusStr isEqualToString:@"0120"])//已支付
    {
        return 70;
    }
    else if ([statusStr isEqualToString:@"0170"])//待收货
    {
        return 70;
    }
    else if ([statusStr isEqualToString:@"0180"])//待评价
    {
        return 70;
    }
    else if ([statusStr isEqualToString:@"0182"])//已完成
    {
        return 70;
        
    }
    else if ([statusStr isEqualToString:@"0183"])//已完成
    {
        return 30;
        
    }
    else if ([statusStr isEqualToString:@"0184"])//已完成
    {
        return 30;
        
    }
    else if ([statusStr isEqualToString:@"0172"])//退款驳回
    {
        return 70;
    }
    else if ([statusStr isEqualToString:@"0173"])//订单退款中
    {
        return 70;
    }
    else if ([statusStr isEqualToString:@"0174"])//订单退款完成
    {
        return 70;
    }

    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MineBuyShopsM *shopsM;
    
    if (_ifShopOrTuanGou == ShopClass)
    {
        if (tableView==allTB) {
            shopsM =[allOrderArray objectAtIndex:indexPath.section];
        }
        else if (tableView==paymentTB) {
            shopsM =[payMentOrderArray objectAtIndex:indexPath.section];
        }
        else if (tableView==goodsTB) {
            shopsM =[goodsOrderArray objectAtIndex:indexPath.section];
        }
        else if (tableView==evaluateTB) {
            shopsM =[evaluateOrderArray objectAtIndex:indexPath.section];
        }
        
    }
    else
    {
        if (tableView==tuanGouAllTB)
        {
            shopsM = [allTuanGouArray objectAtIndex:indexPath.section];
        }
        else if(tableView == tuanGouEnableTB)
        {
            shopsM = [evaluateTuanGouArray objectAtIndex:indexPath.section];
        }
        
    }

    
    if (_ifShopOrTuanGou == ShopClass)
    {
        NSArray *shopArr = shopsM.orderSubInfoList;
        if ([NSArray isArrEmptyOrNull:shopArr]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            return cell;
        }
        
        MineBuyorderM *orderM = shopArr[0];
        if (indexPath.row != orderM.orderItemInfoList.count)
        {
            
            BuyCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell==nil)
            {
                cell=[[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSArray *shopArr = shopsM.orderSubInfoList;
            if (![NSArray isArrEmptyOrNull:shopArr]) {
                MineBuyorderM *orderM = shopArr[0];
                MineBuyGoodM *goodM = orderM.orderItemInfoList[indexPath.row];
                
                if (_ifShopOrTuanGou ==ShopClass)
                {
                    if (goodM.isShiti) {
                        [cell getShitiBuyM:goodM];
                    }
                    //            else {
                    //                [cell getXuliBuyM:goodM];
                    //            }
                }
                else if (_ifShopOrTuanGou == taunGouClass) {
                    [cell taunGouM:goodM number:orderM.orderItemInfoList.count];
                }
            }
            return cell;
            
            
        }
        else
        {
            
            BuyGuiZongCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell==nil)
            {
                cell =[[BuyGuiZongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.button1.tag=indexPath.section;
            [cell.button1 addTarget:self action:@selector(DidSelectChlick:) forControlEvents:UIControlEventTouchUpInside];
            cell.button2.tag=indexPath.section;
            [cell.button2 addTarget:self action:@selector(quxiaoArr:) forControlEvents:UIControlEventTouchUpInside];
            cell.button3.tag=indexPath.section;
            
            if (_ifShopOrTuanGou ==ShopClass)
            {
                [cell setButton:shopsM tuanGouOrShangcheng:@"shangcheng"];
            }
            else
            {
                [cell setButton:shopsM tuanGouOrShangcheng:@"tuangou"];
            }
            
            return cell;
            
        }

    }
    else
    {
        NSArray *shopArr = shopsM.orderSubInfoList;
        if ([NSArray isArrEmptyOrNull:shopArr]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            return cell;
        }
        
        MineBuyorderM *orderM = shopArr[0];
        if (indexPath.row ==0)
        {
            
            BuyCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (cell==nil)
            {
                cell=[[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSArray *shopArr = shopsM.orderSubInfoList;
            if (![NSArray isArrEmptyOrNull:shopArr]) {
                MineBuyorderM *orderM = shopArr[0];
                MineBuyGoodM *goodM = orderM.orderItemInfoList[indexPath.row];
                
                if (_ifShopOrTuanGou ==ShopClass)
                {
                    if (goodM.isShiti) {
                        [cell getShitiBuyM:goodM];
                    }
                    //            else {
                    //                [cell getXuliBuyM:goodM];
                    //            }
                }
                else if (_ifShopOrTuanGou == taunGouClass) {
                    [cell taunGouM:goodM number:orderM.orderItemInfoList.count];
                }
            }
            return cell;
            
            
        }
        else
        {
            
            BuyGuiZongCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell==nil)
            {
                cell =[[BuyGuiZongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.button1.tag=indexPath.section;
            [cell.button1 addTarget:self action:@selector(DidSelectChlick:) forControlEvents:UIControlEventTouchUpInside];
            cell.button2.tag=indexPath.section;
            [cell.button2 addTarget:self action:@selector(quxiaoArr:) forControlEvents:UIControlEventTouchUpInside];
            cell.button3.tag=indexPath.section;
            
            if (_ifShopOrTuanGou ==ShopClass)
            {
                [cell setButton:shopsM tuanGouOrShangcheng:@"shangcheng"];
            }
            else
            {
                [cell setButton:shopsM tuanGouOrShangcheng:@"tuangou"];
            }
            
            
            return cell;
            
        }

    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.section;
    if (_ifShopOrTuanGou ==ShopClass)
    {
        MineBuyShopsM *shopM = [[self orderArrForShopType] objectAtIndex:indexPath.section];
        NSArray *shopArr = shopM.orderSubInfoList;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
        StayPaymentViewController *staypayMent =[[StayPaymentViewController alloc]init];
        staypayMent.mineshopsM = shopM;
        staypayMent.buySuccessBlock=^()
        {
            [self resetUpdate];
        };
        
        if (![NSArray isArrEmptyOrNull:shopArr]) {
            MineBuyorderM *orderM = shopArr[0];
            staypayMent.mineorderM =orderM;
        }
        
        [self.navigationController pushViewController:staypayMent animated:YES];
    }
    else
    {
        
        MineBuyShopsM *shopM = [[self orderArrForShopType] objectAtIndex:indexPath.section];
        NSArray *shopArr = shopM.orderSubInfoList;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
        
        GrouponDetailsVC *grouponVc =[[GrouponDetailsVC alloc]init];
        grouponVc.mineshopsM = shopM;
        grouponVc.tuanGouSuccessBlock=^()
        {
            [self resetUpdate];
        };
        
        if (![NSArray isArrEmptyOrNull:shopArr]) {
            MineBuyorderM *orderM = shopArr[0];
            grouponVc.mineorderM =orderM;
        }
        
        [self.navigationController pushViewController:grouponVc animated:YES];
    }
}

//立即购买或者删除
-(void)DidSelectChlick:(UIButton *)button
{
    //判断是虚拟订单还是实体订单，如果是虚拟订单直接请求删除
   shopsMM =[[self orderArrForShopType] objectAtIndex:button.tag];
    if ([NSArray isArrEmptyOrNull:shopsMM.orderSubInfoList]) {
        return;
    }
    
    MineBuyorderM *orderM =[shopsMM.orderSubInfoList objectAtIndex:0];
    
    NSString *statusPayStr =[NSString stringWithFormat:@"%@",shopsMM.statusTotal];
    if ([statusPayStr isEqualToString:@"0130"] )//待付款
    {
        LiJiFuKuanVC *ljfk =[[LiJiFuKuanVC alloc]init];
        ljfk.buyshopsM=shopsMM;
        ljfk.mobPhoneNum=orderM.mobPhoneNum;
        ljfk.paySuccessBlock=^()
        {
            [self resetUpdate];
        };
        [self.navigationController pushViewController:ljfk animated:YES];

    }
    else if ([statusPayStr isEqualToString:@"0131"])//已取消
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0120"])//已支付
    {
       
    }
    else if ([statusPayStr isEqualToString:@"0170"])//待收货
    {
        //NSLog(@"待收货");
        
        ConfirmAlertView =[[UIAlertView alloc]initWithTitle:nil message:@"亲，您收到货了吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
        [ConfirmAlertView show];
    }
    else if ([statusPayStr isEqualToString:@"0180"])//待评价
    {
        NSLog(@"待评价");
        GoodsShopsCommentsVC *gsCommentVc= [GoodsShopsCommentsVC new];
        if (_ifShopOrTuanGou==ShopClass)
        {
            gsCommentVc.ifTgorSc =ScClass;
        }
        else
        {
            gsCommentVc.ifTgorSc =TgClass;
        }
        gsCommentVc.orderM=orderM;
        gsCommentVc.mineshopsM = shopsMM;
        gsCommentVc.commentSuccessBlock=^()
        {
            [self resetUpdate];
        };
        
        [self.navigationController pushViewController:gsCommentVc animated:YES];

    }
    else if ([statusPayStr isEqualToString:@"0172"])//退款驳回
    {
        [self wuLiu:orderM];
    }
    else if ([statusPayStr isEqualToString:@"0173"])//订单退款中
    {
        [self wuLiu:orderM];
    }
    else if ([statusPayStr isEqualToString:@"0174"])//订单退款完成
    {
        [self wuLiu:orderM];
    }
    else if ([statusPayStr isEqualToString:@"0182"])//已完成
    {
        [self wuLiu:orderM];
    }

    
    
}


-(void)quxiaoArr:(UIButton *)button
{
    [self resetUpdate];
    MineBuyShopsM *shopsM =[[self orderArrForShopType] objectAtIndex:button.tag];
    cancelorderM=[shopsM.orderSubInfoList objectAtIndex:0];
    NSLog(@"merchantName  =%@,shopsM.orderNo = %@,cancelorderM.deliveryMerchantType = %@",shopsM.merchantName,cancelorderM.deliveryMerchantNo,cancelorderM.deliveryMerchantType);
    NSString *statusPayStr =[NSString stringWithFormat:@"%@",shopsM.statusTotal];
    if ([statusPayStr isEqualToString:@"0130"] )//待付款
    {
        cancelOreder =[[UIAlertView alloc]initWithTitle:nil message:M_MINEBUY_CANCELORDER delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认", nil];
        [cancelOreder show];
    }
    else if ([statusPayStr isEqualToString:@"0131"])//已取消
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0120"])//已支付
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0170"])//待收货
    {
        [self wuLiu:cancelorderM];
        
    }
    else if ([statusPayStr isEqualToString:@"0180"])//待评价
    {
        [self wuLiu:cancelorderM];
    }
    else if ([statusPayStr isEqualToString:@"0182"])//交易成功
    {
        
    }
    
}

//-(void)paymentArr:(UIButton *)but
//{
//    UIButton *button =(UIButton *)but;
//    NSLog(@"%ld",button.tag);
//}
-(void)wuLiu:(MineBuyorderM *)cancelorderMM
{
    if ([cancelorderMM.deliveryMerchantType isEqualToString:@"0022"])
    {
        wuLiuAlert =[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"该商品为商家自己配送，可拨打商家电话查询配送情况！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [wuLiuAlert show];
    }
    else if([NSString isEmptyOrNull:cancelorderMM.deliveryMerchantNo])
    {
        UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"没有快递单号" message:@"请联系商家！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [aler show];
    }
    else
    {
        NSLog(@"待收货");
        WebVC *logisticsvc = [WebVC new];
        logisticsvc.title = @"物流";
        NSString *urlStr =[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@#result",cancelorderMM.deliveryMerchantType,cancelorderMM.deliveryMerchantNo];
        logisticsvc.webURL = urlStr;
        [self.navigationController pushViewController:logisticsvc animated:YES];
    }

}


#pragma mark -UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView ==cancelOreder)
    {
        if (buttonIndex==1)
        {
            [AppUtils showProgressMessage:@"取消订单中"];
            QuXiaoDindanModel *quxiaoM =[QuXiaoDindanModel new];
            QuxiaoDindanHandler *quxiaoH =[QuxiaoDindanHandler new];
            quxiaoM.orderSubNo =cancelorderM.orderSubNo;
            [quxiaoH CancelDindan:quxiaoM success:^(id obj) {
                buyH.isAllBuyUpdate = YES;
                buyH.isPaymentUpdate = YES;
                if (_ifShopOrTuanGou == ShopClass)
                {
                    [self buyRefreshingNeedUpdate];
                }
                else
                {
                    [self tuanGouRefreshingNeedUpdate];
                }
                [AppUtils showSuccessMessage:obj];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
            }];
        }
    }
    else if (alertView==ConfirmAlertView)
    {
        if(buttonIndex==1)
        {
            DeleteDingdanHandler *querenH =[DeleteDingdanHandler new];
            DeleteDingdanModel   *querenM =[DeleteDingdanModel new];
            querenM.memberNo =[UserManager shareManager].userModel.memberId;
            querenM.orderNo = shopsMM.orderNo;
            
            [querenH AffirmConsignee:querenM success:^(id obj) {
                buyH.isGoodsUpdate = YES;
                buyH.isAllBuyUpdate= YES;
                [self buyRefreshingNeedUpdate];
                [AppUtils showAlertMessageTimerClose:@"已确认收货"];
            } failed:^(id obj) {
                [AppUtils showAlertMessageTimerClose:obj];
            }];
        }
    }
}

@end
