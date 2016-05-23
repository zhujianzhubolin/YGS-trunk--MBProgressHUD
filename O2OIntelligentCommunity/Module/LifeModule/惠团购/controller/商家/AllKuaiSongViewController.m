//
//  AllKuaiSongViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/4.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "AllKuaiSongViewController.h"
#import <UIImageView+AFNetworking.h>
#import "ShopGoodsCell.h"
#import "ShangchengCell.h"
#import "HuiTuanCell.h"
#import "TuanOrderPageViewController.h"
#import "TGShopDetailViewController.h"
#import "Life_First.h"
#import "EasyShopInfo.h"
#import "UserManager.h"
#import "TGListModel.h"
#import "TGHandel.h"

#import "TGShopModel.h"
#import "TGGoodsModel.h"
#import "RatingBar.h"
#import "ZJWebProgrssView.h"
#import "WTTuanGouDetail.h"

@interface AllKuaiSongViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    
    __weak IBOutlet UIImageView *headImage;

    __weak IBOutlet UILabel *shopName;
    
    __weak IBOutlet RatingBar *rating;
    
    __weak IBOutlet UILabel *serverTime;
    
    __weak IBOutlet UILabel *shopAdress;
    
    __weak IBOutlet UIImageView *rzState;
    
    __weak IBOutlet UITableView *allGoodslist;
    NSDictionary * shopDict;
    NSMutableArray * goodsArray;
    TGShopModel * myShopM;
    int PageNum;
    BOOL isRemoveAll;
    ZJWebProgrssView * progress;
    ZJWebProgrssView * progress1;
    UIButton * shoucang;
    NSString * totalPage;
}

@end

@implementation AllKuaiSongViewController

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    isRemoveAll = YES;
    PageNum = 1;
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(initData) userInfo:nil repeats:NO];
    [progress1 startAnimation];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {//shoucang
    [super viewDidLoad];
    self.title = @"商品列表";
    
    allGoodslist.delegate = self;
    allGoodslist.dataSource = self;
    
    PageNum = 1;
    isRemoveAll = NO;
    
    goodsArray = [NSMutableArray array];
    
    [self viewDidLayoutSubviewsForTableView:allGoodslist];
    [self setExtraCellLineHidden:allGoodslist];
    [allGoodslist registerNib:[UINib nibWithNibName:@"TuanGouShangJiaCell" bundle:nil] forCellReuseIdentifier:@"SJCell"];
    [allGoodslist registerNib:[UINib nibWithNibName:@"HuiTuanCell" bundle:nil] forCellReuseIdentifier:@"TuanCell"];
    
    [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    rating.isIndicator = YES;
    
    shoucang= [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [shoucang setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [shoucang setImage:[UIImage imageNamed:@"shoucang_h"] forState:UIControlStateSelected];
    [shoucang addTarget:self action:@selector(ShouCangGoods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:shoucang];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem2;
    
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
    
    [allGoodslist addLegendHeaderWithRefreshingBlock:^{
        PageNum = 1;
        isRemoveAll = YES;
        [self shopGoodsList];
    }];
    
    [allGoodslist addLegendFooterWithRefreshingBlock:^{
        PageNum++;
        isRemoveAll = NO;
        [self shopGoodsList];
    }];
    
    __block typeof(self)weakSelf = self;
    progress1 = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    progress1.loadBlock = ^{
        [NSTimer scheduledTimerWithTimeInterval:0.8 target:weakSelf selector:@selector(initData) userInfo:nil repeats:NO];
    };
    [self.view addSubview:progress1];

    
//    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(initData) userInfo:nil repeats:NO];
    
}


- (void)initData{
    [self getShopInfor];
}


- (void)getShopInfor{
    Life_First * handel = [Life_First new];
    EasyShopInfo * info = [EasyShopInfo new];
    info.storeId = [NSNumber numberWithLong:[self.shopId intValue]];
    info.memberId = [UserManager shareManager].userModel.memberId;
    [handel getShopInfor:info success:^(id obj) {
        
        shopDict = (NSDictionary *)obj;
        NSLog(@"商家信息>>>>>%@",obj);
        
        if ([shopDict[@"code"] isEqualToString:@"success"] && ![shopDict[@"entity"] isEqual:[NSNull null]]) {
            
            [progress1 stopAnimationNormalIsNoData:NO];
            
            progress = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 91, IPHONE_WIDTH, IPHONE_HEIGHT - 91)];
            [self.view addSubview:progress];
            __block typeof(self)weakSelf = self;
            progress.loadBlock = ^{
                [weakSelf shopGoodsList];
            };
            [progress startAnimation];
            
            
            [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shopDict[@"entity"][@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            shopName.text = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"name"]];
            serverTime.text = [NSString stringWithFormat:@"营业时间:%@~%@",shopDict[@"entity"][@"storeStartDate"],shopDict[@"entity"][@"storeEndDate"]];
            shopAdress.text = [NSString stringWithFormat:@"商家地址:%@",shopDict[@"entity"][@"storeAddress"]];
            
            
            if (![shopDict[@"entity"][@"score"] isEqual:[NSNull null]]) {
                
                if ([shopDict[@"entity"][@"score"] floatValue] <= 0) {
                    
                    rating.hidden = YES;
                    
                }else{
                    [rating displayRating:[shopDict[@"entity"][@"score"] floatValue]];
                }
                
            }else{
                rating.hidden = YES;
            }
            
            
            if (![shopDict[@"entity"] isEqual:[NSNull null]]) {
                
                if ([shopDict[@"entity"][@"status"] isEqualToString:@"Y"]) {
                    
                    shoucang.selected = YES;
                    
                }else{
                    shoucang.selected = NO;
                }
            }
            
            if (![shopDict[@"entity"][@"rzStatus"] isEqual:[NSNull null]]) {
                
                if ([shopDict[@"entity"][@"rzStatus"] isEqualToString:@"未认证"]) {//未认证
                    rzState.hidden = YES;
                }else{//已认证
                    rzState.hidden = NO;
                }
                
            }else{
                rzState.hidden = YES;
            }
            
            [self shopGoodsList];

        }else{
            [progress1 stopAnimationNormalIsNoData:YES];
        }
        
    } failed:^(id obj) {
        
        [progress1 stopAnimationFailIsNoData:YES];
        
    }];
    
}


//收藏商品
- (void)ShouCangGoods:(UIButton *)sender{
    
    Life_First * handel = [Life_First new];
    ShouCangGoods * shop = [ShouCangGoods new];
    
    shop.memberId = [UserManager shareManager].userModel.memberId;
    shop.storeId = [NSString stringWithFormat:@"%@",self.shopId];
    
    if (sender.selected) {
        shop.isDeleted = @"1";//取消收藏
    }else{
        shop.isDeleted = @"0";//收藏
    }
    
    [handel ShopShouCang:shop success:^(id obj) {
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            [AppUtils showAlertMessageTimerClose:@"商家收藏成功!"];
        }else{
            [AppUtils showAlertMessageTimerClose:@"取消商家收藏!"];
        }
        
        
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            if (sender.selected) {
                [AppUtils showAlertMessageTimerClose:@"商家收藏失败!"];
            }else{
                [AppUtils showAlertMessageTimerClose:@"取消商家收藏失败!"];
            }
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
    
}


- (void)shopGoodsList{

    TGHandel * handel = [TGHandel new];
    TGListModel * model = [TGListModel new];
    
    model.pageNumber = [NSString stringWithFormat:@"%d",PageNum];
    model.pageSize = @"10";
    model.catalogId = @"150";
    model.storeId = self.shopId;
    model.memberId = [UserManager shareManager].userModel.memberId;
    
    [handel ShopGoodsLiss:model success:^(id obj) {
        
        NSLog(@"商家商品>>>>>%@",obj);
        myShopM = (TGShopModel *)obj[0];
        
        if (isRemoveAll) {
            [goodsArray removeAllObjects];
        }else{
            NSLog(@"不需要清空数组");
        }
        
        NSLog(@"添加数组之前的数据元素%@",goodsArray);
        
        for (TGGoodsModel * goodsM in myShopM.goodsArray) {
            [goodsArray addObject:goodsM];
        }
        

        
        [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:goodsArray]];
        
        totalPage = handel.totalPage;
        
        [allGoodslist.header endRefreshing];
        [allGoodslist.footer endRefreshing];
        [allGoodslist reloadData];
    } failed:^(id obj) {
        [allGoodslist.header endRefreshing];
        [allGoodslist.footer endRefreshing];
        [progress stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:goodsArray]];
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [AppUtils tableViewFooterPromptWithPNumber:PageNum withPCount:[totalPage intValue] forTableV:allGoodslist];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 78;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    HuiTuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TuanCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HuiTuanCell" owner:self options:nil]  objectAtIndex:0];
    }
    
    
    TGGoodsModel * goods = goodsArray[indexPath.row];
    
    [cell TGGoodsCellData:goods];
    
    cell.buyNow = ^(TGGoodsModel * goodsData){
        
        [self buyNowWithGoodsData:goodsData];
        
    };
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"商品的数组>>>>>>%@",myShopM.goodsArray);

    TGGoodsModel * goodsModel =(TGGoodsModel *) goodsArray[indexPath.row];
    WTTuanGouDetail * detail = [[WTTuanGouDetail alloc] init];
    detail.goodsModel = goodsModel;
    [self.navigationController pushViewController:detail animated:YES];

}

- (IBAction)goToDetail:(UIButton *)sender {
    
    if (shopDict == nil) {
        [AppUtils showAlertMessageTimerClose:@"暂未获取商家信息"];
        return;
    }else{
        if (![shopDict[@"entity"] isEqual:[NSNull null]]) {
            TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
            detail.shopId = [NSString stringWithFormat:@"%@",shopDict[@"entity"][@"id"]];
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            [AppUtils showAlertMessageTimerClose:@"商家信息不全!"];
        }
    }
    
}



//立即购买
- (void)buyNowWithGoodsData:(TGGoodsModel *)dataDict{
    
    TuanOrderPageViewController * order = [[TuanOrderPageViewController alloc] init];
    order.goodsInfor = dataDict;
    [self.navigationController pushViewController:order animated:YES];
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


@end
