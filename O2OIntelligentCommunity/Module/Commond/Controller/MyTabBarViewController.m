//
//  MyTabBarViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "MainTBViewController.h"
#import "NeighbourViewController.h"
#import "MineviewController.h"
#import "UserManager.h"

@interface MyTabBarViewController () 

@end

@implementation MyTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
    UINavigationController *mainNVC = [mainStoryboard instantiateInitialViewController];
    
    NeighbourViewController * neighbourVC = [[NeighbourViewController alloc]init];
    UINavigationController * neighbourNVC = [[UINavigationController alloc]initWithRootViewController:neighbourVC];
    neighbourVC.title = @"邻里";
    
    MineViewController * mineVC = [[MineViewController alloc]init];
    UINavigationController * mineNVC = [[UINavigationController alloc]initWithRootViewController:mineVC];
    mineVC.title = @"我的";
    
    self.viewControllers = @[neighbourNVC,mainNVC,mineNVC];
    self.selectedIndex = 1;
    
    NSArray *titleArr = @[@"邻里",@"首页",@"我的"];
    NSArray *itemImgArr = @[@"neighB",@"mainDefailt",@"mine"];
    NSArray *selectedImgArr = @[@"neighB_selected",@"mainSelected",@"mine_selected"];
    for (int i = 0; i < 3; i++) {
        UITabBarItem* item = [self.tabBar.items objectAtIndex:i];
        item.selectedImage = [UIImage imageNamed:selectedImgArr[i]];
        item.image = [UIImage imageNamed:itemImgArr[i]];
        [item setTitle:titleArr[i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
