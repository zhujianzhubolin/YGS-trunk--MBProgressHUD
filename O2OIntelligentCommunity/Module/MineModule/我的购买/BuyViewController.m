//
//  BuyViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#ifdef SmartComJYZX

#elif SmartComYGS
    typedef NS_ENUM(NSUInteger, TuanGouType) {
        TuangouTypeAll,
        TuangouTypeEnable
    };

    typedef NS_ENUM(NSUInteger, ShangChengPerhapsTaunGou){
        ShopClass,
        taunGouClass
        
    };

#else

#endif


typedef NS_ENUM(NSUInteger, ShopType) {
    ShopTypeAll,
    ShopTypeWaitPay ,
    ShopTypeWaitShouhuo,
    ShopTypeWaitPingjia
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
#import "LogisticsVC.h"
#import "GoodsShopsCommentsVC.h"

//#import "LogisticsVC.h"
#import "ZJWebProgrssView.h"

#ifdef SmartComJYZX

#elif SmartComYGS
#import "GrouponDetailsVC.h"
#else

#endif


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
#ifdef SmartComJYZX
    
#elif SmartComYGS
    UITableView *tuanGouAllTB;
    UITableView *tuanGouEnableTB;
    TopTabControl *tuanGoutabCtrl;
    TuanGouType tgouType;
    ShangChengPerhapsTaunGou ifShopOrTuanGou;
    UISegmentedControl *segmentedControl;
    
    
#else
    
#endif

    
   

   
    
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
    ShopType currentType;
    
    
    ZJWebProgrssView *progrssV;
    BuyHandel *buyH;
    
    NSArray *segmentedArray;
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#ifdef SmartComJYZX
        [self buyRefreshingNeedUpdate];
#elif SmartComYGS
        [self refreshData];
#else
        
#endif
        
    });
}

- (void)refreshData {
    
#ifdef SmartComJYZX
    [self resetUpdate];
    [self buyRefreshingNeedUpdate];
#elif SmartComYGS
    [self resetUpdate];
    [self buyRefreshingNeedUpdate];
    if (ifShopOrTuanGou == ShopClass)
    {
        [self buyRefreshingNeedUpdate];
    }
    else if (ifShopOrTuanGou == taunGouClass)
    {
        [self tuanGouRefreshingNeedUpdate];
    }

#else
    
#endif

}

-(void)initData
{
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
    segmentedArray     = [NSArray arrayWithObjects:@"商城",@"团购", nil];
    allTuanGouArray    = [NSMutableArray array];
    evaluateTuanGouArray = [NSMutableArray array];
    tgouType = TuangouTypeAll;
    ifShopOrTuanGou =ShopClass;

#else
    
#endif

    allOrderArray = [NSMutableArray array];
    payMentOrderArray  = [NSMutableArray array];
    goodsOrderArray    = [NSMutableArray array];
    evaluateOrderArray = [NSMutableArray array];
    
    buyH =[BuyHandel new];
    if ([self.ispay isEqualToString:@"YES"])
    {
        currentType = ShopTypeWaitPay;
    }
    else
    {
        currentType = ShopTypeAll;
    }
    [self resetUpdate];
}


//订单
-(void)buyRefreshingNeedUpdate
{
    switch (currentType) {
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
                [self startNetworkGetShopsIsHeader3:YES];
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
#ifdef SmartComJYZX
    switch (currentType) {
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
#elif SmartComYGS
    if (ifShopOrTuanGou==ShopClass)
    {
        switch (currentType) {
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
    else if (ifShopOrTuanGou ==taunGouClass)
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
    
#else
    
#endif

    
}

- (void)resetUpdate {
    buyH.isAllBuyUpdate = YES;
    buyH.isPaymentUpdate = YES;
    buyH.isGoodsUpdate = YES;
    buyH.isEvaluatBuyUpdate = YES;
    buyH.isAllTuanGouUpdate= YES;
    buyH.isEnableTuanGouUpdate=YES;
}

-(void)initUI
{
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 0, 25, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backRootVC) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backItem;
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                                                               self.view.frame.size.width,
                                                               50)];
    [self.view addSubview:headerV];
    
    
    
    
    
#ifdef SmartComJYZX
    self.title = @"我的购买";
    buytoptabCtrl = [[TopTabControl alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    buytoptabCtrl.datasource = self;
    buytoptabCtrl.showIndicatorView = YES;
    [buytoptabCtrl reloadData];
    [self.view addSubview:buytoptabCtrl];
    __block __typeof(self)weakSelf = self;
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
    if ([self.ispay isEqualToString:@"YES"])
    {
        [buytoptabCtrl displayPageAtIndex:1];
    }



#elif SmartComYGS
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
    
    
    __block __typeof(self)weakSelf = self;
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
    if ([self.ispay isEqualToString:@"YES"])
    {
        [buytoptabCtrl displayPageAtIndex:1];
    }


    
#else
    
#endif
    
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

#ifdef SmartComJYZX

#elif SmartComYGS

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

-(void)segmentAction:(UISegmentedControl *)Seg
{
    [progrssV startAnimation];

    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            buytoptabCtrl.hidden=NO;
            tuanGoutabCtrl.hidden=YES;
            ifShopOrTuanGou =ShopClass;
            [buytoptabCtrl addSubview:progrssV];
        }
            NSLog(@"1");
            break;
        case 1:
        {
            tuanGoutabCtrl.hidden=NO;
            buytoptabCtrl.hidden=YES;
            ifShopOrTuanGou =taunGouClass;
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
    NSLog(@"tuanGouChangeClick sender.tag = %d",sender.tag);
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


//团购订单查询
-(void)startNetworkGetTuanGouIsHeader2:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"7151",@"memberNo",
                                 @"GROUP_BUY",@"orderType",
                                 @"0120",@"statusTotal",
                                 nil];
    buyM.queryMap =queryMapDic;
    
    [buyH postEnableTuanGouList:buyM success:^(id obj) {
        buyH.isEnableTuanGouUpdate = NO;
        evaluateTuanGouArray =(NSMutableArray *)obj;
        [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:evaluateTuanGouArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:evaluateTB];
        [evaluateTB reloadData];
    } failed:^(id obj) {
        buyH.isEnableTuanGouUpdate = YES;
        [AppUtils tableViewEndMJRefreshWithTableV:evaluateTB];
        [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:evaluateTuanGouArray]];
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
                                 [UserManager shareManager].comModel.merberId,@"memberNo",
                                 @"GROUP_BUY",@"orderType",
                                 nil];
    buyM.queryMap =queryMapDic;
    
    [buyH postAllTuanGouList:buyM success:^(id obj) {
        buyH.isAllTuanGouUpdate = NO;
        allTuanGouArray =(NSMutableArray *)obj;
        [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:allTuanGouArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:allTB];
        [tuanGouAllTB reloadData];
    } failed:^(id obj) {
        buyH.isAllTuanGouUpdate = YES;
        [AppUtils tableViewEndMJRefreshWithTableV:allTB];
        [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:allTuanGouArray]];
    } isHeader:isHeader];
}



#else

#endif



- (void)buyChangeClick:(UIButton *)sender {
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
        currentType = ShopTypeAll;
        buyH.isAllBuyUpdate = YES;
    }
    else if (sender.tag==501)
    {
        currentType = ShopTypeWaitPay;
        buyH.isPaymentUpdate = YES;
    }
    else if(sender.tag==502)
    {
        currentType = ShopTypeWaitShouhuo;
        buyH.isGoodsUpdate = YES;
    }
    else if (sender.tag==503)
    {
        currentType = ShopTypeWaitPingjia;
        buyH.isEvaluatBuyUpdate = YES;
    }
    
    [self buyRefreshingNeedUpdate];
}





-(void)startNetworkGetShopsIsHeader1:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";

    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].comModel.merberId,@"memberNo",
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

-(void)startNetworkGetShopsIsHeader2:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.isDeleted=@"0";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].comModel.merberId,
                                 @"0130",@"statusTotal",
                                 @"GENERAL",@"orderType",//取实体订单
                                 nil];
    
    buyM.queryMap =queryMapDic;
    
    [buyH postPaymentBuyList:buyM success:^(id obj) {
        buyH.isPaymentUpdate = NO;
        payMentOrderArray =(NSMutableArray *)obj;
        [AppUtils tableViewEndMJRefreshWithTableV:paymentTB];
        [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:payMentOrderArray]];
        [paymentTB reloadData];

    } failed:^(id obj) {
        buyH.isPaymentUpdate = YES;
        [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:payMentOrderArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:paymentTB];
    } isHeader:isHeader];
}
-(void)startNetworkGetShopsIsHeader3:(BOOL)isHeader
{
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.isDeleted=@"0";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].comModel.merberId,@"memberNo",
                                 @"0170",@"statusTotal",
                                 @"GENERAL",@"orderType",//取实体订单
                                 nil];
    
    buyM.queryMap =queryMapDic;
    
    [buyH postGoodsBuyList:buyM success:^(id obj) {
        buyH.isGoodsUpdate = NO;
        goodsOrderArray =(NSMutableArray *)obj;
        [AppUtils tableViewEndMJRefreshWithTableV:goodsTB];
        [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:goodsOrderArray]];
        [goodsTB reloadData];
    } failed:^(id obj) {
        buyH.isGoodsUpdate = YES;
        [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:goodsOrderArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:goodsTB];
     } isHeader:isHeader];
}
-(void)startNetworkGetShopsIsHeader4:(BOOL)isHeader
{
    
    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"10";
    buyM.isDeleted=@"0";
    buyM.orderBy=@"orderTime";
    buyM.orderType=@"desc";
    
    
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UserManager shareManager].comModel.merberId,@"memberNo",
                                 @"0180",@"statusTotal",
                                 @"GENERAL",@"orderType",//取实体订单
                                 nil];
    
    buyM.queryMap =queryMapDic;
    
    [buyH postEvaluateBuyList:buyM success:^(id obj) {
        buyH.isEvaluatBuyUpdate = NO;
        evaluateOrderArray =(NSMutableArray *)obj;
        [AppUtils tableViewEndMJRefreshWithTableV:evaluateTB];
        [progrssV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:evaluateOrderArray]];
        [evaluateTB reloadData];
    } failed:^(id obj) {
        buyH.isEvaluatBuyUpdate = YES;
        [progrssV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:evaluateOrderArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:evaluateTB];
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
    
#ifdef SmartComJYZX
    return IPHONE_WIDTH/4;
#elif SmartComYGS
    if (tabCtrl == tuanGoutabCtrl)
    {
        return IPHONE_WIDTH/2;
    }
    else
    {
        return IPHONE_WIDTH/4;
    }

#else
    
#endif
}
- (NSInteger)TopTabMenuCount:(TopTabControl *)tabCtrl{
    
#ifdef SmartComJYZX
    return 4;
#elif SmartComYGS
    if (tabCtrl==tuanGoutabCtrl)
    {
        return 2;
    }
    else
    {
        return 4;
    }

#else
    
#endif
    
}

-(TopTabMenuItem *)TopTabControl:(TopTabControl *)tabCtrl itemAtIndex:(NSUInteger)index
{
#ifdef SmartComJYZX
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
            if ([self.ispay isEqualToString:@"YES"])
            {
                allBtn.selected = NO;
            }
            else{
                allBtn.selected=YES;
            }
            
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
            if ([self.ispay isEqualToString:@"YES"])
            {
                paymentBtn.selected = YES;
            }
            else{
                paymentBtn.selected=NO;
            }
            
            
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
            goodsBtn.selected = NO;
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
            evaluateBtn.selected = NO;
            [topItem addSubview:evaluateBtn];
            return topItem;
        }
            break;
        default:
            break;
    }
    return topItem;

#elif SmartComYGS
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
                if ([self.ispay isEqualToString:@"YES"])
                {
                    allBtn.selected = NO;
                }
                else{
                    allBtn.selected=YES;
                }
                
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
                if ([self.ispay isEqualToString:@"YES"])
                {
                    paymentBtn.selected = YES;
                }
                else{
                    paymentBtn.selected=NO;
                }
                
                
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
                goodsBtn.selected = NO;
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
                evaluateBtn.selected = NO;
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
                allBtn.selected=YES;
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
                 paymentBtn.selected=NO;
                
                [tuanGouItem addSubview:paymentBtn];
                return tuanGouItem;
            }
                break;
            default:
                break;
        }
        return tuanGouItem;
        
    }

#else
    
#endif
    
}

-(TopTabPage *)TopTabControl:(TopTabControl *)tabCtrl pageAtIndex:(NSUInteger)index
{
    
#ifdef SmartComJYZX
    TopTabPage *page = [[TopTabPage alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    tabCtrl.frame.size.width,
                                                                    tabCtrl.frame.size.height - TAB_ITEM_HEIGHT
                                                                    )];

    
    //    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, page.frame.size.width, 2)];
    //    headview.backgroundColor = [UIColor lightGrayColor];

    if (index==0)
    {
        allTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
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
        paymentTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
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
        goodsTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
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
        evaluateTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
        
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

#elif SmartComYGS
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
            allTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
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
            paymentTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
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
            goodsTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
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
            evaluateTB = [[UITableView alloc] initWithFrame:page.bounds style:UITableViewStylePlain];
            
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
            tuanGouAllTB = [[UITableView alloc] initWithFrame:tuanGouPage.bounds style:UITableViewStylePlain];
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
            tuanGouEnableTB = [[UITableView alloc] initWithFrame:tuanGouPage.bounds style:UITableViewStylePlain];
            tuanGouEnableTB.dataSource=self;
            tuanGouEnableTB.delegate=self;
            [tuanGouPage addSubview:tuanGouEnableTB];
            //paymentTB.tableHeaderView=headview;
            [self viewDidLayoutSubviewsForTableView:tuanGouEnableTB];
            paymentTB.tableFooterView = [AppUtils tableViewsFooterView];
            __block __typeof(self)taunGouTableview =self;
            
            [paymentTB addLegendHeaderWithRefreshingBlock:^{
                [taunGouTableview startNetworkGetTuanGouIsHeader2:YES];//下啦刷新
            }];
            
            [paymentTB addLegendFooterWithRefreshingBlock:^{
                [taunGouTableview startNetworkGetTuanGouIsHeader2:NO];//上拉刷新
            }];
            
        }
        return tuanGouPage;

    }
    else
    {
        return nil;
    }
#else
    
#endif
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
    
#ifdef SmartComJYZX
    if (tableView ==allTB)
    {
        return allOrderArray.count;
    }
    else if (tableView==paymentTB)
    {
        return payMentOrderArray.count;
    }
    else if (tableView==goodsTB)
    {
        return goodsOrderArray.count;
    }
    else
    {
        return evaluateOrderArray.count;
    }

#elif SmartComYGS
    
    if (ifShopOrTuanGou == ShopClass)
    {
        if (tableView ==allTB)
        {
            return allOrderArray.count;
        }
        else if (tableView==paymentTB)
        {
            return payMentOrderArray.count;
        }
        else if (tableView==goodsTB)
        {
            return goodsOrderArray.count;
        }
        else
        {
            return evaluateOrderArray.count;
        }

    }
    else
    {
        if (tableView == tuanGouAllTB)
        {
            return allTuanGouArray.count;
        }
        else if (tableView == tuanGouEnableTB)
        {
            return evaluateTuanGouArray.count;
        }
        else
        {
            return 0;
        }
    }
    
#else
    
#endif

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
#ifdef SmartComJYZX
    MineBuyShopsM *shopM;
    MineBuyorderM *orderM;
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
#elif SmartComYGS
    MineBuyShopsM *shopM;
    MineBuyorderM *orderM;
    if(ifShopOrTuanGou == ShopClass)
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

    }
    else
    {
        if (tableView == tuanGouAllTB)
        {
            shopM= allTuanGouArray[section];
        }
        else if (tableView == evaluateTB)
        {
            shopM = evaluateTuanGouArray[section];
        }
    }
    
    NSArray *shopArr = shopM.orderSubInfoList;
    if (![NSArray isArrEmptyOrNull:shopArr])
    {
        orderM = shopArr[0];
    }
    return orderM.orderItemInfoList.count+1;
#else
    
#endif
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MineBuyShopsM *shopsM;
#ifdef SmartComJYZX
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

#elif SmartComYGS
    if (ifShopOrTuanGou == ShopClass)
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
        else if (tableView == evaluateTB)
        {
            shopsM = [evaluateTuanGouArray objectAtIndex:section];
        }
        else
        {
            return 0;
        }
    }
    
    
#else
    
#endif
    
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    view.backgroundColor = [AppUtils colorWithHexString:@"EDEFEB"];
    
    CGFloat dealstateLWidth = 80;
    CGFloat interval = 10;
    UILabel *dealstateLabe = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - dealstateLWidth - interval, 0, dealstateLWidth, 25)];
    NSString *statusPayStr =[NSString stringWithFormat:@"%@",shopsM.statusTotal];
    if ([statusPayStr isEqualToString:@"0130"] )
    {
        dealstateLabe.text=@"待付款";
    }
    else if ([statusPayStr isEqualToString:@"0131"])
    {
        dealstateLabe.text =@"已取消";
    }
    else if ([statusPayStr isEqualToString:@"0120"])
    {
        dealstateLabe.text =@"等待发货";
    }
    else if ([statusPayStr isEqualToString:@"0170"])
    {
        dealstateLabe.text =@"待收货";
    }
    else if ([statusPayStr isEqualToString:@"0180"])
    {
        dealstateLabe.text =@"待评价";
    }
    else if ([statusPayStr isEqualToString:@"0182"])
    {
        dealstateLabe.text =@"交易成功";
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
#ifdef SmartComJYZX
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

#elif SmartComYGS
    
    if (ifShopOrTuanGou == ShopClass)
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
    else
    {
        if(tableView == tuanGouAllTB)
        {
            shopsM = [allTuanGouArray objectAtIndex:indexPath.section];
        }
        else if(tableView == evaluateTB)
        {
            shopsM = [evaluateTuanGouArray objectAtIndex:indexPath.section];
        }

        
    }
    
    
#else
    
#endif

    
    NSArray *shopArr = shopsM.orderSubInfoList;
    
    if (![NSArray isArrEmptyOrNull:shopArr]) {
        MineBuyorderM *orderM = shopArr[0];
        if (orderM.orderItemInfoList.count == indexPath.row)
        {
             NSString *statusStr =[NSString stringWithFormat:@"%@",shopsM.statusTotal];
            if ([statusStr isEqualToString:@"0130"] )//待付款
            {
                return 70;
            }
            else if ([statusStr isEqualToString:@"0131"])//已取消
            {
                return 30;
            }
            else if ([statusStr isEqualToString:@"0120"])//已支付
            {
                return 30;
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
                return 30;
                
            }
            else {
                return 0;
            }
        }
        else {
            return 90;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineBuyShopsM *shopsM;
#ifdef SmartComJYZX
    
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
    
#elif SmartComYGS
    
    
    if (ifShopOrTuanGou == ShopClass)
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
        else if(tableView == evaluateTB)
        {
            shopsM = [evaluateTuanGouArray objectAtIndex:indexPath.section];
        }

    }
    
    
#else
    
#endif
    
        NSArray *shopArr = shopsM.orderSubInfoList;
    if ([NSArray isArrEmptyOrNull:shopArr]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        }
        return cell;
    }
    
    MineBuyorderM *orderM = shopArr[0];
    if (indexPath.row == orderM.orderItemInfoList.count)
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
        
        [cell setButton:shopsM];
       
        return cell;
        
    }
    else
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
            
            
#ifdef SmartComJYZX
            if (goodM.isShiti) {
                [cell getShitiBuyM:goodM];
            }

#elif SmartComYGS
            if (ifShopOrTuanGou ==ShopClass)
            {
                if (goodM.isShiti) {
                    [cell getShitiBuyM:goodM];
                }
                //            else {
                //                [cell getXuliBuyM:goodM];
                //            }
                
            }
            else if (ifShopOrTuanGou == taunGouClass)
            {
                [cell taunGouM:goodM];
            }

#else
            
#endif

        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     selectedRow = indexPath.section;
#ifdef SmartComJYZX
   
    
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

#elif SmartComYGS
    
    if (ifShopOrTuanGou ==ShopClass)
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
    
   

#else
    
#endif

}

//立即购买或者删除
-(void)DidSelectChlick:(UIButton *)button
{
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
    
#else
    
#endif

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
        gsCommentVc.orderM=orderM;
        gsCommentVc.mineshopsM = shopsMM;
        gsCommentVc.commentSuccessBlock=^()
        {
           [self resetUpdate];
        };

        [self.navigationController pushViewController:gsCommentVc animated:YES];
    }
    else if ([statusPayStr isEqualToString:@"0182"])//交易成功
    {
     
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
        if ([cancelorderM.deliveryMerchantType isEqualToString:@"0022"])
        {
            wuLiuAlert =[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"该商品为商家自己配送，可拨打商家电话查询配送情况！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [wuLiuAlert show];
        }
        else if([NSString isEmptyOrNull:cancelorderM.deliveryMerchantNo])
        {
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"没有快递单号" message:@"请联系商家！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [aler show];
        }
        else
        {
            NSLog(@"待收货");
            LogisticsVC *logisticsvc =[[LogisticsVC alloc]init];
            logisticsvc.aliasOrderNo=cancelorderM.deliveryMerchantNo;
            logisticsvc.deliveryMerchantType=cancelorderM.deliveryMerchantType;
            [self.navigationController pushViewController:logisticsvc animated:YES];
        }
        
        
    }
    else if ([statusPayStr isEqualToString:@"0180"])//待评价
    {
        NSLog(@"待评价");
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
                [self buyRefreshingNeedUpdate];
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
            querenM.memberNo =[UserManager shareManager].comModel.merberId;
            querenM.orderNo = shopsMM.orderNo;
            
            [querenH AffirmConsignee:querenM success:^(id obj) {
                buyH.isGoodsUpdate = YES;
                [self buyRefreshingNeedUpdate];
                [AppUtils showAlertMessageTimerClose:@"已确认收货"];
            } failed:^(id obj) {
                [AppUtils showAlertMessageTimerClose:obj];
            }];
        }
    }
}

@end
