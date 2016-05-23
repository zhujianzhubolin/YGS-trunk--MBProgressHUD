//
//  PayViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/13.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "PayViewController.h"
#import "ZSDPaymentView.h"
#import "MoneyBagPayModel.h"
#import "MoneyBagPayHandler.h"
#import "UserManager.h"
#import "PayDoneShangCheng.h"
#import "AppDelegate.h"
#import "WeChatPayClass.h"
#import "BuyViewController.h"
#import "LifeCircleVC.h"
#import "StoreViewController.h"

@interface PayViewController ()<UIAlertViewDelegate>

{
    UIActivityIndicatorView * activity;
}


@end

@implementation PayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startCircle];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [activity stopAnimating];
}

//- (ZSDPaymentView *)paymentView {
//          return payment;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doNothing)];
    self.navigationItem.leftBarButtonItem = leftBar;

    if (self.method == QianBaoMethod) {//钱包支付
        [self qianBaoPayMethod];
    }else{//微信支付
        UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishDo)];
        self.navigationItem.rightBarButtonItem = rightBar;

        [self wxPayMethod];
    }
}


- (void)startCircle{
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//指定进度轮的大小
    activity.layer.cornerRadius = 5;
    
    activity.backgroundColor = [UIColor lightGrayColor];
    [activity setCenter:CGPointMake(IPHONE_WIDTH/2,IPHONE_HEIGHT/2)];//指定进度轮中心点
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    [self.view addSubview:activity];
    [activity startAnimating];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, activity.frame.size.height - 20, activity.frame.size.width, 20)];
    lable.text = @"支付进行中...";
    lable.font = [UIFont systemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [activity addSubview:lable];
}

- (void)doNothing{
    
}

//钱包支付方法
- (void)qianBaoPayMethod{
    ZSDPaymentView *payment = [ZSDPaymentView new];
    NSLog(@"payment = %p",payment);
    __block __typeof(self)weakSelf = self;
    __block __typeof(payment)weakPayment = payment;
    payment.closeBlock = ^{
        NSLog(@"closeBlock,weakPayment =  %p",weakPayment);
        if (weakPayment != nil) {
            [weakSelf closeQianBao];
        }
        weakPayment = nil;
    };
    
    payment.title      = @"请输入支付密码";
    payment.goodsName  = @"应付金额";
    payment.amount     = [self.allMoney floatValue];
    payment.finishBlock = ^(NSString *inputStr) {
        weakPayment = nil;
        
        NSLog(@"finishBlock,weakPayment =  %p",weakPayment);
        MoneyBagPayModel *payM =[MoneyBagPayModel new];
        MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
        
        payM.memberId      = [UserManager shareManager].userModel.memberId;
        //先注释掉，待钱包修改后解注
        payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
        payM.amount        = weakSelf.allMoney;
        payM.payOrderNo    = weakSelf.orderNum;
        
        [AppUtils showProgressMessage:@"正在支付..." withType:SVProgressHUDMaskTypeClear];
        [AppUtils showProgressMessage:W_ALL_PROGRESS withType:SVProgressHUDMaskTypeClear];
        [payH moneybagpay:payM success:^(id moneyPayObj) {
            [AppUtils dismissHUD];
            NSLog(@">>>>>%@",moneyPayObj);
            PayDoneShangCheng * done = [[PayDoneShangCheng alloc] init];
            done.isMine = weakSelf.isMine;
            done.totalPrice = [NSString stringWithFormat:@"%@",weakSelf.allMoney];
            done.orderlist = weakSelf.orderlistArray;
            [weakSelf.navigationController pushViewController:done animated:YES];
        } failed:^(id moneyPayObj) {
            
            [AppUtils dismissHUD];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"支付失败，%@，您可以在我的订单内继续支付",moneyPayObj] delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
            alert.tag = 1000;
            [alert show];
            return ;
        }];
    };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [payment show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [AppUtils closeKeyboard];
    if (alertView.tag == 1000) {//钱包支付错误
        if (buttonIndex == 0) {
                [self pushToMoyOrder];
        }else{
                if (self.viewIsVisible) {
                    [self qianBaoPayMethod];
                }
        }

    }else if (alertView.tag == 1001){//关闭钱包
    
        if (buttonIndex == 0) {
                [self pushToMoyOrder];

        }else{
                if (self.viewIsVisible) {
                    [self qianBaoPayMethod];
                }
        }
            
    }else if(alertView.tag == 1002){//微信支付取消
    
        if (buttonIndex == 0) {
            
            [self pushToMoyOrder];
            
        }else{
            
            if (self.viewIsVisible) {
                [self wxPayMethod];
            }
            
        }
        
    }else{//完成
    
        if (buttonIndex == 0) {
            
            __block BOOL isPop = NO;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[StoreViewController class]]) {
                    isPop = YES;
                    [self.navigationController popToViewController:obj animated:YES];
                    return;
                    *stop = YES;
                }
            }];
            
            if (!isPop) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            
            if (self.viewIsVisible) {
                [self wxPayMethod];
            }
            
        }
    }
    
}


- (void)pushToMoyOrder{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BuyViewController * buy = [[BuyViewController alloc] init];
        buy.ifShopOrTuanGou = ShopClass;
        buy.currentType=ShopTypeWaitPay;
        [self.navigationController pushViewController:buy animated:YES];
    });

}

//微信支付方式
- (void)wxPayMethod{
    
    //调起微信支付
    [WeChatPayClass wxPayWithOrderName:@"" price:@"" order:self.orderNum];
    AppDelegate * dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dele.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
        NSLog(@"支付结果>>>>%ld",(unsigned long)payStatus);
        
        if (payStatus == 0) {
            PayDoneShangCheng * done = [[PayDoneShangCheng alloc] init];
            done.orderlist = self.orderlistArray;
            done.isMine = self.isMine;
            done.totalPrice = [NSString stringWithFormat:@"%@",self.allMoney];
            [self.navigationController pushViewController:done animated:YES];
        }else{

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已取消支付，您可以在我的订单内继续支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
            alert.tag = 1002;
            [alert show];
            
            return ;
            
        }
    };
}


//关闭钱包的事件
- (void)closeQianBao{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已取消支付，您可以在我的订单内继续支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
    alert.tag = 1001;
    [alert show];
    return;
    
}

//点击完成做的事情
- (void)finishDo{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已下单成功，您可以在我的订单内继续支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
    alert.tag = 1003;
    [alert show];
    return;
}

@end
