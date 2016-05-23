//
//  RegisterViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/25.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2ORegisterViewController.h"
#import "UITextField+wrapper.h"
#import "UserHandler.h"
#import "RegisterHandler.h"
#import "NSString+wrapper.h"
#import "O2OLoginViewController.h"
#import "WebVC.h"
#import "MessageHandler.h"
#import "MessageHandler.h"  

@interface O2ORegisterViewController () <UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation O2ORegisterViewController
{
    __weak IBOutlet UITextField *phoneTF;
    __weak IBOutlet UITextField *passwordTF;
    __weak IBOutlet UITextField *verificationCodeTF;
    __weak IBOutlet UITextField *inviterPhoneTF;
    __weak IBOutlet UIButton *registorButton;
    __weak IBOutlet UIButton *verificationCodeButton;
    __weak IBOutlet UIButton *agreeBtn;
    __weak IBOutlet UIButton *protocolBtn;

    __weak IBOutlet UISwitch *passwordOn;
    NSTimer *waitTimer;

    NSUInteger timerSec;
    BOOL isGetCode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    timerSec = 60;
    if ([waitTimer isValid]) {
        [waitTimer invalidate];
        waitTimer = nil;
    }
    
    [verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    passwordOn.on = NO;
    self.title = @"用户注册";
    [protocolBtn  setTitle:[NSString stringWithFormat:@"同意%@用户协议",P_NMAE] forState:UIControlStateNormal];
    timerSec = 60;
    isGetCode = NO;
    [self initUI];
    // Do any additional setup after loading the view.
}

- (IBAction)zhuCeXieYiClick:(id)sender {
    WebVC *webVC = [WebVC new];
    webVC.webURL = P_USER_PROTOCAL;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)initUI {
    //设置textfield左边视图的图片和位置
    NSArray *tfArr = @[phoneTF,passwordTF,verificationCodeTF,inviterPhoneTF];
    NSArray *imgArr = @[@"userInfo",@"passwordInfo",@"verfiricate",@"userInfo"];
    
    for (int i = 0; i < tfArr.count; i++) {
        UITextField *currentTF = (UITextField *)tfArr[i];
        currentTF.leftView = [UITextField addSideViewWithfillImg:[UIImage imageNamed:imgArr[i]]];
        currentTF.leftViewMode = UITextFieldViewModeAlways;
        currentTF.adjustsFontSizeToFitWidth = YES;
        currentTF.delegate = self;
    }
    
    verificationCodeButton.layer.cornerRadius = 8;
    registorButton.layer.cornerRadius = 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Event
- (IBAction)getAuthCode:(UIButton *)sender {
    if (isGetCode || waitTimer.isValid) {
        return;
    }
    
    if (![AppUtils isMobileNumber:phoneTF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    [AppUtils showProgressMessage:@"正在获取验证码"];
    verificationCodeTF.text = nil;
    isGetCode = YES;
    
    MessageModel *messageM = [MessageModel new];
    messageM.businessType = @"register";
    messageM.mobilePhone = phoneTF.text;
    messageM.reference = P_REFERENCE;

    MessageHandler *messageH = [MessageHandler new];

    [messageH executeRegisterGetVerifyCodeTaskWithModel:messageM success:^(id obj) {
        [AppUtils showSuccessMessage:W_ALL_SENDCODE_SUC];
        if (!waitTimer.isValid) {
            waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(waitVertificateCode:) userInfo:sender repeats:YES];
        }
        isGetCode = NO;
    } failed:^(id obj) {
        [AppUtils showAlertMessageTimerClose:obj];
        isGetCode = NO;
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

- (IBAction)passwordSecureClick:(UISwitch *)sender {
    passwordTF.secureTextEntry = !sender.isOn;
}

- (IBAction)agreeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    if (![AppUtils isMobileNumber:phoneTF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    if ([NSString isEmptyOrNull:verificationCodeTF.text] ||
        [NSString isEmptyOrNull:passwordTF.text] ||
        [NSString isEmptyOrNull:verificationCodeTF.text]) {
        [AppUtils showAlertMessageTimerClose:@"请输入完整的注册信息"];
        return;
    }

    if (passwordTF.text.length < 6) {
        [AppUtils showAlertMessageTimerClose:W_ALL_PASS_LENGTH];
        return;
    }
    
    if (inviterPhoneTF.text.length > 0 &&
        ![AppUtils isMobileNumber:inviterPhoneTF.text]) {
        [AppUtils showAlertMessage:@"亲爱的,邀请人的手机号码格式不对喔"];
        return;
    }
    
    if (!agreeBtn.selected) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"请勾选‘%@用户协议’",P_NMAE]
                                                        delegate:self
                                               cancelButtonTitle:@"不同意"
                                               otherButtonTitles:@"同意", nil];
        [alertV show];
        return;
    }
    [self registerNetworkHandle];

}

- (void)registerNetworkHandle {
    [AppUtils showProgressMessage:@"注册中..."];
    RegisterHandler *registerH = [RegisterHandler new];
    RegisterEntity *registerE = [RegisterEntity new];
    registerE.accountName       = phoneTF.text;
    registerE.password          = [NSString md5_32Bit_String:passwordTF.text];
    registerE.salt              = @"123";
    registerE.reference         = P_REFERENCE;
    registerE.verCode           = verificationCodeTF.text;
    registerE.registerType      = @"mobilePhone";
    registerE.recomPhone        = inviterPhoneTF.text;
    registerE.orgcode           = @"123";
    registerE.channel           = @"ios";
    
    [registerH excuteRegisterTaskWithUser:registerE success:^(id obj) {
        [AppUtils showSuccessMessage:obj];
        [self.navigationController popViewControllerAnimated:YES];
        passwordTF.text = nil;
    } failed:^(id obj) {
        [AppUtils showAlertMessageTimerClose:obj];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    int passwordInputLength = 18;
    //限定输入字符的属性
    if (textField == phoneTF) {
        return range.location < PHONE_INPUT_BITS;
    }
    if (textField == passwordTF) {
        return range.location < passwordInputLength;
    }
    if (textField == verificationCodeTF) {
        return range.location < AUTH_CODE_INPUT_BITS;
    }
    if (textField == inviterPhoneTF) {
        return range.location < PHONE_INPUT_BITS;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1) {
        agreeBtn.selected = YES;
        [self registerNetworkHandle];
    }
}
@end
