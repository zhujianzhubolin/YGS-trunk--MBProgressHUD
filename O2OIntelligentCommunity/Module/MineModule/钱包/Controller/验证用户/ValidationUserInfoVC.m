//
//  ValidationUserInfoVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ValidationUserInfoVC.h"
#import "UserManager.h"
#import "AlterMoneyPasswordVC.h"
//忘记密码
#import "OpenMoneyBagHandler.h"
#import "OpenMoneyBagModel.h"
//获取验证码接口类
#import "MessageHandler.h"
#import "MessageModel.h"
//获取钱包信息接口类
#import "MoneyBagInfoModel.h"
#import "MoneyBaginfoHandler.h"

@interface ValidationUserInfoVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation ValidationUserInfoVC
{
    UITableView *ValidationTB;
    UITextField *nameF;
    UITextField *idcardF;
    UITextField *phineF;
    UITextField *verificationcodeF;
    
    
    MoneyBagInfoModel *moneyinfoM;
    
    NSTimer *waitTimer;
    
    NSUInteger timerSec;
    BOOL isGetCode;
}

-(void)viewDidLoad
{
    timerSec = 60;
    [super viewDidLoad];
    [self initUI];
    [self getmonaybaginfo];
}

//获取钱包信息
-(void)getmonaybaginfo
{
    MoneyBagInfoModel *moneyM =[MoneyBagInfoModel new];
    MoneyBaginfoHandler *moneyH = [MoneyBaginfoHandler new];
    moneyM.memberId=[UserManager shareManager].userModel.memberId;
    
    [moneyH moneybaginfo:moneyM success:^(id obj) {
        moneyinfoM =(MoneyBagInfoModel *)obj;
        NSLog(@"name ==%@",moneyinfoM.name);
        [ValidationTB reloadData];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:@"获取钱包信息失败" isShow:self.viewIsVisible];

        
    }];
}


-(void)validationArr
{
    
    if([NSString isEmptyOrNull:nameF.text])
    {
        [AppUtils showAlertMessageTimerClose:@"姓名不能为空!"];
        return;
    }
    if ([NSString isEmptyOrNull:idcardF.text])
    {
        [AppUtils showAlertMessageTimerClose:@"身份证号不能为空!"];
        return;
    }
    if([NSString isEmptyOrNull:verificationcodeF.text])
    {
        [AppUtils showAlertMessageTimerClose:@"验证码不能为空!"];
        return;
    }
    
    [AppUtils showProgressMessage:@"验证中"];
    OpenMoneyBagModel *fotgetM =[OpenMoneyBagModel new];
    OpenMoneyBagHandler *fotgetH =[OpenMoneyBagHandler new];
    fotgetM.memberId=[UserManager shareManager].userModel.memberId;
    fotgetM.name    =nameF.text;
    fotgetM.cardNo  =idcardF.text;
    fotgetM.phone   =[UserManager shareManager].userModel.phone;
    fotgetM.code    =verificationcodeF.text;
    [fotgetH forgetzhifupassword:fotgetM success:^(id obj) {
        NSDictionary *dic=(NSDictionary *)obj;
        if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
        {
            [AppUtils dismissHUD];
            AlterMoneyPasswordVC *alterVC =[AlterMoneyPasswordVC new];
            alterVC.isPasswordPage=ForgetPassword;
            [self.navigationController pushViewController:alterVC animated:YES];
        }
        else
        {
            [AppUtils showAlertMessageTimerClose:dic[@"message"]];
        }
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:obj];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
}

-(void)initUI
{
    
    
    self.title=@"找回密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"openqianbaoset"] style:UIBarButtonItemStyleBordered target:self action:@selector(validationArr)];
    
    ValidationTB = [[UITableView alloc]init];
    ValidationTB.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    ValidationTB.dataSource=self;
    ValidationTB.delegate=self;
    ValidationTB.separatorStyle = UITableViewCellAccessoryNone;
    ValidationTB.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    [self.view addSubview:ValidationTB];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselfviewArr:)];
    [self.view addGestureRecognizer:tap];

}

-(void)tapselfviewArr:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    [self viewMoving:ValidationTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
}


#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 40;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 20;
            break;
        case 3:
            return 5;
            break;
            
        default:
            return 0;
            break;
    }
    
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    if (section==0)
    {
        headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 40);
        
        UILabel *lab =[[UILabel alloc]init];
        //lab.numberOfLines=0;
        lab.font=[UIFont systemFontOfSize:15];
        
        lab.text=@"请填写您预留的信息，以便找回密码。";
//        CGSize titleSize = [lab.text boundingRectWithSize:CGSizeMake(IPHONE_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        lab.frame =CGRectMake(10, 0, self.view.frame.size.width, 40);
        [headView addSubview:lab];
        
    }
    else
    {
        
        headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 25);
    }
    return headView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer =@"openmoneybagsetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.selectionStyle=UITableViewCellAccessoryNone;
    }
    CGRect fram =CGRectMake(100, 3, self.view.frame.size.width-130, 40);
        if (indexPath.section==0)
        {
            cell.textLabel.text=@"姓       名：";
            nameF =[[UITextField alloc]initWithFrame:fram];
            nameF.placeholder=[moneyinfoM.name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            nameF.delegate=self;
            [cell.contentView addSubview:nameF];
            
        }
        else if (indexPath.section==1)
        {
            cell.textLabel.text=@"身份证号：";
            idcardF =[[UITextField alloc]initWithFrame:fram];
            if (moneyinfoM.idNumber.length==16)
            {
                idcardF.placeholder= [moneyinfoM.idNumber stringByReplacingCharactersInRange:NSMakeRange(0, 12) withString:@"************"];
                
            }
            else if (moneyinfoM.idNumber.length==18)
            {
                idcardF.placeholder= [moneyinfoM.idNumber stringByReplacingCharactersInRange:NSMakeRange(0, 14) withString:@"**************"];
            }
            idcardF.keyboardType =UIKeyboardTypeASCIICapable;
            idcardF.delegate=self;
            [cell.contentView addSubview:idcardF];
            
        }
        else if (indexPath.section==2)
        {
            cell.textLabel.text=@"手  机  号：";
            phineF =[[UITextField alloc]initWithFrame:fram];
            phineF.text=[UserManager shareManager].userModel.phone;
            phineF.enabled=NO;
            [cell.contentView addSubview:phineF];
        }
        
        else if (indexPath.section==3)
        {
            cell.textLabel.text=@"验  证  码：";
            verificationcodeF =[[UITextField alloc]initWithFrame:CGRectMake(100, 3, 80, 40)];
            verificationcodeF.keyboardType = UIKeyboardTypeNumberPad;
//            verificationcodeF.placeholder=@"验证码";
            verificationcodeF.delegate=self;
            [cell.contentView addSubview:verificationcodeF];
            
            UIButton *getverificationcodeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            getverificationcodeBtn.frame=CGRectMake(IPHONE_WIDTH-130, 5, 120, 35);
            getverificationcodeBtn.backgroundColor=[AppUtils colorWithHexString:@"08A4DD"];
            getverificationcodeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [getverificationcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            getverificationcodeBtn.layer.masksToBounds=YES;
            getverificationcodeBtn.layer.cornerRadius=5;
            getverificationcodeBtn.tag=300;
            [getverificationcodeBtn addTarget:self action:@selector(getverifivationcode:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:getverificationcodeBtn];
        }
    
    return cell;
}



#pragma mark -获取验证码方法
-(void)getverifivationcode:(UIButton *)sender
{
    if (isGetCode || waitTimer.isValid)
    {
        return;
    }
    
    [AppUtils showProgressMessage:@"发送中"];
    isGetCode = YES;
    
    MessageModel *messageE = [MessageModel new];
    messageE.memberId=[UserManager shareManager].userModel.memberId;
    messageE.mobilePhone=[UserManager shareManager].userModel.phone;
    messageE.reference=P_REFERENCE;
    messageE.businessType=@"resetPayPsd";
    MessageHandler *messageH = [MessageHandler new];
    
    [messageH executeMoneyBagCodeTaskWithModel:messageE success:^(id obj) {
        [AppUtils showSuccessMessage:@"验证码发送成功"];
        [verificationcodeF becomeFirstResponder];//发送验证码将该对应的textfield变成第一响应者
        if (!waitTimer.isValid) {
            waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(waitVertificateCode:) userInfo:sender repeats:YES];
        }
        isGetCode = NO;

        
    } failed:^(id obj) {
        isGetCode = NO;
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:@"验证码发送失败"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];

}
- (void)waitVertificateCode:(NSTimer *)timer {
    UIButton *button = (UIButton *)timer.userInfo;
    timerSec--;
    if (timerSec == 0) {
        timerSec = 60;
        [timer invalidate];
        timer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [button setTitle:[NSString stringWithFormat:@"重获验证码(%lu)",(unsigned long)timerSec] forState:UIControlStateNormal];
    });
}



#pragma mark - UITextField 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if(string.length==0)
    {
        return YES;
    }
    int nameLength =25;
    int userInputLength = 11; //设置电话输入框输入字符的个数
    int idcardLength    =18;  //设置身份证输入框输入字符个数
    int verificationcodeLength =6;//验证码个数

    
        
    if (textField == phineF)
    {
        return range.location < userInputLength;
    }
    else if (textField ==idcardF)
    {
        return range.location < idcardLength;
    }
    else if (textField ==verificationcodeF)
    {
        return range.location <verificationcodeLength;
    }
    else if (textField == nameF)
    {
        if (![AppUtils isNotLanguageEmoji]) {
            return NO;
        }

        return range.location <nameLength;
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self viewMoving:ValidationTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==nameF)
    {
        [self viewMoving:ValidationTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==idcardF)
    {
        [self viewMoving:ValidationTB frame:CGRectMake(0, -30, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==phineF)
    {
        [self viewMoving:ValidationTB frame:CGRectMake(0, -70, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==verificationcodeF)
    {
        [self viewMoving:ValidationTB frame:CGRectMake(0, -120, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
}


//点击cell tableView上下滚动
-(void)viewMoving:(UIView *)View frame:(CGRect)frame setAnimationDuration:(double)moveTime
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:moveTime];//动画时间长度，单位秒，浮点数
    View.frame = frame;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}



@end
