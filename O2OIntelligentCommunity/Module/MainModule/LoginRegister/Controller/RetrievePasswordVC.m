//
//  RetrievePasswordViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/25.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RetrievePasswordVC.h"
#import "NSString+wrapper.h"
#import "RetrievePassH.h"
#import "ResetPasswordVC.h"
#import "MessageModel.h"    
#import "MessageHandler.h"
#import "UITextField+wrapper.h"

@interface RetrievePasswordVC () <UITextFieldDelegate>

@end

@implementation RetrievePasswordVC
{
    __weak IBOutlet UITextField *phoneTF;
    __weak IBOutlet UITextField *authTF;
    
    NSTimer *waitTimer;
    
    __weak IBOutlet UIButton *submitBtn;
    __weak IBOutlet UIButton *getCodeBtn;
    NSUInteger timerSec;
    BOOL isGetCode;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     timerSec = 60;
    phoneTF.text = nil;
    authTF.text = nil;
    if ([waitTimer isValid]) {
        [waitTimer invalidate];
        waitTimer = nil;
    }
    
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (IBAction)submitClick:(id)sender {
    [self.view endEditing:YES];
    if (![AppUtils isMobileNumber:phoneTF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    
    MessageModel *messageE = [MessageModel new];
    messageE.mobile = phoneTF.text;
    messageE.code = authTF.text;
    messageE.smsType = @"RetPwd";
    
    MessageHandler *messageH = [MessageHandler new];
    [messageH executeVerifyCodeIsRightTaskWithModel:messageE success:^(id obj) {
        NSString *code = (NSString *)obj;
        if (![NSString isEmptyOrNull:code] && [code isEqualToString:authTF.text]) {
            [AppUtils dismissHUD];
            UIStoryboard *mainStoryB = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
            ResetPasswordVC *resetPassVC = [mainStoryB instantiateViewControllerWithIdentifier:@"ResetPasswordVCID"];
            resetPassVC.phone = messageE.mobile;
            [self.navigationController pushViewController:resetPassVC animated:YES];
        }
        else {
            [AppUtils showAlertMessageTimerClose:@"亲,验证码不正确哦"];
        }
    } failed:^(id obj) {
        [AppUtils showAlertMessageTimerClose:obj];
    }];
}

- (IBAction)getAutoCode:(UIButton *)sender {
    if (isGetCode || waitTimer.isValid) {
        return;
    }
    
    if (![AppUtils isMobileNumber:phoneTF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }
    
    [AppUtils showProgressMessage:@"正在获取验证码"];
    authTF.text = nil;
    isGetCode = YES;
    
    MessageModel *messageM = [MessageModel new];
    messageM.smsType = @"RetPwd",
    messageM.mobile = phoneTF.text;
    messageM.reference = P_REFERENCE;
    
    MessageHandler *messageH = [MessageHandler new];
    [messageH executeGetVerifyCodeTaskWithModel:messageM success:^(id obj) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    phoneTF.delegate = self;
    authTF.delegate = self;
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initUI {
    isGetCode = NO;
    self.title = @"找回密码";
    timerSec = 60;
    getCodeBtn.layer.cornerRadius = 8;
    submitBtn.layer.cornerRadius = 8;
    

    //设置textfield左边视图的图片和位置
    NSArray *tfArr = @[phoneTF,authTF];
    NSArray *imgArr = @[@"userInfo",@"verfiricate"];
    
    for (int i = 0; i < tfArr.count; i++) {
        UITextField *currentTF = (UITextField *)tfArr[i];
        currentTF.leftView = [UITextField addSideViewWithfillImg:[UIImage imageNamed:imgArr[i]]];
        currentTF.leftViewMode = UITextFieldViewModeAlways;
        currentTF.adjustsFontSizeToFitWidth = YES;
        currentTF.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    //限定输入字符的属性
    if (textField == phoneTF) {
        return range.location < PHONE_INPUT_BITS;
    }
    if (textField == authTF) {
        return range.location < AUTH_CODE_INPUT_BITS;
    }
    return YES;
}
@end
