//
//  BillViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BillViewController.h"
#import "UserManager.h"
#import "NSString+wrapper.h"
#import "PaycostHandler.h"

@interface BillViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *footoView;

@end

@implementation BillViewController
{
    UITableView *TableView;
    NSArray *notMonthArr;
    NSArray *notAddressArr;
    NSArray *notMonthAddressArr;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

-(void)initData
{
    notMonthArr =[NSArray arrayWithObjects:@"订 单 号:",@"缴费项目:",@"缴费状态:",@"缴费金额:",@"收费单位:",@"用户编号:",@"帐号类型:",@"客户名称:",@"缴费地址:", nil];
    notAddressArr =[NSArray arrayWithObjects:@"订 单 号:",@"缴费项目:",@"缴费状态:",@"缴费金额:",@"所缴月份:",@"收费单位:",@"用户编号:",@"帐号类型:",@"客户名称:", nil];
    notMonthAddressArr =[NSArray arrayWithObjects:@"订 单 号:",@"缴费项目:",@"缴费状态:",@"缴费金额:",@"收费单位:",@"用户编号:",@"帐号类型:",@"客户名称:", nil];
}

-(void)initUI
{
    
    self.title=@"缴费详情";
    
    if (![NSString isEmptyOrNull:_payM.refund])
    {
        [self footoView];
    }
    
    TableView =[[UITableView alloc]init];
    TableView.frame=CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT+49);
    TableView.dataSource=self;
    TableView.delegate=self;
    TableView.backgroundColor=[AppUtils colorWithHexString:@"F7F7F7"];
     TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (![NSString isEmptyOrNull:_payM.refund])
    {
        
        TableView.tableFooterView = _footoView;
    }
    

    [self.view addSubview:TableView];
    [self setExtraCellLineHidden:TableView];
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    //[tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
}

#pragma make -Set/Get
-(UIView *)footoView
{
    if (_footoView == nil)
    {
        _footoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 150)];

        UILabel *liuyanLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, G_INTERVAL, IPHONE_WIDTH-G_INTERVAL_BIG*2, 50)];
        liuyanLab.text=[NSString stringWithFormat:@"客服留言：\n%@",_payM.refund];
        liuyanLab.numberOfLines=0;
        //liuyanLab.font=[UIFont systemFontOfSize:14];
        [_footoView addSubview:liuyanLab];
        CGSize labSize = [AppUtils sizeWithString:liuyanLab.text font:liuyanLab.font size:CGSizeMake(IPHONE_WIDTH-G_INTERVAL_BIG*2, 100)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            liuyanLab.frame=CGRectMake(G_INTERVAL_BIG, G_INTERVAL, IPHONE_WIDTH-G_INTERVAL_BIG*2, labSize.height);
            //liuyanLab.backgroundColor= [UIColor redColor];
        });
        
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame = CGRectMake(IPHONE_WIDTH-110, labSize.height+G_INTERVAL*2, 100, 35);
        [phoneBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
        //phoneBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [phoneBtn.layer setMasksToBounds:YES];
        [phoneBtn.layer setCornerRadius:5];
        [phoneBtn addTarget:self action:@selector(btnChickAction) forControlEvents:UIControlEventTouchUpInside];
        [_footoView addSubview:phoneBtn];

    
        

    }
    return _footoView;
}

-(void)btnChickAction
{
    [AppUtils callPhone:P_SERVICE_PHONE];
}

#pragma make - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_payM.type isEqualToString:@"S"] || [_payM.type isEqualToString:@"D"] ||[_payM.type isEqualToString:@"M"])
    {
        if ([NSString isEmptyOrNull:_payM.consumeCycle] && ![NSString isEmptyOrNull:_payM.address])
        {
             return notMonthArr.count;
        }
        else if (![NSString isEmptyOrNull:_payM.consumeCycle] && [NSString isEmptyOrNull:_payM.address])
        {
            return notAddressArr.count;
        }
        else if ([NSString isEmptyOrNull:_payM.consumeCycle] && [NSString isEmptyOrNull:_payM.address])
        {
            return notMonthAddressArr.count;
        }
        else
        {
            return 0;
        }
    }
    else if ([_payM.type isEqualToString:@"W"])
    {
        return 8;
    }
    else if ([_payM.type isEqualToString:@"J"])
    {
        if ([NSString isEmptyOrNull:_payM.poundage] || [_payM.poundage intValue] <= 0)
        {
            return 6;
        }
        else if ([NSString isEmptyOrNull:_payM.name])
        {
            return 6;
        }
        else
        {
            return 7;
        }
        
    }
    else if ([_payM.type isEqualToString:@"T"])
    {
        return 10;
    }
    else if ([_payM.type isEqualToString:@"H"])
    {
        return 6;
    }
    else
    {
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell ==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    
    NSLog(@"_payM.type=%@",_payM.type);
    if ([_payM.type isEqualToString:@"S"] || [_payM.type isEqualToString:@"D"] || [_payM.type isEqualToString:@"M"])
    {
        
        if ([NSString isEmptyOrNull:_payM.consumeCycle] && ![NSString isEmptyOrNull:_payM.address])
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[notMonthArr objectAtIndex:indexPath.section]];
            if (indexPath.section==0)
            {
                cell.textLabel.text=@"订  单  号:";
                UILabel *orderlab =[[UILabel alloc]init];
                orderlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 85, 30);
                orderlab.text=_payM.orderId;
                orderlab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:orderlab];
                
            }
            else if(indexPath.section ==1 )
            {
                cell.textLabel.text=@"缴费项目:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, 100, 30);
                namelab.textColor=[UIColor grayColor];
                namelab.textAlignment=NSTextAlignmentLeft;
                if ([_payM.type isEqualToString:@"S"])
                {
                    namelab.text=@"水费";
                }
                else if ([_payM.type isEqualToString:@"D"])
                {
                    namelab.text =@"电费";
                }
                else if ([_payM.type isEqualToString:@"M"])
                {
                    namelab.text=@"燃气费";
                }
                [cell.contentView addSubview:namelab];
            }
            else if(indexPath.section==2)
            {
                cell.textLabel.text=@"缴费状态:";
                UILabel *statuslab =[[UILabel alloc]init];
                statuslab.frame=CGRectMake(100, 7, 80, 30);
                statuslab.text=_payM.statusCN;
                statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                [cell.contentView addSubview:statuslab];
                
                UILabel *timelab =[[UILabel alloc]init];
                timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
                timelab.font=[UIFont systemFontOfSize:12];
                timelab.text=_payM.updateTime;
                timelab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:timelab];
            }
            else if(indexPath.section==3)
            {
                cell.textLabel.text=@"缴费金额:";
                
                UILabel *moneylab =[[UILabel alloc]init];
                moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                moneylab.text=[NSString stringWithFormat:@"%@元",_payM.saleAmount];
                [cell.contentView addSubview:moneylab];
            }
            else if (indexPath.section==4)
            {
                cell.textLabel.text=@"收费单位:";
                
                UILabel *unitlab =[[UILabel alloc]init];
                unitlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                unitlab.textColor=[UIColor grayColor];
                unitlab.text=_payM.chargeUnit;
                [cell.contentView addSubview:unitlab];
            }
            else if (indexPath.section==5)
            {
                cell.textLabel.text=@"用户编号:";
                UILabel *userlab =[[UILabel alloc]init];
                userlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                userlab.textColor=[UIColor grayColor];
                userlab.text=_payM.userNumber;
                [cell.contentView addSubview:userlab];
            }
            else if (indexPath.section==6) {
                cell.textLabel.text=@"账号类型:";
                UILabel *typeL =[[UILabel alloc]init];
                typeL.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                typeL.textColor=[UIColor grayColor];
                
                if (![NSString isEmptyOrNull:_payM.preapidFlag] && [_payM.preapidFlag isEqualToString:@"1"]) {
                    typeL.text= @"预付费";
                }
                else {
                    typeL.text= @"后付费";
                }
                
                [cell.contentView addSubview:typeL];
            }
            else if (indexPath.section==7)
            {
                cell.textLabel.text=@"客户名称:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                namelab.textColor=[UIColor grayColor];
                //namelab.text=[UserManager shareManager].userModel.nickName;
                namelab.text=_payM.name;
                [cell.contentView addSubview:namelab];
            }
            else if (indexPath.section==8)
            {
                cell.textLabel.text=@"缴费地址:";
                UILabel *addresslab =[[UILabel alloc]init];
                addresslab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                addresslab.textColor=[UIColor grayColor];
                
                if (![NSString isEmptyOrNull:_payM.address]) {
                    addresslab.text=[NSString stringWithFormat:@"%@",_payM.address];
                }
                
                [cell.contentView addSubview:addresslab];
                
            }

        }
        else if (![NSString isEmptyOrNull:_payM.consumeCycle] && [NSString isEmptyOrNull:_payM.address])
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[notAddressArr objectAtIndex:indexPath.section]];
            
            if (indexPath.section==0)
            {
                cell.textLabel.text=@"订  单  号:";
                UILabel *orderlab =[[UILabel alloc]init];
                orderlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 85, 30);
                orderlab.text=_payM.orderId;
                orderlab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:orderlab];
                
            }
            else if(indexPath.section ==1 )
            {
                cell.textLabel.text=@"缴费项目:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, 100, 30);
                namelab.textColor=[UIColor grayColor];
                namelab.textAlignment=NSTextAlignmentLeft;
                if ([_payM.type isEqualToString:@"S"])
                {
                    namelab.text=@"水费";
                }
                else if ([_payM.type isEqualToString:@"D"])
                {
                    namelab.text =@"电费";
                }
                else if ([_payM.type isEqualToString:@"M"])
                {
                    namelab.text=@"燃气费";
                }
                [cell.contentView addSubview:namelab];
            }
            else if(indexPath.section==2)
            {
                cell.textLabel.text=@"缴费状态:";
                UILabel *statuslab =[[UILabel alloc]init];
                statuslab.frame=CGRectMake(100, 7, 80, 30);
                statuslab.text=_payM.statusCN;
                statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                [cell.contentView addSubview:statuslab];
                
                UILabel *timelab =[[UILabel alloc]init];
                timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
                timelab.font=[UIFont systemFontOfSize:12];
                timelab.text=_payM.updateTime;
                timelab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:timelab];
            }
            else if(indexPath.section==3)
            {
                cell.textLabel.text=@"缴费金额:";
                
                UILabel *moneylab =[[UILabel alloc]init];
                moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                moneylab.text=[NSString stringWithFormat:@"%@元",_payM.saleAmount];
                [cell.contentView addSubview:moneylab];
            }
            else if (indexPath.section==4)
            {
                cell.textLabel.text=@"所缴月份:";
                
                UILabel *monthlab =[[UILabel alloc]init];
                monthlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                monthlab.textColor=[UIColor grayColor];
                if (![NSString isEmptyOrNull:_payM.consumeCycle]) {
                    monthlab.text=[NSString stringWithFormat:@"%@",_payM.consumeCycle];
                }
                
                [cell.contentView addSubview:monthlab];
                
            }
            else if (indexPath.section==5)
            {
                cell.textLabel.text=@"收费单位:";
                
                UILabel *unitlab =[[UILabel alloc]init];
                unitlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                unitlab.textColor=[UIColor grayColor];
                unitlab.text=_payM.chargeUnit;
                [cell.contentView addSubview:unitlab];
            }
            else if (indexPath.section==6)
            {
                cell.textLabel.text=@"用户编号:";
                UILabel *userlab =[[UILabel alloc]init];
                userlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                userlab.textColor=[UIColor grayColor];
                userlab.text=_payM.userNumber;
                [cell.contentView addSubview:userlab];
            }
            else if (indexPath.section==7) {
                cell.textLabel.text=@"账号类型:";
                UILabel *typeL =[[UILabel alloc]init];
                typeL.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                typeL.textColor=[UIColor grayColor];
                
                if (![NSString isEmptyOrNull:_payM.preapidFlag] && [_payM.preapidFlag isEqualToString:@"1"]) {
                    typeL.text= @"预付费";
                }
                else {
                    typeL.text= @"后付费";
                }
                
                [cell.contentView addSubview:typeL];
            }
            else if (indexPath.section==8)
            {
                cell.textLabel.text=@"客户名称:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                namelab.textColor=[UIColor grayColor];
                //namelab.text=[UserManager shareManager].userModel.nickName;
                namelab.text=_payM.name;
                [cell.contentView addSubview:namelab];
            }
            
        }
        else if ([NSString isEmptyOrNull:_payM.consumeCycle] && [NSString isEmptyOrNull:_payM.address])
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[notMonthAddressArr objectAtIndex:indexPath.section]];
            if (indexPath.section==0)
            {
                cell.textLabel.text=@"订  单  号:";
                UILabel *orderlab =[[UILabel alloc]init];
                orderlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 85, 30);
                orderlab.text=_payM.orderId;
                orderlab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:orderlab];
                
            }
            else if(indexPath.section ==1 )
            {
                cell.textLabel.text=@"缴费项目:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, 100, 30);
                namelab.textColor=[UIColor grayColor];
                namelab.textAlignment=NSTextAlignmentLeft;
                if ([_payM.type isEqualToString:@"S"])
                {
                    namelab.text=@"水费";
                }
                else if ([_payM.type isEqualToString:@"D"])
                {
                    namelab.text =@"电费";
                }
                else if ([_payM.type isEqualToString:@"M"])
                {
                    namelab.text=@"燃气费";
                }
                [cell.contentView addSubview:namelab];
            }
            else if(indexPath.section==2)
            {
                cell.textLabel.text=@"缴费状态:";
                UILabel *statuslab =[[UILabel alloc]init];
                statuslab.frame=CGRectMake(100, 7, 80, 30);
                statuslab.text=_payM.statusCN;
                statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                [cell.contentView addSubview:statuslab];
                
                UILabel *timelab =[[UILabel alloc]init];
                timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
                timelab.font=[UIFont systemFontOfSize:12];
                timelab.text=_payM.updateTime;
                timelab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:timelab];
            }
            else if(indexPath.section==3)
            {
                cell.textLabel.text=@"缴费金额:";
                
                UILabel *moneylab =[[UILabel alloc]init];
                moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                moneylab.text=[NSString stringWithFormat:@"%@元",_payM.saleAmount];
                [cell.contentView addSubview:moneylab];
            }
            else if (indexPath.section==4)
            {
                cell.textLabel.text=@"收费单位:";
                
                UILabel *unitlab =[[UILabel alloc]init];
                unitlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                unitlab.textColor=[UIColor grayColor];
                unitlab.text=_payM.chargeUnit;
                [cell.contentView addSubview:unitlab];
            }
            else if (indexPath.section==5)
            {
                cell.textLabel.text=@"用户编号:";
                UILabel *userlab =[[UILabel alloc]init];
                userlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                userlab.textColor=[UIColor grayColor];
                userlab.text=_payM.userNumber;
                [cell.contentView addSubview:userlab];
            }
            else if (indexPath.section==6) {
                cell.textLabel.text=@"账号类型:";
                UILabel *typeL =[[UILabel alloc]init];
                typeL.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                typeL.textColor=[UIColor grayColor];
                
                if (![NSString isEmptyOrNull:_payM.preapidFlag] && [_payM.preapidFlag isEqualToString:@"1"]) {
                    typeL.text= @"预付费";
                }
                else {
                    typeL.text= @"后付费";
                }
                
                [cell.contentView addSubview:typeL];
            }
            else if (indexPath.section==7)
            {
                cell.textLabel.text=@"客户名称:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                namelab.textColor=[UIColor grayColor];
                //namelab.text=[UserManager shareManager].userModel.nickName;
                namelab.text=_payM.name;
                [cell.contentView addSubview:namelab];
            }
           
        }

        
    }
    else if ([_payM.type isEqualToString:@"W"])
    {
        if (indexPath.section==0)
        {
            cell.textLabel.text=@"订  单  号:";
            
            UILabel *orderlab =[[UILabel alloc]init];
            orderlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 85, 30);
            orderlab.text=_payM.orderId;
            orderlab.textColor=[UIColor grayColor];
            [cell.contentView addSubview:orderlab];
            
        }
        else if(indexPath.section ==1 )
        {
            cell.textLabel.text=@"缴费项目:";
            
            UILabel *namelab =[[UILabel alloc]init];
            namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            namelab.textColor=[UIColor grayColor];
            namelab.text=@"物业费";
            [cell.contentView addSubview:namelab];
        }
        else if(indexPath.section==2)
        {
            cell.textLabel.text=@"缴费状态:";
            UILabel *statuslab =[[UILabel alloc]init];
            statuslab.frame=CGRectMake(100, 7, 80, 30);
            statuslab.text=_payM.statusCN;
            statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
            [cell.contentView addSubview:statuslab];
            
            UILabel *timelab =[[UILabel alloc]init];
            timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 190, 30);
            timelab.font=[UIFont systemFontOfSize:12];
            timelab.text=_payM.updateTime;
            timelab.textColor=[UIColor grayColor];
            [cell.contentView addSubview:timelab];
        }
        else if(indexPath.section==3)
        {
            cell.textLabel.text=@"缴费金额:";
            
            UILabel *moneylab =[[UILabel alloc]init];
            moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
            moneylab.text=[NSString stringWithFormat:@"%@元",_payM.saleAmount];
            [cell.contentView addSubview:moneylab];
        }
        else if (indexPath.section==4)
        {
            cell.textLabel.text=@"所缴月份:";
            
            UILabel *monthlab =[[UILabel alloc]init];
            monthlab.frame=CGRectMake(100, 7,IPHONE_WIDTH -  100, 30);
            monthlab.textColor=[UIColor grayColor];
            monthlab.text=[NSString stringWithFormat:@"%@",_payM.consumeCycle];
            [cell.contentView addSubview:monthlab];
        }
        else if (indexPath.section==5)
        {
            cell.textLabel.text=@"收费单位:";
            
            UILabel *unitlab =[[UILabel alloc]init];
            unitlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            unitlab.textColor=[UIColor grayColor];
            unitlab.text=_payM.chargeUnit;
            [cell.contentView addSubview:unitlab];
        }
        else if (indexPath.section==6)
        {
            cell.textLabel.text=@"客户名称:";
            
            UILabel *namelab =[[UILabel alloc]init];
            namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            namelab.textColor=[UIColor grayColor];
            //namelab.text=[UserManager shareManager].userModel.nickName;
            namelab.text=_payM.name;
            [cell.contentView addSubview:namelab];
        }
        else if (indexPath.section==7)
        {
            cell.textLabel.text=@"客户地址:";
            UILabel *addresslab =[[UILabel alloc]init];
            addresslab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            addresslab.textColor=[UIColor grayColor];
            addresslab.text=[NSString stringWithFormat:@"%@",_payM.address];
            [cell.contentView addSubview:addresslab];
            
        }

        
    }
    else if ([_payM.type isEqualToString:@"T"])
    {
        if (indexPath.section==0)
        {
            cell.textLabel.text=@"订  单  号:";
            
            UILabel *orderlab =[[UILabel alloc]init];
            orderlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 85, 30);
            orderlab.text=_payM.orderId;
            orderlab.textColor=[UIColor grayColor];
            [cell.contentView addSubview:orderlab];
            
        }
        else if(indexPath.section ==1 )
        {
            cell.textLabel.text=@"缴费项目:";
            
            UILabel *namelab =[[UILabel alloc]init];
            namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            namelab.textColor=[UIColor grayColor];
            namelab.text=@"停车费";
            [cell.contentView addSubview:namelab];
        }
        else if(indexPath.section==2)
        {
            cell.textLabel.text=@"缴费状态:";
            UILabel *statuslab =[[UILabel alloc]init];
            statuslab.frame=CGRectMake(100, 7, 80, 30);
            statuslab.text=_payM.statusCN;
            statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
            [cell.contentView addSubview:statuslab];
            
            UILabel *timelab =[[UILabel alloc]init];
            timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
            timelab.font=[UIFont systemFontOfSize:12];
            timelab.text=_payM.updateTime;
            timelab.textColor=[UIColor grayColor];
            [cell.contentView addSubview:timelab];
        }
        else if(indexPath.section==3)
        {
            cell.textLabel.text=@"缴费金额:";
            
            UILabel *moneylab =[[UILabel alloc]init];
            moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
            moneylab.text=[NSString stringWithFormat:@"%@元",_payM.saleAmount];
            [cell.contentView addSubview:moneylab];
        }
        else if (indexPath.section==4)
        {
            cell.textLabel.text=@"所缴时长:";
            
            UILabel *monthlab =[[UILabel alloc]init];
            monthlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            monthlab.textColor=[UIColor grayColor];
            monthlab.text=[NSString stringWithFormat:@"%@个月",_payM.payMonths];
            [cell.contentView addSubview:monthlab];
            
        }
        else if (indexPath.section==5)
        {
            cell.textLabel.text=@"收费单位:";
            
            UILabel *unitlab =[[UILabel alloc]init];
            unitlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            unitlab.textColor=[UIColor grayColor];
            unitlab.text=_payM.chargeUnit;
            [cell.contentView addSubview:unitlab];
        }
        else if (indexPath.section==6)
        {
            cell.textLabel.text=@"车库类型:";
            UILabel *userlab =[[UILabel alloc]init];
            userlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            userlab.textColor=[UIColor grayColor];
            userlab.text=_payM.parkingType;
            [cell.contentView addSubview:userlab];
        }
        else if (indexPath.section==7)
        {
            cell.textLabel.text=@"车牌号码:";
            
            UILabel *namelab =[[UILabel alloc]init];
            namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            namelab.textColor=[UIColor grayColor];
            namelab.text=_payM.licenseNumber;
            [cell.contentView addSubview:namelab];
        }
        else if (indexPath.section==8)
        {
            cell.textLabel.text=@"车主名称:";
            UILabel *addresslab =[[UILabel alloc]init];
            addresslab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            addresslab.textColor=[UIColor grayColor];
            //addresslab.text=[UserManager shareManager].userModel.nickName;
            addresslab.text=_payM.name;
            [cell.contentView addSubview:addresslab];
            
        }

        else if (indexPath.section==9)
        {
            cell.textLabel.text=@"住户地址:";
            UILabel *addresslab =[[UILabel alloc]init];
            addresslab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            addresslab.textColor=[UIColor grayColor];
            addresslab.text=[NSString stringWithFormat:@"%@",_payM.address];
            [cell.contentView addSubview:addresslab];
        }

        
    }
    else if ([_payM.type isEqualToString:@"H"])
    {
        if (indexPath.section==0)
        {
            cell.textLabel.text=@"订  单  号:";
            
            UILabel *orderlab =[[UILabel alloc]init];
            orderlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 85, 30);
            orderlab.text=_payM.orderId;
            orderlab.textColor=[UIColor grayColor];
            [cell.contentView addSubview:orderlab];
            
        }
        else if(indexPath.section ==1 )
        {
            cell.textLabel.text=@"缴费项目:";
            
            UILabel *namelab =[[UILabel alloc]init];
            namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            namelab.textColor=[UIColor grayColor];
            namelab.text=@"话费充值";
            [cell.contentView addSubview:namelab];
        }
        else if(indexPath.section==2)
        {
            cell.textLabel.text=@"缴费状态:";
            UILabel *statuslab =[[UILabel alloc]init];
            statuslab.frame=CGRectMake(100, 7, 80, 30);
            statuslab.text=_payM.statusCN;
            statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
            [cell.contentView addSubview:statuslab];
            
            UILabel *timelab =[[UILabel alloc]init];
            timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
            timelab.font=[UIFont systemFontOfSize:12];
            timelab.text=_payM.updateTime;
            timelab.textColor=[UIColor grayColor];
            [cell.contentView addSubview:timelab];
        }
        else if(indexPath.section==3)
        {
            cell.textLabel.text=@"充值金额:";
            
            UILabel *moneylab =[[UILabel alloc]init];
            moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
            moneylab.text=[NSString stringWithFormat:@"%@元",_payM.saleAmount];
            [cell.contentView addSubview:moneylab];
        }
        else if (indexPath.section==4)
        {
            cell.textLabel.text=@"实付金额:";
            
            UILabel *monthlab =[[UILabel alloc]init];
            monthlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            monthlab.textColor=[UIColor grayColor];
            monthlab.text=[NSString stringWithFormat:@"%@元",_payM.payAmount];
            [cell.contentView addSubview:monthlab];
            
        }
        else if (indexPath.section==5)
        {
            cell.textLabel.text=@"充值手机:";
            
            UILabel *unitlab =[[UILabel alloc]init];
            unitlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
            unitlab.textColor=[UIColor grayColor];
            unitlab.text=_payM.usernumber;
            [cell.contentView addSubview:unitlab];
        }
        
    }
    else if ([_payM.type isEqualToString:@"J"])
    {
        
        
        if ([NSString isEmptyOrNull:_payM.poundage] || [_payM.poundage intValue] <= 0)
        {
            if (indexPath.section==0)
            {
                cell.textLabel.text=@"订  单  号:";
                
                UILabel *orderlab =[[UILabel alloc]init];
                [orderlab setNumberOfLines:0];
                orderlab.font=[UIFont systemFontOfSize:14];
                orderlab.text=_payM.orderId;
                orderlab.frame=CGRectMake(100, 5, IPHONE_WIDTH - 100, 30);
                orderlab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:orderlab];
                
            }
            else if(indexPath.section ==1 )
            {
                cell.textLabel.text=@"缴费项目:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                namelab.textColor=[UIColor grayColor];
                namelab.text=@"交通罚款";
                [cell.contentView addSubview:namelab];
            }
            else if(indexPath.section==2)
            {
                cell.textLabel.text=@"缴费状态:";
                UILabel *statuslab =[[UILabel alloc]init];
                statuslab.frame=CGRectMake(100, 7, 80, 30);
                statuslab.text=_payM.statusCN;
                statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                [cell.contentView addSubview:statuslab];
                
                UILabel *timelab =[[UILabel alloc]init];
                timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
                timelab.font=[UIFont systemFontOfSize:12];
                timelab.text=_payM.updateTime;
                timelab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:timelab];
            }
            else if(indexPath.section==3)
            {
                cell.textLabel.text=@"缴费金额:";
                
                UILabel *moneylab =[[UILabel alloc]init];
                moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                moneylab.text=[NSString stringWithFormat:@"%@元",_payM.money];
                [cell.contentView addSubview:moneylab];
            }
            else if (indexPath.section==4)
            {
                
                cell.textLabel.text=@"车牌号码:";
                
                UILabel *monthlab =[[UILabel alloc]init];
                monthlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                monthlab.textColor=[UIColor grayColor];
                monthlab.text=_payM.carnumber;
                [cell.contentView addSubview:monthlab];
            }
            else if (indexPath.section==5)
            {
                cell.textLabel.text=@"车主名称:";
                UILabel *addresslab =[[UILabel alloc]init];
                addresslab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                addresslab.textColor=[UIColor grayColor];
                //addresslab.text=[UserManager shareManager].userModel.nickName;
                addresslab.text=_payM.name;
                [cell.contentView addSubview:addresslab];
                
            }

        }
        else
        {
            if (indexPath.section==0)
            {
                cell.textLabel.text=@"订  单  号:";
                
                UILabel *orderlab =[[UILabel alloc]init];
                [orderlab setNumberOfLines:0];
                orderlab.font=[UIFont systemFontOfSize:14];
                orderlab.text=_payM.orderId;
                orderlab.frame=CGRectMake(100, 5, IPHONE_WIDTH - 100, 30);
                orderlab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:orderlab];
                
            }
            else if(indexPath.section ==1 )
            {
                cell.textLabel.text=@"缴费项目:";
                
                UILabel *namelab =[[UILabel alloc]init];
                namelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                namelab.textColor=[UIColor grayColor];
                namelab.text=@"交通罚款";
                [cell.contentView addSubview:namelab];
            }
            else if(indexPath.section==2)
            {
                cell.textLabel.text=@"缴费状态:";
                UILabel *statuslab =[[UILabel alloc]init];
                statuslab.frame=CGRectMake(100, 7, 80, 30);
                statuslab.text=_payM.statusCN;
                statuslab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                [cell.contentView addSubview:statuslab];
                
                UILabel *timelab =[[UILabel alloc]init];
                timelab.frame=CGRectMake(180, 7, IPHONE_WIDTH - 180, 30);
                timelab.font=[UIFont systemFontOfSize:12];
                timelab.text=_payM.updateTime;
                timelab.textColor=[UIColor grayColor];
                [cell.contentView addSubview:timelab];
            }
            else if(indexPath.section==3)
            {
                cell.textLabel.text=@"手续费:";
                
                UILabel *shouxufelab =[[UILabel alloc]init];
                shouxufelab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                shouxufelab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                shouxufelab.text=[NSString stringWithFormat:@"%@元",_payM.poundage];
                [cell.contentView addSubview:shouxufelab];

            }
            else if (indexPath.section==4)
            {
                cell.textLabel.text=@"缴费金额:";
                
                UILabel *moneylab =[[UILabel alloc]init];
                moneylab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                moneylab.textColor=[AppUtils colorWithHexString:@"FD6900"];
                moneylab.text=[NSString stringWithFormat:@"%@元",_payM.count];
                [cell.contentView addSubview:moneylab];

            }
            else if (indexPath.section==5)
            {
                cell.textLabel.text=@"车牌号码:";
                
                UILabel *monthlab =[[UILabel alloc]init];
                monthlab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                monthlab.textColor=[UIColor grayColor];
                monthlab.text=_payM.carnumber;
                [cell.contentView addSubview:monthlab];
            }
            else if (indexPath.section==6)
            {
                cell.textLabel.text=@"车主名称:";
                UILabel *addresslab =[[UILabel alloc]init];
                addresslab.frame=CGRectMake(100, 7, IPHONE_WIDTH - 100, 30);
                addresslab.textColor=[UIColor grayColor];
                //addresslab.text=[UserManager shareManager].userModel.nickName;
                addresslab.text=_payM.name;
                [cell.contentView addSubview:addresslab];

            }
        }
    }
    return cell;
}
@end
