//
//  PayDoneShangCheng.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PayDoneShangCheng.h"
#import "OrderGoodslistCell.h"
#import "StoreViewController.h"
#import "OrderClickCell.h"
#import "BuyHandel.h"
#import "MineBuyShopsM.h"
#import "SearchOrderDetailHandel.h"
#import "OrderSearchModel.h"
#import "StayPaymentViewController.h"
#import "MineBuyShopsM.h"
#import "UserManager.h"
#import "BuyHandel.h"
#import "MineBuyShopsM.h"
#import "MineBuyorderM.h"
#import "MineBuyShiGoodM.h"
#import "LifeCircleVC.h"
#import "CollectionViewtroller.h"
#import "TGPayDoneViewController.h"
#import "BuyViewController.h"

@interface PayDoneShangCheng ()<UITableViewDelegate,UITableViewDataSource,SeeOrderDetail>
{
    __weak IBOutlet UITableView *goodsinfo;
    int viewwidth;
    int viewheight;
    
    UIView * headView;
    UILabel * chaifenLable;
    BuyHandel *buyH;
}

@end

@implementation PayDoneShangCheng

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"订单数组>>>>>%@",self.orderlist);
    
    self.title = @"支付成功";
    
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
    
    [goodsinfo registerNib:[UINib nibWithNibName:@"OrderClickCell" bundle:nil] forCellReuseIdentifier:@"clickCell"];
    
    goodsinfo.delegate = self;
    goodsinfo.dataSource = self;
    
    [self setExtraCellLineHidden:goodsinfo];
    [self viewDidLayoutSubviewsForTableView:goodsinfo];
    

    CGFloat  headViewHeight;
    if (_orderlist.count > 1) {
        headViewHeight = 180;
    }else{
        headViewHeight = 150;
    }
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewwidth, headViewHeight)];
    goodsinfo.tableHeaderView = headView;
    
    //成功图标
    UIImageView * stateImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewwidth/2 -25, 10, 50, 50)];
    stateImage.image = [UIImage imageNamed:@"gouda"];
    [headView addSubview:stateImage];
    
    UILabel * totalPriceLable = [[UILabel alloc] initWithFrame:CGRectMake(30, stateImage.frame.size.height + stateImage.frame.origin.y + 10, viewwidth - 60, 30)];
    totalPriceLable.textAlignment = NSTextAlignmentCenter;
    totalPriceLable.text = [NSString stringWithFormat:@"成功支付%@元",_totalPrice];
    [headView addSubview:totalPriceLable];
    
    
    UILabel * mydesc = [[UILabel alloc] initWithFrame:CGRectMake(10, totalPriceLable.frame.origin.y + totalPriceLable.frame.size.height, viewwidth - 20, 30)];
    mydesc.textAlignment = NSTextAlignmentLeft;
    mydesc.font = [UIFont systemFontOfSize:15];
    mydesc.text = @"我们会尽快为您配送,祝您购物愉快";
    [headView addSubview:mydesc];
    
    //此处高度 = 130
    
    if (_orderlist.count > 1) {
        //此处要加判断
        chaifenLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 130 , viewwidth - 20, 50)];
        chaifenLable.textAlignment = NSTextAlignmentLeft;
        chaifenLable.numberOfLines = 0;
        chaifenLable.text = @"您的商品属于不同商家,系统自动拆分为以下订单,并分开为您配送!";
        chaifenLable.font = [UIFont systemFontOfSize:15];
        [headView addSubview:chaifenLable];
    }else{

    }

    UIBarButtonItem * baritem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(payDoneOrder)];
    self.navigationItem.rightBarButtonItem = baritem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderlist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderClickCell * cell = [tableView dequeueReusableCellWithIdentifier:@"clickCell"];
    cell.orderDelegate = self;
    if (cell == nil) {
        cell = [[OrderClickCell alloc] init];
    }
    [cell setCellData:_orderlist[indexPath.row]];
    return cell;
}

//需要判断从商家进入还是商品
- (void)payDoneOrder{
    for (UIViewController * controller in self.navigationController.viewControllers) {//
        //从晚上商城列表进入
        if ([controller isKindOfClass:[StoreViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
        
        //从我的订单进来
        if ([controller isKindOfClass:[BuyViewController class]]) {
            BuyViewController * myBuy = (BuyViewController *)controller;
            myBuy.ifShopOrTuanGou = ShopClass;
            [self.navigationController popToViewController:myBuy animated:YES];
            return;
        }
        
        //从我的收藏进来
        if ([controller isKindOfClass:[CollectionViewtroller class]]) {
            CollectionViewtroller * mycoll = (CollectionViewtroller *)controller;
            [self.navigationController popToViewController:mycoll animated:YES];
            return;
        }
        
        // 从生活圈进来
        if ([controller isKindOfClass:[LifeCircleVC class]]) {
            LifeCircleVC * mycoll = (LifeCircleVC *)controller;
            [self.navigationController popToViewController:mycoll animated:YES];
            return;
        }
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

//查看订单详情,请求成功后跳转到详情页面
- (void)lookOrderDetail:(NSString *)orderStr{
    
    
    [AppUtils showProgressMessage:@"正在查询..." withType:SVProgressHUDMaskTypeClear];
    
    NSLog(@"%@",orderStr);

    MineBuyShopsM *buyM =[MineBuyShopsM new];
    buyM.pageNumber=@"1";
    buyM.pageSize=@"5";
    buyM.orderBy = @"orderTime";
    buyM.orderType = @"desc";
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 orderStr,@"orderNo",
                                 nil];
    
    buyM.queryMap =queryMapDic;
    
    buyH =[BuyHandel new];
    [buyH postAllBuyList:buyM success:^(id obj) {
        
        
        NSLog(@"%@",obj);
        
        [SVProgressHUD dismiss];

        NSMutableArray * myArray= (NSMutableArray *)obj;
        
        
        MineBuyShopsM *shopM = [myArray objectAtIndex:0];;
        NSArray *shopArr = shopM.orderSubInfoList;
        
        StayPaymentViewController *staypayMent =[[StayPaymentViewController alloc]init];
        staypayMent.mineshopsM = shopM;
        if (![NSArray isArrEmptyOrNull:shopArr]) {
            MineBuyorderM *orderM = shopArr[0];
            staypayMent.mineorderM =orderM;
            
        }
        
        [self.navigationController pushViewController:staypayMent animated:YES];
        
    } failed:^(id obj) {
        [SVProgressHUD dismiss];
    } isHeader:YES];
}






//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
