//
//  WTTuanGouDetail.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "WTTuanGouDetail.h"
#import "ZJWebProgrssView.h"
#import "UserManager.h"
#import "Life_First.h"
#import "StoreGoodsDetailModel.h"
#import "TuanOrderPageViewController.h"
#import "TGPingJianViewController.h"
#import "TGShopDetailViewController.h"


@interface WTTuanGouDetail ()<UIWebViewDelegate>

{
    __weak IBOutlet UIWebView *webV;
    ZJWebProgrssView *progressV;
    UIButton * shoucangbtn;
    NSString * KuCun;
    __weak IBOutlet UIButton *addbtn;
    __weak IBOutlet UIView *backView;
    __weak IBOutlet UIButton *jianBtn;
    __weak IBOutlet UILabel *numLable;
    int numBer;
    __weak IBOutlet UIButton *buyNowBtn;
    NSDictionary * goodsInfor;
}

@end

@implementation WTTuanGouDetail

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"团购详情";
    
    numBer = 1;
    numLable.text = [NSString stringWithFormat:@"%d",numBer];
    NSLog(@"团购详情>>>>>%@",self.goodsModel);

    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(getGoodsDetail) userInfo:nil repeats:NO];

    
    shoucangbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [shoucangbtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [shoucangbtn setImage:[UIImage imageNamed:@"shoucang_h"] forState:UIControlStateSelected];
    [shoucangbtn addTarget:self action:@selector(ShouCangGoods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:shoucangbtn];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem2];
    
    __block typeof (self)weakSelf = self;
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:weakSelf selector:@selector(getGoodsDetail) userInfo:nil repeats:NO];
    };
    [progressV startAnimation];
}

- (IBAction)numJian:(UIButton *)sender {

    if (numBer <= 1) {
        return;
    }
    numBer --;
    numLable.text = [NSString stringWithFormat:@"%d",numBer];
}

- (IBAction)numAdd:(UIButton *)sender {
    
    numBer ++;
    numLable.text = [NSString stringWithFormat:@"%d",numBer];
    
}

- (void)getGoodsDetail{

    Life_First * handel = [Life_First new];
    StoreGoodsDetailModel * detailmodel = [StoreGoodsDetailModel new];
    detailmodel.productId = self.goodsModel.goodsid;
    detailmodel.memberId = [UserManager shareManager].userModel.memberId;
    [handel getStoreGoodsDetail:detailmodel success:^(id obj) {
        
        NSLog(@"商品详情>>>>%@",obj);
        
        if (![obj[@"entity"] isEqual:[NSNull null]]) {
            KuCun = obj[@"entity"][@"stock"];
            [self loadJsView:KuCun];
            goodsInfor = (NSDictionary *)obj[@"entity"];
            if ([obj[@"entity"][@"status"] isEqualToString:@"N"]) {
                shoucangbtn.selected = NO;
            }else{
                shoucangbtn.selected = YES;
            }
            
            if (![obj[@"entity"][@"marketStatus"] isEqualToString:@"ON_MARKET"]) {
                shoucangbtn.hidden = YES;
                backView.hidden = YES;
            }
            
            
            NSString * startTime = [NSString stringWithFormat:@"%@",goodsInfor[@"groupStartDate"]];
            NSString * endTime = [NSString stringWithFormat:@"%@",goodsInfor[@"groupEndDate"]];
            NSString * serVerTime = [NSString stringWithFormat:@"%@",goodsInfor[@"serverTime"]];
            
            //还未开始
            if ([serVerTime  compare:startTime] == NSOrderedAscending) {
                [buyNowBtn setTitle:@"即将开售" forState:UIControlStateNormal];
            }else if ([serVerTime compare:endTime] == NSOrderedDescending){//已经结束
                [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            }else{
                [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            }
            
        }
        
        
        
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA
                            isShow:self.viewIsVisible];
        [progressV stopAnimationFailIsNoData:YES];
    }];

}

- (void)loadJsView:(NSString *)kucun{
    
    webV.frame = self.view.bounds;
    webV.scrollView.showsVerticalScrollIndicator = NO;
    webV.delegate = self;
    webV.scalesPageToFit = YES;
    
//    NSString *urlStr = [NSString stringWithFormat:@"http://%@11005/weixin/wx/group_buying!detail.action?id=%@&memberId=%@",A_HOST_SUP,self.goodsModel.goodsid,[UserManager shareManager].userModel.memberId];
    
    NSString *urlStr;

//    #ifdef DEBUG
//        urlStr = [NSString stringWithFormat:@"http://%@11005/weixin/wx/group_buying!detail.action?id=%@&memberId=%@",A_HOST_SUP,self.goodsModel.goodsid,[UserManager shareManager].userModel.memberId];
//    #else
        urlStr = [NSString stringWithFormat:@"http://wechat.ygs001.com/weixin/wx/group_buying!detail.action?id=%@&memberId=%@",self.goodsModel.goodsid,[UserManager shareManager].userModel.memberId];
//    #endif
    


    [self loadWebWithUrl:urlStr];
    
    webV.scalesPageToFit = YES;
}

//立即购买
- (IBAction)buyNow:(UIButton *)sender {
    
    if (numBer > [KuCun intValue]) {
        [AppUtils showAlertMessage:[NSString stringWithFormat:@"该商品库存为%@,您购买的数量大于库存，请先修改!",KuCun]];
        return;
    }
    
    NSString * startTime = [NSString stringWithFormat:@"%@",goodsInfor[@"groupStartDate"]];
    NSString * endTime = [NSString stringWithFormat:@"%@",goodsInfor[@"groupEndDate"]];
    NSString * serVerTime = [NSString stringWithFormat:@"%@",goodsInfor[@"serverTime"]];
    
    //还未开始
    if ([serVerTime  compare:startTime] == NSOrderedAscending) {
        
        [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@开售",startTime]];
        return ;
        
    }else if ([serVerTime compare:endTime] == NSOrderedDescending){//已经结束
        
        [AppUtils showAlertMessageTimerClose:@"团购已经结束"];
        return;
    }else{
        
        TGGoodsModel * newModel = [TGGoodsModel new];
        
        newModel.goodsNum = [NSString stringWithFormat:@"%d",numBer];
        
        newModel.atStatus = [NSString stringWithFormat:@"%@",goodsInfor[@"atStatus"]];
        newModel.details = [NSString stringWithFormat:@"%@",goodsInfor[@"details"]];
        newModel.effectiveTime = [NSString stringWithFormat:@"%@",goodsInfor[@"effectiveTime"]];
        newModel.fullMoney = [NSString stringWithFormat:@"%@",goodsInfor[@"fullMoney"]];
        newModel.goodsid = [NSString stringWithFormat:@"%@",goodsInfor[@"id"]];
        newModel.img = [NSString stringWithFormat:@"%@",goodsInfor[@"img"]];
        newModel.listImg = [NSString stringWithFormat:@""];
        newModel.madein = [NSString stringWithFormat:@"%@",goodsInfor[@"madein"]];
        newModel.marketStatus = [NSString stringWithFormat:@"%@",goodsInfor[@"marketStatus"]];
        newModel.market_price = [NSString stringWithFormat:@"%@",goodsInfor[@"market_price"]];
        newModel.name = [NSString stringWithFormat:@"%@",goodsInfor[@"name"]];
        newModel.notFullMoney = [NSString stringWithFormat:@"%@",goodsInfor[@"notFullMoney"]];
        newModel.num = [NSString stringWithFormat:@"%@",goodsInfor[@"num"]];
        newModel.price = [NSString stringWithFormat:@"%@",goodsInfor[@"price"]];
        newModel.shortDescription = [NSString stringWithFormat:@"%@",goodsInfor[@"shortDescription"]];
        newModel.standard = [NSString stringWithFormat:@"%@",goodsInfor[@"standard"]];
        newModel.status = [NSString stringWithFormat:@"%@",goodsInfor[@"status"]];
        newModel.stock = [NSString stringWithFormat:@""];
        newModel.storeEndDate = [NSString stringWithFormat:@"%@",goodsInfor[@"storeEndDate"]];
        newModel.storeId = [NSString stringWithFormat:@"%@",goodsInfor[@"storeId"]];
        newModel.storeName = [NSString stringWithFormat:@"%@",goodsInfor[@"storeName"]];
        newModel.storeStartDate = [NSString stringWithFormat:@"%@",goodsInfor[@"storeStartDate"]];
        
        newModel.groupEndDate = [NSString stringWithFormat:@"%@",goodsInfor[@"groupEndDate"]];
        newModel.groupStartDate = [NSString stringWithFormat:@"%@",goodsInfor[@"groupStartDate"]];
        newModel.serverTime = [NSString stringWithFormat:@"%@",goodsInfor[@"serverTime"]];
        
        
        TuanOrderPageViewController * order = [[TuanOrderPageViewController alloc] init];
        order.goodsInfor = newModel;
        [self.navigationController pushViewController:order animated:YES];
        
    }
}


//团购商品收藏
- (void)ShouCangGoods:(UIButton *)sender{
    
    if (!sender.selected) {/*添加收藏*/
        
        Life_First * handel = [Life_First new];
        ShouCangGoods * shou = [ShouCangGoods new];
        shou.memberId = [UserManager shareManager].userModel.memberId;
        shou.productId = self.goodsModel.goodsid;
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
        shou.productId = self.goodsModel.goodsid;
        
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


- (void)loadWebWithUrl:(NSString *)urlStr {
    
    NSLog(@"详情链接>>>>>%@",urlStr);
    
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (funcStr.length <= 0) {
            return YES;
        }
        
        //无参数的
        if([funcStr isEqualToString:@"webViewPushToShopDetailVC"])
        {
            /*调用本地函数1*/
            NSLog(@"webViewPushToShopDetailVC");
            TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
            detail.shopId = [NSString stringWithFormat:@"%@",goodsInfor[@"storeId"]];
            [self.navigationController pushViewController:detail animated:YES];

        }
        else if ([funcStr isEqualToString:@"webViewPushToEvaluateVC"]) {
            NSLog(@"webViewPushToEvaluateVC");
            TGPingJianViewController * pingJia = [[TGPingJianViewController alloc] init];
            pingJia.goodsID = self.goodsModel.goodsid;
            [self.navigationController pushViewController:pingJia animated:YES];
        }
        
        //有参数的
        if(2 == [arrFucnameAndParameter count])
        {
            if ([funcStr isEqualToString:@"webViewPhoneCall"] && [arrFucnameAndParameter objectAtIndex:1]){
                [AppUtils callPhone:[arrFucnameAndParameter objectAtIndex:1]];
            }
        }
        return NO;
    };
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    [progressV stopAnimationNormalIsNoData:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"didFailLoadWithError,error = %@",error);
    [progressV stopAnimationFailIsNoData:YES];
}


@end
