//
//  PropertyViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PropertyViewController.h"
#import "ChangePostionButton.h"
#import "CommunityViewCotroller.h"
#import "FeesPaidViewController.h"  
#import "PropertyChargeE.h"
#import "PropertyChargeH.h"
#import "UserManager.h"
#import "ProInfoConfirmViewController.h"

@interface PropertyViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation PropertyViewController
{
    IBOutlet UITableView *infoTableView;
    NSArray *comDescArr; //小区描述信息
    NSMutableArray *comInfoArr; //小区具体信息
    
    NSArray *chargeDescArr;
    NSMutableArray *chargeInfoArr;
    
    NSArray *xqChargeArr; //小区列表数组
    BingingXQModel *currentXQM;
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:infoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self refreshCommunityDataWithXqModel:currentXQM];
    // Do any additional setup after loading the view.
}

- (void)initData {
    comDescArr = @[@"小区信息",@"所在小区: ",@"楼  栋  号: ",@"地        区: "];
    chargeDescArr = @[@"待缴费信息",@"收费单位: ",@"待缴费月数: ",@"待缴费金额: "];

    xqChargeArr = [NSArray array];
    comInfoArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    chargeInfoArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    currentXQM = [UserManager shareManager].comModel;
}

- (void)initUI {
    self.title = [LocalUtils titleForChargeType:ChargeTypeProperty];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableView.frame.size.width, 70)];
    footer.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(G_INTERVAL_BIG, G_INTERVAL_BIG, footer.frame.size.width - G_INTERVAL_BIG * 2, 45);
    [footerButton addTarget:self action:@selector(onlineHandleClick) forControlEvents:UIControlEventTouchUpInside];
    footerButton.layer.cornerRadius = 3;
    footerButton.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    [footerButton setTitle:@"立即缴费" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [footer addSubview:footerButton];
    infoTableView.tableFooterView = footer;
}

- (void)emptyChargeData {
    chargeInfoArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    [infoTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refreshCommunityDataWithXqModel:(BingingXQModel *)xqM {
    //刷新小区的基本信息
    
    NSMutableString *shengShiQu  = [NSMutableString new];
    if (![NSString isEmptyOrNull:xqM.cityName]) {
        [shengShiQu appendString:xqM.cityName];
    }
    
    if (![NSString isEmptyOrNull:xqM.areaname]) {
        [shengShiQu appendString:xqM.areaname];
    }
    
    comInfoArr = [NSMutableArray arrayWithObjects:@"",xqM.xqName,xqM.xqHouse,shengShiQu,nil];
    [infoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    
    if (![NSString isEmptyOrNull:xqM.xqNo]) {
        //获取小区的缴费信息
            PropertyChargeE *propertyE = [PropertyChargeE new];

            propertyE.xqNo      = xqM.xqNo;
            propertyE.wyID      = xqM.wyId;
            propertyE.buildNo   = xqM.floorNumber;
        
            if ([NSString isEmptyOrNull:xqM.unitNumber]) {
                xqM.unitNumber = @"";
            }
        
            propertyE.unitNo    = xqM.unitNumber;
            propertyE.houseNo   = xqM.roomNumber;
            propertyE.cityNo    = xqM.cityid;
        
            PropertyChargeH *propertyH = [PropertyChargeH new];
            [propertyH executeGetPropertyOrderTaskWithUser:propertyE success:^(id obj) {
                xqChargeArr = (NSArray *)obj;
                [chargeInfoArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%lu个月",(unsigned long)xqChargeArr.count]];
                __block CGFloat chargeCount = 0;
                [xqChargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    PropertyChargeE *propertyRecvE = (PropertyChargeE *)obj;
                    chargeCount += propertyRecvE.saleAmount.floatValue;
                }];
                
                if (xqChargeArr.count > 0) {
                    PropertyChargeE *propertyE = xqChargeArr[0];
                    if (![NSString isEmptyOrNull:propertyE.chargeUnit]) {
                        [chargeInfoArr replaceObjectAtIndex:1 withObject:propertyE.chargeUnit];
                    }
                }
                
                [chargeInfoArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%.2f元",chargeCount]];
                [infoTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                [AppUtils dismissHUD];
            } failed:^(id obj) {
                [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
            }];
        }
    else {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }
}

- (void)onlineHandleClick {
    for (int i = 1; i < comDescArr.count; i++) {
        UITableViewCell *cell = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.textLabel.text.length <= 6) {
            [AppUtils showAlertMessageTimerClose:@"请选择完整的小区信息"];
            return;
        }
    }
    
    for (int i = 2; i < chargeDescArr.count; i++) {
        UITableViewCell *cell = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        if (cell.textLabel.text.length <= 7) {
            [AppUtils showAlertMessageTimerClose:@"未获取到物业缴费信息"];
            return;
        }
    }
    
    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    ProInfoConfirmViewController *proInfoVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"ProInfoConfirmViewControllerID"];
    
    if (comInfoArr.count > 1) {
        proInfoVC.xqAllName = [NSString stringWithFormat:@"%@",comInfoArr[1]];
    }
    
    if (comInfoArr.count > 2) {
        proInfoVC.xqAllName = [NSString stringWithFormat:@"%@%@",comInfoArr[1],comInfoArr[2]];
    }
    
    NSMutableArray *arr1 = [NSMutableArray array];
    [xqChargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PropertyChargeE *propertyE = obj;
        propertyE.xqNo = currentXQM.xqNo;
        propertyE.wyID = currentXQM.wyId;
        propertyE.buildNo = currentXQM.floorNumber;
        propertyE.unitNo = currentXQM.unitNumber;
        propertyE.houseNo = currentXQM.roomNumber;
        propertyE.cityNo = currentXQM.cityid;
        [arr1 addObject:propertyE];
    }];
    
    proInfoVC.chargeArr = [NSArray arrayWithArray:arr1];
    [self.navigationController pushViewController:proInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return comDescArr.count;
    }
    else if (section == 1) {
        return chargeDescArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryView = nil;
    cell.textLabel.text = nil;
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        if (indexPath.section == 0) {
            cell.textLabel.text = comDescArr[indexPath.row];
            ChangePostionButton *button = [ChangePostionButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 130, 44);
            [button addTarget:self action:@selector(changeCom) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"changeCom"] forState:UIControlStateNormal];
            [button setTitle:@"更改小区" forState:UIControlStateNormal];
            [button setTitleColor:[AppUtils colorWithHexString:@"1cabdb"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [button setInternalPositionType:ButtonInternalLabelPositionRight spacing:5];
            cell.accessoryView = button;
        }
        else if (indexPath.section == 1){
            cell.textLabel.text = chargeDescArr[indexPath.row];
        }
    }
    else {
        cell.textLabel.textColor = [AppUtils colorWithHexString:@"404040"];
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",comDescArr[indexPath.row]];
            if (comInfoArr.count > indexPath.row) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",cell.textLabel.text,comInfoArr[indexPath.row]];
            }
        }
        else if (indexPath.section == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",chargeDescArr[indexPath.row]];
            if (chargeInfoArr.count > indexPath.row) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",cell.textLabel.text,chargeInfoArr[indexPath.row]];
            }
            
            if (indexPath.row == chargeInfoArr.count - 1) {
                NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(6, str.length - 6)];
                cell.textLabel.attributedText=str;
            }
        }
    }
}

- (void)changeCom {
    CommunityViewCotroller *communityVC = [CommunityViewCotroller new];
    communityVC.comLimits = ComLimitsClassifyProperty;
    communityVC.communityType = CommunityChooseTypeBinding;
    communityVC.comBlock = ^(BingingXQModel *comModel) {
        [self emptyChargeData];
        currentXQM = comModel;
        [self refreshCommunityDataWithXqModel:currentXQM];
    };
    [self.navigationController pushViewController:communityVC animated:YES];
}

@end
