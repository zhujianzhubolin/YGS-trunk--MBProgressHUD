//
//  BaseViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "AppDelegate.h"
#import "NetworkRequest.h"  

@interface O2OBaseViewController ()

@end

@implementation O2OBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    self.view.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidDisappear:(BOOL)animated {
    self.viewIsVisible = NO;
    [NetworkRequest cancelAllOperations];
}

- (void)viewWillAppear:(BOOL)animated {
    self.viewIsVisible = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviewsForTableView:(UITableView *)tableview
{
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

//显示TableBar
- (void)showTabbar{
    __block CGRect tempRect = self.tabBarController.tabBar.frame;
    
    if (tempRect.origin.y != IPHONE_HEIGHT - self.tabBarController.tabBar.frame.size.height) {
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             tempRect.origin.y = IPHONE_HEIGHT - self.tabBarController.tabBar.frame.size.height;
                             self.tabBarController.tabBar.frame = tempRect;
                         }];
    }
}

//隐藏Tabbar
- (void)hidetabbar{
    __block CGRect tempRect = self.tabBarController.tabBar.frame;
    
    if (tempRect.origin.y != IPHONE_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tempRect = self.tabBarController.tabBar.frame;
            tempRect.origin.y = IPHONE_HEIGHT;
            self.tabBarController.tabBar.frame = tempRect;
        } completion:^(BOOL finished) {
            self.tabBarController.tabBar.hidden = YES;
        }];
    }
}

@end
