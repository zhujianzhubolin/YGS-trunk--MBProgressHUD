//
//  ShangChengGoodsDeatil.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShangChengGoodsDeatil.h"
#import "MorePinLunCell.h"
#import "ShoppingCar.h"
#import "Life_First.h"
#import "StoreGoodsDetailModel.h"
#import "GoodsPinLun.h"
#import "ShangChengMuLu.h"
#import "ShouCangGoods.h"
#import "ShoppingCarDataSocure.h"
#import "UserManager.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
//分享相关
#import "HYActivityView.h"
#import <UIImageView+AFNetworking.h>
#import "WXApi.h"
#import "GoodsViewController.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import "EasyDetail.h"
#import "ZLPhotoPickerBrowserViewController.h"
//举报相关
#import "ZJLongPressGesture.h"
#import "ReportBtn.h"
#import "ReportVC.h"
//新的滚动视图
#import "SDCycleScrollView.h"
#import "ZJWebProgrssView.h"

#import "TGShopDetailViewController.h"


@interface ShangChengGoodsDeatil ()<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UMSocialUIDelegate,
UIWebViewDelegate,
ZLPhotoPickerBrowserViewControllerDataSource,
UIScrollViewDelegate,
SDCycleScrollViewDelegate>

{
    UIButton * shoppingCarbtn;
    //更多评论
    UIButton * button1;
    __weak IBOutlet UIScrollView *myScrollView;
    UILabel * goodinfor;
    
    UILabel * newPrice;
    UILabel * oldPrice;
    UILabel * peisongTime;
    UITableView * pinglunTable;
    UILabel * shoppingCarlable;
    
    __weak IBOutlet UITextField *inputNum;
    
    int numberIntextField;
    
    NSMutableArray * pinglunListArray;
    NSMutableArray * twoListArray;
    
    UIButton *myshoucangbtn;
    NSMutableDictionary * goodsDict;
    long shopCarNumber;

    UIWebView * detailWebView;
    
    int viewwidth;
    int viewheight;
    CGFloat webViewHeight;
    UILabel * shopName;
    UILabel * yunfeiState;
    
    UIView * shopDetail;
    MultiShowing * multShow;
    
    //下架需要隐藏的View
    __weak IBOutlet UIView *addBackView;
    __weak IBOutlet UIButton *addShopCarBtn;
    __weak IBOutlet UIButton *jianBtn;
    UIView * backView;
    NSMutableArray * imageArray;
    
    UIButton * detailBtn;
    UIButton * pinglunBtn;
    UIImageView *imgView2;
    
    //新的滚动视图
    SDCycleScrollView * sdScrollView;
    ZJWebProgrssView *progressV;
    ZJWebProgrssView *pinglunProgressV;
}

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation ShangChengGoodsDeatil

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

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:addBackView];
    [self.view bringSubviewToFront:addShopCarBtn];

    
    //先隐藏下面的两个按钮
    addBackView.hidden = YES;
    addShopCarBtn.hidden = YES;
    
    imageArray = [NSMutableArray array];
    twoListArray = [NSMutableArray array];
    
    self.title = @"商品详情";
    NSLog(@"产品ID>>>>>>>%@",_productId);
    numberIntextField = 1;
    inputNum.text = [NSString stringWithFormat:@"%d",numberIntextField];
    myScrollView.pagingEnabled = NO;
    myScrollView.contentSize = CGSizeMake(0, myScrollView.frame.size.height + 100);
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.delegate = self;
    inputNum.delegate = self;
    //加滚动视图会很卡
    self.view.backgroundColor = [AppUtils colorWithHexString:@"eeeeea"];

    myshoucangbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [myshoucangbtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [myshoucangbtn setImage:[UIImage imageNamed:@"shoucang_h"] forState:UIControlStateSelected];
    [myshoucangbtn addTarget:self action:@selector(ShouCangGoods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:myshoucangbtn];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem2];
    
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
    //将减号按钮设置为禁用状态
    [jianBtn setBackgroundImage:[UIImage imageNamed:@"btnlight"] forState:UIControlStateNormal];
    jianBtn.enabled = NO;
    
    __block typeof(self)weakSelf = self;
    progressV = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf getGoodsInfor];
    };
    
    [progressV startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getGoodsInfor) userInfo:nil repeats:NO];
}

- (void)initWithUI{

    sdScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, viewwidth, viewwidth *3/4) delegate:self placeholderImage:[UIImage imageNamed:@"enLargeImg"]];
    sdScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    sdScrollView.currentPageDotColor = [UIColor whiteColor];
    sdScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [myScrollView addSubview:sdScrollView ];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sdScrollView.imageURLStringsGroup = imageArray;
    });

    backView =  [[UIView alloc] initWithFrame:CGRectMake(0, sdScrollView.frame.origin.y + sdScrollView.frame.size.height, viewwidth, 180)];
    backView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:backView];
    
    //屏幕宽度的分割线
    UILabel * seperateLine1 = [UILabel addlable:backView frame:CGRectMake(0, 0, viewwidth, 1) text:nil textcolor:nil];
    seperateLine1.backgroundColor = [AppUtils colorWithHexString:@"EDEDED"];
    
    goodinfor = [UILabel addlable:backView frame:CGRectMake(10, 1, viewwidth-20, 40) text:@"" textcolor:[UIColor blackColor]];
    goodinfor.font = [UIFont systemFontOfSize:16];
    
    //新价格
    newPrice = [UILabel addlable:backView frame:CGRectMake(10, goodinfor.frame.origin.y+goodinfor.frame.size.height, 80, 30) text:@"" textcolor:[AppUtils colorWithHexString:@"FB5609"]];
    newPrice.font = [UIFont systemFontOfSize:15];
    newPrice.textAlignment = NSTextAlignmentLeft;
    
    //原来的价格
    oldPrice = [UILabel addlable:backView frame:CGRectMake(newPrice.frame.origin.x + newPrice.frame.size.width, newPrice.frame.origin.y, 80, 30) text:@"" textcolor:[UIColor lightGrayColor]];
    oldPrice.font = [UIFont systemFontOfSize:15];
    oldPrice.backgroundColor = [UIColor clearColor];
    oldPrice.textAlignment = NSTextAlignmentLeft;
    
    //动态计算分割线的宽度
    CGSize lineViewW = [AppUtils sizeWithString:[NSString stringWithFormat:@"%@:元",goodsDict[@"entity"][@"market_price"]] font:[UIFont systemFontOfSize:13] size:CGSizeMake(CGFLOAT_MAX, 1)];
    //分割线
    UIView * linView = [[UIView alloc] initWithFrame:CGRectMake(0, 13,lineViewW.width, 1)];
    linView.backgroundColor = [UIColor lightGrayColor];
    [oldPrice addSubview:linView];
    
    
    //配送时间
    peisongTime = [UILabel addlable:backView frame:CGRectMake(viewwidth - 140, oldPrice.frame.origin.y, 140, 30) text:@"配送时间:10:00-21:00" textcolor:[UIColor blackColor]];
    
    //在此处添加商家详情
    shopDetail = [[UIView alloc] initWithFrame:CGRectMake(0, oldPrice.frame.origin.y + oldPrice.frame.size.height, viewwidth, 60)];
    [backView addSubview:shopDetail];
    
    
    UILabel * seperateLine = [UILabel addlable:shopDetail frame:CGRectMake(0, 0, viewwidth, 1) text:nil textcolor:nil];
    seperateLine.backgroundColor = [AppUtils colorWithHexString:@"EDEDED"];
    
    shopName = [UILabel addlable:shopDetail frame:CGRectMake(10, 2, viewwidth /2 - 30, 56) text:@"" textcolor:[UIColor blackColor]];
    shopName.numberOfLines = 1;
    shopName.font = [UIFont systemFontOfSize:15];
    
    //创建运费lable
    yunfeiState = [UILabel addlable:shopName frame:CGRectMake(shopName.frame.origin.x + shopName.frame.size.width - 15, shopName.frame.origin.y, 130, 56) text:nil textcolor:[UIColor lightGrayColor]];
    yunfeiState.text = @"【免运费】";
    yunfeiState.font = [UIFont systemFontOfSize:13];
    yunfeiState.textAlignment = NSTextAlignmentLeft;
    
    UIButton * guanyiguang = [UIButton buttonWithType:UIButtonTypeCustom];
    guanyiguang.frame = CGRectMake(viewwidth - 70, 15, 60, 30);
    guanyiguang.layer.cornerRadius = 5;
    [guanyiguang setTitle:@"逛一逛" forState:UIControlStateNormal];
    guanyiguang.titleLabel.font = [UIFont systemFontOfSize:15];
    guanyiguang.backgroundColor = [AppUtils colorWithHexString:@"3FAAF9"];
    [guanyiguang addTarget:self action:@selector(gotoShopDetail) forControlEvents:UIControlEventTouchUpInside];
    [shopDetail addSubview:guanyiguang];

    detailBtn = [self addButtonCustom:backView frame:CGRectMake(0, shopDetail.frame.origin.y + shopDetail.frame.size.height, viewwidth/2, 50) tag: 100 action:@selector(SeegoodsDetail)];
    [detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    detailBtn.backgroundColor = [AppUtils colorWithHexString:@"C4BEAF"];
    [detailBtn setTitle:@"商品详情" forState:UIControlStateNormal];
    
    
    pinglunBtn = [self addButtonCustom:backView frame:CGRectMake(viewwidth/2, shopDetail.frame.origin.y + shopDetail.frame.size.height, viewwidth/2, 50) tag: 100 action:@selector(SeePinLun)];
    [pinglunBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pinglunBtn.backgroundColor = [AppUtils colorWithHexString:@"EAEBE5"];
    [pinglunBtn setTitle:@"商品评论" forState:UIControlStateNormal];

    
    //加载HTML代码，的WebView
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, viewwidth, 0)];
    detailWebView.backgroundColor = [UIColor clearColor];
    detailWebView.scalesPageToFit = YES;
    detailWebView.delegate = self;
    detailWebView.scrollView.bounces = YES;
    detailWebView.scrollView.scrollEnabled = YES;
    [myScrollView addSubview:detailWebView];
    
    
    pinglunTable = [[UITableView alloc] initWithFrame:CGRectMake(0, backView.frame.origin.y + backView.frame.size.height, viewwidth, 2000) style:UITableViewStylePlain];
    
    pinglunTable.scrollEnabled = NO;
    pinglunTable.delegate = self;
    pinglunTable.dataSource = self;
    pinglunTable.hidden = YES;
    
    
    [myScrollView addSubview:pinglunTable];
    [self viewDidLayoutSubviewsForTableView:pinglunTable];
    [pinglunTable registerNib:[UINib nibWithNibName:@"MorePinLunCell" bundle:nil] forCellReuseIdentifier:@"pinLunCell"];

    //底部更多评论
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    button1.backgroundColor = [AppUtils colorWithHexString:@"EAEBE5"];
    [button1 setTitle:@"更多>>" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(getPinLun) forControlEvents:UIControlEventTouchUpInside];
    button1.hidden = YES;
    pinglunTable.tableFooterView = button1;

    __block typeof(self)weakSelf = self;
    
    CGFloat pinglunVHeight = self.view.frame.size.height - pinglunTable.frame.origin.y - 50;
    pinglunVHeight = MAX(pinglunVHeight, 50);
    pinglunProgressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, pinglunTable.frame.origin.y, self.view.frame.size.width, pinglunVHeight)];
    [myScrollView addSubview:pinglunProgressV];
    pinglunProgressV.loadBlock = ^ {
        [weakSelf SeePinLun];
    };
    
    //悬浮购物车
    shoppingCarbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCarbtn.frame = CGRectMake(20, viewheight - 180, 50, 50);
    [shoppingCarbtn setImage:[UIImage imageNamed:@"shoppingCar"] forState:UIControlStateNormal];
    [shoppingCarbtn addTarget:self action:@selector(goToShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoppingCarbtn];
    
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
    
    shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
    
    addBackView.hidden = NO;
    addShopCarBtn.hidden = NO;
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.dataSource = self;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)getGoodsInfor{
    [self getGoodsDeatail:_productId];
}

//获取商城商品详情页面
- (void)getGoodsDeatail:(NSString *)productId{
    
    Life_First * handel = [Life_First new];
    StoreGoodsDetailModel * detailmodel = [StoreGoodsDetailModel new];
    detailmodel.productId = productId;
    detailmodel.memberId = [UserManager shareManager].userModel.memberId;
    [handel getStoreGoodsDetail:detailmodel success:^(id obj) {
        NSLog(@"详情返回>>>>>%@",obj);
        if ([obj[@"code"] isEqualToString:@"success"] ) {
            [progressV stopAnimationNormalIsNoData:NO];
            if ([obj[@"entity"] isEqual:[NSNull null]]) {
                [progressV stopAnimationNormalIsNoData:YES];
                return ;
            }else{
                
                if (![obj[@"entity"][@"listImg"] isEqual:[NSNull null]]) {
                    for (NSString * MyimageStr in obj[@"entity"][@"listImg"]) {
                        [imageArray addObject:MyimageStr];
                    }
                }
                
                
                goodsDict = (NSMutableDictionary *)obj;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self initWithUI];
                    goodinfor.text = [NSString stringWithFormat:@"%@",obj[@"entity"][@"name"]];
                    newPrice.text = [NSString stringWithFormat:@"%@元",obj[@"entity"][@"price"]];
                    oldPrice.text = [NSString stringWithFormat:@"%@元",obj[@"entity"][@"market_price"]];
                    
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
                    
                    NSLog(@"%@>>%@",startTime,endTime);
                    
                    peisongTime.text = [NSString stringWithFormat:@"配送时间:%@-%@",startTime,endTime];
                    if ([obj[@"entity"][@"fullMoney"] isEqual:[NSNull null]] || [obj[@"entity"][@"fullMoney"] floatValue] <= 0) {
                        yunfeiState.text = @"【免运费】";
                    }else{
                        
                        CGFloat YF = [obj[@"entity"][@"fullMoney"] floatValue];
                        NSString * YFS = [NSString stringWithFormat:@"%.2f",YF];
                        yunfeiState.text = [NSString stringWithFormat:@"【满%@免运费】",YFS];
                    }
                    
                    shopName.text = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"storeName"]];//fullMoney
                    
                    //下架商品处理,或者库存为零的时候
                    if (![obj[@"entity"][@"marketStatus"] isEqualToString:@"ON_MARKET"] || [obj[@"entity"][@"stock"] intValue] == 0) {
                        addBackView.hidden = YES;
                        addShopCarBtn.hidden = YES;
                        myshoucangbtn.hidden = YES;
                        myScrollView.frame = CGRectMake(0, 0, viewwidth, viewheight);
                    }
                    
                    if ([obj[@"entity"][@"status"] isEqualToString:@"Y"]) {
                        myshoucangbtn.selected = YES;
                    }
                    
                    NSString * wordJs = [NSString stringWithFormat:@"<body width=%dpx style=\"word-wrap:break-word; font-family:Arial\">",viewwidth];
                    
                    NSString * imageJS = [NSString stringWithFormat:@"<head><style>img{width:%dpx !important;}</style></head>",viewwidth];
                    
                    
                    NSLog(@"HTML代码>>>>>>>>%@",[NSString stringWithFormat:@"%@%@%@",wordJs,imageJS,obj[@"entity"][@"details"]]);
                    
                    
                    if (![obj[@"entity"][@"details"] isEqual:[NSNull null]]) {
                        NSLog(@"detail = %@",obj[@"entity"][@"details"]);
                        [detailWebView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",wordJs,imageJS,obj[@"entity"][@"details"]] baseURL:nil];
                    }
                });


            }
        }else{
            [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@",obj[@"message"]]];
            [progressV stopAnimationNormalIsNoData:YES];

            return ;
        }
        
    } failed:^(id obj) {
        
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        }else{
        
        }
        
        [progressV stopAnimationFailIsNoData:YES];

    }];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *contentH = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    webViewHeight = [contentH floatValue] + 25;
    
    detailWebView.frame = CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, viewwidth, webViewHeight);
    
    CGRect frameX = detailWebView.scrollView.frame;
    frameX.origin.x = -5;
    frameX.size.width = detailWebView.scrollView.frame.size.width + 2;
    detailWebView.scrollView.frame = frameX;
    
    myScrollView.contentSize = CGSizeMake(0, backView.frame.origin.y + backView.frame.size.height + webViewHeight);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    NSLog(@"加载失败");
}

//查看商家详情
- (void)gotoShopDetail{
//    
//    if ([goodsDict[@"entity"][@"atStatus"] isEqualToString:@"已认证"]) {
//        UIStoryboard *easydetail = [UIStoryboard storyboardWithName:@"LifeViewController" bundle:nil];
//        GoodsViewController *detaileasy = [easydetail instantiateViewControllerWithIdentifier:@"EasygoodsList"];
//        detaileasy.shopID = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"storeId"]];
//        detaileasy.shopName = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"storeName"]];
//        [self.navigationController pushViewController:detaileasy animated:YES];
//    }else{
    
//        
//        UIStoryboard *easydetail = [UIStoryboard storyboardWithName:@"LifeViewController" bundle:nil];
//        EasyDetail *detaileasy = [easydetail instantiateViewControllerWithIdentifier:@"easyDetailID"];
//        detaileasy.shopID = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"storeId"]] intValue]];
//        detaileasy.storeType = @"2600";
//        [self.navigationController pushViewController:detaileasy animated:YES];
        
        TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
        detail.shopId = goodsDict[@"entity"][@"storeId"];
        [self.navigationController pushViewController:detail animated:YES];
//    }
}

//前往购物车
- (void)goToShoppingCar:(UIButton *)sender{
    ShoppingCar * car = [[ShoppingCar alloc] initWithNibName:@"ShoppingCar" bundle:nil];
    car.isMine = NO;
    [self.navigationController pushViewController:car animated:YES];
}

//加入购物车操作
- (IBAction)addGoodsToShoppingCar:(UIButton *)sender {
    NSLog(@"加入购物车");
    
    NSString * kucun = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"stock"]];

    if ([goodsDict[@"stock"] isEqual:[NSNull null]]) {
        [AppUtils showAlertMessage:@"商品信息不全"];
        return;
    }else if ([kucun intValue] <=0){//没有库存的时候
        [AppUtils showAlertMessage:@"暂无库存"];
        return;
    }else{//有库存，并且商品信息齐全的情况下
        
        NSString * goodsID = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"id"]];
        
        if ([[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum] <= 0) {//空购物车直接添加
            [self addToShopCar];
            return;
        }else{//购物车不为空，判断添加
            NSMutableArray * shopCarData = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData];
            int shopCarNum = 0;
            BOOL isExist = NO;
            for (NSMutableDictionary * shop in shopCarData) {//遍历购物车里面的商家
                for (NSMutableDictionary * goods in shop[@"goodsList"]) {//遍历商家里面的商品
                    if ([goodsID isEqualToString:goods[@"id"]]) {//该商品存在
                        shopCarNum = [goods[@"addNumber"] intValue];
                        isExist = YES;
                        break;
                        break;
                    }
                }
            }
            
            if (isExist) {
                if (shopCarNum < [kucun intValue]) {
                    [self addToShopCar];
                }else{
                    [AppUtils showAlertMessage:@"购买数已到当前库存最大数"];
                    return;
                }
            }
            else {
                [self addToShopCar];
            }
        }
    }
}

- (void)addToShopCar{

        CGPoint windowPoint = CGPointMake(backView.frame.origin.x, backView.frame.origin.y);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        imgV.image = [UIImage imageNamed:@"addGouWuChe"];
        imgV.center = windowPoint;
        [self.view addSubview:imgV];
        [UIView animateWithDuration:0.5f animations:^{
            myScrollView.userInteractionEnabled = NO;
            imgV.center = shoppingCarbtn.center;
            imgV.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            myScrollView.userInteractionEnabled = YES;
            [imgV removeFromSuperview];
            shoppingCarlable.text = [NSString stringWithFormat:@"%@",inputNum.text];
            NSMutableDictionary * addDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:goodsDict,@"goodslist",goodsDict[@"entity"][@"storeId"],@"storeId",goodsDict[@"entity"][@"name"],@"name",goodsDict[@"entity"][@"id"],@"id",inputNum.text,@"addNumber", nil];
            
            
            NSLog(@"添加的数据>>>>%@",addDict);
            
            int textNum = [inputNum.text intValue];//添加的商品数量
            NSString * kucun = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"stock"]];//商品库存
            NSString * goodsID = [NSString stringWithFormat:@"%@",goodsDict[@"entity"][@"id"]];//商品ID查找出来该商品的数量
            NSMutableArray * shopCarData = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData];
            int shopCarNum = 0;
            for (NSMutableDictionary * shop in shopCarData) {
                for (NSMutableDictionary * goods in shop[@"goodsList"]) {
                    if ([goodsID isEqualToString:goods[@"id"]]) {
                        shopCarNum = [goods[@"addNumber"] intValue];
                    }
                }
            }
            
            //剩下可以添加的商品数量
            int leftNum = [kucun intValue] - shopCarNum;

            if (textNum > leftNum) {
                [AppUtils showAlertMessage:[NSString stringWithFormat:@"库存最大%@件，请修改添加数量",kucun]];
            }else{
                [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:addDict addnumber:inputNum.text];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                shopCarNumber = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum];
                if (shopCarNumber <= 0) {
                    shoppingCarlable.hidden = YES;
                }else{
                    shoppingCarlable.hidden = NO;
                    shoppingCarlable.text = [NSString stringWithFormat:@"%ld",shopCarNumber];
                }
            });
        }];
}




//评论列表代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = nil;
    if ([twoListArray[indexPath.row][@"content"] isEqual:[NSNull null]]) {
        text = @"";
    }else{
        text = twoListArray[indexPath.row][@"content"];
    }
    
    CGFloat imageH = 0;
    
    if ([twoListArray[indexPath.row] isEqual:[NSNull null]]) {
        imageH = 0;
    }else{

        if ([twoListArray[indexPath.row][@"file"] isEqual:[NSNull null]]) {
            imageH = 0;
        }else{
            if ([twoListArray[indexPath.row][@"file"] count] > 0) {
                imageH = 70;
            }else{
                imageH = 0;
            }
        }
    }
    
    CGSize constraint = CGSizeMake(viewwidth - 61 - 5, 20000.0f);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGFloat height = MAX(size.height + 50 + imageH, 73);
    
    return height + 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return twoListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MorePinLunCell * mycell = [tableView dequeueReusableCellWithIdentifier:@"pinLunCell"];
    
    if (mycell == nil) {
        mycell = [[MorePinLunCell alloc] init];
    }
    
    
    ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:mycell.contentView];
    pressGesture.pressBlock = ^{
        [self pushToReportVC:indexPath.row];
    };
    [mycell.contentView addGestureRecognizer:pressGesture];
    
    
    [mycell cellData:(NSDictionary *)[twoListArray objectAtIndex:indexPath.row] isCollectionHide:NO];
    
    return mycell;
    
}

//举报话题
- (void)pushToReportVC:(NSUInteger)dataIndex {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:[twoListArray[dataIndex][@"commentId"] intValue]];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}



//查看详情
- (void)SeegoodsDetail{
    pinglunProgressV.hidden = YES;
    pinglunTable.hidden = YES;
    detailWebView.hidden = NO;
    detailBtn.backgroundColor = [AppUtils colorWithHexString:@"C4BEAF"];
    pinglunBtn.backgroundColor = [AppUtils colorWithHexString:@"EAEBE5"];
    myScrollView.contentSize = CGSizeMake(0, backView.frame.origin.y + backView.frame.size.height + 80 + webViewHeight);
}

//查看评论
- (void)SeePinLun{
    [pinglunProgressV startAnimation];
    Life_First * handel = [Life_First new];
    PinLunModel * model = [PinLunModel new];
    model.productId = [NSNumber numberWithLong:[_productId intValue]];
    model.pageNumber = [NSNumber numberWithLong:1];
    model.pageSize = [NSNumber numberWithLong:5];
    if (twoListArray.count > 0) {
        [twoListArray removeAllObjects];
    }
    [handel getPinLunInStore:model success:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        pinglunListArray = [NSMutableArray array];
        pinglunListArray = dic[@"list"];
        [pinglunProgressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:pinglunListArray]];
        if (pinglunListArray.count >=2 ) {
            for (int i = 0; i < 2; i ++) {
                [twoListArray addObject:[pinglunListArray objectAtIndex:i]];
            }
            button1.hidden = NO;
        }else{
            button1.hidden = YES;
            twoListArray = pinglunListArray;
        }

        pinglunTable.hidden = NO;
        detailWebView.hidden = YES;
        detailBtn.backgroundColor = [AppUtils colorWithHexString:@"EAEBE5"];
        pinglunBtn.backgroundColor = [AppUtils colorWithHexString:@"C4BEAF"];
        CGFloat wordHeight = 0;
        //动态计算tableView的高度
        for (int i = 0; i < twoListArray.count; i ++) {
            CGFloat imageHeight;
            NSString *text = nil;
            if ([twoListArray[i][@"content"] isEqual:[NSNull null]]) {
                text = @"";
            }else{
                text = twoListArray[i][@"content"];
            }
            if (![twoListArray[i][@"file"] isEqual:[NSNull null]]) {
                if ([twoListArray[i][@"file"] count] > 0) {
                    imageHeight = 70;
                }else{
                    imageHeight = 0;
                }
            }else{
                imageHeight = 0;
            }
            CGSize constraint = CGSizeMake(IPHONE_WIDTH - 61 - 5, 20000.0f);
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:text
             attributes:attributes];
            CGRect rect = [attributedText boundingRectWithSize:constraint
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            wordHeight += rect.size.height + imageHeight;
            
            NSLog(@"高度>>>>>%f",wordHeight);
        }
        CGFloat tableViewHeight = wordHeight + 72 * twoListArray.count + 30;
        pinglunTable.frame = CGRectMake(0, backView.frame.origin.y + backView.frame.size.height, viewwidth, tableViewHeight);
        myScrollView.contentSize = CGSizeMake(0, backView.frame.origin.y + backView.frame.size.height + pinglunTable.frame.size.height);
        [pinglunTable reloadData];
    } failed:^(id obj) {
        [pinglunProgressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:pinglunListArray]];
        button1.hidden = YES;
    }];

}

//获取评论接口，首页展示两条，其余下一页面获取
- (void)getPinLun{
    GoodsPinLun * pinlun = [[GoodsPinLun alloc] init];
    pinlun.productId = self.productId;
    [self.navigationController pushViewController:pinlun animated:YES];
}

//顶部广告滚动视图
- (NSInteger)numberOfPages{
    if (imageArray.count <= 0) {
        return 1;
    }else{
        return imageArray.count;
    }
}

//2、图片放大控件更换，需要设置代理；
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return imageArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [imageArray objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    
    UIImageView * myImageView = [[UIImageView alloc] initWithFrame:sdScrollView.bounds];
    
    [myImageView setImageWithURL:[NSURL URLWithString:imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"enLargeImg"]];
    photo.toView = myImageView;
    
    return photo;
}



//购物车相关操作
//购物车数量加
- (IBAction)shoppingcarplus:(UIButton *)sender {
    
    numberIntextField ++;
    inputNum.text = [NSString stringWithFormat:@"%d",numberIntextField];
    [jianBtn setBackgroundImage:[UIImage imageNamed:@"goodsjian_n"] forState:UIControlStateNormal];
    jianBtn.enabled = YES;
}


//购物车数量减
- (IBAction)shoppingcarless:(UIButton *)sender {
    numberIntextField --;
    inputNum.text = [NSString stringWithFormat:@"%d",numberIntextField];
    if ([inputNum.text intValue] <= 1) {
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"btnlight"] forState:UIControlStateNormal];
        jianBtn.enabled = NO;
        return;
    }
}


- (void)ShouCangGoods:(UIButton *)sender{

    if (!sender.selected) {/*添加收藏*/
        
        Life_First * handel = [Life_First new];
        ShouCangGoods * shou = [ShouCangGoods new];
        shou.memberId = [UserManager shareManager].userModel.memberId;
        shou.productId = _productId;
        [handel StoreGoods:shou success:^(id obj) {
            
            
            if ([obj[@"code"] isEqualToString:@"success"]) {
                sender.selected = !sender.selected;
                [AppUtils showAlertMessageTimerClose:@"收藏成功!"];
            }else{
                [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@",obj[@"message"]]];
            }

        } failed:^(id obj) {
            if (self.viewIsVisible) {
                [AppUtils showAlertMessageTimerClose:@"收藏失败!"];
            }
            else {
                [AppUtils dismissHUD];
            }
        }];
        
    }else{/*取消收藏*/
        
        Life_First * handel = [Life_First new];
        ShouCangGoods * shou = [ShouCangGoods new];
        shou.memberId = [UserManager shareManager].userModel.memberId;
        shou.productId = _productId;
        
        [handel DeleGoodsShou:shou success:^(id obj) {
            if ([obj[@"code"] isEqualToString:@"success"]) {
                sender.selected = !sender.selected;
                [AppUtils showAlertMessageTimerClose:@"取消收藏"];
            }else{
                [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@",obj[@"message"]]];
            }

        } failed:^(id obj) {
            if (self.viewIsVisible) {
                [AppUtils showAlertMessageTimerClose:@"取消收藏失败"];
            }
            else {
                [AppUtils dismissHUD];
            }
        }];
        
    }
    
}

//添加一个按钮
- (UIButton *)addButtonCustom:(UIView *)view frame:(CGRect)frame tag:(int)tag action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    
    [view addSubview:button];
    
    if (action)
    {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}


@end
