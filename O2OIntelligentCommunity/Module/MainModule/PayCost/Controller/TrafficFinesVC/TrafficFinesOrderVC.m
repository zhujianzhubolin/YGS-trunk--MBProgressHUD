//
//  FinesOnlineViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TrafficFinesOrderVC.h"
#import "TrafficOrderE.h"
#import "CheckstandViewController.h"
#import "NSString+wrapper.h"
#import "UserManager.h"

@interface TrafficFinesOrderVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation TrafficFinesOrderVC
{
    IBOutlet UITableView *onlineTableView;
    NSArray *descripArr;
    NSMutableArray *statusArr;
    UIView *footerV;
}

- (void)setTrafficArr:(NSArray *)trafficArr {
    _trafficArr = trafficArr;
    
    statusArr = [NSMutableArray array];
    [_trafficArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [statusArr addObject:[NSNumber numberWithBool:NO]];
    }];
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:onlineTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
    [[UIApplication sharedApplication].keyWindow addSubview:footerV];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [footerV removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (void)initData {
    descripArr = @[@"通知书编号: ",@"地  点: ",@"原  因: ",@"处罚措施: "];
}

- (void)initUI {
    self.title = @"提交订单";
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, onlineTableView.frame.size.width - 10, 40)];
    moneyLabel.tag = 10;
    moneyLabel.text = @"应付金额: 0.00元(手续费0.00元)";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:moneyLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(6,str.length - 6)];
    moneyLabel.attributedText = str;
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(G_INTERVAL_BIG, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + 10, onlineTableView.frame.size.width - G_INTERVAL_BIG * 2, 45);
    [footerButton addTarget:self action:@selector(onlineHandleClick) forControlEvents:UIControlEventTouchUpInside];
    footerButton.layer.cornerRadius = 3;
    footerButton.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    [footerButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    footerV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (footerButton.frame.origin.y + footerButton.frame.size.height + 10), onlineTableView.frame.size.width, footerButton.frame.origin.y + footerButton.frame.size.height + 10)];
    footerV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    
    [footerV addSubview:moneyLabel];
    [footerV addSubview:footerButton];
    
    UIView *footer = [[UIView alloc] initWithFrame:footerV.frame];
    onlineTableView.tableFooterView = footer;
    [self configurateTotalCount];
}

- (void)onlineHandleClick {
    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    CheckstandViewController *checkstandVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"CheckstandViewControllerID"];
    checkstandVC.chargeType = ChargeTypeTraffic;
    
    __block CGFloat totalCharge = 0;
    __block CGFloat totalShouxu = 0;
    __block NSMutableArray *idsArr = [NSMutableArray array];
    [self.trafficArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([statusArr[idx] boolValue]) {
            TrafficOrderE *trafficE = (TrafficOrderE *)obj;
            trafficE.carcode = self.carcode;
            trafficE.cardrivenumber = self.cardrivenumber;
            trafficE.carnumber = self.carnumber;
            
            totalCharge += trafficE.count.floatValue;
            totalShouxu += trafficE.poundage.floatValue;
            [idsArr addObject:trafficE];
        }
    }];
    
    if (totalCharge + totalShouxu <= 0) {
        [AppUtils showAlertMessage:@"暂无缴费信息"];
        return;
    }
    
    checkstandVC.payCount = [NSString stringWithFormat:@"%.2f",totalCharge + totalShouxu];
    checkstandVC.idsArr = [idsArr copy];
    checkstandVC.licenseNumber = self.carnumber;
    
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void)configurateTotalCount {
    __block CGFloat totalCharge = 0;
    __block CGFloat totalShouxu = 0;
    [self.trafficArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([statusArr[idx] boolValue]) {
            TrafficOrderE *trafficE = (TrafficOrderE *)obj;
            totalCharge += trafficE.count.floatValue;
            totalShouxu += trafficE.poundage.floatValue;
        }
    }];
    UILabel *moneyL = (UILabel *)[footerV viewWithTag:10];
    moneyL.text = [NSString stringWithFormat:@"应付金额: %.2f元(手续费%.2f元)",totalCharge + totalShouxu,totalShouxu];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:moneyL.text];
    [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(6,str.length - 6)];
    dispatch_async(dispatch_get_main_queue(), ^{
        moneyL.attributedText = str;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50;
    if (indexPath.row == 3) {

        TrafficOrderE *trafficE = self.trafficArr[indexPath.section];
        NSString *reasonText = [NSString stringWithFormat:@"%@%@",descripArr[indexPath.row - 1],trafficE.reason];
        CGSize reasonSize = [AppUtils sizeWithString:reasonText
                                                font:[UIFont systemFontOfSize:FONT_SIZE]
                                                size:CGSizeMake(IPHONE_WIDTH - G_INTERVAL_BIG *2, MAXFLOAT)];
        DNSLogSize(reasonSize);
        return MAX(reasonSize.height + G_INTERVAL *2, height);
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.trafficArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    TrafficOrderE *trafficE = self.trafficArr[section];
    if (!(![NSString isEmptyOrNull:trafficE.canProcess] && [trafficE.canProcess isEqualToString:@"1"])) {
        return 30; 
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TrafficOrderE *trafficE = self.trafficArr[section];
    if (!(![NSString isEmptyOrNull:trafficE.canProcess] && [trafficE.canProcess isEqualToString:@"1"])) {
        UILabel *footerL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        footerL.backgroundColor = [UIColor redColor];
        footerL.textColor = [UIColor whiteColor];
        footerL.adjustsFontSizeToFitWidth = YES;
        footerL.textAlignment = NSTextAlignmentCenter;
        footerL.text = @"代缴代扣功能马上开通,敬请期待!";
        return footerL;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return descripArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    cell.backgroundColor = [UIColor whiteColor];
    TrafficOrderE *trafficE = self.trafficArr[indexPath.section];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"gou"];
        cell.imageView.highlightedImage = [UIImage imageNamed:@"gou_h"];
        cell.imageView.tag = indexPath.section + 10;
        cell.imageView.highlighted = [statusArr[indexPath.section] boolValue];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellImgClick:)];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:tap];
        
        cell.textLabel.text = [NSString stringWithFormat:@"违章时间: %@",trafficE.time];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",descripArr[indexPath.row - 1]];
        if (![NSString isEmptyOrNull:trafficE.Archive]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",cell.textLabel.text,trafficE.Archive];
        }
    }
    else if (indexPath.row == 2) {
        NSString *locationStr = descripArr[indexPath.row - 1];
        
        if (![NSString isEmptyOrNull:trafficE.LocationName]) {
            locationStr = [NSString stringWithFormat:@"%@%@",locationStr,trafficE.LocationName];
        }
        
        if (![NSString isEmptyOrNull:trafficE.location]) {
            locationStr = [NSString stringWithFormat:@"%@－%@",locationStr,trafficE.location];
        }
        
        cell.textLabel.text = locationStr;
    }
    else if (indexPath.row == 3) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",descripArr[indexPath.row - 1],trafficE.reason];
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@罚款%.2f元, 扣%@分",descripArr[indexPath.row - 1],trafficE.count.floatValue,trafficE.Degree];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(6,str.length - 6)];
        cell.textLabel.attributedText = str;
    }
}

- (void)cellImgClick:(UITapGestureRecognizer *)tap {
    UITableViewCell *cell = (UITableViewCell *)tap.view;
    [self.trafficArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (cell.imageView.tag - 10 == idx) {
            TrafficOrderE *trafficE = (TrafficOrderE *)obj;
            if (!(![NSString isEmptyOrNull:trafficE.canProcess] && [trafficE.canProcess isEqualToString:@"1"])) {
                *stop = YES;
                return;
            }
            
            [statusArr replaceObjectAtIndex:idx withObject:[NSNumber numberWithBool:!cell.imageView.highlighted]];
            cell.imageView.highlighted = !cell.imageView.highlighted;
            *stop = YES;
        }
    }];
    [self configurateTotalCount];
}

@end
