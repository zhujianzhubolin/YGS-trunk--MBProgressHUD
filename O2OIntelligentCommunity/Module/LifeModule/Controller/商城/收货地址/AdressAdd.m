//
//  AdressAdd.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AdressAdd.h"
#import "Life_First.h"
#import "DaoJIShi.h"
#import "AddNewDressModel.h"
#import "UserManager.h"

@interface AdressAdd ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

{
    __weak IBOutlet UITextField *adressdetail;
    __weak IBOutlet UITextField *adress;
    __weak IBOutlet UITextField *name;
    __weak IBOutlet UITextField *phoneNum;
    __weak IBOutlet UIButton *defaultAdressBtn;
    
    UIPickerView * adressPicker;
    UIToolbar * bar;
    
    NSMutableArray * provinceArray;
    NSMutableArray * provinceCodeArray;
    
    NSMutableArray * shiArray;
    NSMutableArray * shiCodeArray;
    
    NSMutableArray * quArray;
    NSMutableArray * quCodeArray;
    
    BOOL isUpdate;
    
    NSInteger sheng;
    NSInteger shi;
    NSInteger qu;
}

@end

@implementation AdressAdd

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self hidetabbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_EditingAddStr isEqualToString:@"bianji"])
    {
        self.title = @"编辑收货地址";
    }
    else
    {
        self.title = @"添加新地址";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    name.delegate = self;
    phoneNum.delegate = self;
    adressdetail.delegate = self;
    
    isUpdate = NO;
    
    
    UITapGestureRecognizer * gues = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gues];
    
    provinceArray = [NSMutableArray array];
    provinceCodeArray = [NSMutableArray array];
    
    shiArray = [NSMutableArray array];
    shiCodeArray = [NSMutableArray array];
    
    quArray = [NSMutableArray array];
    quCodeArray = [NSMutableArray array];
    
    //键盘联想功能
    adressPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, IPHONE_WIDTH, 180)];
    bar =[[UIToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, 44)];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(makeSureupLoadData)];
    self.navigationItem.rightBarButtonItem = rightBar;
    

    UIBarButtonItem *quxiao = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(quxiaoChose)];
    
    UIBarButtonItem *btnDidSelectleixing = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(makeSureChoose)];
    
    UIBarButtonItem *flexibleSpaceleixing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UILabel * noticelable = [UILabel addlable:bar frame:CGRectMake(60, 0, IPHONE_WIDTH - 100, 44) text:@"温馨提示，如果没有当前省市区，请滚动一下查看" textcolor:[UIColor redColor]];
    noticelable.backgroundColor = [UIColor clearColor];
    noticelable.numberOfLines = 2;
    [bar setItems:[NSArray arrayWithObjects:quxiao,flexibleSpaceleixing,btnDidSelectleixing, nil]];
    adressPicker.showsSelectionIndicator =YES;
    adressPicker.delegate =self;
    adressPicker.dataSource =self;
    adress.inputAccessoryView = bar;
    adress.inputView = adressPicker;
    adress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getAllProvince) userInfo:nil repeats:NO];
    
    //UITextField注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged1:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:name];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged2:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:adressdetail];
    if (self.isEmpty) {
         defaultAdressBtn.selected = YES;
     }else{
         defaultAdressBtn.selected = NO;
     }


    [defaultAdressBtn addTarget:self action:@selector(selectOrNot:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.adressDict == nil) {
        
    }else{
        NSLog(@"传过来的>>>>%@",self.adressDict);
        
        name.text = [NSString stringWithFormat:@"%@",self.adressDict[@"consignee"]];
        phoneNum.text = [NSString stringWithFormat:@"%@",self.adressDict[@"mobile"]];
        adress.text = [NSString stringWithFormat:@"%@",self.adressDict[@"ssq_Address"]];
        adressdetail.text = [NSString stringWithFormat:@"%@",self.adressDict[@"shipping_Address"]];
        
        if ([self.adressDict[@"isDefault"] boolValue]) {
                defaultAdressBtn.selected = YES;
        
        }
    }
    
}

-(void)selectOrNot:(UIButton *)sender{

    sender.selected = !sender.selected;
}


- (void)textFiledEditChanged1:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 15;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}



- (void)textFiledEditChanged2:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 50;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:name];

    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:adressdetail];
}


- (void)quxiaoChose{
    [self hideKeyBoard];
}

- (void)getAllProvince{

    Life_First * handel = [Life_First new];
    DaoJIShi * dao = [DaoJIShi new];
    dao.areaId = [NSNumber numberWithLong:1602];
    
    [handel getCityList:dao success:^(id obj) {
        
        NSLog(@"省列表>>>>%@",obj);
        
        for (NSDictionary  * dict in obj[@"list"]) {
            
            [provinceCodeArray addObject:dict[@"areaId"]];
            [provinceArray addObject:dict[@"areaName"]];
            
        }
        
    } failed:^(id obj) {
        if (self.viewIsVisible) {
            [AppUtils showErrorMessage:@"获取城市列表失败"];
        }
        else {
            [AppUtils dismissHUD];
        }
    }];
    
}


- (void)hideKeyBoard{
    [adressdetail resignFirstResponder];
    [adress resignFirstResponder];
    [name resignFirstResponder];
    [phoneNum resignFirstResponder];
    
}

- (void)makeSureChoose{
    
    NSLog(@"%ld>>%ld>>%ld",(long)sheng,(long)shi,(long)qu);
    
    NSString * prostr;
    NSString * shistr;
    
    if (provinceArray.count > 0) {
        prostr = [provinceArray objectAtIndex:sheng];
    }else{
        [self shoMessage:@"请选择省"];
        return;
    }
    if (shiArray.count > 0) {
        shistr = [shiArray objectAtIndex:shi];
    }else{
        [self shoMessage:@"请选择市"];
        return;
    }
    
    NSString * qustr;
    if (quArray.count > 0) {
        qustr = [quArray objectAtIndex:qu];
    }else{
        qustr = @"";
    }
    adress.text = [NSString stringWithFormat:@"%@%@%@",prostr,shistr,qustr];
    [self hideKeyBoard];
}

- (void)shoMessage:(NSString *)message{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

//相当于多少段
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


//每段里面的列表数量
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        if (provinceArray.count <=0) {
            return 1;
        }else{
            return provinceArray.count;
        }
    }else if (component == 1){
        if (shiCodeArray.count <= 0) {
            return 1;
        }else{
            return shiCodeArray.count;
        }
    }else{
        if (quArray.count <= 0) {
            return 1;
        }else{
            return quCodeArray.count;
        }
    }
}

//每一个列表里面显示的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        
        if (provinceArray.count <=0) {
            return @"";
        }else{
            return [provinceArray objectAtIndex:row];
        }
        
    }else if (component == 1){
        
        if (shiCodeArray.count <= 0) {
            return @"";
        }else{
            return [shiArray objectAtIndex:row];
        }
        
    }else{
        
        if (quArray.count <= 0) {
            return @"";
        }else{
            return [quArray  objectAtIndex:row];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    isUpdate = YES;
    
    if (component == 0) {
        sheng = row;
        [shiCodeArray removeAllObjects];
        [shiArray removeAllObjects];
        
        [quArray removeAllObjects];
        [quCodeArray removeAllObjects];
        
        Life_First * handel = [Life_First new];
        DaoJIShi * dao = [DaoJIShi new];
        dao.areaId = [NSNumber numberWithLong:[[provinceCodeArray objectAtIndex:row] intValue]];
        
        [handel getCityList:dao success:^(id obj) {
            
            NSLog(@"市列表>>>>%@",obj);
            
            for (NSDictionary * dict in obj[@"list"]) {
                [shiArray addObject:dict[@"areaName"]];
                [shiCodeArray addObject:dict[@"areaId"]];
                [adressPicker reloadAllComponents];
            }
            
        } failed:^(id obj) {
            if (self.viewIsVisible) {
                [AppUtils showErrorMessage:@"获取市失败"];
            }
            else {
                [AppUtils dismissHUD];
            }
        }];
    }else if (component == 1){
    
        if (shiArray.count > 0) {
            shi = row;
            
            [quCodeArray removeAllObjects];
            [quArray removeAllObjects];
            
            Life_First * handel = [Life_First new];
            DaoJIShi * dao = [DaoJIShi new];
            dao.areaId = [NSNumber numberWithLong:[[shiCodeArray objectAtIndex:row] intValue]];
            
            [handel getCityList:dao success:^(id obj) {
                
                NSLog(@"区列表>>>>%@",obj);
                
                for (NSDictionary * dict in obj[@"list"]) {
                    [quArray addObject:dict[@"areaName"]];
                    [quCodeArray addObject:dict[@"areaId"]];
                    [adressPicker reloadAllComponents];
                }
                
            } failed:^(id obj) {
                if (self.viewIsVisible) {
                    [AppUtils showErrorMessage:@"获取区失败"];
                }
                else {
                    [AppUtils dismissHUD];
                }
            }];
        }else{
        
        }
        
    }else{
    
        qu = row;
        
    }
}

//pickerView的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return IPHONE_WIDTH/3;
}

- (void)makeSureupLoadData{
    
//        BOOL isAvalePhone = [self checkTel:phoneNum.text];

    NSString * nameWithOutSpace = [name.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (nameWithOutSpace.length <=0) {
            [self showNotice:@"收货人不能为空"];
            return;
        }
    
        if (nameWithOutSpace.length > 15) {
            [self showNotice:@"收货人名字长度不能大于15"];
            return;
        }
    
//        if (!isAvalePhone){
//            [self showNotice:@"请输入正确的手机号码"];
//            return;
//        }
    
        if (adress.text.length<=0){
            [self showNotice:@"收货人地址不能为空"];
            return;
        }
        
        NSString * adressWithoutSpace = [adressdetail.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
        if (adressWithoutSpace.length <=0) {
            [self showNotice:@"收货人详细地址不能为空"];
            return;
        }
        
        if (adressWithoutSpace.length > 50) {
            [self showNotice:@"收货人详细地址长度不能大于50"];
            return;
        }
        
        Life_First * handel = [Life_First new];
        AddNewDressModel * model = [AddNewDressModel new];
        model.memberId = [UserManager shareManager].userModel.memberId;
        model.consignee = name.text;
        model.mobile = phoneNum.text;

        model.addressName = adressdetail.text;
        
        if (defaultAdressBtn.selected) {
            model.default_Address = @"1";
        }else{
            model.default_Address = @"";
        }
        
    
    
        if (self.adressDict == nil) {
            
            model.province = [provinceCodeArray objectAtIndex:sheng];
            model.city = [shiCodeArray objectAtIndex:shi];
            
            if (quArray.count <=0 ) {
                model.district = @"";
            }else{
                model.district = [quCodeArray objectAtIndex:qu];
            }
            
            [handel addNewAdress:model success:^(id obj) {
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:k_NOTI_ORDER_ADDORESS_CHANGE object:self];

                NSLog(@"新增收货地址>>>>>%@",obj);
                if (![NSString isEmptyOrNull:obj[@"code"]] && [obj[@"code"] isEqualToString:@"success"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [AppUtils showAlertMessage:[NSString stringWithFormat:@"%@",obj[@"message"]]];
                }
                
            } failed:^(id obj) {
                if (self.viewIsVisible) {
                    [AppUtils showErrorMessage:@"添加收货地址失败"];
                }
                else {
                    [AppUtils dismissHUD];
                }
            }];
            
        }else{
            
            if (isUpdate) {//省市区有更新
                
                model.province = [provinceCodeArray objectAtIndex:sheng];
                model.city = [shiCodeArray objectAtIndex:shi];
                
                if (quArray.count <=0 ) {
                    model.district = @"";
                }else{
                    model.district = [quCodeArray objectAtIndex:qu];
                }
                
            }else{//省市区没有更新
                model.province = self.adressDict[@"province"];
                model.city = self.adressDict[@"city"];
                model.district = self.adressDict[@"district"];
            }
            
            model.adressid = self.adressDict[@"id"];
            
            [handel resertAdress:model success:^(id obj) {
                
                if ([obj[@"code"] isEqualToString:@"success"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [AppUtils showAlertMessage:[NSString stringWithFormat:@"%@",obj[@"message"]]];
                }
                

                
            } failed:^(id obj) {
                if (self.viewIsVisible) {
                    [AppUtils showErrorMessage:@"修改收货地址失败"];
                }
                else {
                    [AppUtils dismissHUD];
                }
            }];
            
        }
}


- (void)showNotice:(NSString *)str{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



#pragma TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:name]) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        NSLog(@"%ld",strLength);
        if (strLength > 15){
            return NO;
        }
    }
    
    if ([textField isEqual:phoneNum]) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        NSLog(@"%ld",strLength);
        if (strLength > 20){
            return NO;
        }
    }
    
    if ([textField isEqual:adressdetail]) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        NSLog(@"%ld",strLength);
        if (strLength > 50){
            return NO;
        }
    }
    return YES;
}


//验证手机号的合法性
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}




@end
