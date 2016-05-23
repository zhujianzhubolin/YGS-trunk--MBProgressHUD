//
//  PaySucViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PaySucViewController.h"
#import "FeesPaidViewController.h"

@interface PaySucViewController ()

@end

@implementation PaySucViewController
{
    __weak IBOutlet UILabel *paySucLabel;
    __weak IBOutlet UILabel *payTimeL;
    __weak IBOutlet UILabel *payCountL;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"支付成功";
    paySucLabel.text = [NSString stringWithFormat:@"恭喜您, %@支付成功",self.payType];
    payTimeL.text = [AppUtils currentDate];
    payCountL.text = [NSString stringWithFormat:@"%@元",self.payCount];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 30);
    rightButton.layer.cornerRadius = 2;
    [rightButton addTarget:self action:@selector(complichClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[AppUtils colorWithHexString:@"fc6d22"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)complichClick {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FeesPaidViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    return;
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
