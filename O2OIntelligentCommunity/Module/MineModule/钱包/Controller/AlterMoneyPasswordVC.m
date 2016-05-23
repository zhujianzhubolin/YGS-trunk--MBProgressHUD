//
//  AlterMoneyPasswordVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AlterMoneyPasswordVC.h"
#import "UserManager.h"
#import "MoneyBagVC.h"

#import "ValidationUserInfoVC.h"
#import "ZSDPaymentView.h"
//修改支付密码接口类
#import "AlterMoneyPasswordModel.h"
#import "AlterMoneyPasswordHandler.h"

@interface AlterMoneyPasswordVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@end

@implementation AlterMoneyPasswordVC
{
    UITableView *alterpasswordTB;
    UITextField *textField1;
    UITextField *textField2;
    UITextField *textField3;
    UIAlertView *alertV;
    NSDictionary *dict;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}


-(void)initUI
{
    
    self.title=@"修改密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiugaiicon"] style:UIBarButtonItemStyleBordered target:self action:@selector(AlterMoneypasswordArr)];

    
    alterpasswordTB =[[UITableView alloc]init];
    alterpasswordTB.frame=self.view.bounds;
    alterpasswordTB.dataSource=self;
    alterpasswordTB.delegate=self;
    alterpasswordTB.separatorStyle = UITableViewCellAccessoryNone;
    alterpasswordTB.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    [self.view addSubview:alterpasswordTB];
}

-(void)AlterMoneypasswordArr
{
    
    if (_isPasswordPage ==ModificatoryPassword)
    {
        
        if (textField1.text.length == 0  && [NSString isEmptyOrNull:textField1.text])
        {
            [AppUtils showAlertMessageTimerClose:@"旧密码不能为空"];
            return;
        }
        if (textField2.text.length == 0  && [NSString isEmptyOrNull:textField2.text])
        {
            [AppUtils showAlertMessageTimerClose:@"新密码不能为空"];
            return;
        }

        if (textField3.text.length == 0  && [NSString isEmptyOrNull:textField3.text])
        {
            [AppUtils showAlertMessageTimerClose:@"再次输入的新密码不能为空"];
            return;
        }
        
        if ([textField3.text isEqualToString:textField2.text])
        {
            AlterMoneyPasswordModel *alterM =[AlterMoneyPasswordModel new];
            AlterMoneyPasswordHandler *alterH =[AlterMoneyPasswordHandler new];
            alterM.memberId=[UserManager shareManager].userModel.memberId;
            alterM.oldpayPassword= [NSString md5_32Bit_String:textField1.text];
            alterM.payPassword=[NSString md5_32Bit_String:textField2.text];
            
            [alterH altermoneypassword:alterM success:^(id obj) {
                dict=(NSDictionary *)obj;
                if ([dict[@"code"] isEqualToString:@"success"])
                {
                    [AppUtils showAlertMessageTimerClose:dict[@"message"]];
                     [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(SkipVC) userInfo:nil repeats:NO];
                }
                else if ([dict[@"code"] isEqualToString:@"201"])
                {
                    
                    alertV = [[UIAlertView alloc]initWithTitle:@"操作提示" message:dict[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertV show];

                }
                else if ([dict[@"code"] isEqualToString:@"202"])
                {
                    NSString *messageStr = [NSString stringWithFormat:@"%@\n请联系客服:%@",dict[@"message"],P_SERVICE_PHONE];
                    alertV = [[UIAlertView alloc]initWithTitle:@"操作提示" message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"呼叫", nil];
                    [alertV show];
                }

                
                

            } failed:^(id obj) {
                [AppUtils showAlertMessageTimerClose:obj];
            }];
        }
        else {
            [AppUtils showAlertMessageTimerClose:@"两次输入密码不一致"];
        }

    }
    else
    {
        if (textField2.text.length !=6 || textField3.text.length!=6) {
            [AppUtils showErrorMessage:@"密码只能为6位"];
            return;
        }
        
        if (![textField2.text isEqualToString:textField3.text]) {
            [AppUtils showErrorMessage:@"两次输入密码不一致"];
            return;
        }
        
        [AppUtils showProgressMessage:@"提交中"];
        AlterMoneyPasswordModel *alterM =[AlterMoneyPasswordModel new];
        AlterMoneyPasswordHandler *alterH =[AlterMoneyPasswordHandler new];
        alterM.memberId=[UserManager shareManager].userModel.memberId;
        alterM.payPassword=[NSString md5_32Bit_String:textField2.text];
        [alterH confirmIdsetPassword:alterM success:^(id obj) {
            NSDictionary *dic=(NSDictionary *)obj;
            [AppUtils showAlertMessageTimerClose:dic[@"message"]];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(SkipVC) userInfo:nil repeats:NO];
        } failed:^(id obj) {
            [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
        }];
    }
}

-(void)SkipVC
{
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[MoneyBagVC class]]){
            MoneyBagVC *c = (MoneyBagVC *)controller;
            [self.navigationController popToViewController:c animated:YES];
            break;
        }
    }
}

#pragma makr - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [AppUtils callPhone:P_SERVICE_PHONE];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ZSDPaymentView *paymentV = [ZSDPaymentView new];
    if (textField == textField1) {
        paymentV.title = @"请输入原密码";
    }
    else if (textField == textField2) {
        paymentV.title=@"请设置新密码";
    }
    else if (textField == textField3) {
        paymentV.title=@"请再次输入新密码";
    }
    
    paymentV.goodsName = @"密码为6位";
    paymentV.amount = -1;
    paymentV.finishBlock = ^(NSString *inputStr){
        textField.text = inputStr;
    };
    [paymentV show];
    return NO;
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isPasswordPage ==ModificatoryPassword)
    {
        return 3;
    }
    else
    {
        return 2;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isPasswordPage ==ModificatoryPassword)
    {
        switch (section)
        {
            case 0:
                return 10;
                break;
            case 1:
                return 20;
                break;
            case 2:
                return 10;
                break;
                
            default:
                return 0;
                break;
        }

    }
    else
    {
        switch (section)
        {
            case 0:
                return 10;
                break;
            case 1:
                return 10;
                break;
                
            default:
                return 0;
                break;
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"alterPasswordCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//去掉cell的选中状态
    if (_isPasswordPage == ModificatoryPassword)
    {
        if (indexPath.section==0)
        {
            cell.textLabel.text=@"原支付密码：";
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            textField1 = [[UITextField alloc]init];
            textField1.frame=CGRectMake(IPHONE_WIDTH/2-50,(55-40)/2, 150, 40);
            //textField1.backgroundColor=[UIColor redColor];
            textField1.delegate=self;
            textField1.secureTextEntry=YES;
            textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField1.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:textField1];
            
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(IPHONE_WIDTH-70, 10, 60, 30);
            [button setTitle:@"忘记密码" forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(forgetArr) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
        if (indexPath.section==1)
        {
            cell.textLabel.text=@"新支付密码：";
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            textField2 = [[UITextField alloc]init];
            textField2.delegate=self;
            textField2.secureTextEntry=YES;
            textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField2.frame=CGRectMake(IPHONE_WIDTH/2-50, (55-40)/2, 150, 40);
            textField2.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:textField2];
            
        }
        if (indexPath.section==2)
        {
            cell.textLabel.text=@"确认新支付密码：";
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            textField3 = [[UITextField alloc]init];
            textField3.delegate=self;
            textField3.secureTextEntry=YES;
            //textField3.backgroundColor =[UIColor redColor];
            textField3.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField3.frame=CGRectMake(IPHONE_WIDTH/2-20, (55-40)/2, 150, 40);
            textField3.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:textField3];
        }

    }
    else
    {
        if (indexPath.section==0)
        {
            cell.textLabel.text=@"新支付密码：";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            textField2 = [[UITextField alloc]init];
            textField2.delegate=self;
            textField2.secureTextEntry=YES;
            textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField2.frame=CGRectMake(IPHONE_WIDTH/2-50, (55-40)/2, 150, 40);
            textField2.keyboardType = UIKeyboardTypePhonePad;
            [cell.contentView addSubview:textField2];
            
        }
        if (indexPath.section==1)
        {
            cell.textLabel.text=@"确认新支付密码：";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            textField3 = [[UITextField alloc]init];
            textField3.delegate=self;
            textField3.secureTextEntry=YES;
            textField3.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField3.frame=CGRectMake(IPHONE_WIDTH/2-20,(55-40)/2, 150, 40);
            textField3.keyboardType = UIKeyboardTypePhonePad;
            [cell.contentView addSubview:textField3];
        }

    }
    
    return cell;
}

-(void)forgetArr
{
    ValidationUserInfoVC *validationVc =[ValidationUserInfoVC new];
    [self.navigationController pushViewController:validationVc animated:YES];
}

@end
