//
//  TestingViewController.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define tagForVertificateBtn 10000

#import "TestingViewController.h"
#import "UserManager.h"
#import "CommunityViewCotroller.h"

#import "MessageModel.h"
#import "BingingXQModel.h"
#import "SwitchXQHandler.h"
#import "UserHandler.h"
#import "MessageHandler.h"
#import "bindingHandler.h"


@interface TestingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITextField *phoneF;
@property (nonatomic,strong)UITextField *verificationF;
@property (nonatomic,strong)UITextField *nameF;
@property (nonatomic,strong)UIButton    *nextBtn;
@property (nonatomic,strong)UIButton    *verificationcodeBtn;




@end

@implementation TestingViewController
{
    UITableView *testingTB;
    NSArray     *phoneArray;
    NSUInteger  next;
    UILabel *leftLab;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    [self registerNotification];
}

-(void)initData
{
    phoneArray = [NSArray array];
    phoneArray =[_phoneStr componentsSeparatedByString:@","];
    next = 0;
}

-(void)initUI
{
    self.title = @"验证信息";
    
    UIView *footoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 20, IPHONE_WIDTH-20, 25)];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text=@"如业主已更换手机，需业主前往服务中心更新；";
    [footoView addSubview:lab];
    
    if ([NSString isEmptyOrNull:_phoneStr])
    {
        lab.hidden=YES;
    }

    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(20, 75, IPHONE_WIDTH-40, 40);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.layer.masksToBounds=YES;
    submitBtn.layer.cornerRadius=5;
    submitBtn.titleLabel.textColor = [UIColor whiteColor];
    submitBtn.backgroundColor = [AppUtils colorWithHexString:G_BTN_BGCOLOR];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:submitBtn];
    
    
    testingTB = [[UITableView alloc]initWithFrame:self.view.bounds];
    testingTB.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    testingTB.dataSource = self;
    testingTB.delegate =self;
    testingTB.tableFooterView =footoView;
    [self.view addSubview:testingTB];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapArr:)];
    [self.view addGestureRecognizer:tap];

    
}

-(void)tapArr:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    [self viewMoving:testingTB frame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.phoneF];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.verificationF];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nameF];
    
    
}

- (void)popToLastVC {
    
    NSInteger vcCount = self.navigationController.viewControllers.count;
    NSLog(@"vcCount = %d",vcCount);
    if (vcCount >= 3) {
        UIViewController *before2vc = self.navigationController.viewControllers[vcCount - 1 - 2];
        [self.navigationController popToViewController:before2vc animated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)huanyigePhone
{
    NSLog(@"换一个");
    NSLog(@"%@,%@,%@,%@,%@",_louDongStr,_danYanStr,_fangHaoStr,_guanXiStr,_phoneStr);
    next++;
    if (next==phoneArray.count)
    {
        next=0;
    }
    self.phoneF.text=[phoneArray objectAtIndex:next];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [testingTB reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

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


- (void)registerNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged1:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneF];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged1:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.verificationF];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged1:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameF];

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
                UIButton *l_timeButton =(UIButton *)[self.view viewWithTag:tagForVertificateBtn];
                [l_timeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = YES;
            });
        }
        else
        {
            //            int minutes = timeout / 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                UIButton *l_timeButton =(UIButton *)[self.view viewWithTag:tagForVertificateBtn];
                [l_timeButton setTitle:[NSString stringWithFormat:@"重获验证码(%@)",strTime] forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Event
-(void)getverifivationcode
{
    NSLog(@"验证码");
    
    if (self.phoneF.text.length==7) {
        [AppUtils showAlertMessage:@"请补全预留的手机号码！"];
        return;
    }

    if (![AppUtils isMobileNumber:self.phoneF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    [AppUtils showProgressMessage:@"正在获取验证码"];
    MessageModel *messageE = [MessageModel new];
    messageE.smsType = @"BinDingUser";
    messageE.mobile=self.phoneF.text;
    messageE.reference = P_REFERENCE;
    messageE.roomId=_roomIdStr;
    
    MessageHandler *messageH = [MessageHandler new];
    
    [messageH executeBindingXiaoQuWithModel:messageE success:^(id obj) {
        [AppUtils showSuccessMessage:W_ALL_SENDCODE_SUC];
        [self YanZhengMaTime];
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:obj];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
    
}

- (void)textFiledEditChanged1:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    if (textField==self.phoneF)
    {
        NSUInteger kMaxLength = 11;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                   inTextField:textField];
    }
    else if (textField==self.verificationF)
    {
        NSUInteger kMaxLength = 6;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                   inTextField:textField];
    }
    else if (textField==self.nameF)
    {
        NSUInteger kMaxLength = 6;
        [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                                   inTextField:textField];
    }
}

-(void)submitAction
{
    if (_phoneF.text.length !=11)
    {
        [AppUtils showAlertMessageTimerClose:@"请补全预留手机号码！"];
        return;
    }
    
    [AppUtils showProgressMessage:@"正在提交数据"];
    
    BingingXQModel *xqModel = [[BingingXQModel alloc]init];
    bindingHandler *mineHand = [[bindingHandler alloc]init];
    
    if ([NSString isEmptyOrNull:_phoneStr])
    {
        xqModel.merberId = [UserManager shareManager].userModel.memberId;
        xqModel.xqNo = self.xqModel.xqNo;
        xqModel.bindingId = self.xqModel.bindingId;
        xqModel.identity = _guanXiStr;
        xqModel.smstype = @"BinDingUser";
        xqModel.floorNumber=_louDongStr;
        if (![NSString isEmptyOrNull:_danYanStr])
        {
            xqModel.unitNumber = _danYanStr;
        }
        else
        {
            xqModel.unitNumber =@"";
        }
        if ([NSString isEmptyOrNull:_roomIdStr])
        {
            xqModel.roomId=@"";
        }
        else
        {
            xqModel.roomId=_roomIdStr;
        }

        xqModel.userName = [UserManager shareManager].userModel.realName;
        xqModel.userName = self.nameF.text;
        xqModel.roomNumber = _fangHaoStr;
        xqModel.userPhone = self.phoneF.text;
        xqModel.code = self.verificationF.text;
    }
    else
    {
        if ([_guanXiStr isEqualToString:@"1"])
        {
            xqModel.merberId = [UserManager shareManager].userModel.memberId;
            xqModel.xqNo = self.xqModel.xqNo;
            xqModel.bindingId = self.xqModel.bindingId;
            xqModel.identity = _guanXiStr;
            xqModel.smstype = @"BinDingUser";
            xqModel.floorNumber=_louDongStr;
            if (![NSString isEmptyOrNull:_danYanStr])
            {
                xqModel.unitNumber = _danYanStr;
            }
            else
            {
                xqModel.unitNumber =@"";
            }
            if ([NSString isEmptyOrNull:_roomIdStr])
            {
                xqModel.roomId=@"";
            }
            else
            {
                xqModel.roomId=_roomIdStr;
            }

            xqModel.userName=[UserManager shareManager].userModel.realName;
            xqModel.roomNumber= _fangHaoStr;
            xqModel.userPhone= self.phoneF.text;
            xqModel.code=self.verificationF.text;
            
        }
        else
        {
            xqModel.merberId = [UserManager shareManager].userModel.memberId;
            xqModel.xqNo = self.xqModel.xqNo;
            xqModel.bindingId = self.xqModel.bindingId;
            xqModel.identity = _guanXiStr;
            xqModel.smstype = @"BinDingUser";
            xqModel.floorNumber=_louDongStr;
            if (![NSString isEmptyOrNull:_danYanStr])
            {
                xqModel.unitNumber = _danYanStr;
            }
            else
            {
                xqModel.unitNumber =@"";
            }
            if ([NSString isEmptyOrNull:_roomIdStr])
            {
                xqModel.roomId=@"";
            }
            else
            {
                xqModel.roomId=_roomIdStr;
            }
            xqModel.userName=[UserManager shareManager].userModel.realName;
            xqModel.roomNumber= _fangHaoStr;
            xqModel.userPhone= self.phoneF.text;
            xqModel.code=@"";
        }
    }
    
    NSLog(@"phone==%@",self.phoneF.text);
    
    //绑定小区
    [mineHand bangdingxiaoqu:xqModel success:^(id bangdingObj)
     {
         if (self.comBindingFinishedBlock) {
             self.comBindingFinishedBlock();
         }

         NSLog(@"==%@",bangdingObj);
         NSString *isCheck = bangdingObj; //审核状态
         
         if (![NSString isEmptyOrNull:isCheck] && [isCheck isEqualToString:@"1"]) {
             [AppUtils showSuccessMessage:@"该小区正在审核中，请等待"];
             [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popToLastVC) userInfo:nil repeats:NO];
             return;
         }
         
         if (![NSString isEmptyOrNull:self.xqModel.xqNo] && [self.xqModel.xqNo isEqualToString:[UserManager shareManager].comModel.xqNo]) {
             [UserHandler executeGetUserInfoSuccess:^(id obj) {
                 self.xqModel = [UserManager shareManager].comModel;
                 [AppUtils showSuccessMessage:W_COM_BANDING_SUC];
                 [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popToLastVC) userInfo:nil repeats:NO];
             } failed:^(id obj) {
                 self.xqModel.isBinding = @"Y";
                 [UserManager shareManager].comModel = self.xqModel;
                 [AppUtils showSuccessMessage:W_COM_BANDING_SUC];
                 [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popToLastVC) userInfo:nil repeats:NO];
             }];
         }
         else {
             [AppUtils showSuccessMessage:W_COM_BANDING_SUC];
             [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popToLastVC) userInfo:nil repeats:NO];
         }
     } failed:^(id obj) {
         [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
     }];
    
}

#pragma mark - setter\getter
-(UITextField *)phoneF
{
    if (_phoneF == nil)
    {
        _phoneF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,IPHONE_WIDTH-140, 44)];
        _phoneF.placeholder = @"请填写手机号";
        _phoneF.delegate = self;
        _phoneF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneF.text = [phoneArray objectAtIndex:next];
    }
    return _phoneF;
}

-(UITextField *)verificationF
{
    if (_verificationF == nil)
    {
        _verificationF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,IPHONE_WIDTH-140, 44)];
        _verificationF.placeholder=@"请输入验证码";
        _verificationF.keyboardType = UIKeyboardTypeNumberPad;
        _verificationF.delegate = self;
       
    }
    return _verificationF;
}

-(UITextField *)nameF
{
    if (_nameF == nil)
    {
        _nameF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,IPHONE_WIDTH-140, 44)];
        _nameF.delegate = self;
        _nameF.placeholder=@"请输入姓名";
    }
    return _nameF;
}

-(UIButton *)nextBtn
{
    if (_nextBtn==nil)
    {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame=CGRectMake(IPHONE_WIDTH-90, (44 -30)/2, 80, 30);
        _nextBtn.backgroundColor=[AppUtils colorWithHexString:@"08A4DD"];
        _nextBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_nextBtn setTitle:@"换一个" forState:UIControlStateNormal];
        _nextBtn.layer.masksToBounds=YES;
        _nextBtn.layer.cornerRadius=5;
        [_nextBtn addTarget:self action:@selector(huanyigePhone) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.hidden=YES;
    }
    return _nextBtn;
}

-(UIButton *)verificationcodeBtn
{
    if (_verificationcodeBtn == nil)
    {
        
        _verificationcodeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _verificationcodeBtn.frame=CGRectMake(IPHONE_WIDTH-130, (44 -30)/2, 120, 30);
        _verificationcodeBtn.backgroundColor=[AppUtils colorWithHexString:@"08A4DD"];
        _verificationcodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_verificationcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationcodeBtn.layer.masksToBounds=YES;
        _verificationcodeBtn.layer.cornerRadius=5;
        _verificationcodeBtn.tag=tagForVertificateBtn;
        [_verificationcodeBtn addTarget:self action:@selector(getverifivationcode) forControlEvents:UIControlEventTouchUpInside];

    }
    return _verificationcodeBtn;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([NSString isEmptyOrNull:_phoneStr])
    {
        return 3;
    }
    else if (![NSString isEmptyOrNull:_phoneStr])
    {
        if ([_guanXiStr isEqualToString:@"1"])
        {
            return 2;
        }
        else
            return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (![NSString isEmptyOrNull:_phoneStr] && section==0)
    {
        return 40;
    }
    return 5;

    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![NSString isEmptyOrNull:_phoneStr]  && section==0)
    {
        UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-20, 40)];
        lab.font=[UIFont systemFontOfSize:14];
        lab.text = @"  请补全预留在管理服务中心的业主手机号码";
        return lab;

    }
    else
        return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (Cell == nil)
    {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    CGRect rect = CGRectMake(10, 0,IPHONE_WIDTH-140, 44);
    
    if ([NSString isEmptyOrNull:_phoneStr])
    {
        if (indexPath.section==0)
        {
            [Cell.contentView addSubview:self.nameF];
        }
        else if (indexPath.section==1)
        {
            [Cell.contentView addSubview:self.phoneF];
        }
        else if (indexPath.section==2)
        {
            [Cell.contentView addSubview:self.verificationF];
            
                        [Cell.contentView addSubview:self.verificationcodeBtn];

        }
    }
    else if (![NSString isEmptyOrNull:_phoneStr])
    {
        if ([_guanXiStr isEqualToString:@"1"])
        {
            if (indexPath.section==0)
            {
                NSLog(@"phoneArray.conunt== %lu",(unsigned long)phoneArray.count);
                
                if (![NSArray isArrEmptyOrNull:phoneArray] && phoneArray.count > 1)
                {
                    self.nextBtn.hidden = NO;
                }
                else
                {
                    self.nextBtn.hidden = YES;
                }
                [Cell.contentView addSubview:self.phoneF];
                [Cell.contentView addSubview:self.nextBtn];

                
            }
            else if (indexPath.section==1)
            {
                [Cell.contentView addSubview:self.verificationF];
                
                UIButton *getverificationcodeB=[UIButton buttonWithType:UIButtonTypeCustom];
                getverificationcodeB.frame=CGRectMake(IPHONE_WIDTH-130, (44 -30)/2, 120, 30);
                getverificationcodeB.backgroundColor=[AppUtils colorWithHexString:@"08A4DD"];
                getverificationcodeB.titleLabel.adjustsFontSizeToFitWidth = YES;
                [getverificationcodeB setTitle:@"获取验证码" forState:UIControlStateNormal];
                getverificationcodeB.layer.masksToBounds=YES;
                getverificationcodeB.layer.cornerRadius=5;
                getverificationcodeB.tag=tagForVertificateBtn;
                [getverificationcodeB addTarget:self action:@selector(getverifivationcode) forControlEvents:UIControlEventTouchUpInside];
                [Cell.contentView addSubview:getverificationcodeB];
            }

        }
        else
        {
            if (indexPath.section==0)
            {
              
                [Cell.contentView addSubview:self.phoneF];
                
                if (![NSArray isArrEmptyOrNull:phoneArray] && phoneArray.count > 1)
                {
                    self.nextBtn.hidden = NO;
                }
                else
                {
                    self.nextBtn.hidden = YES;
                }
                [Cell.contentView addSubview:self.nextBtn];
                
            }

        }
    }
    
    return Cell;
}




#pragma mark -  UITextField 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"string = %@",string);
    if (textField==self.phoneF)
    {
        if(textField.text.length > 7){
            return YES;
        }
        else if (textField.text.length == 7) {
            if (string.length > 0) {
                return YES;
            }
        }
        
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (VIEW_IPhone4_INCH)
    {
        if (textField==self.verificationF)
        {
            [self viewMoving:testingTB frame:CGRectMake(0, -80, IPHONE_WIDTH, IPHONE_HEIGHT) setAnimationDuration:0.3];
        }
        
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
