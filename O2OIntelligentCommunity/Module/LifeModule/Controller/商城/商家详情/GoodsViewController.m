//
//  GoodsViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "GoodsViewController.h"
#import "SellerCellGoods.h"
#import "ShoppingCar.h"
#import "RatingBar.h"
#import "ShoppingCarDataSocure.h"
#import "Life_First.h"
#import "ShopGoodsList.h"
#import "HuiTuanGouMuLuModel.h"
#import "EasyShopGoodsConditionSearch.h"
#import "EasyGoodArrange.h"
#import "ShangChengGoodsDeatil.h"
#import "EasyDetail.h"
#import <UIImageView+AFNetworking.h>
#import "UserManager.h"
#import "TGShopDetailViewController.h"
#import "ZJWebProgrssView.h"



@interface GoodsViewController ()<UITableViewDataSource,UITableViewDelegate,ChangeCarNum>

{
    __weak IBOutlet UIImageView *heanImage;
    __weak IBOutlet UIView *goodsInfor;
    UIButton * shoppingCarbtn;
    __weak IBOutlet UILabel *serverTime;
    __weak IBOutlet RatingBar *rate;
    __weak IBOutlet UITableView *goodstableView;
    __weak IBOutlet UILabel *storeName;
    __weak IBOutlet UIImageView *rzStateImage;
    __weak IBOutlet UILabel *zhuyingyewu;
    NSMutableArray * dataSocure;
    long shopCarNumber;
    UILabel * shoppingCarlable;
    NSMutableArray * fenleiListArray;
    NSMutableArray * goodsLeiBieID;
    long fenleiid;
    NSString * storeType;
    NSDictionary * shopData;//接收商家信息，传递下级页面  157
    int viewwidth;
    int viewheight;
    
    ZJWebProgrssView * progress;
    ZJWebProgrssView * progress1;
}

@end

@implementation GoodsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self hidetabbar];
    
    shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
    
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
    
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    
    
    heanImage.contentMode = UIViewContentModeScaleAspectFill;
    heanImage.clipsToBounds = YES;

    self.navigationItem.title = @"商家详情";
    
    goodstableView.delegate = self;
    goodstableView.dataSource = self;
    fenleiListArray = [NSMutableArray array];
    goodsLeiBieID = [NSMutableArray array];
    goodstableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
    goodstableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
    //悬浮购物车
    shoppingCarbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCarbtn.frame = CGRectMake(20, viewheight -160, 50, 50);
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
    shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
    NSLog(@"评分>>>%@",_ratenumber);

    heanImage.clipsToBounds = YES;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShopDetail)];
    [goodsInfor addGestureRecognizer:tap];
    
    __block typeof(self)weakSelf = self;
    progress = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT - 64)];
    progress.loadBlock = ^{
        
        [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:weakSelf selector:@selector(getShopInfor) userInfo:nil repeats:NO];
        
        
    };
    [self.view addSubview:progress];
    [progress startAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopInfor) userInfo:nil repeats:NO];

}

- (void)initWithUI{

}

//商家详情
- (void)ShopDetail{
    
    if (shopData == nil) {
        [AppUtils showAlertMessageTimerClose:@"商家信息不全"];
        return;
    }else{
        TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
        detail.shopId = shopData[@"entity"][@"id"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)getShopInfor{
    Life_First * handel = [Life_First new];
    EasyShopInfo * info = [EasyShopInfo new];
    info.storeId = [NSNumber numberWithLong:[_shopID intValue]];
    info.memberId = [UserManager shareManager].userModel.memberId;
    [handel getShopInfor:info success:^(id obj) {

        shopData = (NSDictionary *)obj;
        
        NSLog(@"便利店详情>>>>>>%@",obj);
        
        if (![obj[@"entity"] isEqual:[NSNull null]]) {
            
            [progress stopAnimationNormalIsNoData:NO];
            
            __block typeof(self)weakSelf = self;
            progress1 = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, 93, IPHONE_WIDTH, IPHONE_HEIGHT - 93)];
            progress1.loadBlock = ^{
                
                //需要区分快送跟商城商品
                
                if ([weakSelf.catalogid isEqualToString:@"201"]) {//商城
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(getGoodsList) userInfo:nil repeats:NO];
                }else{//快送
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(getKuaiSongList) userInfo:nil repeats:NO];
                }
                
            };
            [self.view addSubview:progress1];
            [progress1 startAnimation];
            
            //需要区分快送跟商城商品
            if ([self.catalogid isEqualToString:@"201"]) {//商城
                
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getGoodsList) userInfo:nil repeats:NO];
                
            }else{//快送
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(getKuaiSongList) userInfo:nil repeats:NO];
            }

            [heanImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",obj[@"entity"][@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            storeType = [NSString stringWithFormat:@"%@",obj[@"entity"][@"optionCode"]];
            
            
            NSString * startTime = nil;
            NSString * endTime = nil;
            
            if ([obj[@"entity"][@"storeStartDate"] isEqual:[NSNull null]]) {
                startTime = @"00:00";
            }else{
                startTime = [NSString stringWithFormat:@"%@",obj[@"entity"][@"storeStartDate"]];
            }
            
            if ([obj[@"entity"][@"storeEndDate"] isEqual:[NSNull null]]) {
                endTime = @"24:00";
            }else{
                endTime = [NSString stringWithFormat:@"%@",obj[@"entity"][@"storeEndDate"]];
            }
            
            
            serverTime.text = [NSString stringWithFormat:@"营业时间:%@~%@",startTime,endTime];
            storeName.text = [NSString stringWithFormat:@"%@",obj[@"entity"][@"name"]];
            zhuyingyewu.text = [NSString stringWithFormat:@"主营业务:%@",obj[@"entity"][@"bizArea"]];
            rzStateImage.hidden = NO;
            if ([obj[@"entity"][@"score"] isEqual:[NSNull null]] || [obj[@"entity"][@"score"] floatValue] <= 0) {

                rate.hidden = YES;
                
                CGRect frameY = serverTime.frame;
                frameY.origin.y -= 6;
                serverTime.frame = frameY;
                
            }else{
                rate.hidden = NO;

                [rate setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
                rate.isIndicator = YES;
                [rate displayRating:[obj[@"entity"][@"score"] floatValue]];
            }
        }else{

            [progress stopAnimationNormalIsNoData:NO];

        }
        
    } failed:^(id obj) {
        
        if (self.viewIsVisible) {
            [AppUtils showErrorMessage:@"获取商家信息失败"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];

}

//前往购物车
- (void)goToShoppingCar:(UIButton *)sender{
    ShoppingCar * car = [[ShoppingCar alloc] init];
    car.isMine = NO;
    [self.navigationController pushViewController:car animated:YES];
}


//所有商城商品列表
- (void)getGoodsList{

    Life_First * handel  = [Life_First new];
    ShopGoodsList * model = [ShopGoodsList new];
    model.pageNumber = [NSNumber numberWithLong:1];
    model.pageSize = [NSNumber numberWithLong:0];
    model.storeId = _shopID;
    model.memberId = [UserManager shareManager].userModel.memberId;
    model.catalogId = self.catalogid;
    
    [handel getAllGoodsInShop:model success:^(id obj) {
        
        NSLog(@"商家所有商品列表>>>>>>%@",obj);
        
        if (![obj[@"list"] isEqual:[NSNull null]] && [obj[@"list"] count] > 0) {//商家不为空
            if (![obj[@"list"][0][@"group"] isEqual:[NSNull null]]) {
                dataSocure = (NSMutableArray *)obj[@"list"][0][@"group"];
                [goodstableView reloadData];
            }
            
        }
        [progress1 stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:dataSocure]];
        
    } failed:^(id obj) {
        [progress1 stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:dataSocure]];
    }];
}


//快送商品列表
- (void)getKuaiSongList{

    Life_First * handel  = [Life_First new];
    ShopGoodsList * model = [ShopGoodsList new];
    model.pageNumber = [NSNumber numberWithLong:1];
    model.pageSize = [NSNumber numberWithLong:0];
    model.storeId = _shopID;
    model.memberId = [UserManager shareManager].userModel.memberId;
    model.catalogId = self.catalogid;
    
    [handel getKuaiSongList:model success:^(id obj) {
        
        NSLog(@"快送商品列表>>>>>%@",obj);
        
        
        if (![obj[@"list"] isEqual:[NSNull null]] && [obj[@"list"] count] > 0) {//商家不为空
            
            if (![obj[@"list"][0][@"group"] isEqual:[NSNull null]]) {
                dataSocure = (NSMutableArray *)obj[@"list"][0][@"group"];
                [goodstableView reloadData];
            }
            
        }
        [progress1 stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:dataSocure]];

    } failed:^(id obj) {
        [progress1 stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:dataSocure]];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSocure.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellID = @"goodsCell";
    SellerCellGoods * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.numdel = self;
    if (cell == nil) {
        
        cell = [[SellerCellGoods alloc] init];
    }
    
    [cell setGoodsData:[dataSocure objectAtIndex:indexPath.row]];

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ShangChengGoodsDeatil * detail = [[ShangChengGoodsDeatil alloc] init];
    detail.productId = [dataSocure objectAtIndex:indexPath.row][@"id"];//有数据时替换
    [self.navigationController pushViewController:detail animated:YES];
}

//分割线靠边界
-(void)viewDidLayoutSubviews
{
    if ([goodstableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [goodstableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([goodstableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [goodstableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}



- (void)setCarNum{
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(resetGoodsNum) userInfo:nil repeats:NO];
    
}

- (void)resetGoodsNum{
    shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
    if (shopCarNumber <= 0) {
        shoppingCarlable.hidden = YES;
    }else{
        shoppingCarlable.hidden = NO;
        shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    }
}

@end
