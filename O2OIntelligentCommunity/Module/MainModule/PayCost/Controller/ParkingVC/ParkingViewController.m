//
//  ParkingViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/15.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ParkingViewController.h"
#import "ChangePostionButton.h"
#import "UIView+wrapper.h"
#import "CommunityViewCotroller.h"
#import "UserManager.h"
#import "PropertyChargeH.h"
#import "NIDropDown.h"  
#import "NSString+wrapper.h"    
#import "CheckstandViewController.h"

@interface ParkingViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NIDropDownDelegate,UITextFieldDelegate>

@end

@implementation ParkingViewController
{
    IBOutlet UITableView *infoTableView;
    NSArray *parkingArr;
    NSArray *chargeTimeArr; //缴费时长数组
    
    NSMutableArray *infoArr; //小区具体信息
    NSArray *xqChargeArr; //小区列表数组
    NSArray *chePaiList; //车牌选择列表
    NSMutableArray *selectedArr;
    BingingXQModel *currenComM;
    
    PropertyChargeE *currentParkE; //当前的缴费信息
    UITextField *carNumTF;
    ChangePostionButton *alphaBtn;
    ChangePostionButton *provinceBtn;
    NSUInteger chargeTimeIndex; //当前选择的缴费时长
    UITextField *chargeTimeTF; //不输入，缴费时长选择使用
}

//分割线靠边界
-(void)viewDidLayoutSubviews {
    [self viewDidLayoutSubviewsForTableView:infoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)startNetworkWithXQID:(BingingXQModel *)comM withTFText:(NSString *)text{
    [AppUtils showProgressMessage:W_ALL_PROGRESS];
    PropertyChargeE *propertyE = [PropertyChargeE new];
    
    NSMutableString *carStr = [NSMutableString new];

    [carStr appendString:provinceBtn.titleLabel.text];
    [carStr appendString:alphaBtn.titleLabel.text];
    [carStr appendString:text];
    
    propertyE.licenseNumber = [carStr copy];
    NSLog(@"propertyE.licenseNumber = %@",propertyE.licenseNumber);
    propertyE.xqNo   = comM.xqNo;
    propertyE.wyID   = comM.wyId;
    propertyE.cityNo = comM.cityid;
    
    PropertyChargeH *propertyH = [PropertyChargeH new];
    [propertyH executeGetParkingTypeTaskWithUser:propertyE success:^(id obj) {
        [self.view endEditing:YES];
        [AppUtils dismissHUD];
        PropertyChargeE *recvParkingE = obj;
        currentParkE = recvParkingE;
        currentParkE.mouths = chargeTimeArr[chargeTimeIndex];
        
        [infoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self configurateTotalCharge];
    } failed:^(id obj) {
        [self.view endEditing:YES];
        if (self.viewIsVisible) {
            [AppUtils showAlertMessageTimerClose:obj];
        }
        else {
            [AppUtils dismissHUD];
        }
        [infoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self configurateTotalCharge];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)resetChargeData {
    chargeTimeIndex = 0;
    carNumTF.text = nil;
    currentParkE = [PropertyChargeE new];
    currentParkE.mouths = chargeTimeArr[chargeTimeIndex];
    currentParkE.parkingType = @"";
    currentParkE.monthlyFee = @"0";
    [infoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    [self configurateTotalCharge];
}

- (void)initData {
    parkingArr = @[@"小区信息",@"所在小区: ",@"楼  栋  号: ",@"",@"",@"车库类型: ",@"缴费时长: ",@"缴费金额: ",];
    chargeTimeArr = @[@"1",@"3",@"6",@"12"];
    
    infoArr = [NSMutableArray arrayWithObjects:@"",[UserManager shareManager].comModel.xqName,[UserManager shareManager].comModel.xqHouse,@"",@"",@"",@"",@"",nil];
    xqChargeArr = [NSArray array];

    NSString *path=[[NSBundle mainBundle] pathForResource:@"chePaiList"
                                                   ofType:@"plist"];
    chePaiList = [NSMutableArray arrayWithContentsOfFile:path];
    
    selectedArr = [NSMutableArray array];
    [chePaiList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chaPaiDic = (NSDictionary *)obj;
        [selectedArr addObject:chaPaiDic.allKeys[0]];
    }];
    [NIDropDown dropDownInstance].delegate = self;
    currenComM = [UserManager shareManager].comModel;
}

- (void)initUI {
    self.title = @"停车缴费";
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoTableView.frame.size.width, 70)];
    footer.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(10, 10, footer.frame.size.width - 10 * 2, 45);
    [footerButton addTarget:self action:@selector(onlineHandleClick) forControlEvents:UIControlEventTouchUpInside];
    footerButton.layer.cornerRadius = 3;
    footerButton.backgroundColor = [AppUtils colorWithHexString:@"fc6d22"];
    [footerButton setTitle:@"立即缴费" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [footer addSubview:footerButton];
    infoTableView.tableFooterView = footer;

    [self resetCommunityData];
    [self resetChargeData];
}

- (void)onlineHandleClick {
    UITableViewCell *cell1 = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    if (carNumTF.text.length <= 0) {
        [AppUtils showAlertMessage:W_PARK_NO_INPUT_CAR_NUM];
        return;
    }
    
    if ([cell1.textLabel.text isEqualToString:parkingArr[5]] || currentParkE.monthlyFee.floatValue <= 0) {
        [AppUtils showAlertMessageTimerClose:@"未获取到缴费信息"];
        return;
    }
    
    UIStoryboard *feesPaidStoryboard = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
    CheckstandViewController *checkstandVC = [feesPaidStoryboard instantiateViewControllerWithIdentifier:@"CheckstandViewControllerID"];
    checkstandVC.chargeType = ChargeTypePark;
    checkstandVC.community = [NSString stringWithFormat:@"%@ %@",[UserManager shareManager].comModel.xqName,[UserManager shareManager].comModel.xqHouse,nil];
    checkstandVC.xqName = [UserManager shareManager].comModel.xqName;
    checkstandVC.payCount = [NSString stringWithFormat:@"%.2f",currentParkE.monthlyFee.floatValue * currentParkE.mouths.floatValue];
    
    NSMutableString *carStr = [NSMutableString new];

    [carStr appendString:provinceBtn.titleLabel.text];

    [carStr appendString:alphaBtn.titleLabel.text];
    [carStr appendString:carNumTF.text];
    
    
    checkstandVC.licenseNumber  = [carStr copy];
    checkstandVC.monthlyFee     = currentParkE.monthlyFee;
    checkstandVC.parkingType    = currentParkE.parkingType;
    checkstandVC.mouths         = currentParkE.mouths;
    checkstandVC.xqNo           = currenComM.xqNo;
    checkstandVC.wyNo           = currenComM.wyId;
    checkstandVC.infoNo         = currentParkE.infoNo;
    checkstandVC.cityNo         = currenComM.cityid;
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurateTotalCharge {
    //配置缴费总额
    UITableViewCell *cell1 = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    UILabel *accL1 = (UILabel *)cell1.accessoryView;
    UITableViewCell *cell2 = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    
    if (accL1.text.length > 2 && cell2.textLabel.text.length > 7) {
        CGFloat carParkingType = [accL1.text substringToIndex:(accL1.text.length - 2)].floatValue;
        
        NSString *yueStr = [[cell2.textLabel.text trim] substringFromIndex:5];
        CGFloat chargeTime = [yueStr substringToIndex:yueStr.length - 2].floatValue;
        
        UITableViewCell *cell3 = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        cell3.textLabel.text = [NSString stringWithFormat:@"%@%.2f元",parkingArr[7],chargeTime * carParkingType];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell3.textLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(5, str.length - 5)];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell3.textLabel.attributedText = str;
        });
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 5;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return parkingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subView = (UIView *)obj;
        [subView removeFromSuperview];
    }];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryView = nil;
    cell.textLabel.text = parkingArr[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        ChangePostionButton *button = [ChangePostionButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 120, cell.frame.size.height);
        [button addTarget:self action:@selector(changeCom) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"更改小区" forState:UIControlStateNormal];
        [button setTitleColor:[AppUtils colorWithHexString:@"1cabdb"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"changeCom"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
        [button setInternalPositionType:ButtonInternalLabelPositionRight spacing:5];
        cell.accessoryView = button;
    }
    else if (indexPath.row == 3) {
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    }
    else if (indexPath.row == 4) {
        cell.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        CGFloat distance = 1;
        provinceBtn = [ChangePostionButton new];
        provinceBtn.frame = CGRectMake(0, 0, (tableView.frame.size.width - distance * 2) *3 /10, 49);
        provinceBtn.tag = 20;
        provinceBtn.backgroundColor = [UIColor whiteColor];
        [provinceBtn setTitle:@"粤" forState:UIControlStateNormal];
        [provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [provinceBtn setImage:[UIImage imageNamed:@"downListLight"] forState:UIControlStateNormal];
        [provinceBtn setInternalPositionType:ButtonInternalLabelPositionLeft spacing:30];
        [provinceBtn addTarget:self action:@selector(carNumChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        alphaBtn = [ChangePostionButton new];
        alphaBtn.frame = CGRectMake(provinceBtn.frame.origin.x + provinceBtn.frame.size.width + distance, provinceBtn.frame.origin.y, provinceBtn.frame.size.width, provinceBtn.frame.size.height);
        alphaBtn.tag = 30;
        alphaBtn.backgroundColor = [UIColor whiteColor];
        [alphaBtn setTitle:@"B" forState:UIControlStateNormal];
        [alphaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [alphaBtn setImage:[UIImage imageNamed:@"downListLight"] forState:UIControlStateNormal];
        [alphaBtn setInternalPositionType:ButtonInternalLabelPositionLeft spacing:30];
        [alphaBtn addTarget:self action:@selector(carNumChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomTFV = [[UIView alloc] initWithFrame:CGRectMake(alphaBtn.frame.origin.x + alphaBtn.frame.size.width + distance, alphaBtn.frame.origin.y, tableView.frame.size.width - (alphaBtn.frame.origin.x + alphaBtn.frame.size.width + distance), alphaBtn.frame.size.height)];
        bottomTFV.backgroundColor = [UIColor whiteColor];
        
        carNumTF = [[UITextField alloc] initWithFrame:CGRectMake(10,0,bottomTFV.frame.size.width - 10,bottomTFV.frame.size.height)];
        
        carNumTF.tag = 40;
        carNumTF.delegate = self;
        carNumTF.backgroundColor = [UIColor whiteColor];
        carNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        carNumTF.placeholder = @"输入车牌号";
        carNumTF.keyboardType = UIKeyboardTypeASCIICapable;
        [bottomTFV addSubview:carNumTF];
        
        [cell.contentView addSubview:provinceBtn];
        [cell.contentView addSubview:alphaBtn];
        [cell.contentView addSubview:bottomTFV];
    }
    else {
        if (infoArr.count > indexPath.row ) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",parkingArr[indexPath.row],infoArr[indexPath.row]];
        }
        else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",parkingArr[indexPath.row]];
        }
        
        if (indexPath.row == parkingArr.count - 1) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(6,str.length - 6)];
            cell.textLabel.attributedText = str;
        }
        else if (indexPath.row == parkingArr.count - 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@个月",parkingArr[indexPath.row],chargeTimeArr[chargeTimeIndex]];
            
            chargeTimeTF = [[UITextField alloc] initWithFrame:CGRectMake(-10, 0, IPHONE_WIDTH + 10, 50)];
            chargeTimeTF.delegate = self;
            [cell.contentView addSubview:chargeTimeTF];
            
            UIPickerView *durationPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 120)];
            durationPicker.showsSelectionIndicator = YES;
            
            UIToolbar *bar =[[UIToolbar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoose)];
            
            UIBarButtonItem *sureItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(makeSureChoose)];
            
            UIBarButtonItem *centerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            UILabel * noticelable = [UILabel addlable:bar frame:CGRectMake(50, 0, tableView.frame.size.width - 100, 50) text:@"缴费时长" textcolor:[UIColor blackColor]];
            noticelable.textAlignment = NSTextAlignmentCenter;
            noticelable.backgroundColor = [UIColor clearColor];
            noticelable.numberOfLines = 2;
            [bar setItems:[NSArray arrayWithObjects:cancelItem,centerItem,sureItem, nil]];
            durationPicker.showsSelectionIndicator =YES;
            durationPicker.delegate =self;
            durationPicker.dataSource =self;
            chargeTimeTF.inputAccessoryView = bar;
            chargeTimeTF.inputView = durationPicker;
        }
        else if (indexPath.row == parkingArr.count - 3) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",parkingArr[indexPath.row],currentParkE.parkingType];
            cell.tag = indexPath.row + 1;
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            typeLabel.textAlignment = NSTextAlignmentRight;
            typeLabel.textColor = [AppUtils colorWithHexString:@"fc6d22"];
            typeLabel.text = [NSString stringWithFormat:@"%@元/月",currentParkE.monthlyFee];
            cell.accessoryView = typeLabel;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 6) {
        [chargeTimeTF becomeFirstResponder];
    }
}

- (void)carNumChooseClick:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;

    if (sender.tag == 20) {
        [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(sender.frame.size.width, 40 * (selectedArr.count > 4 ? 4 : selectedArr.count)) withButton:sender withArr:selectedArr];
    }
    else {
        __block NSArray *showArr = [NSArray array];
        UIButton *chePaiBtn = (UIButton *)[self.tableView viewWithTag:20];
        [chePaiList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSEnumerator * enumerator = [dic keyEnumerator];
            id object;
            //遍历输出
            while(object = [enumerator nextObject])
            {
                if ([chePaiBtn.titleLabel.text isEqualToString:object]) {
                    showArr = [[dic objectForKey:object] copy];
                    break;
                }
            }
        }];
        
        if (showArr.count > 0) {
            [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(sender.frame.size.width, 40 * (showArr.count > 4 ? 4 : showArr.count)) withButton:sender withArr:showArr];
        }
    }
}

- (void)resetCommunityData {
    infoArr = [NSMutableArray arrayWithObjects:@"",currenComM.xqName,currenComM.xqHouse,@"",@"",@"",@"",@"",nil];
    [infoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)changeCom {
    CommunityViewCotroller *communityVC = [CommunityViewCotroller new];
    communityVC.comLimits = ComLimitsClassifyPark;
    communityVC.comBlock = ^(BingingXQModel *comModel) {
        currenComM = comModel;
        [self resetCommunityData];
        [self resetChargeData];
    };
    
    communityVC.communityType = CommunityChooseTypeBinding;
    [self.navigationController pushViewController:communityVC animated:YES];
}

- (void)queryChargeInfo:(NSTimer *)timer {
    NSString *appendStr = timer.userInfo;
    [self startNetworkWithXQID:currenComM withTFText:appendStr];
}

- (void)cancelChoose {
    [self.view endEditing:YES];
}

- (void)makeSureChoose {
    UITableViewCell *chargeTimeCell = [infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:parkingArr.count - 2 inSection:0]];
    chargeTimeCell.textLabel.text = [NSString stringWithFormat:@"%@%@个月",parkingArr[6],chargeTimeArr[chargeTimeIndex]];
    currentParkE.mouths = chargeTimeArr[chargeTimeIndex];
    
    [self configurateTotalCharge];
    [self cancelChoose];
}

#pragma mark - UIPickerViewDataSource && UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [chargeTimeArr count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@个月",chargeTimeArr[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    chargeTimeIndex = row;
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button {
    [self resetChargeData];
    button.selected = NO;
    if (button.tag == 20) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:selectedArr[index] forState:UIControlStateNormal];
        });
        
        
        __block NSArray *showArr = [NSArray array];;
        [chePaiList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSEnumerator * enumerator = [dic keyEnumerator];
            id object;
            //遍历输出
            while(object = [enumerator nextObject])
            {
                if ([button.titleLabel.text isEqualToString:object]) {
                    showArr = [[dic objectForKey:object] copy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"showArr[0] = %@",showArr[0]);
                        [alphaBtn setTitle:showArr[0] forState:UIControlStateNormal];
                    });
                    return;
                }
            }
        }];
    }
    else {
        __block NSArray *showArr = [NSArray array];
        UIButton *chePaiBtn = (UIButton *)[self.tableView viewWithTag:20];
        [chePaiList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSEnumerator * enumerator = [dic keyEnumerator];
            id object;
            //遍历输出
            while(object = [enumerator nextObject])
            {
                if ([chePaiBtn.titleLabel.text isEqualToString:object]) {
                    showArr = [[dic objectForKey:object] copy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [button setTitle:showArr[index] forState:UIControlStateNormal];
                    });
                    return;
                }
            }
        }];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == chargeTimeTF) {
        return NO;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    if (range.location == 4 && string.length > 0) {
        NSString *appendStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(queryChargeInfo:) userInfo:appendStr repeats:NO];
        return YES;
    }
    else if (range.location >= 5) {
        return NO;
    }
    return YES;
}

@end
