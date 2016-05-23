//
//  GrayViewController.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/13.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "GrayViewController.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"
#import "ZYXiaoMiPaySuccessVC.h"
#import "ZSDPaymentView.h"
#import "MoneyBagPayModel.h"
#import "MoneyBagPayHandler.h"
#import "UserManager.h"
#import "ZYXiaoMiPlayerVC.h"


@interface GrayViewController ()
{
    UIActivityIndicatorView * activity;
}

@end

@implementation GrayViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=YES;
    [self startCircle];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [activity stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付订单";
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(doNothing)];
    self.navigationItem.leftBarButtonItem = left;
    
    
    if (self.method2 == WXPayMethod2) {
        
        UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishDo)];
        self.navigationItem.rightBarButtonItem = rightBar;
        
        [self wxPayMethod];
    }else{
        [self qianBaoPayMethod];
    }

}

- (void)doNothing{
    
}

- (void)finishDo{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已下单成功，您可以在我的订单内继续支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
    alert.tag = 1003;
    [alert show];
}

- (void)wxPayMethod{
    
    //调起微信支付
    [WeChatPayClass wxPayWithOrderName:@"" price:@"" order:self.orderinformation[@"wxOrderNo"]];
    AppDelegate * dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dele.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
        NSLog(@"支付结果>>>>%ld",(unsigned long)payStatus);
        
        if (payStatus == 0) {
            
            [self paySuccess];
            
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"订单会保持24小时，请及时支付，逾期订单失效后需重新上传素材！您可在我的媒体找到订单。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
            alert.tag = 1002;
            [alert show];
        }
    };
    
    
}

//钱包支付方法
- (void)qianBaoPayMethod{
    
    ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
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
    NSLog(@"_totalFee==%@",_totalFee);
    payment.title      = @"请输入支付密码";
    payment.goodsName  = @"应付金额";
    payment.amount     = [self.orderinformation[@"payAmount"] floatValue];
    payment.finishBlock = ^(NSString *inputStr) {
        weakPayment = nil;
        NSLog(@"finishBlock");
        
        MoneyBagPayModel *payM =[MoneyBagPayModel new];
        MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
        
        payM.memberId      = [UserManager shareManager].userModel.memberId;
        //先注释掉，待钱包修改后解注
        payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
        payM.amount        = self.orderinformation[@"payAmount"];
        payM.payOrderNo    = self.orderinformation[@"orderIdPay"];
        //[AppUtils showProgressMessage:W_ALL_PROGRESS withType:SVProgressHUDMaskTypeClear];
        [payH moneybagpay:payM success:^(id moneyPayObj) {
            
            
            //[AppUtils dismissHUD];
            [self paySuccess];
        } failed:^(id moneyPayObj) {
            
            //[AppUtils dismissHUD];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"支付失败，%@，您可以在我的订单内继续支付",moneyPayObj] delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
            alert.tag = 1000;
            [alert show];
            return ;
        }];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [payment show];
    });
}


-(void)paySuccess{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZYXiaoMiPaySuccessVC * done = [[ZYXiaoMiPaySuccessVC alloc] init];
        done.moneyStr = self.orderinformation[@"payAmount"];
        [self.navigationController pushViewController:done animated:YES];

    });
    
}

//关闭钱包的事件
- (void)closeQianBao{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"订单会保持24小时，请及时支付，逾期订单失效后需重新上传素材！您可在我的媒体找到订单。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
    alert.tag = 1001;
    [alert show];
    return;
    
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
            
            [self pushToMoyOrder];
            
        }else{
            if (self.viewIsVisible) {
                [self wxPayMethod];
            }
        }
    }
    
}

//前往我的订单
- (void)pushToMoyOrder{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZYXiaoMiPlayerVC * xiaomiPlayer = [[ZYXiaoMiPlayerVC alloc] init];
        [self.navigationController pushViewController:xiaomiPlayer animated:YES];
    });
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
