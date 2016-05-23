//
//  ReportThingsServiceTBVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



typedef NS_ENUM(NSUInteger, CellSection) {
    CellSectionRepair,
    CellSectionComplaint,
    CellSectionAdvise,
    CellSectionPushToTalk
};

#import "ReportThingsServiceTBVC.h"
#import "UserManager.h"
#import "NSString+wrapper.h"
#import "RepairTableViewController.h"
#import "AdviceAndSuggestTBVC.h"
#import "HousingViewController.h"

@interface ReportThingsServiceTBVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ReportThingsServiceTBVC
{
    NSArray *titleArr;
    NSArray *imgArr;
    NSArray *subTitleArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    self.title = @"报事服务";
    
    subTitleArr = [NSArray arrayWithObjects:@"公共、家庭设施在线报修，专业人员为您排忧解难",@"对环境、卫生等问题进行投诉，专人受理专项解决",@"共建和谐家园，欢迎您的宝贵建议",@"物业服务热线，随时为您服务", nil];
    imgArr = [NSArray arrayWithObjects:@"needRepair",@"needComplaint", @"adviceAndSuggestions",@"pushToTalk",nil];
    
#ifdef SmartComJYZX
    titleArr = [NSArray arrayWithObjects:@"要报修",@"要投诉",@"意见与建议",@"一键通", nil];
#elif SmartComYGS
    titleArr = [NSArray arrayWithObjects:@"要报修",@"要投诉",@"意见与建议", nil];
#else
    
#endif
}

- (void)initUI {
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    UIImageView *headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.width / 3)];
    headerImgV.image = [UIImage imageNamed:@"reportThing.jpg"];
    self.tableView.tableHeaderView = headerImgV;
    self.tableView.tableFooterView = [AppUtils tableViewsFooterView];
    self.view.backgroundColor = [AppUtils colorWithHexString:@"EFEFF4"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SYSTEM_CELL_ID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = titleArr[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.section]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",subTitleArr[indexPath.section]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#ifdef SmartComJYZX
    if (indexPath.section == CellSectionPushToTalk) {
        [AppUtils callPhone:[UserManager shareManager].userModel.telphone];
        return;
    }
#elif SmartComYGS
    
#else
    
#endif
    
    if ([[UserManager shareManager] showCommunityAlertIsBindingFromNav:self.navigationController]) {
        return;
    }
    
    switch (indexPath.section) {
        case CellSectionRepair: {
            if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.repair] || ![[UserManager shareManager].comModel.repair isEqualToString:@"Y"]) {
                [AppUtils showAlertMessage:W_ALL_NO_SERVER];
                return;
            }
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
            RepairTableViewController *repairVC = (RepairTableViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"RepairTableViewControllerID"];
            repairVC.type = VCTypeRepair;
            [self.navigationController pushViewController:repairVC animated:YES];
        }
            break;
        case CellSectionComplaint: {
            if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.complaints] || ![[UserManager shareManager].comModel.complaints isEqualToString:@"Y"]) {
                [AppUtils showAlertMessage:W_ALL_NO_SERVER];
                return;
            }
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainTBViewController" bundle:nil];
            RepairTableViewController *complaintVC = (RepairTableViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"RepairTableViewControllerID"];
            complaintVC.type = VCTypeComplain;
            [self.navigationController pushViewController:complaintVC animated:YES];
        }
            break;
        case CellSectionAdvise: {
            if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.opinion] || ![[UserManager shareManager].comModel.opinion isEqualToString:@"Y"]) {
                [AppUtils showAlertMessage:W_ALL_NO_SERVER];
                return;
            }
            
            AdviceAndSuggestTBVC *adviceVC = [AdviceAndSuggestTBVC new];
            [self.navigationController pushViewController:adviceVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
