//
//  RepairTableViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RepairTableViewController.h"
#import "ChangePostionButton.h"
#import "SubmitRepairCell.h"
#import "MultiShowing.h"    

@interface RepairTableViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation RepairTableViewController
{
    IBOutlet UITableView *infoTableView;
    MultiShowing *multishowing;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:infoTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppUtils dismissHUD];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    multishowing = [[MultiShowing alloc] init];
    if (self.type == VCTypeComplain) {
        self.title = @"投  诉";
    }
    else {
        self.title = @"报  修";
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick)];
    [self.tableView addGestureRecognizer:tap];
    
    // Initialization code
}

- (void)tableViewClick {
    [self.tableView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmitRepairCell *cell = (SubmitRepairCell *)[tableView dequeueReusableCellWithIdentifier:@"SubmitRepairCellID1"];
    cell.type = self.type;
    cell.getImgVC = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmitRepairCell *submitCell = (SubmitRepairCell *)cell;
    submitCell.type = self.type;
    submitCell.getImgVC = self;
}

@end
