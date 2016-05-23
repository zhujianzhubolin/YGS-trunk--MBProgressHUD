//
//  AdActivityWebVC.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/7.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//



#import "O2OBaseViewController.h"
extern NSString * const kAdWebActivity;

@interface AdActivityWebVC : O2OBaseViewController

@property (nonatomic,copy) NSString *adTypeStr;
@property (nonatomic,copy) NSString *webURL;
@end
