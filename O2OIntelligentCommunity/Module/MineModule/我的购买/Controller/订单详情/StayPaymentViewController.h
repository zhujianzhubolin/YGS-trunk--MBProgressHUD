//
//  StayPaymentViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "MineBuyShopsM.h"
#import "MineBuyorderM.h"
#import "MineBuyGoodM.h"


typedef void(^BuySuccessFulBlock)();//购买成功

@interface StayPaymentViewController : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)UITableView *TableView;
@property (strong,nonatomic)MineBuyShopsM  *mineshopsM;
@property (strong,nonatomic)MineBuyorderM  *mineorderM;

@property (strong,nonatomic)BuySuccessFulBlock  buySuccessBlock;


@end
