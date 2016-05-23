//
//  LiJiFuKuanVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "LiJiFuKuanVC.h"
#import "WXApi.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"
#import "ZSDPaymentView.h"
#import "UserManager.h"
#import "LocalUtils.h"



//重新选择支付方式下单
#import "ZhifuHandel.h"
#import "ZhifuModel.h"
//支付接口类
#import "MoneyBagPayModel.h"
#import "MoneyBagPayHandler.h"
#import "BuyViewController.h"

@implementation LiJiFuKuanVC
{
    UITableView *TableView;
    NSArray     *iconArray;
    NSArray     *titleArray;

    
    PayType payType;
    BOOL isWx;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData
{
    if ([WXApi isWXAppInstalled]) {
        isWx = YES;
    }else{
        isWx = NO;
    }

    if (isWx) {
        iconArray =[[NSArray alloc]initWithObjects:@"myPay",@"weChatPay", nil];
        titleArray= [[NSArray alloc]initWithObjects:@"钱包支付",@"微信支付", nil];
    }else{
        iconArray =[[NSArray alloc]initWithObjects:@"myPay", nil];
        titleArray= [[NSArray alloc]initWithObjects:@"钱包支付", nil];
    }

}

-(void)initUI
{
    
    self.title=[NSString stringWithFormat:@"收银台"];
    
    UIView *footerView =[[UIView alloc]init];
    footerView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 100);
    
    UIButton *submitBut =[UIButton buttonWithType:UIButtonTypeCustom];
    submitBut.frame=CGRectMake(20, 20, IPHONE_WIDTH-40, 35);
    [submitBut setTitle:@"立即支付" forState:UIControlStateNormal];
    [submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBut setBackgroundColor:[AppUtils colorWithHexString:@"FF6E00"]];
    [submitBut addTarget:self action:@selector(zhifuArr) forControlEvents:UIControlEventTouchUpInside];
    submitBut.layer.masksToBounds=YES;
    submitBut.layer.cornerRadius=5;
    [footerView addSubview:submitBut];
    
    TableView=[[UITableView alloc]init];
    TableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    TableView.dataSource=self;
    TableView.delegate=self;
    TableView.tableFooterView=footerView;
    TableView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    TableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:TableView];

    payType = PayTypeQianBao;
}

-(void)zhifuArr
{
    [AppUtils showProgressMessage:@"支付中"];
    ZhifuModel *zhifuM =[ZhifuModel new];
    ZhifuHandel *zhifuH =[ZhifuHandel new];
    zhifuM.trade_type=@"APP";//交易类型
    zhifuM.openid=@"";//用户标识
    zhifuM.attach=ENVIRONMENT;
    zhifuM.body=[LocalUtils chargeBodyForCharegeType:ChargeTypeOnlineShop];
    zhifuM.nonce_str=@"c5ls2v7znidfowbg4ua6q3impg6uwm2p";
    zhifuM.spbill_create_ip=@"8.8.8.8";

    if (payType==PayTypeQianBao)
    {
        zhifuM.payType=@"qbPay";
        zhifuM.total_fee=[NSString stringWithFormat:@"%.2f",_buyshopsM.totalPayAmount.floatValue];//总金额
    }
    else if (payType==PayTypeWeiXin)
    {
        zhifuM.payType=@"wxPay";
        zhifuM.total_fee=[NSString stringWithFormat:@"%.0f",_buyshopsM.totalPayAmount.floatValue * 100];//总金额
    }

    zhifuM.orderNo=_buyshopsM.orderNo;
    
    [zhifuH AgainXiaDanZhiFu:zhifuM success:^(id obj) {
        [AppUtils dismissHUD];
        NSString *wxOrderNostr =[NSString stringWithFormat:@"%@",obj[@"wxOrderNo"]];
        if (wxOrderNostr.length >0 && ![NSString isEmptyOrNull:wxOrderNostr])
        {
            
            switch (payType) {
                    
                case PayTypeQianBao:
                {
                    __block ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
                    payment.title      = @"请输入支付密码";
                    payment.goodsName  = @"应付金额";
                    payment.amount     = _buyshopsM.totalPayAmount.floatValue;
                    payment.finishBlock = ^(NSString *inputStr)
                    {
                        [AppUtils showProgressMessage:@"支付中"];
                        MoneyBagPayModel *payM =[MoneyBagPayModel new];
                        MoneyBagPayHandler *payH = [MoneyBagPayHandler new];
                        payM.memberId      = [UserManager shareManager].userModel.memberId;
                        payM.payPassWord   = [NSString md5_32Bit_String:inputStr];
                        //payM.payPassWord =inputStr;
                        payM.amount        = zhifuM.total_fee;
                        payM.payOrderNo    = wxOrderNostr;
                        [payH moneybagpay:payM success:^(id moneyPayObj) {
                            NSLog(@"moneyPayObj==%@",moneyPayObj);
                            [AppUtils showAlertMessageTimerClose:@"支付成功"];
                            
                            if (self.paySuccessBlock)
                            {
                                self.paySuccessBlock();
                            }
                            
                            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
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
                                [AppUtils showSuccessMessage:prompt];
                                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
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
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

- (void)popLastVC {
    __block BOOL isPop = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BuyViewController class]]) {
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

- (PayType)payTypeForSelectedIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return PayTypeQianBao;
            break;
        case 1:
            return PayTypeWeiXin;
            break;
            
        default:
            break;
    }
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  iconArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *str1=@"实付:";
    NSString *str2=[NSString stringWithFormat:@"  %.2f 元",[_buyshopsM.totalPayAmount floatValue]];
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fa6900"] range:NSMakeRange(str1.length, str2.length)];
    
    UIView *headView =[[UIView alloc]init];
    headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 50);
    headView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    UILabel *namelab =[[UILabel alloc]init];
    namelab.frame=CGRectMake(10, 10, IPHONE_WIDTH-20, 30);
    namelab.attributedText=str;
    [headView addSubview:namelab];
    
    return headView;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[TableView dequeueReusableCellWithIdentifier:@"zhifuCell"];
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zhifuCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
        
        UIButton *gouxuanbutton =[UIButton buttonWithType:UIButtonTypeCustom];
        gouxuanbutton.frame=CGRectMake(IPHONE_WIDTH-40, 5, 30, 30);
        gouxuanbutton.tag = indexPath.row + 100;
        [gouxuanbutton setImage:[UIImage imageNamed:@"ZYrechar"] forState:UIControlStateNormal];
        [gouxuanbutton setImage:[UIImage imageNamed:@"ZYrechargeSelected"] forState:UIControlStateSelected];
        [cell.contentView addSubview:gouxuanbutton];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//去掉cell的选中状态
        
        UIImageView *dwoneLineimgV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, IPHONE_WIDTH, 1)];
        dwoneLineimgV.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
        [cell.contentView addSubview:dwoneLineimgV];
        if (indexPath.row == 0) {
            gouxuanbutton.selected = YES;
        }
    }

    cell.imageView.image=[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    cell.textLabel.text=[titleArray objectAtIndex:indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (iconArray.count == 1) {
        return;
    }
    for (int i = 0; i < iconArray.count; i++) {
        UIButton *accesoryBtn = (UIButton *)[tableView viewWithTag:100 + i];
        accesoryBtn.selected = NO;
        
    }
    
    UIButton *accesoryBtn = (UIButton *)[tableView viewWithTag:100 + indexPath.row];
    accesoryBtn.selected = YES;
    payType = [self payTypeForSelectedIndex:indexPath.row];

}




@end
