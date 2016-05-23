//
//  ConvertVC.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/2.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef void(^DuiQuanSuccessBlock)();

#import "O2OBaseViewController.h"


@interface ConvertVC : O2OBaseViewController

@property (nonatomic,strong)DuiQuanSuccessBlock duihuanSuccessBlock;

@end
