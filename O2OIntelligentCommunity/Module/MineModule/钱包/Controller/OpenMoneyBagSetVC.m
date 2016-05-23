//
//  OpenMoneyBagSetVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "OpenMoneyBagSetVC.h"
#import "UserManager.h"
#import "MoneyBagVC.h"
#import "ZSDPaymentView.h"

#ifdef SmartComJYZX
#elif SmartComYGS
#import "HoneyVC.h"
#else

#endif


//获取验证码接口类
#import "MessageHandler.h"
#import "MessageModel.h"
//开通钱包接口类
#import "OpenMoneyBagModel.h"
#import "OpenMoneyBagHandler.h"



#import "UserHandler.h"
#import "AppDelegate.h"
@interface OpenMoneyBagSetVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation OpenMoneyBagSetVC
{
    UITableView *openmonebagTB;
    
    UITextField *nameF;
    UITextField *idcardF;
    UITextField *phineF;
    UITextField *verificationcodeF;
    UITextField *paypasswordF;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    
    self.view.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    self.title=@"钱包设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"openqianbaoset"] style:UIBarButtonItemStyleBordered target:self action:@selector(OpenMoneyBagSetArr)];
    
    
    
    openmonebagTB = [[UITableView alloc]init];
    openmonebagTB.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    openmonebagTB.dataSource=self;
    openmonebagTB.delegate=self;
    openmonebagTB.separatorStyle = UITableViewCellAccessoryNone;
    openmonebagTB.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    [self.view addSubview:openmonebagTB];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselfviewArr:)];
    [self.view addGestureRecognizer:tap];
}

-(void)OpenMoneyBagSetArr
{
    [self.view endEditing:YES];
    [self viewMoving:openmonebagTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];

        if (nameF.text.length <= 0 ||
            idcardF.text.length <= 0 ||
            phineF.text.length <= 0 ||
            verificationcodeF.text.length <= 0 ||
            paypasswordF.text.length <= 0) {
            [AppUtils showAlertMessageTimerClose:@"请填写完整的信息"];
            return;
        }
        
        if (![AppUtils isMobileNumber:phineF.text]) {
            [AppUtils showAlertMessageTimerClose:@"请输入合法的手机号码"];
            return;
        }
        
        if (![AppUtils isValidateIdentityCard:idcardF.text]) {
            [AppUtils showAlertMessageTimerClose:@"请输入合法的身份证"];
            return;
        }
        OpenMoneyBagModel *openM =[OpenMoneyBagModel new];
        OpenMoneyBagHandler *openH =[OpenMoneyBagHandler new];
        openM.memberId      =[UserManager shareManager].userModel.memberId;
        openM.name          =nameF.text;
        openM.cardNo        =idcardF.text;
        openM.phone         =phineF.text;
        openM.code          =verificationcodeF.text;
        openM.payPassword   =[NSString md5_32Bit_String:paypasswordF.text];
        [openH openmoneybag:openM success:^(id obj1)
        {
            paypasswordF.text = nil;
            
            [UserHandler executeGetUserInfoSuccess:^(id obj) {
                [AppUtils showSuccessMessage:obj1];
                [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(pushMoneyBagVC) userInfo:nil repeats:NO];
            } failed:^(id obj) {
                [AppUtils showSuccessMessage:obj1];
                [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(pushMoneyBagVC) userInfo:nil repeats:NO];
            }];

        } failed:^(id obj) {
            [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
        }];
}

- (void)pushMoneyBagVC
{
    
#ifdef SmartComJYZX
    
    MoneyBagVC *moneybagvc=[[MoneyBagVC alloc]init];
    [self.navigationController pushViewController:moneybagvc animated:YES];
#elif SmartComYGS
    if ([_isPageBack isEqualToString:@"honeyPage"]) {
        for (UINavigationController * nav in self.navigationController.viewControllers) {
            if ([nav isKindOfClass:[HoneyVC class]]) {
                
                HoneyVC * honeVc = (HoneyVC *)nav;
                
                [self.navigationController popToViewController:honeVc animated:YES];
                
                return;
            }
        }
        
    }
    else
    {
        MoneyBagVC *moneybagvc=[[MoneyBagVC alloc]init];
        [self.navigationController pushViewController:moneybagvc animated:YES];
    }

#else
    
#endif

    
    
   
}

-(void)tapselfviewArr:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    [self viewMoving:openmonebagTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
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


#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
                return 50;
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
            case 4:
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
        lab.numberOfLines=0;
        lab.font=[UIFont systemFontOfSize:14];
        
        lab.text=@"请如实填写以下信息，该信息将成为钱包的唯一标识。";
        CGSize titleSize = [lab.text boundingRectWithSize:CGSizeMake(IPHONE_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        lab.frame =CGRectMake(10, 0, titleSize.width, 45);
        [headView addSubview:lab];
        
    }
    else
    {
        
        headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 25);
    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer =@"openmoneybagsetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle=UITableViewCellAccessoryNone;
    }
    CGRect fram =CGRectMake(100, (55-40)/2, self.view.frame.size.width-130, 40);
    if (indexPath.section==0)
    {
        cell.textLabel.text=@"姓       名：";
        nameF =[[UITextField alloc]initWithFrame:fram];
        nameF.keyboardType = UIKeyboardTypeDefault;
        nameF.placeholder=@"设置名称";
        nameF.delegate=self;
        [cell.contentView addSubview:nameF];
    }
    else if (indexPath.section==1)
    {
        cell.textLabel.text=@"身份证号：";
        idcardF =[[UITextField alloc]initWithFrame:fram];
        idcardF.keyboardType = UIKeyboardTypeASCIICapable;
        idcardF.placeholder=@"设置身份证号";
        idcardF.delegate=self;
        [cell.contentView addSubview:idcardF];
    }
    else if (indexPath.section==2)
    {
        cell.textLabel.text=@"手  机  号：";
        phineF =[[UITextField alloc]initWithFrame:fram];
        phineF.keyboardType = UIKeyboardTypeNumberPad;
        phineF.text=[UserManager shareManager].userModel.phone;
        phineF.delegate=self;
        phineF.enabled=NO;
        [cell.contentView addSubview:phineF];
        
    }
    
    else if (indexPath.section==3)
    {
        cell.textLabel.text=@"验  证  码：";
        verificationcodeF =[[UITextField alloc]initWithFrame:CGRectMake(100, (55 - 40)/2, 80, 40)];
        verificationcodeF.keyboardType = UIKeyboardTypeNumberPad;
        verificationcodeF.delegate=self;
        [cell.contentView addSubview:verificationcodeF];
        
        UIButton *getverificationcodeB=[UIButton buttonWithType:UIButtonTypeCustom];
        getverificationcodeB.frame=CGRectMake(IPHONE_WIDTH-130, (55 -35)/2, 120, 35);
        getverificationcodeB.backgroundColor=[AppUtils colorWithHexString:@"08A4DD"];
        getverificationcodeB.titleLabel.adjustsFontSizeToFitWidth = YES;
        [getverificationcodeB setTitle:@"获取验证码" forState:UIControlStateNormal];
        getverificationcodeB.layer.masksToBounds=YES;
        getverificationcodeB.layer.cornerRadius=5;
        getverificationcodeB.tag=108;
        [getverificationcodeB addTarget:self action:@selector(getverifivationcode) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:getverificationcodeB];
    }
    else if (indexPath.section==4)
    {
        cell.textLabel.text=@"支付密码：";
        paypasswordF =[[UITextField alloc]initWithFrame:fram];
        paypasswordF.keyboardType = UIKeyboardTypeNumberPad;
        paypasswordF.secureTextEntry=YES;
        paypasswordF.placeholder=@"设置支付密码";
        paypasswordF.delegate=self;
        [cell.contentView addSubview:paypasswordF];
    }

    return cell;
}

#pragma mark -UITextFieldDelegat
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==nameF)
    {
        [self viewMoving:openmonebagTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==idcardF)
    {
        [self viewMoving:openmonebagTB frame:CGRectMake(0, -30, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==phineF)
    {
        [self viewMoving:openmonebagTB frame:CGRectMake(0, -70, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==verificationcodeF)
    {
        [self viewMoving:openmonebagTB frame:CGRectMake(0, -120, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    }
    else if (textField==paypasswordF)
    {
        
        paypasswordF.text=@"";
        
        ZSDPaymentView *paymentV = [ZSDPaymentView new];
        
        paymentV.title = @"设置支付密码";
        
        paymentV.goodsName = @" ";
        paymentV.amount = -1;
        paymentV.finishBlock = ^(NSString *inputStr){

            ZSDPaymentView *paymentV2 = [ZSDPaymentView new];
            paymentV2.title = @"请再次出入支付密码";
            paymentV2.goodsName = @" ";
            paymentV2.amount = -1;
            paymentV2.finishBlock = ^(NSString *inputStr2){
                if ([inputStr2 isEqualToString:inputStr]) {
                    textField.text = inputStr2;
                }
                else {
                    [AppUtils showErrorMessage:W_PASSWORD_NO_EQUAL];
                }
            };
            [paymentV2 show];
        };
        [paymentV show];

    }
}


#pragma mark -获取验证码方法
-(void)getverifivationcode
{
    
    
    if (![AppUtils isMobileNumber:phineF.text]) {
        [AppUtils showAlertMessage:@"请输入正确的手机号码"];
        return;
    }
    
    [verificationcodeF becomeFirstResponder];//发送验证码将该对应的textfield变成第一响应者
    [AppUtils showProgressMessage:@"发送中"];
    
    MessageModel *messageE = [MessageModel new];
    messageE.memberId=[UserManager shareManager].userModel.memberId;
    messageE.mobilePhone=phineF.text;
    messageE.businessType=@"activateMycard";
    messageE.reference=P_REFERENCE;
    MessageHandler *messageH = [MessageHandler new];
    
    [messageH executeMoneyBagCodeTaskWithModel:messageE success:^(id obj) {
        [AppUtils showSuccessMessage:@"验证码发送成功"];
        [self YanZhengMaTime];
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:@"验证码发送失败"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];


}

//发送验证码的时间控制
-(void)YanZhengMaTime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0)
        { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                UIButton *button =(UIButton *)[openmonebagTB viewWithTag:108];
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }
        else
        {
            //            int minutes = timeout / 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                UIButton *button =(UIButton *)[openmonebagTB viewWithTag:108];
                [button setTitle:[NSString stringWithFormat:@"重获验证码(%@)",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
    int paypasswordLength = 6;//支付密码个数
    
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
    else if(textField ==paypasswordF)
    {
        return range.location <paypasswordLength;
    }
    else if (textField==nameF)
    {
        if (![AppUtils isNotLanguageEmoji]) {
            return NO;
        }
        return range.location < nameLength;
    }
        
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self viewMoving:openmonebagTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
    return YES;
}




@end
