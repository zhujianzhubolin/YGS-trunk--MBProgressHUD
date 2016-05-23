//
//  ResetPasswordVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "NSString+wrapper.h"
#import "UpdatePassEntity.h"
#import "RetrievePassH.h"


@interface ResetPasswordVC () <UITextFieldDelegate>

@end

@implementation ResetPasswordVC
{
    __weak IBOutlet UITextField *passOneTF;
    __weak IBOutlet UITextField *passTwoTF;
    
    __weak IBOutlet UIButton *submmitBtn;
}

- (IBAction)submitClick:(id)sender {
    [self.view endEditing:YES];
    if ([NSString isEmptyOrNull:passOneTF.text] ||
        [NSString isEmptyOrNull:passTwoTF.text] ||
        passOneTF.text.length < 6 ||
        passTwoTF.text.length < 6) {
        [AppUtils showAlertMessageTimerClose:W_PASSWORD_LENGTH];
        return;
    }
    
    if (![passOneTF.text isEqualToString:passTwoTF.text]) {
        [AppUtils showAlertMessageTimerClose:W_PASSWORD_NO_EQUAL];
        return;
    }
    
    [AppUtils showProgressMessage:@"重置中,请稍等"];
    RetrievePassH *retrieveH = [RetrievePassH new];
    RetrieveEntity *retrieveE = [RetrieveEntity new];
    retrieveE.phone = self.phone;
    retrieveE.nPass = [NSString md5_32Bit_String:passOneTF.text];
    retrieveE.reference = P_REFERENCE;
    
    [retrieveH excuteRetrievePassTaskWithUser:retrieveE success:^(id obj) {
        [AppUtils showSuccessMessage:W_PASSWORD_MODIFY_SUC];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popToTootVC) userInfo:nil repeats:NO];
        NSLog(@"obj = %@",obj);
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
    }];
}

- (void)popToTootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
    passOneTF.text = nil;
    passTwoTF.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    passOneTF.delegate = self;
    passTwoTF.delegate = self;
    submmitBtn.layer.cornerRadius = 8;
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
    NSInteger passLength = 16;
    if (textField == passOneTF) {
        return range.location < passLength;
    }
    if (textField == passTwoTF) {
        return range.location < passLength;
    }
    return YES;
}

@end
