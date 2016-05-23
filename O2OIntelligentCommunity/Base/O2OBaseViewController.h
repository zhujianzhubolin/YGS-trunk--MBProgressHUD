//
//  BaseViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "SwitchVCAnimation.h"

@interface O2OBaseViewController : UIViewController
@property (nonatomic, assign) BOOL viewIsVisible;
- (void)showTabbar;

- (void)hidetabbar;

-(void)viewDidLayoutSubviewsForTableView:(UITableView *)tableview;

@end
