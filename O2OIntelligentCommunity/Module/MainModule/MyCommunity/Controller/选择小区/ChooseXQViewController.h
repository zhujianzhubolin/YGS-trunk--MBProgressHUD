//
//  ChooseXQViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef void (^CommunityAddFinishedBlock)();
#import "O2OBaseViewController.h"
#import "UserManager.h"

//添加小区
#import "AddXQModel.h"
#import "addXQHandler.h"
#import "BingingXQModel.h"

@interface ChooseXQViewController : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong)NSArray *myXQArr;
@property (nonatomic,strong)NSArray *allXQArray;   
@property (nonatomic,strong)UITableView *TableView;
@property (nonatomic,strong)CommunityAddFinishedBlock comAddFinishedBlock;
@end
