//
//  LoginViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"

typedef NS_ENUM(NSUInteger,LoginMode) {
    LoginModeYGS,
    LoginModeYFB
};

@interface O2OLoginViewController : O2OBaseViewController

+ (void)presentToMainVCWithAnimation:(BOOL)isAnimation
                  fromViewController:(UIViewController *)fromVC;
@end
