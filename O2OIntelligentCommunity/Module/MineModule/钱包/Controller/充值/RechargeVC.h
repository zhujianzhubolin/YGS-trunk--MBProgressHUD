//
//  RechargeVC.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef void (^ZYRechargeSucBlock)();

#import "O2OBaseViewController.h"

@interface RechargeVC : O2OBaseViewController
@property (nonatomic, strong)ZYRechargeSucBlock rechargeSucBlock;
@end
