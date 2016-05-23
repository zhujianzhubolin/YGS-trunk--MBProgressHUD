//
//  CollectionViewtroller.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CollectionViewtroller.h"
#import "CollectionMerchantsCell.h"
#import "CollectionShangpinCell.h"
#import "UserManager.h"
#import "TGShopDetailViewController.h"
#import "ShangChengGoodsDeatil.h"
#import <MJRefresh.h>
#import "NSString+wrapper.h"
#import "ZSDPaymentView.h"
#import "ShangChengDingDan.h"
#import "AllKuaiSongViewController.h"
#import "GoodsViewController.h"
#import "EasyDetail.h"

//获取我的收藏商品和商家接口类
#import "CollectionModel.h"
#import "MyCollectionHandler.h"
#import "ShangjiaModel.h"
#import "ZJWebProgrssView.h"
#import "TGGoodsModel.h"
#import "WTTuanGouDetail.h"

@implementation CollectionViewtroller
{
    UIView *butView;
    UIImageView *selectImageView;
    NSInteger type;
    NSMutableArray   *shopsList;//商家列表
    NSMutableArray   *goodsList;//商品列表
    NSMutableArray   *allArray;
    
    UITableView *TableView;
    ZJWebProgrssView *progressV;
    
    MyCollectionHandler *collectionH;
}

- (void)viewWillAppear:(BOOL)animated {
    [self hidetabbar];
    self.navigationController.navigationBar.translucent=YES;
   
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startNetworkGetShopsIsHeader:YES];
    });
}

-(void)initData
{
    type=0;
    shopsList =[NSMutableArray array];
    goodsList =[NSMutableArray array];
    allArray =[NSMutableArray array];
    collectionH = [MyCollectionHandler new];

}


-(void)initUI
{
    
    self.title=@"我的收藏";
    self.view.backgroundColor=[UIColor whiteColor];
    

    
    butView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 40)];
    butView.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
    NSArray *titleArr = @[@"商家",@"商品"];
    for(int i = 0; i < 2;i++)
    {
        UIButton *selectBut = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBut.frame = CGRectMake(self.view.frame.size.width/2 * i, 0, self.view.frame.size.width/2-1, TAB_ITEM_HEIGHT-1);
        selectBut.tag = 100 + i;
        selectBut.titleLabel.font = [UIFont systemFontOfSize:15];
        selectBut.backgroundColor =[UIColor whiteColor];
        selectBut.titleLabel.font=[UIFont systemFontOfSize:G_TAB_ITEM_FONT];
        [selectBut setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [selectBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[selectBut setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [selectBut addTarget:self action:@selector(selectAct:) forControlEvents:UIControlEventTouchUpInside];
        
        [butView addSubview:selectBut];
        
    }
    
    selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, TAB_ITEM_HEIGHT-1, self.view.frame.size.width/2, 2)];
    selectImageView.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
    [butView addSubview:selectImageView];
    [self.view addSubview:butView];
    
    TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-100)];
    TableView.dataSource = self;
    TableView.delegate = self;
    TableView.tableFooterView = [AppUtils tableViewsFooterView];
    TableView.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
    [self viewDidLayoutSubviewsForTableView:TableView];
    [self.view addSubview:TableView];
    
    __block __typeof(self)weakTableView = self;
    [TableView addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakTableView startNetworkGetShopsIsHeader:YES];
    }];
    
    [TableView addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakTableView startNetworkGetShopsIsHeader:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:TableView.bounds];
    [TableView addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [weakTableView startNetworkGetShopsIsHeader:YES];
    };
}

- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
    if (type==0)
        {
            ShangjiaModel *sjM =[ShangjiaModel new];
            sjM.pageSize=@"10";
            
            ShangjiaModel *queryMapM =[ShangjiaModel new];
            queryMapM.memberId=[UserManager shareManager].userModel.memberId;
            
            NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:queryMapM.memberId,@"memberId",
                                         nil];
            sjM.queryMap = queryMapDic;
            [collectionH PostSJList:sjM success:^(id obj)
            {
                collectionH.isSJUpdate=NO;
                [AppUtils tableViewEndMJRefreshWithTableV:TableView];
                
                shopsList =(NSMutableArray *)obj;
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:shopsList]];
                [TableView reloadData];
                
            } failed:^(id obj) {
                collectionH.isSJUpdate=YES;
                //[AppUtils showErrorMessage:@"获取收藏商家列表失败" isShow:self.viewIsVisible];
                [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:shopsList]];
                [AppUtils tableViewEndMJRefreshWithTableV:TableView];
            } isHeader:isHeader];
        }
        else
        {
            CollectionModel *spM =[CollectionModel new];
            spM.pageSize=@"10";
            
            CollectionModel *queryMapM =[CollectionModel new];
            queryMapM.memberId=[UserManager shareManager].userModel.memberId;
            
            NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:queryMapM.memberId,@"memberId",
                                         nil];
            spM.queryMap = queryMapDic;
            [collectionH PostSPList:spM success:^(id obj)
             {
                 //collectionH.isSPUpdate=NO;
                 [AppUtils tableViewEndMJRefreshWithTableV:TableView];
                 goodsList =(NSMutableArray *)obj;
                
                 [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:goodsList]];
                  [TableView reloadData];
            } failed:^(id obj) {
                //collectionH.isSPUpdate=YES;
                 //[AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
                 
                [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:goodsList]];
                [AppUtils tableViewEndMJRefreshWithTableV:TableView];
             } isHeader:isHeader];
        }
    
}

-(void)selectAct:(UIButton *)but
{
    type = but.tag-100;
    for(int i = 0; i < 2;i++)
    {
        UIButton *b = (UIButton *)[self.view viewWithTag:100 + i];
        if(but.tag == b.tag)
        {
            b.selected = YES;
        }
        else
        {
            b.selected = NO;
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    selectImageView.frame = CGRectMake((but.tag - 100) * self.view.frame.size.width/2, TAB_ITEM_HEIGHT-1, self.view.frame.size.width/2, 2);
    [UIView commitAnimations];
    
    [progressV startAnimation];
    [self  startNetworkGetShopsIsHeader:YES];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
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
    if (type==0)
    {
        [AppUtils tableViewFooterPromptWithPNumber:collectionH.sjCurrentPage.integerValue
                                        withPCount:collectionH.sjPageCount.integerValue
                                         forTableV:TableView];

    }
    else
    {
        [AppUtils tableViewFooterPromptWithPNumber:collectionH.spCurrentPage.integerValue
                                        withPCount:collectionH.spPageCount.integerValue
                                         forTableV:TableView];

    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV =[UIView new];
    headV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    headV.frame=CGRectMake(0, 0, tableView.frame.size.width, 2);
    return headV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (type ==0) {
        return shopsList.count;
    }
    return goodsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfier = @"CollectionMerchantsCell";
    static NSString *identfier1 = @"CollectionShangpinCell";
    
    if (type ==0)
    {
        CollectionMerchantsCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
        if(cell == nil)
        {
            cell =[[CollectionMerchantsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
        }
        [cell setdata:[shopsList objectAtIndex:indexPath.row]];
        return cell;
    }
    
    CollectionShangpinCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier1];
    if (cell == nil)
    {
        cell = [[CollectionShangpinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier1];
    }
    CollectionModel *collectionM=[goodsList objectAtIndex:indexPath.row];
    [cell setcellDic:collectionM];
    cell.immediatelyBut.tag=indexPath.row;
    [cell.immediatelyBut addTarget:self action:@selector(orederClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        [progressV startAnimation];
        if (type==0)
        {
            ShangjiaModel *shangjiaM =[shopsList objectAtIndex:indexPath.row];
            
            ShangjiaModel *delectM =[ShangjiaModel new];
            delectM.memberId=[UserManager shareManager].userModel.memberId;
            delectM.storeID=shangjiaM.ID;
            delectM.isDeleted=@"1";
            
            MyCollectionHandler * delctH = [MyCollectionHandler new];
            [delctH DeleteSJ:delectM success:^(id obj) {
                NSMutableArray *goodsArr = [shopsList mutableCopy];
                [goodsArr removeObjectAtIndex:indexPath.row];
                shopsList = [goodsArr mutableCopy];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:shopsList]];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
                [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:shopsList]];
            }];
            
        }
        else
        {
            CollectionModel *shangpinM =[goodsList objectAtIndex:indexPath.row];
            CollectionModel *spM =[CollectionModel new];
            spM.memberId =[UserManager shareManager].userModel.memberId;
            spM.ID=shangpinM.ID;
            
            MyCollectionHandler *delctH =[MyCollectionHandler new];
            [delctH DeleteSP:spM success:^(id obj) {
                [AppUtils showAlertMessageTimerClose:obj];
                NSMutableArray *goodsArr = [goodsList mutableCopy];
                [goodsArr removeObjectAtIndex:indexPath.row];
                goodsList = [goodsArr mutableCopy];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:goodsList]];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj
                                    isShow:self.viewIsVisible];
                [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:goodsList]];
            }];
        }
    }
}

-(void)orederClick:(UIButton *)sender
{
    CollectionModel *collectionM=[goodsList objectAtIndex:sender.tag];
    if ([collectionM.isMarket isEqualToString:@"ON_MARKET"])
    {
        NSMutableArray *shopsArr = [NSMutableArray array];
        NSMutableArray *goodsArr = [NSMutableArray array];
        
        //一个商品的详细数据
        NSMutableDictionary * dictentity = [NSMutableDictionary dictionary];
        [dictentity setObject:collectionM.fullMoney forKey:@"fullMoney"];
        [dictentity setObject:collectionM.ID forKey:@"id"];
        [dictentity setObject:collectionM.img forKey:@"img"];
        [dictentity setObject:collectionM.market_price forKey:@"market_price"];
        [dictentity setObject:collectionM.name forKey:@"name"];
        [dictentity setObject:collectionM.notFullMoney forKey:@"notFullMoney"];
        [dictentity setObject:collectionM.price forKey:@"price"];
        [dictentity setObject:collectionM.stock forKey:@"stock"];
        [dictentity setObject:collectionM.storeId forKey:@"storeId"];
        [dictentity setObject:collectionM.storeName forKey:@"storeName"];
        
        
        NSMutableDictionary * dictGoodsList = [NSMutableDictionary dictionary];
        [dictGoodsList setObject:dictentity forKey:@"entity"];
        
        
        //一个商家里面的一个商品
        NSMutableDictionary * goodDict = [NSMutableDictionary dictionary];
        [goodDict setObject:@"1" forKey:@"addNumber"];
        [goodDict setObject:dictGoodsList forKey:@"goodslist"];
        [goodDict setObject:collectionM.ID forKey:@"id"];
        [goodDict setObject:@"YES" forKey:@"isSelect"];
        [goodDict setObject:collectionM.name forKey:@"name"];
        [goodDict setObject:collectionM.storeId forKey:@"storeId"];
        
        [goodsArr addObject:goodDict];
        
        
        
        //一个商家的
        NSMutableDictionary * shopdict = [NSMutableDictionary dictionary];
        [shopdict setObject:goodsArr forKey:@"goodsList"];
        
        [shopsArr addObject:shopdict];
        
        
        NSLog(@"商品订单>>>>>>%@",shopsArr);
        
        ShangChengDingDan *dingdanVc =[ShangChengDingDan new];
        dingdanVc.isMine=YES;
        dingdanVc.dataArray=shopsArr;
        dingdanVc.totalPrice =  [NSNumber numberWithFloat:[collectionM.price floatValue]];
        [self.navigationController pushViewController:dingdanVc animated:YES];
    }
    else
    {
        [AppUtils showAlertMessageTimerClose:@"亲，该商品已经下架,不能支付了!"];
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if(type==0)
    {
        TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
        ShangjiaModel *shangjM =[shopsList objectAtIndex:indexPath.row];
        detail.shopId = [NSString stringWithFormat:@"%@",shangjM.ID];
        if (![NSString isEmptyOrNull:shangjM.ID])
        {
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    else
    {
        CollectionModel *shangpinM = [goodsList objectAtIndex:indexPath.row];
        if ([shangpinM.productType isEqualToString:@"Quickly"]) {
            ShangChengGoodsDeatil *shangchengVC =[[ShangChengGoodsDeatil alloc]init];
            shangchengVC.productId=shangpinM.ID;
            if (![NSString isEmptyOrNull:shangpinM.ID])
            {
                [self.navigationController pushViewController:shangchengVC animated:YES];
            }

        }
        else if ([shangpinM.productType isEqualToString:@"Group"])
        {
            TGGoodsModel * goodsModel = [TGGoodsModel new];
            goodsModel.goodsid = shangpinM.ID;
            
            WTTuanGouDetail * detail = [[WTTuanGouDetail alloc] init];
            detail.goodsModel = goodsModel;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else if ([shangpinM.productType isEqualToString:@"Supplier"])
        {
            ShangChengGoodsDeatil *shangchengVC =[[ShangChengGoodsDeatil alloc]init];
            shangchengVC.productId=shangpinM.ID;
            if (![NSString isEmptyOrNull:shangpinM.ID])
            {
                [self.navigationController pushViewController:shangchengVC animated:YES];
            }
            
        }

    }
}


@end
