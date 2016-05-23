//
//  UserAccoutInfoVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/1.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "UserAccoutInfoVC.h"
#import "ChangePersonalInfoHandler.h"
#import "UserManager.h"
#import "NSString+wrapper.h"

#import "UserEntity.h"
#import "UserHandler.h"

@interface UserAccoutInfoVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *userInfoTB;
    UITextField *textF;
}

@end

@implementation UserAccoutInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    if (_nameOrNickname ==NameEdit)
    {
        self.title =@"编辑姓名";
    }
    else
    {
        self.title =@"编辑昵称";
    }
    
 
    CGFloat rightBtnWidth = 25;
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,rightBtnWidth *2,rightBtnWidth)];
    [rightButton setBackgroundColor:[AppUtils colorWithHexString:@"fa6900"]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.layer.cornerRadius = 5;
    [rightButton addTarget:self action:@selector(submitAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    userInfoTB = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) style:UITableViewStyleGrouped];
    userInfoTB.dataSource =self;
    userInfoTB.delegate =self;
    [self.view addSubview:userInfoTB];
}

-(void)submitAction
{
    ChangePersonalInfoHandler *changeH =[ChangePersonalInfoHandler new];
    NSDictionary *dic;
    NSString *titleTempStr = [textF.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    if ([NSString isEmptyOrNull:textF.text])
    {
        [AppUtils showAlertMessageTimerClose:@"你还没输入数据呢"];
        return;
    }
    
    if (_nameOrNickname == NicknameEdit)
    {
               dic =[NSDictionary dictionaryWithObjectsAndKeys:
                            [UserManager shareManager].userModel.memberId,@"memberId",
                            titleTempStr,@"nickName",
                            nil];
    

    }
    else
    {
       dic =[NSDictionary dictionaryWithObjectsAndKeys:
                            [UserManager shareManager].userModel.memberId,@"memberId",
                            titleTempStr,@"realName",
                            nil];
    }
    
    [changeH ChangeInfo:dic success:^(id ChangeInfoObj) {
        
        [UserHandler executeGetUserInfoSuccess:^(id obj) {
            [AppUtils showSuccessMessage:ChangeInfoObj];
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(popToLastVC) userInfo:nil repeats:NO];

        } failed:^(id obj) {
            [AppUtils showSuccessMessage:ChangeInfoObj];
            [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(popToLastVC) userInfo:nil repeats:NO];
        }];

    } failed:^(id obj) {
        
        [AppUtils showErrorMessage:@"提交信息失败" isShow:self.viewIsVisible];
    }];

}
- (void)popToLastVC {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:textF];
}

- (void)textFiledEditChanged:(NSNotification*)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSUInteger kMaxLength = 10;
    [AppUtils textFieldLimitChinaMaxLength:kMaxLength
                               inTextField:textField];
}





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if (cell==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    textF =[[UITextField alloc]initWithFrame:CGRectMake(15, 0, IPHONE_WIDTH-30, 44)];
    textF.delegate=self;
    [textF becomeFirstResponder];
    if (_nameOrNickname == NicknameEdit)
    {
        if ([NSString isEmptyOrNull:[UserManager shareManager].userModel.nickName])
        {
            textF.placeholder=@"昵称";
        }
        else
        {
            textF.placeholder=[UserManager shareManager].userModel.nickName;
        }
        
    }
    else
    {
        if ([NSString isEmptyOrNull:[UserManager shareManager].userModel.realName])
        {
            textF.placeholder=@"姓名";
        }
        else
        {
            textF.placeholder=[UserManager shareManager].userModel.realName;
        }
        
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:textF];

    [cell.contentView addSubview:textF];
    return cell;
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
    int textLength =10;
   
    
    if (textField == textF)
    {
        if (![AppUtils isNotLanguageEmoji]) {
            return NO;
        }
        return range.location < textLength;
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
