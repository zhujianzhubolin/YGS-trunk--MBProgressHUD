//
//  PaymentInAdvanceHeaderV.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentInAdvanceHeaderV : UIView <UITextFieldDelegate>

- (void)configurateOweAcount:(NSString *)acount
                     balance:(NSString *)balance
                  chargeType:(ChargeType)type;
- (NSString *)getInputChargeAcount;
- (NSString *)getOweMoneyAount;
@end
