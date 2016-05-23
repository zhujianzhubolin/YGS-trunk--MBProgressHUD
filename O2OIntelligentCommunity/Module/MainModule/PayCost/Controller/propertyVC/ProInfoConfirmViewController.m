//
//  ProInfoConfirmViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ProInfoConfirmViewController.h"
#import "UserManager.h"
#import "PropertyChargeE.h"
#import "CheckstandViewController.h"
#import "UserManager.h"

@interface ProInfoConfirmViewController () 

@end

@implementation ProInfoConfirmViewController
{
    IBOutlet UITableView *infoTableView;
     NSMutableArray *infoArr;
    UIView *charggeFooter;
    UILabel *moneyLabel;
    NSMutableArray *statusArr;
}

- (void)setChargeArr:(NSArray *)chargeArr {
    _chargeArr = chargeArr;
    
    statusArr = [NSMutableArray array];
    
    [_chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [statusArr addObject:[NSNumber numberWithBool:NO]];
    }];
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:infoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
    [[UIApplication sharedApplication].keyWindow addSubview:charggeFooter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [charggeFooter removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    infoArr = [NSMutableArray arrayWithArray:@[@"",@"垃圾处理费: ",@"本体费: ",@"排污费: ",@"管理费: ",@"水: ",@"电: ",@"燃: ",@"滞纳金"]];
//    self.chargeArr = [NSArray array];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    self.title = @"信息确认";
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.frame.size.width - 15 * 2, header.frame.size.height)];

    headerLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.xqAllName];
    [header addSubview:headerLabel];
    infoTableView.tableHeaderView = header;
    
    CGFloat footerHeight = 95;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableView.frame.size.width,footerHeight)];
    footer.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    infoTableView.tableFooterView = footer;
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, infoTableView.frame.size.width - 15 * 2, 20)];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self configuTotalCount];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(10, moneyLabel.frame.origin.y + moneyLabel.frame.size.height + 10, infoTableView.frame.size.width - 10 * 2, 45);
    [footerButton addTarget:self action:@selector(onlineHandleClick) forControlEvents:UIControlEventTouchUpInside];
    footerButton.layer.cornerRadius = 3;
    footerButton.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    [footerButton setTitle:@"确    认" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    charggeFooter = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - footer.frame.size.height, infoTableView.frame.size.width, footer.frame.size.height)];
    charggeFooter.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    
    [charggeFooter addSubview:moneyLabel];
    [charggeFooter addSubview:footerButton];
}

- (void)onlineHandleClick {
    
    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    CheckstandViewController *checkstandVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"CheckstandViewControllerID"];
    checkstandVC.chargeType = ChargeTypeProperty;
    
    __block CGFloat totalCharge = 0;
    __block NSMutableArray *idsArr = [NSMutableArray array];
    [statusArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSNumber *)obj boolValue]) {
            return;
        }
        PropertyChargeE *propertyE = self.chargeArr[idx];
        totalCharge += propertyE.saleAmount.floatValue;
        [idsArr addObject:propertyE];
    }];
    
    if (totalCharge <= 0) {
        [AppUtils showAlertMessageTimerClose:@"暂无缴费记录"];
        return;
    }
    
    checkstandVC.payCount = [NSString stringWithFormat:@"%.2f",totalCharge];
    checkstandVC.idsArr = [idsArr copy];
    checkstandVC.community = self.xqAllName;
    
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configuTotalCount {
    __block CGFloat totalCharge = 0;
    [statusArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSNumber *)obj boolValue]) {
            return;
        }
        PropertyChargeE *propertyE = self.chargeArr[idx];
        totalCharge += propertyE.saleAmount.floatValue;
    }];
    moneyLabel.text = [NSString stringWithFormat:@"合计: %.2f元",totalCharge];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:moneyLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(4,str.length - 4)];
    moneyLabel.attributedText = str;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chargeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PropertyChargeE *propertyE = self.chargeArr[indexPath.section];
    switch (indexPath.row) {
        case 1: {
            if (propertyE.domesticWasteFee.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 2: {
            if (propertyE.ontologyGold.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 3: {
            if (propertyE.dischargeFee.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 4: {
            if (propertyE.managementFee.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 5: {
            if (propertyE.water.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 6: {
            if (propertyE.electricity.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 7: {
            if (propertyE.coal.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 8: {
            if (propertyE.overdueFine.floatValue <= 0) {
                return 0;
            }
        }
        default:
            return 44;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.textLabel sizeThatFits:CGSizeMake(cell.frame.size.width - 50 - cell.accessoryView.frame.size.width, cell.frame.size.height)];
    cell.textLabel.minimumScaleFactor = 12;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    accessoryLabel.textAlignment = NSTextAlignmentRight;
    
    cell.accessoryView = accessoryLabel;
    PropertyChargeE *propertyE = self.chargeArr[indexPath.section];
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"gou_h"];
        cell.imageView.highlightedImage = [UIImage imageNamed:@"gou"];
        cell.imageView.tag = indexPath.section + 10;
        cell.imageView.highlighted = [statusArr[indexPath.section] boolValue];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellImgClick:)];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:tap];
        
        if (propertyE.endDate.length > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[propertyE.endDate substringToIndex:10]];
        }
        
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        accessoryLabel.textColor = [AppUtils colorWithHexString:@"fc6d22"];
        accessoryLabel.text = [NSString stringWithFormat:@"%@元",propertyE.saleAmount];
        return;
    }
    
    cell.imageView.image = nil;
    cell.backgroundColor = [UIColor whiteColor];
    accessoryLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = infoArr[indexPath.row];
    
    switch (indexPath.row) {
        case 1: {
            if (propertyE.domesticWasteFee.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.domesticWasteFee.floatValue];
        }
            break;
        case 2: {
            if (propertyE.ontologyGold.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.ontologyGold.floatValue];
        }
            break;
        case 3: {
            if (propertyE.dischargeFee.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.dischargeFee.floatValue];
        }
            break;
        case 4: {
            if (propertyE.managementFee.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.managementFee.floatValue];
        }
            break;
        case 5: {
            if (propertyE.water.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.water.floatValue];
        }
            break;
        case 6: {
            if (propertyE.electricity.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.electricity.floatValue];
        }
            break;
        case 7: {
            if (propertyE.coal.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.coal.floatValue];
        }
            break;
        case 8: {
            if (propertyE.overdueFine.floatValue <= 0) {
                cell.hidden = YES;
                break;
            }
            accessoryLabel.text = [NSString stringWithFormat:@"%.2f元",propertyE.overdueFine.floatValue];
        }
            break;
        default:
            break;
    }
}

- (void)cellImgClick:(UITapGestureRecognizer *)tap {
    UITableViewCell *cell = (UITableViewCell *)tap.view;
    cell.imageView.highlighted = !cell.imageView.highlighted;
    
    [statusArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (cell.imageView.tag - 10 == idx) {
            [statusArr replaceObjectAtIndex:idx withObject:[NSNumber numberWithBool:cell.imageView.highlighted]];
        }
    }];
    [self configuTotalCount];
}

@end
