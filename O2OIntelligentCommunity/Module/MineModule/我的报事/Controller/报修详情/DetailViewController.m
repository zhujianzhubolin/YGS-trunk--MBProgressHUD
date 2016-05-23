//
//  DetailViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell.h"
#import "WebImage.h"
#import "MultiShowing.h"
#import "ZJWebProgrssView.h"


#import "DetailCommentCell.h"
#import "UserManager.h"

#import "BaoXiuTouShuHandler.h"
#import "BXTSCommentsModel.h"


#import <UIImageView+AFNetworking.h>

@implementation DetailViewController
{
    
    NSArray *NameArray;//投诉name
    NSArray *BaoXiuNameArray;//报修neme
    NSArray *statusArray;//状态图片
    
    NSArray *commentArray;
    
    
    UIImageView *conmentimgView;
    
    MultiShowing *multShow;
    UIImageView *backimgV;
    
    ZJWebProgrssView *progressV;
    BaoXiuTouShuHandler *bxtsH;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航栏文字颜色
    
    self.view.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
    self.navigationController.navigationBar.translucent=YES;
    
    bxtsH = [BaoXiuTouShuHandler new];
    
    NameArray = [[NSArray alloc]initWithObjects:@"投诉日期:",@"投诉类型:",@"投诉单号:",@"投诉地址:",@"投诉小区:",@"投 诉 人:",@"联系电话:", nil];
    BaoXiuNameArray = [[NSArray alloc]initWithObjects:@"报修日期:",@"报修类型:",@"报修单号:",@"报修地址:",@"报修小区:",@"报 修 人:",@"联系电话:", nil];
    statusArray =[[NSArray alloc]initWithObjects:@"status1",@"status2",@"status3",@"status4", nil];
    
    if([_isbaoxiuComplaint isEqualToString:@"1"])
    {
        self.title=@"我的报修详情";
    }
    else if ([_isbaoxiuComplaint isEqualToString:@"2"])
    {
        self.title=@"我的投诉详情";
    }
        
    
    [self initUI];
    //请求报修或者投诉的评论列表
    [progressV startAnimation];
    [self BXTSCommentList];
}

-(void)initUI
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UILabel * stateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 40)];
    stateLab.text=@"处理状态:";
    [headView addSubview:stateLab];
    
    
    UILabel * stateLab1 = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 80, 40)];
    
    stateLab1.textColor=[AppUtils colorWithHexString:@"009AD8"];
    NSString *StatusStr = [NSString stringWithFormat:@"%@",self.bxtsM.complaintStatus];
    NSLog(@"StatusStr==%@",StatusStr);
    
    if ([StatusStr isEqualToString:@"0"])
    {
        stateLab1.text=@"等待处理";
    }
    else if ([StatusStr isEqualToString:@"1"])
    {
       stateLab1.text=@"处理中";
    }
    else if ([StatusStr isEqualToString:@"2"])
    {
        stateLab1.text=@"处理完成";
    }
    [headView addSubview:stateLab1];
    

    _TabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _TabView.dataSource = self;
    _TabView.delegate = self;
    _TabView.showsVerticalScrollIndicator=NO;
    _TabView.tableHeaderView=headView;
    _TabView.separatorStyle = UITableViewCellAccessoryNone;
    _TabView.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    [self.view addSubview:_TabView];
    [self setInfoTabFooter];
    
    CGFloat interval = 10;
    backimgV =[[UIImageView alloc]initWithFrame:CGRectMake(interval, 10 , self.view.frame.size.width-interval * 2, (self.view.frame.size.width-interval * 2) *100 /980)];
    
    CGRect rect= [_TabView rectForSection:3];
    NSLog(@"rect %@", NSStringFromCGRect(rect));
    
    CGFloat propressHeight = self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)- rect.origin.y;
    if (propressHeight <= 100) {
        propressHeight = 100;
    }

    __block __typeof(self)weakSelf = self;
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(_TabView.frame.origin.x,
                                                                   rect.origin.y + 40,
                                                                   _TabView.frame.size.width,
                                                                   propressHeight)];
    [_TabView addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf BXTSCommentList];
    };
    
}

- (void)setInfoTabFooter {
    if ([NSArray isArrEmptyOrNull:commentArray]) {
        UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _TabView.frame.size.width, 100)];
        _TabView.tableFooterView = footerV;
    }
    else {
        _TabView.tableFooterView = [AppUtils tableViewsFooterView];
    }
    
    if (!progressV.isHidden) {
        [_TabView bringSubviewToFront:progressV];
    }
}



-(void)BXTSCommentList
{

    
    BXTSCommentsModel *BXTSModel =[[BXTSCommentsModel alloc]init];
    if([_isbaoxiuComplaint isEqualToString:@"1"])
    {
        
        BXTSModel.pageNumber=@"1";
        BXTSModel.pageSize=@"5";
        BXTSModel.memberId=[UserManager shareManager].userModel.memberId;
        BXTSModel.complaintId=_bxtsM.ID;
        BXTSModel.complaintType=@"REPAIR";

    }
    else if ([_isbaoxiuComplaint isEqualToString:@"2"])
    {
        BXTSModel.pageNumber=@"1";
        BXTSModel.pageSize=@"5";
        BXTSModel.memberId=[UserManager shareManager].userModel.memberId;
        BXTSModel.complaintId=_bxtsM.ID;
        BXTSModel.complaintType=@"COMPLAINT";

    }
    [bxtsH BXTSCommentsList:BXTSModel success:^(id obj)
    {
        commentArray = (NSArray *)obj;
        if([NSArray isArrEmptyOrNull:commentArray])
        {
            //[AppUtils showAlertMessageTimerClose:@"还没有评论信息！"];
        }
        else
        {
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [_TabView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [AppUtils tableViewEndMJRefreshWithTableV:_TabView];
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:commentArray]];
        [self setInfoTabFooter];
        
    } failed:^(id obj) {
        //[AppUtils showErrorMessage:@"" isShow:self.viewIsVisible];
        [AppUtils tableViewEndMJRefreshWithTableV:_TabView];
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:commentArray]];
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return commentArray.count;
            break;
            
        default:
            return 0;
            break;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: {
            return backimgV.frame.size.height+20;
        }
            return 60;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 30;
            break;
            
        default:
            return 0;
            break;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        DetaimgCell * cell = (DetaimgCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }
    if (indexPath.section==2)
    {
        DetailCommentCell *cell =(DetailCommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 40;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_isbaoxiuComplaint isEqualToString:@"1"])
    {
        if (section==0)
        {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            view.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
            //当前处理状态
            NSString *StatusStr = [NSString stringWithFormat:@"%@",self.bxtsM.complaintStatus];
            NSLog(@"StatusStr==%@",StatusStr);
            
            if ([StatusStr isEqualToString:@"0"])
            {
                backimgV.image=[UIImage imageNamed:@"status2.png"];
            }
            else if ([StatusStr isEqualToString:@"1"])
            {
                backimgV.image=[UIImage imageNamed:@"status3.png"];
            }
            else if ([StatusStr isEqualToString:@"2"])
            {
                backimgV.image=[UIImage imageNamed:@"status4.png"];
            }


            [view addSubview:backimgV];
            return view;

        }
        if (section==1)
        {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            view.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
            return view;
        }
        if (section==2)
        {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            view.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
            UILabel *CommentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
            CommentLab.text=@"评论内容";
            [view addSubview:CommentLab];
            return view;
        }

    }
    else
    {
        if (section==0)
        {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            view.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
            //当前处理状态
            NSString *StatusStr = [NSString stringWithFormat:@"%@",self.bxtsM.complaintStatus];
            if ([StatusStr isEqualToString:@"0"])
            {
                backimgV.image=[UIImage imageNamed:@"status2.png"];
            }
            else if ([StatusStr isEqualToString:@"1"])
            {
                backimgV.image=[UIImage imageNamed:@"status3.png"];
            }
            else if ([StatusStr isEqualToString:@"2"])
            {
                backimgV.image=[UIImage imageNamed:@"status4.png"];
            }
        

            
            [view addSubview:backimgV];
            return view;
        }
        if (section==1)
        {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            view.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
            return view;
        }
        if (section==2)
        {
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            view.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
            UILabel *CommentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
            CommentLab.text=@"评论内容";
            [view addSubview:CommentLab];
            return view;
        }
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
    return view;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        static NSString *CellTableIdentifier = @"DetaimgCell";
        DetaimgCell *cell =[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil)
        {
            cell = [[DetaimgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //cell.deletedidImg=self;
        [cell setcellData:self.bxtsM];
        return cell;

    }
    if (indexPath.section==2)
    {
        static NSString *CellTableIdentifier = @"DetailCommentCell";
        DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil)
        {
            cell = [[DetailCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        }
        BXTSCommentsModel *bxtsMM =[commentArray objectAtIndex:indexPath.row];
        
        [cell setcommentDic:bxtsMM];

        return cell;
    }
    static NSString *CellTableIdentifier = @"DetailCell";
    DetailCell *cell =[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil)
    {
        cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, IPHONE_WIDTH, 1)];
        img.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
        [cell addSubview:img];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([_isbaoxiuComplaint isEqualToString:@"1"])
    {
        [cell setName:[BaoXiuNameArray objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell setName:[NameArray objectAtIndex:indexPath.row]];
    }


    cell.DataLabe.tag=100+indexPath.row;
   
    
    if (indexPath.row==0)
    {
        cell.DataLabe.text=self.bxtsM.createTimeStr;
    }
    else if (indexPath.row==1)
    {
        cell.DataLabe.text=self.bxtsM.complaintType;
    }
    else if (indexPath.row==2)
    {
        cell.DataLabe.text=self.bxtsM.ID;
    }
    else if (indexPath.row==3)
    {
        cell.DataLabe.text=self.bxtsM.contactAddress;
    }
    else if (indexPath.row==4)
    {
        cell.DataLabe.text=self.bxtsM.communityName;
    }
    else if (indexPath.row==5)
    {
        cell.DataLabe.text=self.bxtsM.contactPerson;
    }
    else if (indexPath.row==6)
    {
        cell.DataLabe.text=self.bxtsM.contactPhone;
    }
    return cell;

}




@end
