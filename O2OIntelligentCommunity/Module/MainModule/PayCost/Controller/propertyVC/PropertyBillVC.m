//
//  PropertyBillVC.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/5/10.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef NS_ENUM(NSInteger,LabelTag) {
    LabelTagCellText,
    LabelTagCellCount
};

#import "PropertyBillVC.h"
#import "PropertyShowM.h"
#import <UIView+SDAutoLayout.h>
#import "ChangePostionButton.h"
#import "UserManager.h"
#import "CommunityViewCotroller.h"
#import "ChargeOrderE.h"
#import <MJExtension.h>
#import "PropertyChargeH.h"
#import "ZJWebProgrssView.h"

@interface PropertyBillVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *xqTb;
@property (nonatomic,strong) ZJWebProgrssView *progressV;

@end

@implementation PropertyBillVC {
    BingingXQModel *_currentXQM;
    PropertyShowM *_showM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetupData];
    self.title = @"物业费";
    self.view.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    [self xqTb];
    
    [self.progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestForXqPropertyBillInfo];
    });
    // Do any additional setup after loading the view.
}

- (void)viewSetupData {
    _currentXQM = [UserManager shareManager].comModel;
    _showM = [PropertyShowM new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)xqShengShiQu {
    NSMutableString *shengShiQu  = [NSMutableString new];
    if (![NSString isEmptyOrNull:_currentXQM.cityName]) {
        [shengShiQu appendString:_currentXQM.cityName];
    }
    
    if (![NSString isEmptyOrNull:_currentXQM.areaname]) {
        [shengShiQu appendString:_currentXQM.areaname];
    }

    return [shengShiQu copy];
}

- (void)setupProgressFrame {
    CGRect progressRect = self.progressV.frame;
    progressRect.origin.y = [self.xqTb rectForSection:0].size.height;
    progressRect.size.height = self.xqTb.frame.size.height - progressRect.origin.y - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.progressV.frame = progressRect;
}

#pragma mark - Lazy loading
- (UITableView *)xqTb {
    if (_xqTb == nil) {
        _xqTb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_xqTb registerClass:[UITableViewCell class] forCellReuseIdentifier:SYSTEM_CELL_ID];
        _xqTb.separatorColor = [AppUtils colorWithHexString:COLOR_MAIN];
        _xqTb.delegate = self;
        _xqTb.dataSource = self;
        self.view = _xqTb;
    }
    return _xqTb;
}

- (ZJWebProgrssView *)progressV {
    if (!_progressV) {
        _progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, [self.xqTb rectForSection:0].size.height, self.xqTb.frame.size.width, self.xqTb.frame.size.height - [self.xqTb rectForSection:0].size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        typeof(self) __weak weakSelf = self;
        _progressV.loadBlock = ^(){
            [weakSelf requestForXqPropertyBillInfo];
        };
        [self.xqTb addSubview:_progressV];
    }
    return _progressV;
}

#pragma mark - Request
- (void)requestForXqPropertyBillInfo {
    ChargeOrderE *orderE = [ChargeOrderE new];
    
    orderE.wyNo = _currentXQM.wyId;
    orderE.xqNo = _currentXQM.xqNo;
    orderE.cityNo = _currentXQM.cityid;
    orderE.buildNo = _currentXQM.floorNumber;
    if (![NSString isEmptyOrNull:_currentXQM.unitNumber]) {
        orderE.unitNo = _currentXQM.unitNumber;
    }
    orderE.houseNo = _currentXQM.roomNumber;
    orderE.memberInfoPid = _currentXQM.merberId;
    orderE.orderSource = @"APP";

    NSDictionary *paraDic = orderE.mj_keyValues;
     NSLog(@"paraDic = %@",paraDic);
    PropertyChargeH *chargeH = [PropertyChargeH new];
    [chargeH requestForPropertyCostsOrdersWithPara:paraDic success:^(id obj) {
        _showM = obj;
        if (_showM.chargeArr.count > 0) {
            PropertyChargeE *chargeE = _showM.chargeArr[0];
            chargeE.isShow = YES;
        }
        [self.xqTb reloadData];
        [self setupProgressFrame];
        [self.progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:_showM.chargeArr]];
    } failed:^(id obj) {
        _showM = [PropertyShowM new];
        [self.xqTb reloadData];
        [self setupProgressFrame];
        [self.progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:_showM.chargeArr]];
    }];
}

#pragma mark - Event
- (void)clickTapForheader:(UITapGestureRecognizer *)tap {
    UIView *headerV = tap.view;
    NSInteger section = headerV.tag;

    PropertyChargeE *chargeM = _showM.chargeArr[section - 1];
    chargeM.isShow = !chargeM.isShow;
    [self.xqTb reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)clickBtnForChangeCom {
    CommunityViewCotroller *communityVC = [CommunityViewCotroller new];
    communityVC.comLimits = ComLimitsClassifyProperty;
    communityVC.communityType = CommunityChooseTypeBinding;
    communityVC.comBlock = ^(BingingXQModel *comModel) {
        _currentXQM = comModel;
        [self.xqTb reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.progressV startAnimation];
        [self requestForXqPropertyBillInfo];
    };
    [self.navigationController pushViewController:communityVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }
    
    PropertyChargeE *propertyE = _showM.chargeArr[indexPath.section - 1];
    switch (indexPath.row) {
        case 0: {
            if (propertyE.domesticWasteFee.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 1: {
            if (propertyE.ontologyGold.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 2: {
            if (propertyE.dischargeFee.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 3: {
            if (propertyE.managementFee.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 4: {
            if (propertyE.water.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 5: {
            if (propertyE.electricity.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 6: {
            if (propertyE.coal.floatValue <= 0) {
                return 0;
            }
        }
            break;
        case 7: {
            if (propertyE.overdueFine.floatValue <= 0) {
                return 0;
            }
        }
        default:
            return 30;
    }
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _showM.chargeArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    PropertyChargeE *chargeE = _showM.chargeArr[section - 1];
    if (chargeE.isShow) {
        return 8;
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        header.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        CGFloat height = 44;
        UILabel *xqL = [[UILabel alloc] initWithFrame:CGRectMake(G_INTERVAL_BIG, (header.frame.size.height - height )/2, 100, height)];
        xqL.text = @"小区信息";
        [header addSubview:xqL];
        
        ChangePostionButton *xqBtn = [ChangePostionButton buttonWithType:UIButtonTypeCustom];
        CGFloat xqBtnWidth = 130;
        xqBtn.frame = CGRectMake(header.frame.size.width - G_INTERVAL_BIG - xqBtnWidth, xqL.frame.origin.y, xqBtnWidth, xqL.frame.size.height);
        [xqBtn addTarget:self action:@selector(clickBtnForChangeCom) forControlEvents:UIControlEventTouchUpInside];
        [xqBtn setImage:[UIImage imageNamed:@"changeCom"] forState:UIControlStateNormal];
        [xqBtn setTitle:@"更改小区" forState:UIControlStateNormal];
        [xqBtn setTitleColor:[AppUtils colorWithHexString:@"1cabdb"] forState:UIControlStateNormal];
        xqBtn.titleLabel.font = [UIFont boldSystemFontOfSize:xqBtn.titleLabel.font.pointSize];
        xqBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [xqBtn setInternalPositionType:ButtonInternalLabelPositionRight spacing:5];
        [header addSubview:xqBtn];
        return header;
    }
    else {
        static NSString *headerID = @"headerID";
        UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
            header.contentView.backgroundColor = [UIColor whiteColor];
        }
        header.tag = section;
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapForheader:)];
        [header addGestureRecognizer:headerTap];
        
        PropertyChargeE *chargeE = _showM.chargeArr[section - 1];
        NSString *dateStr = [chargeE.endDate substringToIndex:10];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
        
        NSMutableString *date = [NSMutableString new];
        if (dateArr.count > 0) {
            [date appendFormat:@"%@年",dateArr[0]];
        }
        
        if (dateArr.count > 1) {
            [date appendFormat:@"%@月",dateArr[1]];
        }
        
        UILabel *dateL = [[UILabel alloc] init];
        dateL.text = date;
        
        UILabel *countL = [[UILabel alloc] init];
        countL.textAlignment = NSTextAlignmentRight;
        countL.text = [NSString stringWithFormat:@"%.2f元",chargeE.saleAmount.floatValue];
        countL.textColor = [UIColor orangeColor];
        
        UIImageView *indicatorImgV = [[UIImageView alloc] initWithImage:ImageNamed(@"downListLight")
                                                       highlightedImage:ImageNamed(@"upListLight")];
        indicatorImgV.highlighted = chargeE.isShow;
        
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        [header sd_addSubviews:@[dateL,countL,indicatorImgV,lineV]];
        
        dateL.sd_layout
        .leftSpaceToView(header,G_INTERVAL_BIG)
        .centerYEqualToView(header)
        .heightRatioToView(header,1.0)
        .widthIs(100);
//        
        indicatorImgV.sd_layout
        .centerYEqualToView(header)
        .rightSpaceToView(header,G_INTERVAL_BIG)
        .widthIs(15)
        .heightIs(10);
        
        countL.sd_layout
        .rightSpaceToView(indicatorImgV,G_INTERVAL_BIG)
        .leftSpaceToView(dateL,G_INTERVAL)
        .centerYEqualToView(header)
        .heightRatioToView(header,1.0);
        
        lineV.sd_layout
        .leftEqualToView(header)
        .rightEqualToView(header)
        .bottomEqualToView(header)
        .heightIs(1);
        
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (![NSArray isArrEmptyOrNull:_showM.chargeArr] && section == 0) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        footer.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        CGFloat height = 44;
        UILabel *xqL = [[UILabel alloc] initWithFrame:CGRectMake(G_INTERVAL_BIG, (footer.frame.size.height - height )/2, 100, height)];
        xqL.text = @"账单信息";
        [footer addSubview:xqL];
        return footer;
    }

    if (_showM.message.length > 0 && section == _showM.chargeArr.count) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
        footer.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        UILabel *infoL = [[UILabel alloc] init];
        infoL.textColor = [UIColor lightGrayColor];
        infoL.font = [UIFont systemFontOfSize:14];
        [footer addSubview:infoL];
        infoL.text = _showM.message;
        
        [footer sd_addSubviews:@[infoL]];
        infoL.sd_layout
        .leftSpaceToView(footer,G_INTERVAL_BIG)
        .rightSpaceToView(footer,G_INTERVAL_BIG)
        .topSpaceToView(footer,G_INTERVAL)
        .autoHeightRatio(0);
        
        [footer setupAutoHeightWithBottomView:infoL bottomMargin:G_INTERVAL];
        return footer;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (![NSArray isArrEmptyOrNull:_showM.chargeArr] && section == 0) {
        return 50;
    }
    
    if (_showM.message.length > 0 && section == _showM.chargeArr.count) {
        CGSize labelSize = [AppUtils sizeWithString:_showM.message
                                               font:[UIFont systemFontOfSize:14]
                                               size:CGSizeMake(tableView.frame.size.width - G_INTERVAL_BIG * 2, CGFLOAT_MAX)];
        return labelSize.height + G_INTERVAL *2;
    }
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"所在小区: %@",_currentXQM.xqName];
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"楼  栋  号: %@",_currentXQM.xqHouse];
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"地        区: %@",[self xqShengShiQu]];
        }
    }
    else {
        cell.textLabel.text = nil;
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        PropertyChargeE *propertyE = _showM.chargeArr[indexPath.section - 1];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.font = [UIFont systemFontOfSize:FONT_SIZE];
        titleL.textColor = [UIColor grayColor];
        titleL.textAlignment = NSTextAlignmentRight;
        
        UILabel *countL = [[UILabel alloc] init];
        countL.textColor = titleL.textColor;
        countL.font= titleL.font;
        countL.textAlignment = titleL.textAlignment;
        
        [cell.contentView sd_addSubviews:@[titleL,countL]];
        
        titleL.sd_layout
        .leftSpaceToView(cell.contentView,G_INTERVAL)
        .centerYEqualToView(cell.contentView)
        .widthIs(95)
        .heightIs(40);
        
        countL.sd_layout
        .rightSpaceToView(cell.contentView,15 + G_INTERVAL_BIG *2)
        .leftSpaceToView(titleL,G_INTERVAL)
        .centerYEqualToView(cell.contentView)
        .heightIs(30);
        
        switch (indexPath.row) {
            case 0: {
                if (propertyE.domesticWasteFee.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"垃圾处理费";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.domesticWasteFee];
            }
                break;
            case 1: {
                if (propertyE.ontologyGold.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"本体金";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.ontologyGold];
            }
                break;
            case 2: {
                if (propertyE.dischargeFee.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"排污费";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.dischargeFee];
            }
                break;
            case 3: {
                if (propertyE.managementFee.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"管理费";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.managementFee];
            }
                break;
            case 4: {
                if (propertyE.water.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"水费";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.water];
            }
                break;
            case 5: {
                if (propertyE.electricity.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"电费";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.electricity];
            }
                break;
            case 6: {
                if (propertyE.coal.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                
                titleL.text = @"燃气费";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.coal];
            }
                break;
            case 7: {
                if (propertyE.overdueFine.floatValue <= 0) {
                    cell.hidden = YES;
                    break;
                }
                titleL.text = @"滞纳金";
                countL.text = [NSString stringWithFormat:@"%@元",propertyE.overdueFine];
            }
                break;
            default:
                break;
        }
    }
}

@end
