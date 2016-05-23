//
//  GrouponDetailsVC.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//



#import "O2OBaseViewController.h"
#import "MineBuyShopsM.h"
#import "MineBuyorderM.h"
#import "MineBuyGoodM.h"

typedef void(^TuanGouSuccessFulBlock)();//购买成功


@interface GrouponDetailsVC : O2OBaseViewController

@property (strong,nonatomic)MineBuyShopsM  *mineshopsM;
@property (strong,nonatomic)MineBuyorderM  *mineorderM;

@property (strong,nonatomic)TuanGouSuccessFulBlock  tuanGouSuccessBlock;


@end
