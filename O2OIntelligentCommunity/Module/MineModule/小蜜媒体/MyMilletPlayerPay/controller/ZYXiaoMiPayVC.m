//
//  ZYXiaoMiPayVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/25.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define interval 15
#define Pay_TIME_SIZE  17

#import "ZYXiaoMiPayVC.h"
#import "ZJPayChooseView.h"
#import "ZSDPaymentView.h"
#import "UserManager.h"
#import "WXApi.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"
#import "ZYXiaoMiPlayerVC.h"
#import "ZYXiaoMiPaySuccessVC.h"
#import "OpenMoneyBagVC.h"
#import "GrayViewController.h"


#import "ZhifuModel.h"
#import "ZhifuHandel.h"
#import "MoneyBagPayModel.h"
#import "MoneyBagPayHandler.h"
#import "ZJAdvertisementHandler.h"
#import "ZJSubmitOrdersModel.h"

@interface ZYXiaoMiPayVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation ZYXiaoMiPayVC
{
    UITableView *payTB;
    UILabel     *titleLab;
    UILabel     *moneyLab;
    ZJPayChooseView *payView;
    ZJAdvertisementHandler *advertisementH;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}


-(void)initData
{
    advertisementH = [ZJAdvertisementHandler new];
}

-(void)initUI
{
    self.title=@"移公社收银台";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 80)];
    //headView.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    if (_downOrderType==AginDownOrder)
    {
        titleLab =[[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, interval, IPHONE_WIDTH-G_INTERVAL*2, 25)];
        titleLab.text=[NSString stringWithFormat:@"标题：%@",_milletM.ggTitle];
        [headView addSubview:titleLab];
        
        UILabel *jineLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, CGRectGetMaxY(titleLab.frame), 55, 25)];
        jineLab.text=@"金额：";
        //jineLab.backgroundColor=[UIColor redColor];
        [headView addSubview:jineLab];
        
       
        moneyLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jineLab.frame), CGRectGetMaxY(titleLab.frame), IPHONE_WIDTH-G_INTERVAL*2-jineLab.frame.size.width, 25)];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",_milletM.saleAmount]];
        moneyLab.attributedText=[self PayAttributedStr:mutableStr textLength:0];
        
        moneyLab.textAlignment=NSTextAlignmentLeft;
        [headView addSubview:moneyLab];

    }
    else
    {
        titleLab =[[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, interval, IPHONE_WIDTH-G_INTERVAL*2, 25)];
        titleLab.text=[NSString stringWithFormat:@"标题： %@",_downOrderDic[@"ggTitle"]];
        [headView addSubview:titleLab];
        
        UILabel *jineLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, CGRectGetMaxY(titleLab.frame), 55, 25)];
        jineLab.text=@"金额：";
        //jineLab.backgroundColor=[UIColor redColor];
        [headView addSubview:jineLab];
        
        if(_typeClose ==Artwork )
        {
            moneyLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jineLab.frame), CGRectGetMaxY(titleLab.frame), IPHONE_WIDTH-G_INTERVAL*2-jineLab.frame.size.width, 25)];
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",_money]];
            moneyLab.attributedText=[self PayAttributedStr:mutableStr textLength:0];
            moneyLab.textAlignment=NSTextAlignmentLeft;
            [headView addSubview:moneyLab];

        }
        else
        {
            moneyLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jineLab.frame), CGRectGetMaxY(titleLab.frame), IPHONE_WIDTH-G_INTERVAL*2-jineLab.frame.size.width, 25)];
            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",_money]];
            moneyLab.attributedText=[self PayAttributedStr:mutableStr textLength:0];
            moneyLab.textAlignment=NSTextAlignmentLeft;
            [headView addSubview:moneyLab];

        }
        
    }
    
    
    
    
    
    UIView *footoView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
   
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame=CGRectMake(interval, 70, IPHONE_WIDTH-interval*2, 35);
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    payBtn.backgroundColor=[UIColor orangeColor];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.layer.masksToBounds=YES;
    payBtn.layer.cornerRadius=5;
    [payBtn addTarget:self action:@selector(PayAction) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:payBtn];
    
    payTB =[[UITableView alloc]initWithFrame:self.view.bounds];
    payTB.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    payTB.dataSource=self;
    payTB.delegate=self;
    payTB.tableHeaderView=headView;
    payTB.tableFooterView=footoView;
    payTB.showsVerticalScrollIndicator=NO;
    payTB.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:payTB];
    
    payView = [[ZJPayChooseView alloc]initWithFrame:CGRectMake(0, 0, payTB.frame.size.width, 0)];
}

-(void)PayAction
{
   // currentPayType == PayTypeQianBao && ![UserManager shareManager].isOpenWallet
   
    if (payView.paymethod ==PayMethodQianbao)
    {
        if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"0"])//没有开通钱包
        {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"亲,您尚未开通钱包,请前往 我的->钱包开通" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];
            alertV.delegate = self;
            [alertV show];
            return;
        }
    }
    
    if (_downOrderType==AginDownOrder)
    {
        if (payView.paymethod ==PayMethodQianbao){
            [self yuanTuRequest2:@"qbPay" ID:_milletM.ID ];
        }
        else{
            [self yuanTuRequest2:@"wxPay" ID:_milletM.ID];
        }
    }
    else
    {
        //[AppUtils showProgressMessage:@"支付中"];
        if (_typeClose ==Artwork)//原图
        {
            [advertisementH subminMaterialOrders:_downOrderDic success:^(id obj) {
                NSDictionary *dic =(NSDictionary *)obj;
                if ([dic[@"code"] isEqualToString:@"success"])
                {
                    
                    if (payView.paymethod ==PayMethodQianbao)
                    {
                        [self yuanTuRequest2:@"qbPay" ID:dic[@"id"] ];
                    }
                    else
                    {
                        [self yuanTuRequest2:@"wxPay" ID:dic[@"id"]];
                    }
                }
                else
                {
                    [AppUtils showAlertMessageTimerClose:dic[@"message"]];
                }
            } failed:^(id obj) {
               [AppUtils showAlertMessageTimerClose:obj[@"message"]];
            }];

        }
        else
        {
            
            if (payView.paymethod ==PayMethodQianbao)
            {
                [self yuanTuRequest:@"qbPay"];
            }
            else
            {
                [self yuanTuRequest:@"wxPay"];
            }

        }
       
    }
    
}

-(void)yuanTuRequest2:(NSString *)payType ID:(NSString *)ID
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         ID,@"id",
                         payType,@"payType", nil];
    [advertisementH subminOrders:dic success:^(id obj) {
        if([obj[@"code"] isEqualToString:@"success"])
        {
            //[self postDownOrder:obj[@"orderIdPay"] Money:obj[@"payAmount"]];
            
            GrayViewController * pay = [[GrayViewController alloc] init];
            
            if (payView.paymethod ==PayMethodQianbao)
            {
                pay.method2 = QianBaoMethod2;
            }else{//钱包支付
                pay.method2 = WXPayMethod2;
            }
            
            pay.totalFee = [NSString stringWithFormat:@"%.2f",_money];
            pay.orderinformation = (NSDictionary *)obj;
            [self.navigationController pushViewController:pay animated:YES];

        }
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj[@"message"] isShow:self.viewIsVisible];
    }];
    
}


-(void)yuanTuRequest:(NSString *)payType
{

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _downOrderDic[@"id"],@"id",
                         _downOrderDic[@"chargeConfigId"],@"chargeConfigId",
                         _downOrderDic[@"ggServiceDateEnd"],@"ggServiceDateEnd",
                         _downOrderDic[@"ggServiceDateStart"],@"ggServiceDateStart",
                         _downOrderDic[@"linkmanName"],@"linkmanName",
                         _downOrderDic[@"linkmanPhone"],@"linkmanPhone",
                         _downOrderDic[@"ggTitle"],@"ggTitle",
                          payType,@"payType",
                         _downOrderDic[@"remarkUser"],@"remarkUser",
                         
                         nil];
    NSString *title = [NSString jsonStringWithDictionary:dic];
    
    NSLog(@"dic==%@",title);
    [advertisementH subminOrders:dic success:^(id obj) {
        
        if([obj[@"code"] isEqualToString:@"success"])
        {
            //[AppUtils dismissHUD];
                        //[self postDownOrder:obj[@"orderIdPay"] Money:obj[@"payAmount"]];
            
            GrayViewController * pay = [[GrayViewController alloc] init];
            
            if (payView.paymethod ==PayMethodQianbao)
            {
                pay.method2 = QianBaoMethod2;
            }else{//钱包支付
                pay.method2 = WXPayMethod2;
            }
            
            pay.totalFee = [NSString stringWithFormat:@"%.2f",_money];
            pay.orderinformation = (NSDictionary *)obj;
            [self.navigationController pushViewController:pay animated:YES];
            
        }
        else
        {
            [AppUtils showAlertMessageTimerClose:obj[@"message"]];
        }

    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj[@"message"] isShow:self.viewIsVisible];
    }];

}

-(void)postDownOrder:(NSString *)orderNo Money:(NSString *)money
{
 
    [AppUtils dismissHUD];
    NSString *wxOrderNostr =[NSString stringWithFormat:@"%@",orderNo];
    if (wxOrderNostr.length >0 && ![NSString isEmptyOrNull:wxOrderNostr])
    {
        
        switch (payView.paymethod) {
                
            case PayMethodQianbao:
            {
                __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                payment.title      = @"请输入支付密码";
                payment.goodsName  = @"应付金额";
                payment.amount     = _money.floatValue;
                payment.finishBlock = ^(NSString *inputStr)
                {
                    [AppUtils showProgressMessage:@"支付中"];
                    MoneyBagPayModel *payM =[MoneyBagPayModel new];
                    MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                    payM.memberId      = [UserManager shareManager].userModel.memberId;
                    payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                    //payM.payPassWord =inputStr;
                    payM.amount        = money;
                    payM.payOrderNo    = wxOrderNostr;
                    [payH moneybagpay:payM success:^(id moneyPayObj) {
                        NSLog(@"moneyPayObj==%@",moneyPayObj);
                        [AppUtils showAlertMessageTimerClose:@"支付成功"];
                        ZYXiaoMiPaySuccessVC * done = [[ZYXiaoMiPaySuccessVC alloc] init];
                        done.moneyStr=_money;
                        [self.navigationController pushViewController:done animated:YES];
                        //                            if (self.paySuccessBlock)
                        //                            {
                        //                                self.paySuccessBlock();
                        //                            }
                        
                        //[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
                    } failed:^(id moneyPayObj) {
                        [AppUtils showAlertMessageTimerClose:moneyPayObj];
                    }];
                };
                [payment show];
            }
                break;
                
            case PayTypeWeiXin:
            {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:wxOrderNostr];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:
                        {
                            [AppUtils showSuccessMessage:prompt];
                            ZYXiaoMiPaySuccessVC * done = [[ZYXiaoMiPaySuccessVC alloc] init];
                            done.moneyStr=_money;
                            [self.navigationController pushViewController:done animated:YES];
                            //                            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];

                        }
                        break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            [AppUtils showErrorMessage:prompt];
                            break;
                        default:
                            break;
                    }
                };
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)popLastVC {
    __block BOOL isPop = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZYXiaoMiPlayerVC class]]) {
            isPop = YES;
            [self.navigationController popToViewController:obj animated:YES];
            return;
            *stop = YES;
        }
    }];
    
    if (!isPop) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (NSMutableAttributedString *)PayAttributedStr:(NSMutableAttributedString *)str
                                       textLength:(NSUInteger)textlength{
    NSRange numRange = NSMakeRange(0,str.length - (textlength + 1));
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:numRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Pay_TIME_SIZE] range:numRange];
    
    NSRange strRange = NSMakeRange(str.length - textlength ,textlength);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Pay_TIME_SIZE] range:strRange];
    return str;
}


#pragma mark <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return payView.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (Cell==nil)
    {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    
    if (payView.superview == nil) {
        [Cell.contentView addSubview:payView];
    }
    
    return Cell;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        OpenMoneyBagVC *openMoneyVC = [OpenMoneyBagVC new];
        [self.navigationController pushViewController:openMoneyVC animated:YES];
    }
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
