//
//  RechargeVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RechargeVC.h"
#import "PayFinishVC.h"
#import "UserManager.h"
//#import "WXApi.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"

//充值接口类
#import "TopUpModel.h"
#import "TopUpHandler.h"

@interface RechargeVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@end
@implementation RechargeVC
{
    UITableView *rechargeTB;
    
    UITextField *moneyF;
    
    NSArray *iconArray;
    NSArray *payTitleArr;
    PayType payType;
    BOOL isHaveDian;
    //BOOL isWx;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
//    if ([WXApi isWXAppInstalled]) {
//        isWx = YES;
//    }else{
//        isWx = NO;
//    }

    [self initData];
    [self initUI];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)initData
{
//    if (isWx)
//    {
        iconArray = @[@"weChatPay"];
        payTitleArr = @[@"微信支付"];
//    }
//    else
//    {
//        UIAlertView *abnormalAlertV = [[UIAlertView alloc] initWithTitle:@"为了您的资金安全，请先下载并安装微信。" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [abnormalAlertV show];
//
//    }
    
    isHaveDian = NO;
}

-(void)initUI
{
    
    self.title=@"收银台";
    
    UIView *footerView =[[UIView alloc]init];
    footerView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 100);
    
    UIButton *submitBut =[UIButton buttonWithType:UIButtonTypeCustom];
    submitBut.frame=CGRectMake(15, 20, IPHONE_WIDTH-30, 35);
    [submitBut setTitle:@"立即支付" forState:UIControlStateNormal];
    [submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    if (isWx)
//    {
        [submitBut setBackgroundColor:[AppUtils colorWithHexString:@"FF6E00"]];
        [submitBut addTarget:self action:@selector(submitButtonarr) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        [submitBut setBackgroundColor:[AppUtils colorWithHexString:@"CECECE"]];
//    }
    
    submitBut.layer.masksToBounds=YES;
    submitBut.layer.cornerRadius=5;
    [footerView addSubview:submitBut];
    
    rechargeTB =[[UITableView alloc]init];
    rechargeTB.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    rechargeTB.dataSource=self;
    rechargeTB.delegate=self;
    rechargeTB.tableFooterView=footerView;
    rechargeTB.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    rechargeTB.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:rechargeTB];
    
    UIButton *accesoryBtn = (UIButton *)[rechargeTB viewWithTag:100 ];
    accesoryBtn.selected = YES;
    
    UIImageView *uplineimgV = (UIImageView *)[rechargeTB viewWithTag:200];
    uplineimgV.backgroundColor = [UIColor greenColor];
    
    UIImageView *downlineimgV = (UIImageView *)[rechargeTB viewWithTag:300];
    downlineimgV.backgroundColor = [UIColor greenColor];
    
    payType = PayTypeWeiXin;
    
    UITapGestureRecognizer *endKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoardClick)];
    [rechargeTB addGestureRecognizer:endKeyboardTap];
}

- (void)closeKeyBoardClick {
    [self.view endEditing:YES];
}

- (PayType)payTypeForSelectedIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return PayTypeWeiXin;
        default:
            break;
    }
    return 0;
}

-(void)submitButtonarr
{
    if(moneyF.text.floatValue > 5000) {
        [AppUtils showAlertMessageTimerClose:@"单笔充值数额不能超过5000!"];
        return;
    }

    if(moneyF.text.length <= 0 ) {
        [AppUtils showAlertMessageTimerClose:@"请输入充值金额！"];
        return;
    }
    
    NSNumber *a=[NSNumber numberWithFloat:moneyF.text.floatValue];
    NSNumber *b=[NSNumber numberWithFloat:0.01];

    if ([a compare:b]==NSOrderedAscending) {
        [AppUtils showAlertMessageTimerClose:@"充值金额数不能少于0.01"];
        return;
    }
    
    
    [AppUtils showProgressMessage:@"充值中"];
    TopUpModel *topupM =[TopUpModel new];
    TopUpHandler *topupH = [TopUpHandler new];


    topupM.attach           =ENVIRONMENT;
    topupM.body             =[LocalUtils chargeBodyForCharegeType:ChargeTypeWalletRecharge];
    topupM.total_fee        =[NSString stringWithFormat:@"%.f",moneyF.text.floatValue *100];
    topupM.memberId         =[UserManager shareManager].userModel.memberId;
    topupM.trade_type       =@"APP";
    
    [topupH topupRequst:topupM success:^(id obj) {
        [AppUtils dismissHUD];
        switch (payType) {
            case PayTypeWeiXin: {
                [WeChatPayClass wxPayWithOrderName:@"name1" price:@"1" order:obj];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];;
                appDelegate.wxPayBlock = ^(NSUInteger payStatus, NSString *prompt) {
                    switch (payStatus) {
                        case WXPaySuccess:{
                            if (self.rechargeSucBlock) {
                                self.rechargeSucBlock();
                            }
                            PayFinishVC *payfinish =[[PayFinishVC alloc]init];
                            payfinish.paystatus=payStatus;
                            payfinish.payAcount=moneyF.text;
                            [self.navigationController pushViewController:payfinish animated:YES];
                        }
                            break;
                        case WXPayFail:
                        case WXPayCancel:
                        case WXPayFailOther:
                            [AppUtils showAlertMessageTimerClose:prompt];
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
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView =[[UIView alloc]init];
    headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 5);
    headView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    UILabel *namelab =[[UILabel alloc]init];
    namelab.frame=CGRectMake(15, 10, 90, 30);
    namelab.text=@"充值金额：";
    [headView addSubview:namelab];
    
    moneyF=[[UITextField alloc]initWithFrame:CGRectMake(95, 10, IPHONE_WIDTH-110, 30)];
    moneyF.borderStyle = UITextBorderStyleRoundedRect;
    moneyF.placeholder=@"请输入充值金额";
    moneyF.backgroundColor=[UIColor whiteColor];
    moneyF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyF.delegate = self;
//    if (isWx)
//    {
//        [moneyF endEditing:YES];
//    }
//    else
//    {
//        [moneyF endEditing:NO];
//    }
    [headView addSubview:moneyF];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"RechargeCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        ;
        
        UIButton *gouxuanbutton =[UIButton buttonWithType:UIButtonTypeCustom];
        gouxuanbutton.frame=CGRectMake(IPHONE_WIDTH-40, 12, 30, 30);
        gouxuanbutton.tag = indexPath.row + 100;
        [gouxuanbutton setImage:[UIImage imageNamed:@"ZYrechar"] forState:UIControlStateNormal];
        [gouxuanbutton setImage:[UIImage imageNamed:@"ZYrechargeSelected"] forState:UIControlStateSelected];
        [cell.contentView addSubview:gouxuanbutton];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//去掉cell的选中状态
        
        if (indexPath.row ==0)
        {
            gouxuanbutton.selected=YES;
        }
        
        UIImageView *uplineimgV =[[UIImageView alloc]init];
        uplineimgV.frame=CGRectMake(0, 0, IPHONE_WIDTH, 1);
        uplineimgV.backgroundColor=[UIColor grayColor];
        uplineimgV.tag=indexPath.row+200;
        [cell.contentView addSubview:uplineimgV];
        
        UIImageView *downlineimgV =[[UIImageView alloc]init];
        downlineimgV.frame=CGRectMake(0, 54, IPHONE_WIDTH, 1);
        downlineimgV.backgroundColor=[UIColor grayColor];
        downlineimgV.tag=indexPath.row+300;
        [cell.contentView addSubview:downlineimgV];
    }
    

    
    cell.imageView.image=[UIImage imageNamed:iconArray[indexPath.row]];
    cell.textLabel.text = payTitleArr[indexPath.row];
    
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
        
        UIImageView *uplineimgV = (UIImageView *)[tableView viewWithTag:200 + i];
        uplineimgV.backgroundColor = [UIColor grayColor];
        
        UIImageView *downlineimgV = (UIImageView *)[tableView viewWithTag:300 + i];
        downlineimgV.backgroundColor = [UIColor grayColor];
    }
    
    UIButton *accesoryBtn = (UIButton *)[tableView viewWithTag:100 + indexPath.row];
    accesoryBtn.selected = YES;
    
    UIImageView *uplineimgV = (UIImageView *)[tableView viewWithTag:200 + indexPath.row];
    uplineimgV.backgroundColor = [UIColor greenColor];
    
    UIImageView *downlineimgV = (UIImageView *)[tableView viewWithTag:300 + indexPath.row];
    downlineimgV.backgroundColor = [UIColor greenColor];
    
    payType = [self payTypeForSelectedIndex:indexPath.row];
}

#pragma mark - UITextFieldDelegate
//textField.text 输入之前的值         string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger inputLength = 9;
    
    if (range.location > inputLength) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    
    if ([string length]>0)
    {
        return [AppUtils textFieldLimitDecimalPointWithDigits:2 WithText:textField.text shouldChangeCharactersInRange:range replacementString:string] && textField.text.length <= 9;
        
    }
    return YES;
}


@end
