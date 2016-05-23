//
//  ConvertVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/2.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ConvertVC.h"
#import "UserManager.h"
#import "UserHandler.h"

#import "DuiQuanHandel.h"
#import "DuiQuanModel.h"

@interface ConvertVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *converTB;
    UITextField *voucherNumberF;
    UITextField *passwordF;
}

@end

@implementation ConvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    self.title=@"兑券";
    
    
    
    self.view.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    UIView *footoV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
    UIButton *duiQuanButton = [[UIButton alloc]initWithFrame:CGRectMake(10,50,IPHONE_WIDTH-20,45)];
    duiQuanButton.backgroundColor=[AppUtils colorWithHexString:@"fa6900"];
    [duiQuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [duiQuanButton setTitle:@"确定" forState:UIControlStateNormal];
    duiQuanButton.layer.cornerRadius = 5;
    [duiQuanButton addTarget:self action:@selector(defineAction)forControlEvents:UIControlEventTouchUpInside];
    [footoV addSubview:duiQuanButton];
    
    converTB =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    converTB.delegate =self;
    converTB.dataSource =self;
    converTB.separatorStyle=NO;
    converTB.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    converTB.tableFooterView=footoV;
    [self.view addSubview:converTB];
    
    
}

-(void)defineAction
{
    NSLog(@"兑换");
    
    if ([NSString isEmptyOrNull:voucherNumberF.text])
    {
        [AppUtils showAlertMessageTimerClose:@"您还没有输入券号！"];
        return;
    }
    if ([NSString isEmptyOrNull:passwordF.text])
    {
        [AppUtils showAlertMessageTimerClose:@"您还没有输入密码！"];
        return;
    }
    
    DuiQuanHandel *handel =[DuiQuanHandel new];
    DuiQuanModel  *model  =[DuiQuanModel new];
    
    
    model.memberId=[UserManager shareManager].userModel.memberId;
    model.couponNo=voucherNumberF.text;
    model.password=passwordF.text;
    
    [handel duiquanRequest:model success:^(id obj) {
        
        if ([obj[@"code"] isEqualToString:@"error"])
        {
            [AppUtils showAlertMessageTimerClose:obj[@"message"]];
        }
        else
        {
            [AppUtils showAlertMessageTimerClose:obj[@"message"]];
            voucherNumberF.text=@"";
            passwordF.text=@"";

        }
    [UserHandler executeGetUserInfoSuccess:^(id obj) {
        } failed:^(id obj) {
        }];
//        if (self.duihuanSuccessBlock)
//        {
//            self.duihuanSuccessBlock();
//        }
    } failed:^(id obj) {
            [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    else
    {
        return 5;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (Cell==nil)
    {
        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    
    if (indexPath.section==0)
    {
        voucherNumberF =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-20, 44)];
        voucherNumberF.placeholder=@"请输入代金券号";
        voucherNumberF.delegate=self;
        voucherNumberF.keyboardType=UIKeyboardTypeDefault;
        [Cell.contentView addSubview:voucherNumberF];
        [voucherNumberF becomeFirstResponder];
    }
    else if (indexPath.section==1)
    {
        passwordF =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-20, 44)];
        //passwordF.secureTextEntry=YES;
        passwordF.placeholder=@"请输入代金券密码";
        passwordF.delegate=self;
        passwordF.keyboardType=UIKeyboardTypeNumberPad;
        [Cell.contentView addSubview:passwordF];
    }
    return Cell;
}

#pragma mark - UITextField 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(string.length==0)
    {
        return YES;
    }
    int voucherNumberLength =22;
    int passwordLength =8;
    
    
    if (textField == voucherNumberF)
    {
        if (![AppUtils isNotLanguageEmoji]) {
            return NO;
        }
        return range.location < voucherNumberLength;
    }
    else if (textField==passwordF)
    {
        if (![AppUtils isNotLanguageEmoji]) {
            return NO;
        }
        return range.location < passwordLength;

    }
    return YES;
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
