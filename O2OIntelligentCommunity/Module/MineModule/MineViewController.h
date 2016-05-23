//
//  MineViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "O2OBaseViewController.h"
#import "UMSocial.h"
//分享相关
#import "HYActivityView.h"




@interface MineViewController :O2OBaseViewController<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property(strong,nonatomic)UITableView *TableView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) HYActivityView *activityView;

@end
