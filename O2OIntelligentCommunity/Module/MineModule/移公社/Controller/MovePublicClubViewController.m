//
//  MovePublicClubViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MovePublicClubViewController.h"
#import "AboutViewController.h"
#import "WebVC.h"

@implementation MovePublicClubViewController
{
    NSArray *nameArray;
    NSArray *iconArray;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    nameArray =[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@用户协议",P_NMAE],@"常见问题",@"关于技术支持", nil];
    iconArray =[[NSArray alloc]initWithObjects:@"user",@"yinsi",@"jiShuZhiChi", nil];
    
    self.title=[NSString stringWithFormat:@"关于%@",P_NMAE];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}


-(void)initUI
{
    _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _TableView.dataSource =self;
    _TableView.delegate =self;
    _TableView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    [self viewDidLayoutSubviewsForTableView:_TableView];
    [self.view addSubview:_TableView];
    
    [self setExtraCellLineHidden:_TableView];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentier];
    if (cell == nil )
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image =[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:indexPath.row]];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.row==0)
    {
        WebVC *webVC = [WebVC new];
        webVC.title=@"协议";
        webVC.webURL = P_USER_PROTOCAL;
        [self.navigationController pushViewController:webVC animated:YES];

    }
    else if (indexPath.row==1)
    {
        WebVC *changJianWenTiV = [WebVC new];
        changJianWenTiV.title=@"常见问题";
        changJianWenTiV.webURL = P_COMMEN_PROBLEMS;
        [self.navigationController pushViewController:changJianWenTiV animated:YES];
        

    }
    else if (indexPath.row==2)
    {
        AboutViewController *about = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
}
@end
