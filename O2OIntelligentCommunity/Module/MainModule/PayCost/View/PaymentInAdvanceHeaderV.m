//
//  PaymentInAdvanceHeaderV.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PaymentInAdvanceHeaderV.h"
#import "NSString+wrapper.h"

@implementation PaymentInAdvanceHeaderV
{
    UILabel *oweMoneyL;
    UITextField *inputAmountTF;
    UILabel *titleL;
    UILabel *balanceL;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat widthInterval = 15;
    CGFloat height = 40;
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(widthInterval, 0, self.frame.size.width, height)];
    [self addSubview:titleL];
    
    UILabel *oweMoneyTitleL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.frame.origin.x, CGRectGetMaxY(titleL.frame), 85, titleL.frame.size.height)];
    oweMoneyTitleL.text = @"欠费金额: ";
    [self addSubview:oweMoneyTitleL];
    
    oweMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oweMoneyTitleL.frame), oweMoneyTitleL.frame.origin.y, self.frame.size.width - widthInterval *2, oweMoneyTitleL.frame.size.height)];
    oweMoneyL.textColor = [AppUtils colorWithHexString:@"fc6d22"];
    [self addSubview:oweMoneyL];
    
    UILabel *balanceTitleL = [[UILabel alloc] initWithFrame:CGRectMake(oweMoneyTitleL.frame.origin.x, CGRectGetMaxY(oweMoneyTitleL.frame), oweMoneyTitleL.frame.size.width, oweMoneyTitleL.frame.size.height)];
    balanceTitleL.text = @"帐号余额: ";
    [self addSubview:balanceTitleL];
    
    balanceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(balanceTitleL.frame), balanceTitleL.frame.origin.y, oweMoneyL.frame.size.width, balanceTitleL.frame.size.height)];
    balanceL.textColor = [AppUtils colorWithHexString:@"fc6d22"];
    [self addSubview:balanceL];
    
    UIView *seperaterV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(balanceTitleL.frame), self.frame.size.width, 1)];
    seperaterV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    [self addSubview:seperaterV];
    
    inputAmountTF = [[UITextField alloc] initWithFrame:CGRectMake(titleL.frame.origin.x, CGRectGetMaxY(seperaterV.frame), titleL.frame.size.width, titleL.frame.size.height)];
    inputAmountTF.delegate = self;
    inputAmountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    inputAmountTF.placeholder = @"输入金额";
    [self addSubview:inputAmountTF];
}

- (void)configurateOweAcount:(NSString *)acount
                     balance:(NSString *)balance
                  chargeType:(ChargeType)type {
    titleL.text = [NSString stringWithFormat:@"您的帐号为%@预付费类型",[LocalUtils titleForChargeType:type]];
    oweMoneyL.text = [NSString stringWithFormat:@"%@元",acount];
    balanceL.text = [NSString stringWithFormat:@"%@元",balance];
}

- (NSString *)getOweMoneyAount {
    return oweMoneyL.text;
}

- (NSString *)getInputChargeAcount {
    return [NSString stringWithFormat:@"%.2f",inputAmountTF.text.floatValue];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == 0 && ![NSString isEmptyOrNull:string] && [string isEqualToString:@"0"]) {
        return NO;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    int userInputLength = 9;
    if ([AppUtils textFieldLimitDecimalPointWithDigits:2 WithText:textField.text shouldChangeCharactersInRange:range replacementString:string] && range.location < userInputLength) {
        return YES;
    }
    return NO;
}
@end
