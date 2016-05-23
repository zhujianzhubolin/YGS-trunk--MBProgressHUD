//
//  BaseTableViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchVCAnimation.h"

@interface BaseTableViewController : UITableViewController
@property (nonatomic, assign) BOOL viewIsVisible;

- (void)showTabbar;

- (void)hidetabbar;

-(void)viewDidLayoutSubviewsForTableView:(UITableView *)tableview;

@end

