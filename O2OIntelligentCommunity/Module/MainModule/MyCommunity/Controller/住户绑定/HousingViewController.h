//
//  HousingViewController.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef void (^NextBlock)();


#import "O2OBaseViewController.h"
#import "BingingXQModel.h"

@interface HousingViewController : O2OBaseViewController

@property (nonatomic,strong)BingingXQModel *xqModel;
@property (nonatomic,strong)NextBlock nextBlock;


@end
