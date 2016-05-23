//
//  TGPayDoneViewController.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"

@interface TGPayDoneViewController : O2OBaseViewController

@property(nonatomic,strong) NSArray * orderArray;

+ (BOOL)payFinishedForGeneralPush:(UIViewController *) fromPopVC;
@end
