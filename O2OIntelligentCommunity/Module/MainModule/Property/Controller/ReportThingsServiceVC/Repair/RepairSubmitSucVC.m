//
//  RepairSubmitSucVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RepairSubmitSucVC.h"
#import "MineViewController.h"
#import "RepairsViewController.h"
#import "UITextField+wrapper.h"
#import "ReportThingsServiceTBVC.h"

@interface RepairSubmitSucVC ()

@end

@implementation RepairSubmitSucVC
{
    __weak IBOutlet UILabel *submitSucLabel;
    __weak IBOutlet UILabel *orderDescLabel;
    __weak IBOutlet UILabel *orderNumLabel;
    __weak IBOutlet UILabel *repairInfoLabel;
    __weak IBOutlet UIButton *queryBtn;
    __weak IBOutlet UIImageView *repairProImgView;
    __weak IBOutlet UILabel *firstDetailLabel;
    NSString *typeStr;
}

- (IBAction)mineVCClick:(id)sender {
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)mineDetailVCCLick:(id)sender {
    RepairsViewController *repairsVC = [RepairsViewController new];
    self.navigationItem.backBarButtonItem = [AppUtils navigationBackButtonWithNoTitle];
    [self.navigationController pushViewController:repairsVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
//    self.navigationItem.rightBarButtonItem.tintColor = [AppUtils colorWithHexString:@"b1b1b1"];
    // Do any additional setup after loading the view.
}

- (void)rightItemClick {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ReportThingsServiceTBVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initUI {
    if (_type == VCTypeComplain) {
        typeStr = @"投诉";
    }
    else {
        typeStr = @"报修";
    }
    
    self.title = [NSString stringWithFormat:@"%@确认",typeStr];
    submitSucLabel.text = [NSString stringWithFormat:@"%@提交成功!",typeStr];
    orderDescLabel.text = [NSString stringWithFormat:@"%@单号",typeStr];
    repairInfoLabel.text = [NSString stringWithFormat:@"您的%@已经提交成功, 处理进度及状态可在,",typeStr];
    [queryBtn setTitle:@"报事" forState:UIControlStateNormal];
    
    repairInfoLabel.adjustsFontSizeToFitWidth = YES;
    firstDetailLabel.adjustsFontSizeToFitWidth = YES;
    orderNumLabel.text = [NSString stringWithFormat:@"%@",self.orderNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
