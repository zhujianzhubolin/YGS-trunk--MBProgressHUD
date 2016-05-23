//
//  MainTBViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define DEFAULTIMG      @"defaultImg_w"

typedef NS_ENUM (NSUInteger,MenuButtonTag) {
    MenuButtonTagLifeCircle = 1,
    MenuButtonTagFleaMarket,
    MenuButtonTagHomePurchase,
    MenuButtonTagPrepareCost,
    MenuButtonTagReportThingsService,
    MenuButtonTagHouseSaleAndRent,
    MenuButtonTagManagerialReport,
    MenuButtonTagCommunityAffairs,
    MenuButtonTagConsultationService,
    MenuButtonTagMore
};

#import "MainTBViewController.h"
#import "UserManager.h"
#import "NSString+wrapper.h"
#import "ChangePostionButton.h"
#import <MJRefresh.h>
#import "CommunityViewCotroller.h"
#import "MainMenuCell.h"
#import "MainAdvertisingCell.h"
#import "NSArray+wrapper.h"
#import "ADEntity.h"
#import <UIImageView+AFNetworking.h>
#import "LifeCircleVC.h"
#import "FeesPaidViewController.h"
#import "ReportThingsServiceTBVC.h" 
#import "ManagerialReportVC.h"
#import "CommunityAffairsTBVC.h"
#import "ConsultationServiceTBVC.h"
#import "MoreLife.h"
#import "AdvertiseHandler.h"    
#import "MultiShowing.h"
#import "WebImage.h"
#import "ShangChengGoodsDeatil.h"
#import "WebVC.h"   
#import "EasyDetail.h"
#import "NoticeTBVC.h"
#import "HousingViewController.h"
#import "GoodsViewController.h"
#import "IdleMarketVC.h"
#import "HouseRentingVC.h"
#import "SDCycleScrollView.h"
#import "PassPermitTBVC.h"
#import "WTZhouBianKuaiSong.h"
#import "TGShopDetailViewController.h"
#import "WTTuanGouDetail.h"
#import "AdActivityWebVC.h" 
#import "MilletPlayerVC.h"
#import "AppManager.h"

@interface MainTBViewController () <UITableViewDataSource,
                                    UITableViewDelegate,
                                    SDCycleScrollViewDelegate>

@end

@implementation MainTBViewController
{
    IBOutlet UITableView *usertableView;
    NSArray *headerADArr;
    MultiShowing *multiS;
    SDCycleScrollView *adScollView2;
    AdvertiseHandler *adHandler;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabbar];
    [self refreshUI];
    
    if ([UserManager shareManager].isFromLogin) {
        [UserManager shareManager].isFromLogin = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [usertableView.header beginRefreshing];
        });
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AppManager shareManager] getSystemVersionInfo];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)refreshUI {
    UIView *topRightV = self.navigationItem.rightBarButtonItem.customView;
    for (UIView *subV in topRightV.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *topRightBtn = (UIButton *)subV;
            if (![NSString isEmptyOrNull:[UserManager shareManager].comModel.xqName]) {
                [topRightBtn setTitle:[UserManager shareManager].comModel.xqName forState:UIControlStateNormal];
            }
            else {
                [topRightBtn setTitle:P_NMAE forState:UIControlStateNormal];
            }
        }
    }
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:usertableView];
}

- (void)initData {
    headerADArr = [NSArray array];
    multiS = [MultiShowing new];
    adHandler = [AdvertiseHandler new];
}

- (void)pushToOfficialWebsite {
    WebVC *officialWebVC = [WebVC new];
    officialWebVC.webURL = P_OFFICIAL_WEBSITE;
    [self.navigationController pushViewController:officialWebVC animated:YES];
}

- (void)initUI {
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    usertableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    usertableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    usertableView.showsVerticalScrollIndicator = NO;
    self.tabBarController.tabBar.tintColor = [AppUtils colorWithHexString:@"fa6900"];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];

    UIView *topRightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width /2, 40)];
    
    CGFloat rightImgHeight = 10;
    CGFloat rightImgWidth = rightImgHeight + 5;
    CGFloat interval = 5;
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.frame = CGRectMake(0, 0, topRightV.frame.size.width - rightImgWidth - interval, topRightV.frame.size.height);

    [topButton setTitle:P_NMAE forState:UIControlStateNormal];
    [topButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    topButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [topButton addTarget:self action:@selector(chooseCommunity) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *topImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topImgBtn.frame =  CGRectMake(topRightV.frame.size.width - rightImgWidth, (topRightV.frame.size.height - rightImgHeight) /2, rightImgWidth, rightImgHeight);
    topImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [topImgBtn setImage:[UIImage imageNamed:@"listOrangeButtom"] forState:UIControlStateNormal];
    [topImgBtn addTarget:self action:@selector(chooseCommunity) forControlEvents:UIControlEventTouchUpInside];
    
    [topRightV addSubview:topImgBtn];
    [topRightV addSubview:topButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topRightV];
    
    CGFloat height = self.navigationController.navigationBar.frame.size.height- 8;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, height * 3.4627, height);
    [leftBtn setImage:[UIImage imageNamed:P_MAIN_IMG] forState:UIControlStateNormal];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
#ifdef SmartComJYZX
    [leftBtn addTarget:self action:@selector(pushToOfficialWebsite) forControlEvents:UIControlEventTouchUpInside];
#elif SmartComYGS

#else
    
#endif
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    adScollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width *366 / 1080)
                                                      delegate:self
                                              placeholderImage:[UIImage imageNamed:P_MAIN_AD_IMG]];
    adScollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    adScollView2.currentPageDotColor = [UIColor whiteColor];
    adScollView2.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    usertableView.tableHeaderView = adScollView2;
    
    __block __typeof(self)weakSelf = self;
    [usertableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshDataForMainAdIsHeader:YES];
    }];
    
    [usertableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf refreshDataForMainAdIsHeader:NO];
    }];
}

- (void)refreshDataForMainAdIsHeader:(BOOL)isheader {
    __block BOOL adTopIsBack = NO;
    __block BOOL adButtomIsBack = NO;
    
    if (isheader) {
        //获取顶部广告
        ADEntity * admodel = [ADEntity new];
        admodel.companyId = [NSNumber numberWithLong:[UserManager shareManager].comModel.wyId.integerValue];
        admodel.communityhouseId = [NSNumber numberWithLong:[UserManager shareManager].comModel.xqNo.integerValue];
        admodel.code = @"APP_INDEX";
        
        [adHandler executeMainTopAdvertiseTaskWithUser:admodel success:^(id obj) {
            headerADArr = (NSArray *)obj;
            
            NSMutableArray *imgArr = [NSMutableArray new];
            [headerADArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ADEntity *adModel = headerADArr[idx];
                [imgArr addObject:adModel.imageAddres];
            }];
            
            if (imgArr.count > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    adScollView2.imageURLStringsGroup = imgArr;
                });
            }
            else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    adScollView2.imageURLStringsGroup = @[P_MAIN_AD_IMG];
                });
            }
            
            if (imgArr.count > 1) {
                adScollView2.autoScroll = YES;
            }
            else {
                adScollView2.autoScroll = NO;
            }

            adTopIsBack = YES;
            if (adTopIsBack && adButtomIsBack) {
                [AppUtils tableViewEndMJRefreshWithTableV:usertableView];
            }
        } failed:^(id obj) {
            adTopIsBack = YES;
            if (adTopIsBack && adButtomIsBack) {
                [AppUtils tableViewEndMJRefreshWithTableV:usertableView];
            }
        }];
    }

    //获取底部广告
    ADEntity * adBottomModel = [ADEntity new];
    
    adBottomModel.companyId = [NSNumber numberWithLong:[UserManager shareManager].comModel.wyId.integerValue];
    adBottomModel.communityhouseId = [NSNumber numberWithLong:[UserManager shareManager].comModel.xqNo.integerValue];
    adBottomModel.code = @"APP_INDEX2";
    adBottomModel.pageSize = @"10";
    
    [adHandler executeMainButtomAdvertiseTaskWithUser:adBottomModel success:^(id obj) {
        [usertableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        adButtomIsBack = YES;
        if (!isheader) {
            [AppUtils tableViewEndMJRefreshWithTableV:usertableView];
        }
        else {
            if (adTopIsBack && adButtomIsBack) {
                [AppUtils tableViewEndMJRefreshWithTableV:usertableView];
            }
        }
    } failed:^(id obj) {
        adButtomIsBack = YES;
        if (!isheader) {
            [AppUtils tableViewEndMJRefreshWithTableV:usertableView];
        }
        else {
            if (adTopIsBack && adButtomIsBack) {
                [AppUtils tableViewEndMJRefreshWithTableV:usertableView];
            }
        }
    } isHeader:isheader];
}

- (void)chooseCommunity {
    CommunityViewCotroller *communityVC = [CommunityViewCotroller new];
    communityVC.comBlock = ^(BingingXQModel *comModel) {
        if (!usertableView.header.isRefreshing) {
            [usertableView.header beginRefreshing];
        }
    };
    communityVC.communityType = CommunityChooseTypeChooseDefault;
    
    [[SwitchVCAnimation shareInstance] replaceAnimationType:AnimationTypeFade];
    [[SwitchVCAnimation shareInstance] replaceAnimationDirection:AnimationDirectionTop];
    [self.navigationController.view.layer addAnimation:[[SwitchVCAnimation shareInstance] getTransitionAnimation] forKey:nil];
    
    [self.navigationController pushViewController:communityVC animated:YES];
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:15]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showImgForAdModel:(ADEntity *)adModel defaultImg:(UIImage *)defalutImg{
    if ([NSString isEmptyOrNull:adModel.imageAddres]) {
        [multiS ShowImageGalleryFromView:self.tableView ImageList:[NSMutableArray arrayWithObject:defalutImg] ImgType:ImgTypeFromImg Scale:1.0];
        return;
    }
    
    NSMutableArray *webArr = [NSMutableArray array];
    WebImage *webImg = [WebImage new];
    webImg.url = adModel.imageAddres;
    [webArr addObject:webImg];
    
    [multiS ShowImageGalleryFromView:self.tableView ImageList:webArr ImgType:ImgTypeFromWeb Scale:1.0];
}

- (void)advertiseClickWithAdModel:(ADEntity *)adModel defaultImg:(UIImage *)defalutImg{
    if ([NSString isEmptyOrNull:adModel.type]) {
        [self showImgForAdModel:adModel defaultImg:[UIImage imageNamed:P_MAIN_AD_IMG]];
        return;
    }
    
    if ([adModel.type isEqualToString:@"advertisement"]) { //广告
        if ([NSString isEmptyOrNull:adModel.linkCode]) { //无链接地址
            [self showImgForAdModel:adModel defaultImg:defalutImg];
            return;
        }
        
        WebVC *webVc = [WebVC new];
        webVc.webURL = adModel.linkCode;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    else if ([adModel.type isEqualToString:@"product"]) { //商品
        if ([NSString isEmptyOrNull:adModel.productId]) {
            [self showImgForAdModel:adModel defaultImg:defalutImg];
            return;
        }

        if (![NSString isEmptyOrNull:adModel.productType] ) {
            if ([adModel.productType isEqualToString:@"Group"]) { //团购
                WTTuanGouDetail * detail = [[WTTuanGouDetail alloc] init];
                TGGoodsModel * goodsModel = [TGGoodsModel new];
                goodsModel.goodsid = adModel.productId;
                detail.goodsModel = goodsModel;
                [self.navigationController pushViewController:detail animated:YES];
            }
            else if ([adModel.productType isEqualToString:@"Supplier"] || //网上商城商品
                     [adModel.productType isEqualToString:@"Quickly"]) { //小时送
                ShangChengGoodsDeatil *goodDetailVC = [ShangChengGoodsDeatil new];
                goodDetailVC.productId = adModel.productId;
                [self.navigationController pushViewController:goodDetailVC animated:YES];
            }
            else {
                [self showImgForAdModel:adModel defaultImg:defalutImg];
            }
        }
        else { //该商品无类型
            [self showImgForAdModel:adModel defaultImg:defalutImg];
        }
    }
    else if ([adModel.type isEqualToString:@"merchant"]) { //商家
        if ([NSString isEmptyOrNull:adModel.productType]) {
            [self showImgForAdModel:adModel defaultImg:defalutImg];
            return;
        }

        TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
        detail.shopId = adModel.merchantId;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if ([adModel.type isEqualToString:@"ctivity"]) { //网页活动
        if ([NSString isEmptyOrNull:adModel.productType]) {
            [self showImgForAdModel:adModel defaultImg:defalutImg];
            return;
        }
        
         if ([adModel.productType isEqualToString:kAdWebActivity]) { //领券
             if ([NSString isEmptyOrNull:adModel.linkCode]) {
                 [self showImgForAdModel:adModel defaultImg:defalutImg];
                 return;
             }
             else {
                 AdActivityWebVC *adWebVC = [AdActivityWebVC new];
                 adWebVC.adTypeStr = kAdWebActivity;
                 adWebVC.webURL = adModel.linkCode;
                 [self.navigationController pushViewController:adWebVC animated:YES];
             }
         }
         else {
             [self showImgForAdModel:adModel defaultImg:defalutImg];
         }
    }
    else {
        [self showImgForAdModel:adModel defaultImg:defalutImg];
        return;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
#ifdef SmartComJYZX
    if (index == 0) {
        UIStoryboard *mainSTB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
        NoticeTBVC *noticeVC = [mainSTB instantiateViewControllerWithIdentifier:@"NoticeTBVCID"];
        [self.navigationController pushViewController:noticeVC animated:YES];
        return;
    }
#elif SmartComYGS
    
#else
    
#endif

    if (![NSArray isArrEmptyOrNull:headerADArr] && index < headerADArr.count) {
        ADEntity *adModel = headerADArr[index];
        [self advertiseClickWithAdModel:adModel defaultImg:[UIImage imageNamed:DEFAULTIMG]];
        return;
    }

    ADEntity *adModel = [ADEntity new];
    [self advertiseClickWithAdModel:adModel defaultImg:[UIImage imageNamed:P_MAIN_AD_IMG]];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat menuInterval = 10;
    CGFloat menuSideInterval = 8;
    CGFloat menuWidth = (tableView.frame.size.width - 2*menuInterval - 2 *15 - 2*menuInterval) / 3;
    CGFloat menuHeight = menuWidth / 99 * 102;

    if (indexPath.row == 0) {
        return menuSideInterval *2 + menuHeight *4 + menuInterval *3;
    }
    else if (indexPath.row == 1) {
        NSUInteger adButtomLines = adHandler.mainAdArr.count / 2 + adHandler.mainAdArr.count % 2;
        CGFloat oneLineheight = (self.view.frame.size.width - 3 * cellInterval) / 2 / 1.75;
        return (oneLineheight + cellInterval) * adButtomLines;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [AppUtils tableViewFooterPromptWithPNumber:adHandler.mainAdPNumber.integerValue
                                    withPCount:adHandler.mainAdPCount.integerValue
                                     forTableV:usertableView];
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MainMenuCell *menuCell = (MainMenuCell *)cell;
        menuCell.aCellClick = ^(NSUInteger buttonTag){
            switch (buttonTag) {
                case MenuButtonTagLifeCircle: {
                    LifeCircleVC *lifeCircleVC = [LifeCircleVC new];
                    [self.navigationController pushViewController:lifeCircleVC animated:YES];
                }
                    break;
                case MenuButtonTagHomePurchase: {
                    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"ShangChenng" bundle:nil];
                    UIViewController *paySuccessVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"MyShangCheng"];
                    [self.navigationController pushViewController:paySuccessVC animated:YES];
                }
                    break;
                case MenuButtonTagPrepareCost: {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
                    FeesPaidViewController *feesPaidVC = (FeesPaidViewController *)[mainStoryboard instantiateInitialViewController];
                    [self.navigationController pushViewController:feesPaidVC animated:YES];
                }
                    break;
                case MenuButtonTagReportThingsService: {
                    ReportThingsServiceTBVC *reportTBVC = [ReportThingsServiceTBVC new];
                    [self.navigationController pushViewController:reportTBVC animated:YES];
                }
                    break;
                case MenuButtonTagManagerialReport: {
                    
#ifdef SmartComJYZX
                    if ([[UserManager shareManager] showCommunityAlertIsBindingFromNav:self.navigationController]) {
                        return;
                    }
                    ManagerialReportVC *managerReportVC = [ManagerialReportVC new];
                    [self.navigationController pushViewController:managerReportVC animated:YES];
#elif SmartComYGS
                    
                    WTZhouBianKuaiSong * tuangou = [[WTZhouBianKuaiSong alloc] init];
                    [self.navigationController pushViewController:tuangou animated:YES];
#else
                    
#endif
                    
                }
                    break;
                case MenuButtonTagCommunityAffairs: {
                    
#ifdef SmartComJYZX
                    CommunityAffairsTBVC *communityVC = [CommunityAffairsTBVC new];
                    [self.navigationController pushViewController:communityVC animated:YES];
#elif SmartComYGS
                    UIStoryboard *mainSTB = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
                    NoticeTBVC *noticeVC = [mainSTB instantiateViewControllerWithIdentifier:@"NoticeTBVCID"];
                    [self.navigationController pushViewController:noticeVC animated:YES];
#else
                    
#endif
                }
                    break;
                case MenuButtonTagConsultationService: {
                    
#ifdef SmartComJYZX
                    ConsultationServiceTBVC *consultServiceVC = [ConsultationServiceTBVC new];
                    [self.navigationController pushViewController:consultServiceVC animated:YES];
#elif SmartComYGS
                    WebVC *kuadiVC = [WebVC new];
                    kuadiVC.title = @"快递易";
                    kuadiVC.webURL = @"http://m.kuaidi100.com";
                    [self.navigationController pushViewController:kuadiVC animated:YES];
#else
                    
#endif
                }
                    break;
                case MenuButtonTagMore: {
                    MoreLife *moreLifeVC = [MoreLife new];
                    [self.navigationController pushViewController:moreLifeVC animated:YES];
                }
                    break;
                case MenuButtonTagFleaMarket: {
                    IdleMarketVC *idleMarketvVc = [IdleMarketVC new];
                    [self.navigationController pushViewController:idleMarketvVc animated:YES];
                }
                    break;
                case MenuButtonTagHouseSaleAndRent: {
                    
#ifdef SmartComJYZX
                    HouseRentingVC * rent = [[HouseRentingVC alloc] init];
                    [self.navigationController pushViewController:rent animated:YES];
#elif SmartComYGS
                    MilletPlayerVC *mplayer=[[MilletPlayerVC alloc] init];
                    [self.navigationController pushViewController:mplayer animated:YES];
#endif
                }
                    break;
                default:
                    break;
            }
        };
    }
    else {
        MainAdvertisingCell *adCell = (MainAdvertisingCell *)cell;
        adCell.aCellClick = ^(NSUInteger index){
            [self advertiseClickWithAdModel:adHandler.mainAdArr[index] defaultImg:[UIImage imageNamed:DEFAULTIMG]];
        };
        [adCell reloadMainAdCellWithModel:adHandler.mainAdArr];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier1 = @"menuCell";
        MainMenuCell *cell = (MainMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"barnnerCell";
        MainAdvertisingCell *cell = (MainAdvertisingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
