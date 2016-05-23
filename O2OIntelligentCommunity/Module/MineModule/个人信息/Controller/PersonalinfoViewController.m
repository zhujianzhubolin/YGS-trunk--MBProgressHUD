//
//  PersonalinfoViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PersonalinfoViewController.h"
#import "ChangePasswordViewController.h"
#import "NSData+wrapper.h"
#import "SVProgressHUD.h"
#import "UserManager.h"
#import "UIImage+wrapper.h"
#import <UIImageView+AFNetworking.h>
#import "UserAccoutInfoVC.h"
//#import "AddNewAdress.h"
#import "ManagerAdress.h"

//上传图像接口类
#import "ComplaintHandler.h"
#import "FilePostE.h"
//保存用户消息接口类
#import "ChangePersonalInfoHandler.h"
#import "ChangePersonalInfoModel.h"
#import "UserEntity.h"
#import "UserHandler.h"

@implementation PersonalinfoViewController
{
    NSArray *nameArray;
    
    //图片上传后返回的图片ID
    NSMutableString *imgIDStr;
    NSMutableArray *postImgArr;
    NSMutableArray *imageArray;
    
    UIImageView *heldImg;//头像
    
    UITextField *nicknameField;
    UITextField *phoneField;
    UITextField *nameField;
    UILabel     *roleLabe;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    imgIDStr =[[NSMutableString alloc]init];
    postImgArr=[[NSMutableArray alloc]init];
    imageArray=[NSMutableArray array];
    
    
    self.title=@"个人信息";
    self.view.backgroundColor=[UIColor whiteColor];
        
    nameArray  =[[NSArray alloc]initWithObjects:@"头      像",@"昵      称",@"手  机 号",@"姓      名",@"角      色",@"修改密码", nil];
    
    [self initUI];
    [self refreshAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    [self refreshAction];
}


-(void)initUI
{
    _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _TableView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    // _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_TableView];
    [self setExtraCellLineHidden:_TableView];
    [self viewDidLayoutSubviewsForTableView:_TableView];
}

-(void)refreshAction
{
    UILabel *nickLab =[_TableView viewWithTag:555];
    nickLab.text=[UserManager shareManager].userModel.nickName;
    
    
    UILabel *nameLab =[_TableView viewWithTag:556];
    nameLab.text =[UserManager shareManager].userModel.realName;
    
}

//提交action
-(void)submitArr
{
    
    [AppUtils showProgressMessage:@"保存中"];
//    [self.view endEditing:YES];
//    
//    NSString * tempStr = [nicknameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString * nameStr = [nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    
//    if (tempStr.length <= 0) {
//        [AppUtils showAlertMessageTimerClose:@"昵称不能为空"];
//        return;
//    }
//    if (nameStr.length <= 0)
//    {
//        [AppUtils showAlertMessageTimerClose:@"姓名不能为空"];
//        return;
//    }
    
    //ChangePersonalInfoModel *changeM =[ChangePersonalInfoModel new];
    ChangePersonalInfoHandler *changeH =[ChangePersonalInfoHandler new];
//    changeM.memberId=[UserManager shareManager].userModel.memberId;
//    changeM.fileId =(long)[imgIDStr longLongValue];
    
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        [UserManager shareManager].userModel.memberId,@"memberId",
                    
                        [NSString stringWithFormat:@"%ld",(long)[imgIDStr longLongValue]],@"fileId",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    
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

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}

#pragma mark - UITableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 6;
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 10;
            break;
        case 3:
            return 10;
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 55;
    }
    else
        return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    if(cell == nil)
    {
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.textLabel.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    if (indexPath.section == 0)
    {
        
        cell.textLabel.text=@"头      像";
        
        heldImg = [[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-75, 2.5, 50, 50)];
        heldImg.layer.cornerRadius = heldImg.frame.size.height / 2;
        heldImg.layer.masksToBounds = YES;
        NSLog(@"[UserManager shareManager].userModel.photoUrl=%@",[UserManager shareManager].userModel.photoUrl);
        [heldImg setImageWithURL:[NSURL URLWithString:[UserManager shareManager].userModel.photoUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        [cell addSubview:heldImg];
        
        
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row ==0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"昵      称";
            UILabel *nicknameLAb;
            nicknameLAb =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-230, 0, 200, 50)];
            nicknameLAb.tag=555;
            nicknameLAb.textAlignment=NSTextAlignmentRight;
            nicknameLAb.textColor=[UIColor grayColor];
            nicknameLAb.text =[UserManager shareManager].userModel.nickName;
            [cell addSubview:nicknameLAb];
            
        }
        else if(indexPath.row ==1)
        {
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"手 机 号";
            
            phoneField =[[UITextField alloc]init];
            phoneField.frame=CGRectMake(self.view.frame.size.width-230, 0, 200, 50);
            phoneField.textAlignment=NSTextAlignmentRight;
            phoneField.textColor=[UIColor grayColor];
            phoneField.enabled=NO;
            phoneField.text=[UserManager shareManager].userModel.phone;
            [cell addSubview:phoneField];
        }
        else if (indexPath.row ==2)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"姓      名";
            
            UILabel *nameLAb =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-230, 0, 200, 50)];
            nameLAb.tag=556;
            nameLAb.textColor=[UIColor grayColor];
            nameLAb.textAlignment=NSTextAlignmentRight;
            if ([NSString isEmptyOrNull:[UserManager shareManager].userModel.realName]) {
                nameLAb.text=@"";
            }
            else
            {
                nameLAb.text=[UserManager shareManager].userModel.realName;
            }

            [cell addSubview:nameLAb];
            
        }
        else if (indexPath.row ==3)
        {
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"角      色";
            
            roleLabe =[[UILabel alloc]init];
            roleLabe.frame=CGRectMake(self.view.frame.size.width-230, 0, 200, 50);
            roleLabe.textAlignment=NSTextAlignmentRight;
            roleLabe.textColor=[UIColor grayColor];
            roleLabe.enabled=NO;
            if ([UserManager shareManager].isBinding) {
                roleLabe.text = @"小区住户";
            }
            else {
                roleLabe.text = @"正式用户";
            }
            [cell addSubview:roleLabe];
            
            
        }

    }
    else if (indexPath.section ==2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=@"收货地址";
    }
    else if (indexPath.section==3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=@"修改登录密码";
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            [self.view endEditing:YES];
            [[GetImgFromSystem getImgInstance]getImgFromVC:self];
            [GetImgFromSystem getImgInstance].delegate = self;
            [GetImgFromSystem getImgInstance].maxCount = 1;
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            UserAccoutInfoVC *userInfoVc =[[UserAccoutInfoVC alloc]init];
            userInfoVc.nameOrNickname=NicknameEdit;
            [self.navigationController pushViewController:userInfoVc animated:YES];
        }
        else if (indexPath.row==2)
        {
            UserAccoutInfoVC *userInfoVc =[[UserAccoutInfoVC alloc]init];
            userInfoVc.nameOrNickname=NameEdit;
            [self.navigationController pushViewController:userInfoVc animated:YES];
        }

    }
    else if (indexPath.section ==2)
    {
//        AddNewAdress *adress =[[AddNewAdress alloc]init];
//        adress.ismine=YES;
//        [self.navigationController pushViewController:adress animated:YES];
        ManagerAdress * adress = [[ManagerAdress alloc] init];
        adress.title=@"收货地址";
        [self.navigationController pushViewController:adress animated:YES];

    }
    else if (indexPath.section==3)
    {
        ChangePasswordViewController *ChangePassword =[[ChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:ChangePassword animated:YES];
    }
}

#pragma mark - GetImgFromSystemDelegate
- (void)getFromImg:(NSArray *)imgArr
{
    UIImage *img = [UIImage imageNamed:@"touxiang"];
    if (imgArr.count > 0) {
        img = imgArr[0];
    }
    
    ComplaintHandler *complainH = [ComplaintHandler new];
    FilePostE *imgPost = [FilePostE new];
    imgPost.dataD = [NSString encodeBase64Data:[NSData dataTransformUnder1MFromImg:img]];
    imgPost.entityType=@"USERPHOTO";
    imgPost.fileName = [NSString stringWithFormat:@"用户头像%@.png",[[AppUtils currentDate] trim]];
    
    [AppUtils showProgressMessage:@"上传中"];
    [complainH excuteImgPostTask:imgPost success:^(id obj) {
        FilePostE *fileE = (FilePostE *)obj;
        [imgIDStr appendFormat:@"%@,",fileE.idID];
        [postImgArr insertObject:img atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            heldImg.image =img;
        });
        [self submitArr];
        [AppUtils showSuccessMessage:@"上传成功"];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:@"上传失败" isShow:self.viewIsVisible];
    }];
    
}



@end