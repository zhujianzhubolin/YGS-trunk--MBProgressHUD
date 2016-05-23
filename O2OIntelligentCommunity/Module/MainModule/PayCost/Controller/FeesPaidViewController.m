    //
//  FeesPaidViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/9.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define ISBINDING_ALERT_TAG 10
#define ISAUTHON_ALERT_TAG 11

#ifdef SmartComJYZX
    typedef NS_ENUM(NSUInteger,PayCostType) {
        PayCostTypeProperty = 0,
//        PayCostTypePark,
        PayCostTypeWater,
        PayCostTypeElec,
        PayCostTypeCoal,
        PayCostTypePhone,
        PayCostTypeTraffic
    };
#elif SmartComYGS
    typedef NS_ENUM(NSUInteger,PayCostType) {
        PayCostTypeWater = 0,
        PayCostTypeElec,
        PayCostTypeCoal,
        PayCostTypeProperty,
        PayCostTypePark,
        PayCostTypePhone,
        PayCostTypeTraffic
    };
#else

#endif

#import "FeesPaidViewController.h"
#import "WECViewController.h"
#import "ChangePostionButton.h"
#import "PropertyViewController.h"  
#import "ParkingViewController.h"
#import "UserManager.h"
#import "HousingViewController.h"
#import "NSString+wrapper.h"
#import "PhoneChargeViewController.h"
#import "TrafficFinexViewController.h"  
#import "PropertyBillVC.h"

@interface FeesPaidViewController () <UIAlertViewDelegate>

@end

@implementation FeesPaidViewController
{
    IBOutlet UITableView *chargeTableView;
    
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

- (void)viewDidLayoutSubviewsForTableView:(UITableView *)tableview {
    [super viewDidLayoutSubviewsForTableView:tableview];
}

- (void)initData {
#ifdef SmartComJYZX
    titleArr = [NSArray arrayWithObjects:@"物业费查询",@"水费",@"电费",@"燃气费",@"话费充值",@"交通罚款",nil];
    imgArr = [NSArray arrayWithObjects:@"mainPropertyCost",@"mainWaterCost",@"mainElecCost",@"mainCoalCost",@"mainPhoneCost",@"mainTrafficCost",nil];
    subTitleArr = [NSArray arrayWithObjects:@"支持合作小区下物业费缴费查询",@"支持合作小区停车费缴纳",@"支持全国大部分城市水费缴纳",@"支持全国大部分城市电费缴纳",@"支持全国大部分城市燃气费缴纳",@"支持移动、电信、联通手机话费充值",@"支持全国大部分省市违章代缴", nil];
#elif SmartComYGS
    titleArr = [NSArray arrayWithObjects:@"水费",@"电费",@"燃气费",@"物业费",@"停车费",@"话费充值",@"交通罚款",nil];
    imgArr = [NSArray arrayWithObjects:@"mainWaterCost",@"mainElecCost",@"mainCoalCost",@"mainPropertyCost",@"mainParkCost",@"mainPhoneCost",@"mainTrafficCost",nil];
    subTitleArr = [NSArray arrayWithObjects:@"支持全国大部分城市水费缴纳",@"支持全国大部分城市电费缴纳",@"支持全国大部分城市燃气费缴纳",@"支持合作小区下物业费缴费",@"支持合作小区停车费缴纳",@"支持移动、电信、联通手机话费充值",@"支持全国大部分省市违章代缴", nil];
#else
    
#endif
}

- (void)initUI {
    self.title= @"费用查缴";
    chargeTableView.tableFooterView = [AppUtils tableViewsFooterView];
    chargeTableView.delegate = self;
    chargeTableView.dataSource = self;
    [self viewDidLayoutSubviewsForTableView:chargeTableView];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.section]];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.text = titleArr[indexPath.section];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",subTitleArr[indexPath.section]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= titleArr.count) {
        return;
    }
    
#ifdef SmartComJYZX
    if (indexPath.section == PayCostTypeWater ||
        indexPath.section == PayCostTypeElec ||
        indexPath.section == PayCostTypeCoal ||
        indexPath.section == PayCostTypeProperty) {
            //|| indexPath.section == PayCostTypePark) {
        if ([[UserManager shareManager] showCommunityAlertIsBindingFromNav:self.navigationController]) {
            return;
        }
    }
#elif SmartComYGS //标准版无论用户是否绑定都可以缴水电煤
    if (indexPath.section == PayCostTypeProperty ||
        indexPath.section == PayCostTypePark) {
        if ([[UserManager shareManager] showCommunityAlertIsBindingFromNav:self.navigationController]) {
            return;
        }
    }
#else
    
#endif
    
    if (indexPath.section == PayCostTypeWater) {
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        WECViewController *wecVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"WECViewControllerID"];
        
        wecVC.chargeType = ChargeTypeWater;
        [self.navigationController pushViewController:wecVC animated:YES];
    }
    else if (indexPath.section == PayCostTypeElec) {
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        WECViewController *wecVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"WECViewControllerID"];
        wecVC.chargeType = ChargeTypeElec;
        [self.navigationController pushViewController:wecVC animated:YES];
    }
    else if (indexPath.section == PayCostTypeCoal) {
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        WECViewController *wecVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"WECViewControllerID"];
        
        wecVC.chargeType = ChargeTypeCoal;
        [self.navigationController pushViewController:wecVC animated:YES];
    }
        
    else if (indexPath.section == PayCostTypeProperty) {
        if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.propertyConst] || ![[UserManager shareManager].comModel.propertyConst isEqualToString:@"Y"]) {
            [AppUtils showAlertMessage:W_ALL_NO_SERVER];
            return;
        }
        
#ifdef SmartComJYZX
        PropertyBillVC *billVC = [PropertyBillVC new];
        [self.navigationController pushViewController:billVC animated:YES];
#elif SmartComYGS
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        PropertyViewController *propertyVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"PropertyViewControllerID"];
        [self.navigationController pushViewController:propertyVC animated:YES];
#else
        
#endif
    }
    
#ifdef SmartComJYZX

#elif SmartComYGS
    else if (indexPath.section == PayCostTypePark) {
        if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.parkingFees] || ![[UserManager shareManager].comModel.parkingFees isEqualToString:@"Y"]) {
            [AppUtils showAlertMessage:W_ALL_NO_SERVER];
            return;
        }
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        ParkingViewController *parkingVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"ParkingViewControllerID"];
        [self.navigationController pushViewController:parkingVC animated:YES];
    }
#else
    
#endif

    else if (indexPath.section == PayCostTypePhone) {
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        PhoneChargeViewController *phoneVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"PhoneChargeViewControllerID"];
        [self.navigationController pushViewController:phoneVC animated:YES];
    }
    else if (indexPath.section == PayCostTypeTraffic) {
        UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        TrafficFinexViewController *trafficVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"TrafficFinexViewControllerID"];
        [self.navigationController pushViewController:trafficVC animated:YES];
    }
}

@end
