//
//  EasyDetail.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//shsangjiacell    pingluncell


#import<QuartzCore/QuartzCore.h>
#import "EasyDetail.h"
#import "shangjiaCell.h"
#import "pinglun.h"
#import <MJRefresh.h>
#import "MorePinLun.h"
#import "GoodsViewController.h"

#import "EasyShopInfo.h"
#include "Life_First.h"
#import "ShouCangGoods.h"
#import "UserManager.h"
#import <UIImageView+AFNetworking.h>
#import "WXApi.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
//分享相关
#import "HYActivityView.h"
#import "RatingBar.h"
#import <MJRefresh.h>
#import "YingYeZhiZhao.h"

//举报相关
#import "ZJLongPressGesture.h"
#import "ReportBtn.h"
#import "ReportVC.h"

@interface EasyDetail ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    __weak IBOutlet UIView *backView;
    __weak IBOutlet UIButton *shoucang;
    IBOutlet UITableView *detailTableView;
    NSString * telephoneNum;
    NSDictionary * shopDetail;
    BOOL isShouCangSelect;
    NSMutableArray * pingLunArray;
    NSMutableArray * tempPinLunArray;
    UILabel * numlable;
    UIView * myview;
    int viewwidth;
    int viewheight;
    
}

@property (nonatomic, strong) HYActivityView *activityView;

@end

@implementation EasyDetail

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家详情";
    pingLunArray = [NSMutableArray array];
    //防止查不到数据
//    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopInfor) userInfo:nil repeats:NO];
    [self setExtraCellLineHidden:detailTableView];
    
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
    
    if (self.isRz) {
        //底部View，添加查看更多与添加营业执照
        myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        myview.userInteractionEnabled = YES;
        detailTableView.tableFooterView = myview;
    }
    
    __block typeof(self)weakSelf = self;
    [detailTableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getShopDetailByTime];
    }];
    
    [detailTableView.header beginRefreshing];
}

//定时器获取商家详情
- (void)getShopDetailByTime{
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopInfor) userInfo:nil repeats:NO];

}

//获取商家评论
- (void)getShopPingLun{

    
    Life_First * handel = [Life_First new];
    ShopPingLunModel * model = [ShopPingLunModel new];
    model.pageSize = @"10";
    model.pageNumber = @"1";

    model.storeType = _storeType;//有数据修改
    model.storeId = [NSString stringWithFormat:@"%@",_shopID];
    [handel getShopPingLun:model success:^(id obj) {
        
        [pingLunArray removeAllObjects];
        
        if ([detailTableView.header isRefreshing]) {
            [detailTableView.header endRefreshing];
        }
        
        tempPinLunArray = obj[@"list"];
        
        if (tempPinLunArray.count > 5) {
            
            for (int i = 0; i < 5; i ++) {
                [pingLunArray addObject:tempPinLunArray[i]];
            }
            
        }else{
            pingLunArray = tempPinLunArray;
        }
        
        
        NSLog(@"商家评论>>>>%@",pingLunArray);
        
        [detailTableView reloadData];
        numlable.font = [UIFont systemFontOfSize:15];
        numlable.text = [NSString stringWithFormat:@"   全部评论(%lu)",(unsigned long)tempPinLunArray.count];
        if (tempPinLunArray.count <= 0) {//没有评论的时候
            UILabel * noPinlun = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, myview.frame.size.width, 39)];
            noPinlun.text = @"   暂无评论";
            noPinlun.font = [UIFont systemFontOfSize:15];
            noPinlun.textAlignment = NSTextAlignmentCenter;
            noPinlun.backgroundColor = [UIColor whiteColor];
            [myview addSubview:noPinlun];
        }else if (tempPinLunArray.count > 0 && tempPinLunArray.count <=2){
            UILabel * noPinlun = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, myview.frame.size.width, 39)];
            noPinlun.text = @"   暂无更多评论";
            noPinlun.font = [UIFont systemFontOfSize:15];
            noPinlun.textAlignment = NSTextAlignmentCenter;
            noPinlun.backgroundColor = [UIColor whiteColor];
            [myview addSubview:noPinlun];
        }else{
            //添加更多按钮
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100;
            button.frame = CGRectMake(0, 0, myview.frame.size.width, 39);
            [button setTitle:@"更多>>" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(morePinglun) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [myview addSubview:button];
        }
        //查看营业执照
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.backgroundColor = [UIColor whiteColor];
        button1.tag = 101;
        button1.frame = CGRectMake(0, 41, myview.frame.size.width, 40);
        button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button1 setTitle:@"    营业执照" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:15];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(showPhotoimage) forControlEvents:UIControlEventTouchUpInside];
        [myview addSubview:button1];

    } failed:^(id obj) {
        if ([detailTableView.header isRefreshing]) {
            [detailTableView.header endRefreshing];
        }
        
        [detailTableView reloadData];
        numlable.text = [NSString stringWithFormat:@"  全部评论(%lu)",(unsigned long)pingLunArray.count];
        if (self.viewIsVisible) {
            [AppUtils showErrorMessage:@"未获取商家评论"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];

}

//查看营业执照
- (void)showPhotoimage{
    
    if ([shopDetail[@"entity"][@"yyzzImg"] isEqual:[NSNull null]]) {
        [AppUtils showAlertMessageTimerClose:@"      暂无营业执照可查看!"];
    }else{
        YingYeZhiZhao * photo = [[YingYeZhiZhao alloc] init];
        photo.imageUrl = [NSString stringWithFormat:@"%@",shopDetail[@"entity"][@"yyzzImg"]];
        [self.navigationController pushViewController:photo animated:YES];
    }
    
}

- (void)getShopInfor{
    
    Life_First * handel = [Life_First new];
    EasyShopInfo * info = [EasyShopInfo new];
    info.storeId = _shopID;
    info.memberId = [UserManager shareManager].userModel.memberId;
    
    [handel getShopInfor:info success:^(id obj) {

        NSLog(@"商家详情>>>%@",obj);
        
        if (![obj[@"entity"] isEqual:[NSNull null]]) {
            shopDetail = (NSDictionary *)obj;
            if ([obj[@"entity"][@"status"] isEqualToString:@"Y"]) {
                shoucang.selected = YES;
            }
        }else{
            [AppUtils showAlertMessage:@"暂无商家信息"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        //是认证商家就获取商家品论
        if (self.isRz) {
//            [self getShopPingLun];
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getShopPingLun) userInfo:nil repeats:NO];
        }else{
            
            [detailTableView reloadData];

            if ([detailTableView.header isRefreshing]) {
                [detailTableView.header endRefreshing];
            }
        }

    } failed:^(id obj) {
        
        if (self.isRz) {
//            [self getShopPingLun];
        }else{
            if ([detailTableView.header isRefreshing]) {
                [detailTableView.header endRefreshing];
            }
        }
        
        if (self.viewIsVisible) {
            [AppUtils showErrorMessage:@"未获取到商家信息"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}

//查看更多评论
- (void)morePinglun{
    NSLog(@"More");
    MorePinLun * more = [[MorePinLun alloc] initWithNibName:@"MorePinLun" bundle:nil];
    more.storeType = self.storeType;
    more.storeId = [NSString stringWithFormat:@"%@",self.shopID];
    [self.navigationController pushViewController:more animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isRz) {
        return 6 + pingLunArray.count;
    }else{
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.isRz) {
        if (indexPath.row == 0) {
            return 91;
        }
        else if (indexPath.row == 1 || indexPath.row == 4) {
            return 5;
        }else if(indexPath.row == 2 || indexPath.row == 3){
            
            return 50;
        }else if (indexPath.row == 5){
            
            return 30;
        }
        else {
//            return 73;
//            pinglun * cell = (pinglun *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//            return cell.frame.size.height;
            
            NSString * text = nil;
            
            if ([pingLunArray[indexPath.row-6][@"content"] isEqual:[NSNull null]]) {
                text = @"";
            }else{
                text = pingLunArray[indexPath.row-6][@"content"];
            }
            
            CGSize constraint = CGSizeMake(viewwidth - (8 * 3) -60, 20000.0f);
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:text
             attributes:attributes];
            CGRect rect = [attributedText boundingRectWithSize:constraint
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGSize size = rect.size;
            CGFloat height = MAX(size.height + 45, 63);
            
            return height + 10;
        }

    }else{
    
        if (indexPath.row == 0) {
            return 91;
        }
        else if (indexPath.row == 1) {
            return 5;
        }else{
            return 60;
        }
    }
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isRz) {
        //商家信息
        if (indexPath.row == 0) {
            
            static NSString * str = @"shsangjiacell";
            
            shangjiaCell * shangjia = [tableView dequeueReusableCellWithIdentifier:str];
            
            if (shangjia == nil) {
                shangjia = [[shangjiaCell alloc] init];
            }
            shangjia.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (shopDetail != nil) {
                [shangjia setCellData:shopDetail rzState:self.isRz];
            }
            return shangjia;
        }//系统Cell
        else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
            
            static NSString * normal = @"Systemcell";
            UITableViewCell * normcell = [tableView dequeueReusableCellWithIdentifier:normal];
            normcell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (normcell == nil) {
                normcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
            }
            
            //灰色分割线
            if (indexPath.row == 1 || indexPath.row == 4) {
                normcell.backgroundColor = [AppUtils colorWithHexString:@"#DCDCDC"];
            }
            
            //地址Cell//电话Cell  dingwei   phone_n
            if (indexPath.row == 2 || indexPath.row == 3) {
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 20)];
                
                if (indexPath.row == 2) {
                    imageView.image = [UIImage imageNamed:@"dingwei"];
                }else{
                    imageView.image = [UIImage imageNamed:@"phone_n"];
                }
                
                CALayer * layer = [imageView layer];
                [layer setMasksToBounds:YES];
                [layer setCornerRadius:2];
                [normcell.contentView addSubview:imageView];
                
                UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width - 60, 50)];
                lable.font = [UIFont systemFontOfSize:13];
                lable.numberOfLines = 0;
                [normcell.contentView addSubview:lable];
                //地址
                if (indexPath.row == 2) {
                    lable.text = shopDetail[@"entity"][@"storeAddress"];
                }
                //电话
                if (indexPath.row == 3) {
                    telephoneNum = shopDetail[@"entity"][@"phone"];
                    lable.text = telephoneNum;
                    //一键通
                    UIView * dianhuaview = [[UIView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 70, 10, 60, 30)];
                    dianhuaview.backgroundColor = [UIColor orangeColor];
                    [normcell.contentView addSubview:dianhuaview];
                    dianhuaview.layer.cornerRadius = 5;
                    dianhuaview.clipsToBounds = YES;
                    
                    UIButton * btnC = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnC.frame = CGRectMake(1, 1, dianhuaview.frame.size.width -2, dianhuaview.frame.size.height - 2);
                    btnC.layer.cornerRadius = 5;
                    [btnC setImage:[UIImage imageNamed:@"yijianton"] forState:UIControlStateNormal];
                    btnC.backgroundColor = [UIColor whiteColor];
                    [btnC addTarget:self action:@selector(dadianhua) forControlEvents:UIControlEventTouchUpInside];
                    [dianhuaview addSubview:btnC];
                }
            }
            
            //评论所有
            if (indexPath.row == 5) {
                numlable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 30)];
                [normcell.contentView addSubview:numlable];
            }
            
            return normcell;
            
        }
        //评论部分Cell 6跟7行
        else{
            
            static NSString * pinlun = @"pingluncell";
            
            pinglun * plcell = [tableView dequeueReusableCellWithIdentifier:pinlun];
            
            if (plcell == nil) {
                plcell = [[pinglun alloc] init];
            }
            
            if (pingLunArray.count > 0) {
                [plcell setPingLunData:[pingLunArray objectAtIndex:indexPath.row - 6]];
            }
            plcell.selectionStyle = UITableViewCellSelectionStyleNone;
            ZJLongPressGesture *pressGesture = [[ZJLongPressGesture alloc] initWithTarget:self action:@selector(nilSymbol) toView:plcell.contentView];
            pressGesture.pressBlock = ^{
                [self pushToReportVC:indexPath.row - 6];
            };
            [plcell.contentView addGestureRecognizer:pressGesture];
            
            return plcell;
        }
        
    }else{//未认证商家
        //商家信息
        if (indexPath.row == 0) {
            
            static NSString * str = @"shsangjiacell";
            
            shangjiaCell * shangjia = [tableView dequeueReusableCellWithIdentifier:str];
            
            if (shangjia == nil) {
                shangjia = [[shangjiaCell alloc] init];
            }
            shangjia.selectionStyle = UITableViewCellSelectionStyleNone;
            if (shopDetail != nil) {
                [shangjia setCellData:shopDetail rzState:self.isRz];
            }
            return shangjia;
        }else{//系统Cell
            static NSString * normal = @"Systemcell";
            UITableViewCell * normcell = [tableView dequeueReusableCellWithIdentifier:normal];
            normcell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (normcell == nil) {
            normcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
            }
            
            if (indexPath.row == 1) {
                normcell.backgroundColor = [AppUtils colorWithHexString:@"#DCDCDC"];
            }
            
            //地址Cell//电话Cell  dingwei   phone_n
            if (indexPath.row == 2 || indexPath.row == 3) {
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 21, 15, 20)];
                
                if (indexPath.row == 2) {
                    imageView.image = [UIImage imageNamed:@"dingwei"];
                }else{
                    imageView.image = [UIImage imageNamed:@"phone_n"];
                }
                
                CALayer * layer = [imageView layer];
                [layer setMasksToBounds:YES];
                [layer setCornerRadius:2];
                [normcell.contentView addSubview:imageView];
                
                UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(35,0, self.view.frame.size.width - 60, 60)];
                lable.font = [UIFont systemFontOfSize:15];
                lable.numberOfLines = 0;
                [normcell.contentView addSubview:lable];
                
                
                //地址
                if (indexPath.row == 2) {
                    lable.text = shopDetail[@"entity"][@"storeAddress"];
                }
                //电话
                if (indexPath.row == 3) {
                    
                    telephoneNum = shopDetail[@"entity"][@"phone"];
                    lable.text = telephoneNum;
                    
                    //一键通
                    UIView * dianhuaview = [[UIView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 70, 15, 60, 30)];
                    dianhuaview.backgroundColor = [UIColor orangeColor];
                    [normcell.contentView addSubview:dianhuaview];
                    dianhuaview.layer.cornerRadius = 5;
                    dianhuaview.clipsToBounds = YES;
                    
                    UIButton * btnC = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnC.frame = CGRectMake(1, 1, dianhuaview.frame.size.width -2, dianhuaview.frame.size.height - 2);
                    btnC.layer.cornerRadius = 5;
                    [btnC setImage:[UIImage imageNamed:@"yijianton"] forState:UIControlStateNormal];
                    btnC.backgroundColor = [UIColor whiteColor];
                    [btnC addTarget:self action:@selector(dadianhua) forControlEvents:UIControlEventTouchUpInside];
                    [dianhuaview addSubview:btnC];
                }
            }
            return normcell;
        }
    }
}

- (void)dadianhua{

//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNum];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.view addSubview:callWebview];
    
    [AppUtils callPhone:telephoneNum];
}

//举报
- (void)pushToReportVC:(NSUInteger)dataIndex {
    ReportVC *reportVC = [ReportVC new];
    reportVC.idID = [NSNumber numberWithInt:[pingLunArray[dataIndex][@"commentId"] intValue]];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[ReportBtn btnInstance] removeReportBtn];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if(indexPath.row == 3){
//        NSLog(@"%@",telephoneNum);
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNum];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
//    }else{
//    
//        NSLog(@"不打电话");
//    }
//
//    NSLog(@"%ld",(long)indexPath.row);
//}

//收藏商家
- (IBAction)shoucang:(UIButton *)sender {
    
    Life_First * handel = [Life_First new];
    ShouCangGoods * shop = [ShouCangGoods new];
    
    shop.memberId = [UserManager shareManager].userModel.memberId;
    shop.storeId = [NSString stringWithFormat:@"%@",_shopID];
    
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

////分享商品
//- (IBAction)fenxiang:(UIButton *)sender {
//    
//    if (!self.activityView) {
//        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:[UIApplication sharedApplication].keyWindow];
//        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
//        self.activityView.numberOfButtonPerLine = 2;
//        ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"lfxinlangweibo"] handler:^(ButtonView *buttonView){
//            NSLog(@"点击新浪微博");
//            [[UMSocialControllerService defaultControllerService] setShareText:@"分享内嵌文字" shareImage:[UIImage imageNamed:@"defaultImg_w"] socialUIDelegate:self];        //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        }];
//        [self.activityView addButtonView:bv];
//        
//        
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
//            NSLog(@"install--安装");
//            [UMSocialQQHandler setQQWithAppId:P_APPID_QQ appKey:P_APPKEY_QQ url:@"http://www.baidu.com"];
//            bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"lfQQ"] handler:^(ButtonView *buttonView){
//                NSLog(@"QQ");
//                [UMSocialData defaultData].extConfig.qqData.title = W_PROPERTY_NMAE;
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享文字" image:[UIImage imageNamed:@"defaultImg_w"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                    if (response.responseCode == UMSResponseCodeSuccess) {
//                        NSLog(@"分享成功！");
//                    }
//                }];
//            }];
//            [self.activityView addButtonView:bv];
//        }else{
//            NSLog(@"no---没安装");
//        }
//        
//        if ([WXApi isWXAppInstalled]) {
//            [UMSocialWechatHandler setWXAppId:@"wx1c6f2b037f4687fe" appSecret:@"f4acef7c5259ed6832c0fa818559fbb3" url:@"http://www.baidu.com"];
//            bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"lfweixin"] handler:^(ButtonView *buttonView){
//                NSLog(@"微信");
//                [UMSocialData defaultData].extConfig.wechatSessionData.title = W_PROPERTY_NMAE;
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:[UIImage imageNamed:@"defaultImg_w"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                    if (response.responseCode == UMSResponseCodeSuccess) {
//                        NSLog(@"分享成功！");
//                    }
//                    
//                }];
//                
//            }];
//            [self.activityView addButtonView:bv];
//        }
//        
//        bv = [[ButtonView alloc]initWithText:@"短信" image:[UIImage imageNamed:@"lfduanxin"] handler:^(ButtonView *buttonView){
//            
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:@"分享内嵌文字" image:[UIImage imageNamed:@"defaultImg_w"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    NSLog(@"分享成功！");
//                }
//            }];
//            
//        }];
//        [self.activityView addButtonView:bv];
//    }
//    [self.activityView show];
//    
//
//}
//
//分割线靠边界
-(void)viewDidLayoutSubviews
{
    if ([detailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [detailTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([detailTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [detailTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
