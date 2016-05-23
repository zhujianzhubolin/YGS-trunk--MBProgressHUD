//
//  ChangePasswordViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserManager.h"
#import "NSString+wrapper.h"

//修改密码接口类
#import "ChangePasswordModel.h"
#import "ChangePasswordHandler.h"

@interface ChangePasswordViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChangePasswordViewController
{
    UITextField *passworeF;
    UITextField *newPassworeF;
    UITextField *againNewPassworeF;
    
    UITableView *passwordTB;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"修改登录密码";
    
    self.view.backgroundColor=[AppUtils colorWithHexString:@"eeeeea"];
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=YES;
}

-(void)initUI
{
    
    passwordTB = [[UITableView alloc]initWithFrame:self.view.bounds];
    passwordTB.dataSource=self;
    passwordTB.delegate=self;
    passwordTB.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:passwordTB];
    [self setExtraCellLineHidden:passwordTB];
    passwordTB.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
    [self viewDidLayoutSubviewsForTableView:passwordTB];
    
    UITapGestureRecognizer *endEdtingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:endEdtingTap];
}

- (void)endEditing {
    [self.view endEditing:YES];
}

-(void)submitAct
{
    
    if (newPassworeF.text.length <6)
    {
        [AppUtils showAlertMessageTimerClose:@"新密码长度不能小于6位"];
        return;
    }
    if (againNewPassworeF.text.length<6)
    {
        [AppUtils showAlertMessageTimerClose:@"确认新密码长度不能小于6位"];
        return;
    }
    
    ChangePasswordModel *changepasswordM =[ChangePasswordModel new];
    ChangePasswordHandler *changepasswordH =[ChangePasswordHandler new];
    NSLog(@"[UserManager shareManager].userModel.memberId=%@",[UserManager shareManager].userModel.memberId);
    changepasswordM.memberId = [UserManager shareManager].userModel.memberId;
    if (![NSString isEmptyOrNull:passworeF.text] && ![NSString isEmptyOrNull:newPassworeF.text] && ![NSString isEmptyOrNull:againNewPassworeF.text])
    {
        if ([newPassworeF.text isEqualToString:againNewPassworeF.text])
        {
            changepasswordM.oldPassword = [NSString md5_32Bit_String:passworeF.text];
            changepasswordM.NewPassword = [NSString md5_32Bit_String:newPassworeF.text];
            changepasswordM.salt=@"123";
            changepasswordM.reference =P_REFERENCE;
            changepasswordM.verifyName=[UserManager shareManager].userModel.phone;
            
            [changepasswordH ChangePassword:changepasswordM success:^(id obj) {
                [AppUtils showSuccessMessage:@"修改密码成功,请重新登录"];
                //[UserManager shareManager].userModel.phone = nil;
                [UserManager shareManager].userModel.memberId = nil;
                [UserManager shareManager].userModel.accountName = nil;
                [UserManager shareManager].comModel=[BingingXQModel new];
                
                [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
                
                self.navigationController.tabBarController.selectedIndex = 0;
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(selectedOneNav) userInfo:nil repeats:NO];
                
                
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
            }];
            
        }
        else
        {
            [AppUtils showAlertMessageTimerClose:@"俩次密码不相同，请检查重新输入"];
        }
    }
    else
    {
        [AppUtils showAlertMessageTimerClose:@"密码信息不能为空"];
    }
    
    
}

- (void)selectedOneNav {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}
#pragma mark - UITextField 代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextField 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(string.length==0)
    {
        return YES;
    }
    int passwordLength = 20;//支付密码个数
    
    if (textField == passworeF)
    {
        return range.location < passwordLength;
    }
    else if (textField ==newPassworeF)
    {
        return range.location < passwordLength;
    }
    else if (textField ==againNewPassworeF)
    {
        return range.location <passwordLength;
    }
    
    return YES;
}


#pragma mark -<UITableViewDataSource,UITableViewDelegate>

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//分割线靠边界
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 3;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headV =[[UIView alloc]initWithFrame:CGRectMake(0, 60, IPHONE_WIDTH, 100)];
    if (section==0)
    {
        headV.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
    }
    else
    {
        UIButton *submitBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame =CGRectMake(20, 50, IPHONE_WIDTH-40, 40);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        submitBtn.titleLabel.font=[UIFont systemFontOfSize:G_BTN_FONT];
        submitBtn.backgroundColor=[AppUtils colorWithHexString:G_BTN_BGCOLOR];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.layer.masksToBounds=YES;
        submitBtn.layer.cornerRadius=5;
        [self.view addSubview:submitBtn];
        [submitBtn addTarget:self action:@selector(submitAct) forControlEvents:UIControlEventTouchUpInside];
        [headV addSubview:submitBtn];
    }
    
    return headV;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (Cell==nil)
    {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat textFieldHigth = 40,interval=10,imgViewInterval = 15;
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(interval, imgViewInterval, 30, 30)];
    imgV.image=[UIImage imageNamed:@"passwordInfo"];
    [Cell.contentView addSubview:imgV];

    if (indexPath.row==0)
    {
        passworeF = [[UITextField alloc]init];
        passworeF.frame=CGRectMake(CGRectGetMaxX(imgV.frame)+interval, interval, IPHONE_WIDTH-60, textFieldHigth);
        passworeF.backgroundColor=[UIColor whiteColor];
        passworeF.placeholder= @"请输入原密码";
        passworeF.delegate=self;
        passworeF.clearButtonMode = UITextFieldViewModeWhileEditing;
        passworeF.borderStyle = UITextBorderStyleRoundedRect;
        passworeF.secureTextEntry = YES;
        [Cell.contentView addSubview:passworeF];
        
    }
    
    else if (indexPath.row==1)
    {
        newPassworeF = [[UITextField alloc]init];
        newPassworeF.frame=CGRectMake(CGRectGetMaxX(imgV.frame)+interval, interval, IPHONE_WIDTH-60, textFieldHigth);
        newPassworeF.backgroundColor =[UIColor whiteColor];
        newPassworeF.placeholder=@"输入新密码";
        newPassworeF.delegate=self;
        newPassworeF.clearButtonMode = UITextFieldViewModeWhileEditing;
        newPassworeF.borderStyle = UITextBorderStyleRoundedRect;
        newPassworeF.secureTextEntry = YES;
        [Cell.contentView addSubview:newPassworeF];
    }
    else if (indexPath.row==2)
    {
        againNewPassworeF=[[UITextField alloc]init];
        againNewPassworeF.frame =CGRectMake(CGRectGetMaxX(imgV.frame)+interval, interval, IPHONE_WIDTH-60, textFieldHigth);
        againNewPassworeF.backgroundColor=[UIColor whiteColor];
        againNewPassworeF.placeholder=@"确认新密码";
        againNewPassworeF.delegate=self;
        againNewPassworeF.clearButtonMode = UITextFieldViewModeWhileEditing;
        againNewPassworeF.borderStyle = UITextBorderStyleRoundedRect;
        againNewPassworeF.secureTextEntry = YES;
        [Cell.contentView addSubview:againNewPassworeF];
    }
    return Cell;
}





@end
