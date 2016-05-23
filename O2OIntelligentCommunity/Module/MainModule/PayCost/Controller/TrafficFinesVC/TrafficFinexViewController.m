//
//  TrafficFinexViewController.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

NSString * const textPlaceholder = @"请选择";

#import "TrafficFinexViewController.h"
#import "ChangePostionButton.h"
#import "NIDropDown.h"  
#import "UserManager.h"
#import "TrafficOrderE.h"
#import "TrafficFinesH.h"
#import "TrafficFinesOrderVC.h"
#import "TrafficCarBitsE.h"
#import "TrafficCityModel.h"

@interface TrafficFinexViewController () <NIDropDownDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSMutableArray *provinceShowArr;
@property (nonatomic,strong) NSArray *cityArr;
@property (nonatomic,strong) NSMutableArray *cityShowArr;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorV;

@end

@implementation TrafficFinexViewController
{
    __weak IBOutlet ChangePostionButton *carProvinceButton;
    __weak IBOutlet ChangePostionButton *carAlphaButton;
    __weak IBOutlet UILabel *provinceLabel;
    __weak IBOutlet UILabel *alphaLabel;
    __weak IBOutlet UITextField *chePaiTF;
    __weak IBOutlet UITextField *cheShibieMa;
    __weak IBOutlet UITextField *faDongJiCode;
    __weak IBOutlet UIButton *searchButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hidetabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestForCurrentCity];
        [self requestForAllProvince];
    });
    // Do any additional setup after loading the view.
}

- (UIActivityIndicatorView *)indicatorV {
    if (_indicatorV == nil) {
        _indicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorV;
}

- (void)setProvinceArr:(NSArray *)provinceArr {
    _provinceArr = provinceArr;
    
    [self.provinceShowArr removeAllObjects];
    [provinceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrafficCityModel *cityM = obj;
        [self.provinceShowArr addObject:cityM.province];
    }];
}

- (void)setCityArr:(NSArray *)cityArr {
    _cityArr = cityArr;
    
    [self.cityShowArr removeAllObjects];
    [cityArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TrafficCityModel *cityM = obj;
        [self.cityShowArr addObject:cityM.city];
    }];
}

- (void)initData {
    self.provinceArr = [NSArray array];
    self.provinceShowArr = [NSMutableArray array];
    self.cityArr = [NSArray array];
    self.cityShowArr = [NSMutableArray array];
    [NIDropDown dropDownInstance].delegate = self;
}

- (void)initUI {
    self.title = @"交通罚款";
    [carProvinceButton setInternalPositionType:ButtonInternalLabelPositionLeft spacing:20];
    [carAlphaButton setInternalPositionType:ButtonInternalLabelPositionLeft spacing:20];
    searchButton.layer.cornerRadius = 3;
    [NIDropDown dropDownInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)indicatorVStartAnimationInView:(UIView *)view {
    view.hidden = YES;
    [view.superview addSubview:self.indicatorV];
    self.indicatorV.center = view.center;
    [self.indicatorV startAnimating];
}

- (void)indicatorVStopAnimationFromView:(UIView *)view {
    [self.indicatorV stopAnimating];
    [self.indicatorV removeFromSuperview];
    view.hidden = NO;
}

#pragma mark - Update
- (void)resetUIForPlaceHolderForCarInfo {
    cheShibieMa.placeholder = @"选填";
    faDongJiCode.placeholder = @"选填";
}

- (void)resetUIForProvinceLAndCityL {
    [self resetUIForProvinceL];
    [self resetUIForCityL];
}

- (void)resetUIForProvinceL {
    provinceLabel.text = textPlaceholder;
    self.provinceArr = [NSArray array];
}

- (void)resetUIForCityL {
    alphaLabel.text = textPlaceholder;
    self.cityArr = [NSArray array];
}

#pragma mark - Request
- (void)requestForCurrentCity {
    [self indicatorVStartAnimationInView:provinceLabel];
    TrafficCityModel *cityM = [TrafficCityModel new];
    cityM.cityId = [UserManager shareManager].comModel.cityid;
    
    NSDictionary *paraDic = @{@"cityId":cityM.cityId};
    
    TrafficFinesH *trafficH = [TrafficFinesH new];
    [trafficH ZJ_requestForGetCurrentTrafficCityWithPara:paraDic success:^(id obj) {
        TrafficCityModel *cityM = obj;
        if (![NSString isEmptyOrNull:cityM.province]) {
            provinceLabel.text = cityM.province;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestForProvinceIncludeCities];
            });
        }
        else {
            [self resetUIForProvinceL];
        }
        
        if (![NSString isEmptyOrNull:cityM.province]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                alphaLabel.text = cityM.city;
                [self requestForGetCarNumberBits];
            });
        }
        else {
            [self resetUIForCityL];
        }
        
        [self indicatorVStopAnimationFromView:provinceLabel];
    } failed:^(id obj) {
        [self resetUIForProvinceLAndCityL];
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
        [self indicatorVStopAnimationFromView:provinceLabel];
    }];
}

- (void)requestForAllProvince {
    carProvinceButton.enabled = NO;
    carAlphaButton.enabled = NO;
    
    [self indicatorVStartAnimationInView:provinceLabel];
    TrafficFinesH *trafficH = [TrafficFinesH new];
    [trafficH ZJ_requestForGetAllTrafficProvinceWithsuccess:^(id obj) {
        self.provinceArr = [obj copy];
        [self indicatorVStopAnimationFromView:provinceLabel];
        
        carProvinceButton.enabled = YES;
        carAlphaButton.enabled = YES;
    } failed:^(id obj) {
        [self resetUIForProvinceL];
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
        [self indicatorVStopAnimationFromView:provinceLabel];
        
        carProvinceButton.enabled = YES;
        carAlphaButton.enabled = YES;
    }];
}

- (void)requestForProvinceIncludeCities {
    [self indicatorVStartAnimationInView:alphaLabel];
    TrafficCityModel *cityM = [TrafficCityModel new];
    cityM.province = provinceLabel.text;
    
    NSDictionary *paraDic = @{@"province":cityM.province};

    TrafficFinesH *trafficH = [TrafficFinesH new];
    [trafficH ZJ_requestForGetTrafficProvinceIncludeCitiesWithPara:paraDic success:^(id obj) {
        self.cityArr = [obj copy];
        [self indicatorVStopAnimationFromView:alphaLabel];
    } failed:^(id obj) {
        [self resetUIForCityL];
        [AppUtils showErrorMessage:obj
                            isShow:self.viewIsVisible];
        [self indicatorVStopAnimationFromView:alphaLabel];
    }];
}

- (void)requestForGetCarNumberBits {
    TrafficCarBitsE *carBitsE = [TrafficCarBitsE new];
    carBitsE.province = provinceLabel.text;
    
    if ([LocalUtils isSepcialCity:carBitsE.province]) {
        carBitsE.city = carBitsE.province;
    }
    else {
        carBitsE.city = [NSString stringWithFormat:@"%@%@",carBitsE.province,alphaLabel.text];
    }
    
    TrafficFinesH *trafficH = [TrafficFinesH new];
    [trafficH executeGetTrafficCarBitsTaskWithUser:carBitsE success:^(id obj) {
        TrafficCarBitsE *carBitsE = obj;
        
        if (carBitsE.carCodeLen.integerValue == 99) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cheShibieMa.placeholder = @"请输入完整的车辆识别码";
            });
        }
        else if (carBitsE.carCodeLen.integerValue > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                cheShibieMa.placeholder = [NSString stringWithFormat:@"识别码后%lu位",(unsigned long)carBitsE.carCodeLen.integerValue];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cheShibieMa.placeholder = [NSString stringWithFormat:@"选填"];
            });
        }
        
        if (carBitsE.carEngineLen.integerValue == 99) {
            dispatch_async(dispatch_get_main_queue(), ^{
                faDongJiCode.placeholder = @"请输入完整的发动机号";
            });
        }
        else if (carBitsE.carEngineLen.integerValue > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                faDongJiCode.placeholder = [NSString stringWithFormat:@"发动机后%lu位",(unsigned long)carBitsE.carEngineLen.integerValue];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                faDongJiCode.placeholder = @"选填";
            });
        }
    } failed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cheShibieMa.placeholder = @"选填";
            faDongJiCode.placeholder = @"选填";
        });
    }];
}

#pragma mark - Event
- (IBAction)onHandleClick:(id)sender {
    [self.view endEditing:YES];
    if (chePaiTF.text.length != 5) {
        [AppUtils showAlertMessage:W_TRAFFIC_NO_CAR_NUM];
        return;
    }
    
    if (![cheShibieMa.placeholder isEqualToString:@"选填"] && cheShibieMa.text.length <= 0) {
        [AppUtils showAlertMessage:W_TRAFFIC_NO_IDCODE];
        return;
    }
    
    if (![faDongJiCode.placeholder isEqualToString:@"选填"] && faDongJiCode.text.length <= 0) {
        [AppUtils showAlertMessage:W_TRAFFIC_NO_ENGINE_NUM];
        return;
    }
    
    [AppUtils showProgressMessage:W_TRAFFIC_QUERING];
    TrafficOrderE *trafficE = [TrafficOrderE new];
    
    trafficE.carnumber = [NSString stringWithFormat:@"%@%@%@",provinceLabel.text,alphaLabel.text,[chePaiTF.text trim]];
    trafficE.carcode = [cheShibieMa.text trim];
    trafficE.cardrivenumber = [faDongJiCode.text trim];
    
    TrafficFinesH *trafficH = [TrafficFinesH new];
    [trafficH executeGetTrafficFinesTaskWithUser:trafficE success:^(id obj) {
        [AppUtils dismissHUD];
        UIStoryboard *feespaidSITB = [UIStoryboard storyboardWithName:@"FeesPaid" bundle:nil];
        TrafficFinesOrderVC *trafficPayVC = [feespaidSITB instantiateViewControllerWithIdentifier:@"TrafficFinesOrderVCID"];
        trafficPayVC.trafficArr = [obj copy];
        trafficPayVC.carnumber = trafficE.carnumber;
        trafficPayVC.cardrivenumber = trafficE.cardrivenumber;
        trafficPayVC.carcode = trafficE.carcode;
        [self.navigationController pushViewController:trafficPayVC animated:YES];
    } failed:^(id obj) {
        [AppUtils dismissHUD];
        if (self.viewIsVisible) {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@未查询到违章记录",trafficE.carnumber] message:obj delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertV show];
        }
    }];
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    
    if (sender.tag == 1) {
        if (self.provinceShowArr.count > 0) {
            [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(sender.frame.size.width, 40 * (self.provinceShowArr.count > 5 ? 5 : self.provinceShowArr.count)) withButton:sender withArr:self.provinceShowArr];
        }
        else {
            if (provinceLabel.text.length == 0 ||
                [provinceLabel.text isEqualToString:textPlaceholder]) {
                [self requestForCurrentCity];
                [self requestForAllProvince];
            }
        }
    }
    else {
        if (self.cityShowArr.count > 0) {
            [[NIDropDown dropDownInstance] showDropDownWithSize:CGSizeMake(sender.frame.size.width, 40 * (self.cityShowArr.count > 5 ? 5 : self.cityShowArr.count)) withButton:sender withArr:self.cityShowArr];
        }
        else {
            if (alphaLabel.text.length == 0 ||
                [alphaLabel.text isEqualToString:textPlaceholder]) {
                [self requestForProvinceIncludeCities];
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NSInteger) index forBtn:(UIButton *)button {
    button.selected = NO;
    if (button.tag == 1) {
        provinceLabel.text = self.provinceShowArr[index];
        [self resetUIForPlaceHolderForCarInfo];
        [self resetUIForCityL];
        [self requestForProvinceIncludeCities];
    }
    else {
        alphaLabel.text = self.cityShowArr[index];
        [self requestForGetCarNumberBits];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    if (textField == chePaiTF) { //车牌号限制最多5位
        return range.location <= 4;
    }
    else if (textField == cheShibieMa) {
        return range.location <= 17;
    }
    else if (textField == faDongJiCode) {
        return range.location <= 9;
    }
    return NO;
}
@end
