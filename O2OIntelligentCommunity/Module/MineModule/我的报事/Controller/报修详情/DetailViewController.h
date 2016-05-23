//
//  DetailViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "BaoXiuTouSuModel.h"
#import "DetaimgCell.h"




@interface DetailViewController : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)UITableView *TabView;
@property (nonatomic,strong)BaoXiuTouSuModel *bxtsM;


@property (nonatomic,copy)NSString *isbaoxiuComplaint;

@end
