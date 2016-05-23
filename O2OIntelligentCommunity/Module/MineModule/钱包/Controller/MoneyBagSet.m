//
//  MoneyBagSet.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoneyBagSet.h"
#import "UserManager.h"

#import "AlterMoneyPasswordVC.h"

//钱包信息获取接口
#import "MoneyBagInfoModel.h"
#import "MoneyBaginfoHandler.h"

//获取验证码接口类
#import "MessageHandler.h"


@interface MoneyBagSet ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation MoneyBagSet
{
    UITableView *moneysetTB;
    MoneyBagInfoModel *moneyinfoM;
    UITextField *nameF;
    UITextField *idcardF;
    UITextField *phineF;
    UITextField *paypasswordF;
    UIButton *getverificationcodeB;
    
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self getmonaybaginfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//获取钱包信息
-(void)getmonaybaginfo
{
    MoneyBagInfoModel *moneyM =[MoneyBagInfoModel new];
    MoneyBaginfoHandler *moneyH = [MoneyBaginfoHandler new];
    moneyM.memberId=[UserManager shareManager].userModel.memberId;
    
    [moneyH moneybaginfo:moneyM success:^(id obj) {
        moneyinfoM =(MoneyBagInfoModel *)obj;
        NSLog(@"name ==%@",moneyinfoM.name);
        [moneysetTB reloadData];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:self.viewIsVisible];
    }];
}

-(void)initUI
{
    self.title=@"钱包设置";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
    [rightButton setTitle:@"修改" forState:UIControlStateNormal];
    rightButton.layer.masksToBounds=YES;
    rightButton.layer.cornerRadius=5;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[AppUtils colorWithHexString:@"fa6900"]];
    [rightButton addTarget:self action:@selector(changeArr)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;

    moneysetTB = [[UITableView alloc]init];
    moneysetTB.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    moneysetTB.dataSource=self;
    moneysetTB.delegate=self;
    //moneysetTB.separatorStyle = UITableViewCellAccessoryNone;
    moneysetTB.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    moneysetTB.tableFooterView = [AppUtils tableViewsFooterView];
    [AppUtils tableViewsFooterView];
    [self.view addSubview:moneysetTB];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapselfviewArr:)];
    [self.view addGestureRecognizer:tap];
}

-(void)tapselfviewArr:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    
}




-(void)changeArr
{
    UIActionSheet *sctionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"修改支付密码" otherButtonTitles:nil, nil];
    sctionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sctionSheet showInView:self.view];

}

#pragma mark - UIActionSheet 代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        AlterMoneyPasswordVC *password =[[AlterMoneyPasswordVC alloc]init];
        password.isPasswordPage=ModificatoryPassword;
        [self.navigationController pushViewController:password animated:YES];
    }
}




#pragma mark - UITableView 代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 50;
            break;
        case 1:
            return 20;
            break;
            
        default:
            return 0;
            break;
    }
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    if (section==0)
    {
        headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 50);
        
        UILabel *lab =[[UILabel alloc]init];
        lab.numberOfLines=0;
        lab.font=[UIFont systemFontOfSize:14];
        lab.text=@"请如实填写以下信息，该信息将成为钱包的唯一标识。";
        CGSize titleSize = [lab.text boundingRectWithSize:CGSizeMake(IPHONE_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        lab.frame =CGRectMake(10, 0, titleSize.width, 50);
        [headView addSubview:lab];
        
    }
    else
    {
        
        headView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 25);
    }
    return headView;
}

//// 定义成方法方便多个label调用 增加代码的复用性
//- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size
//{
//    CGRect rect = [string boundingRectWithSize:CGSizeMake(size.width, size.height)//限制最大的宽度和高度
//                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
//                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
//                                       context:nil];
//    
//    return rect.size;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer =@"openmoneybagsetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.selectionStyle=UITableViewCellAccessoryNone;
    }
    CGRect fram =CGRectMake(100, (55-40)/2, IPHONE_WIDTH-130, 40);
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"姓       名：";
            nameF =[[UITextField alloc]initWithFrame:fram];
            nameF.text=moneyinfoM.name;
    
            nameF.enabled=NO;
            [cell.contentView addSubview:nameF];

        }
        else if (indexPath.row==1)
        {
            cell.textLabel.text=@"身份证号：";
            idcardF =[[UITextField alloc]initWithFrame:fram];
            if (moneyinfoM.idNumber.length==16)
            {
                idcardF.text=moneyinfoM.idNumber;
                
            }
            else if (moneyinfoM.idNumber.length==18)
            {
                 idcardF.text=moneyinfoM.idNumber;
            }
            
            idcardF.enabled=NO;
            [cell.contentView addSubview:idcardF];
        }
        else if (indexPath.row==2)
        {
            cell.textLabel.text=@"手  机  号：";
            
            phineF =[[UITextField alloc]initWithFrame:fram];
            phineF.text= [UserManager shareManager].userModel.phone;
            phineF.enabled=NO;
            [cell.contentView addSubview:phineF];

        }
        
    }
    else if (indexPath.section==1)
    {
        cell.textLabel.text=@"支付密码：";
        paypasswordF =[[UITextField alloc]initWithFrame:fram];
        paypasswordF.keyboardType = UIKeyboardTypeNumberPad;
        paypasswordF.secureTextEntry=YES;
        paypasswordF.text=@"******";
        paypasswordF.enabled=NO;
        [cell.contentView addSubview:paypasswordF];

    }
   
    
    return cell;

}






@end
