//
//  SetViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"

@interface SetViewController : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic)UITableView *TableView;

@end
