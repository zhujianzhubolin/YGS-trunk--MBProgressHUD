//
//  WECPayConfirmViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "WECPayConfirmTBVC.h"
#import "CheckstandViewController.h"
#import "UserManager.h" 
#import "NSString+wrapper.h"

@interface WECPayConfirmTBVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation WECPayConfirmTBVC
{
    NSArray *descripArr;
    NSMutableArray *dataArr;
    IBOutlet UITableView *infoTableView;
}
//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:infoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initData {
    self.title = @"信息确认";
    descripArr = @[@"缴费内容: ",@"所在小区: ",@"收费单位: ",@"姓       名: ",@"用户编号: ",@"缴费金额: ",@"备        注: "];
    dataArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@""]];
    
    NSString *title = [LocalUtils titleForChargeType:self.chargeType];
    if (![NSString isEmptyOrNull:title]) {
        [dataArr replaceObjectAtIndex:0 withObject:title];
    }

    if (![NSString isEmptyOrNull:self.chargeE.xqAddress]) {
        [dataArr replaceObjectAtIndex:1 withObject:self.chargeE.xqAddress];
    }
    
    if (![NSString isEmptyOrNull:self.chargeE.BizIncrSdmTestname]) {
        [dataArr replaceObjectAtIndex:2 withObject:self.chargeE.BizIncrSdmTestname];
    }
    
    if (![NSString isEmptyOrNull:self.chargeE.sdmName]) {
        [dataArr replaceObjectAtIndex:3 withObject:self.chargeE.sdmName];
    }
    
    if (![NSString isEmptyOrNull:self.chargeE.consNo]) {
        [dataArr replaceObjectAtIndex:4 withObject:self.userNum];
    }
    
    if (![NSString isEmptyOrNull:self.chargeE.sdmMoney]) {
        [dataArr replaceObjectAtIndex:5 withObject:self.chargeE.sdmMoney];
    }
    
    if (![NSString isEmptyOrNull:self.chargeE.sdmRemarks]) {
        [dataArr replaceObjectAtIndex:6 withObject:self.chargeE.sdmRemarks];
    }
}

- (void)initUI {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableView.frame.size.width, 70)];
    footer.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(10, 10, footer.frame.size.width - 10 * 2, 45);
    [footerButton addTarget:self action:@selector(onlineHandleClick) forControlEvents:UIControlEventTouchUpInside];
    footerButton.layer.cornerRadius = 3;
    footerButton.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    [footerButton setTitle:@"确    认" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [footer addSubview:footerButton];
    infoTableView.tableFooterView = footer;
}

- (void)onlineHandleClick {
    if (dataArr.count <= 5) {
        [AppUtils showAlertMessage:@"未获取到足够的缴费信息"];
        return;
    }
    
    if ([NSString isEmptyOrNull:dataArr[4]]) {
        [AppUtils showAlertMessage:@"用户编号不能为空"];
        return;
    }
    
    if ([NSString isEmptyOrNull:dataArr[5]]) {
        [AppUtils showAlertMessage:@"缴费金额未知"];
        return;
    }
    
    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    CheckstandViewController *checkstandVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"CheckstandViewControllerID"];
    checkstandVC.chargeType     = self.chargeType;
    checkstandVC.community      = self.chargeE.xqAddress;
    checkstandVC.payCount       = self.chargeE.sdmMoney;
    checkstandVC.userNum        = self.userNum;
    
    checkstandVC.wecE           = self.chargeE;
    checkstandVC.xqNo           = self.xqNo;
    checkstandVC.wyNo           = self.wyNo;
    checkstandVC.cityNo         = self.cityNo;
    checkstandVC.buildingNo     = self.buildingNo;
    checkstandVC.houseNo        = self.houseNo;
    
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return descripArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 5) {
        NSString *detailStr;
        if ([NSString isEmptyOrNull:dataArr[indexPath.row]]) {
            detailStr = [NSString stringWithFormat:@"%@0元",descripArr[indexPath.row]];
        }
        else {
            detailStr = [NSString stringWithFormat:@"%@%@元",descripArr[indexPath.row],dataArr[indexPath.row]];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:detailStr];
        [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(6,str.length - 6)];
        cell.textLabel.attributedText = str;
    }
    else {
        NSString *detailStr = [NSString stringWithFormat:@"%@%@",descripArr[indexPath.row],dataArr[indexPath.row]];
        cell.textLabel.text = detailStr;
    }
    
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
