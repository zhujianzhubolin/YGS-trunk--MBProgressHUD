//
//  PhoneChargeViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PhoneButtonTag) {
   phoneButtonTag50 = 1,
   phoneButtonTag100,
   phoneButtonTag300,
   phoneButtonTag500
};

#import "PhoneChargeViewController.h"
#import "PhoneChargeE.h"
#import "UserManager.h"
#import <SVProgressHUD.h>
#import "CheckstandViewController.h"
#import "PhoneH.h"

@interface PhoneChargeViewController () <UITextFieldDelegate>

@end

@implementation PhoneChargeViewController
{
    __weak IBOutlet UIButton *phone50Button;
    __weak IBOutlet UIButton *phone100Button;
    __weak IBOutlet UIButton *phone300Button;
    __weak IBOutlet UIButton *phone500Button;
    __weak IBOutlet UIView *chargeButtomView;
    __weak IBOutlet UIButton *chargeButton;
    __weak IBOutlet UITextField *phoneTF;
    
    UIButton *selectedBtn;
    __weak IBOutlet UILabel *payCountL;
    NSString *attribution; //归属地
}

- (void)resetPayCount {
    payCountL.text = [NSString stringWithFormat:@"金额: %@.00元",selectedBtn.titleLabel.text];
    
    if (![NSString isEmptyOrNull:attribution]) {
        payCountL.text = [NSString stringWithFormat:@"%@ (%@)",payCountL.text,attribution];
    }
}

- (IBAction)phoneButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    selectedBtn = sender;

    [self resetPayCount];
    for (int i = 1; i <= 4; i++) {
        UIButton *phoneButton = (UIButton *)[self.view viewWithTag:i];
        phoneButton.selected = NO;
        [phoneButton setBackgroundColor:[UIColor whiteColor]];
    }

    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    }
}

- (IBAction)chargeClick:(id)sender {
    [self.view endEditing:YES];
    
    if (phoneTF.text.length == 0) {
        [AppUtils showAlertMessage:W_PHONE_NO_INPUT];
        return;
    }
    
    if (![AppUtils isMobileNumber:phoneTF.text]) {
        [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
        return;
    }

    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    CheckstandViewController *checkStandVC = (CheckstandViewController *)[feesPaidStoryboard instantiateViewControllerWithIdentifier:@"CheckstandViewControllerID"];

    checkStandVC.attribution    = attribution;
    checkStandVC.phone          = phoneTF.text;
    checkStandVC.chargeType     = ChargeTypePhone;
    checkStandVC.payCount       = [NSString stringWithFormat:@"%.2f",selectedBtn.titleLabel.text.floatValue];
    
    [self.navigationController pushViewController:checkStandVC animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:phoneTF];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:phoneTF];
}

- (void)textFiledEditChanged:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    if (textField.text.length == 11) {
        if (![AppUtils isMobileNumber:phoneTF.text]) {
            [AppUtils showAlertMessage:W_ALL_PHONE_ERR_FORMAT];
            return;
        }
        
        [AppUtils showProgressMessage:@"查询中,请稍候"];
        
        PhoneH *phoneH = [PhoneH new];
        NSDictionary *paraDic = @{@"phone":phoneTF.text,
                                  @"key":PHONE_QUERE_KEY};
        
        [phoneH executeTaskForQueryPhoneAttribution:paraDic success:^(id obj) {
            [AppUtils dismissHUD];
            attribution = obj;
            [self resetPayCount];
        } failed:^(id obj) {
            [AppUtils dismissHUD];
            attribution = nil;
            [self resetPayCount];
        }];
    }
    else {
        attribution = nil;
        [self resetPayCount];
    }
}

- (void)initUI {
    attribution = nil;
    phone100Button.selected = YES;
    phone100Button.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    selectedBtn = phone100Button;
    payCountL.text = [NSString stringWithFormat:@"  金额: %@.00元",selectedBtn.titleLabel.text];
    
    self.title = @"话费充值";
    for (int i = 1; i <= 4; i++) {
        UIButton *phoneButton = (UIButton *)[self.view viewWithTag:i];
        phoneButton.titleLabel.backgroundColor = [UIColor clearColor];
        phoneButton.layer.cornerRadius = 5;
    }
    chargeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftV.backgroundColor = [UIColor clearColor];
    phoneTF.leftView = leftV;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == phoneTF) {
        if (string.length == 0) {
            return YES;
        }

        //限定输入字符的属性
        return range.location < PHONE_INPUT_BITS;
    }
    return YES;
}

@end
