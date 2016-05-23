//
//  AdviceVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/19.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AdviceVC.h"
#import "DetaimgCell.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import "UserManager.h"
#import "ZJWebProgrssView.h"

//查询建议回复
#import "QueryCommentHandler.h"
#import "QueryCommentModel.h"


@interface AdviceVC ()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation AdviceVC
{
    UITableView *adviceTB;
    MultiShowing *multShow;
    UIView *jianyiConnetView;
    NSString *huifuCommentStr;
    //ZJWebProgrssView *progressV;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initDate];
    [self initUI];
    
    if ([_jianyiM.opinionStatus isEqualToString:@"1"])
    {
        [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(viewDisloadRefresh) userInfo:nil repeats:NO];
    }
    
    
}

-(void)initDate
{
    huifuCommentStr = [[NSString alloc]init];
}

-(void)initUI
{
    self.title=@"建议详情";
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headView.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
    
    UILabel * stateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 40)];
    stateLab.text=@"处理状态:";
    [headView addSubview:stateLab];
    
    UILabel * stateLab1 = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 80, 40)];
    stateLab1.text=@"等待处理";
    stateLab1.textColor=[AppUtils colorWithHexString:@"009AD8"];
    
    stateLab1.textColor=[AppUtils colorWithHexString:@"009AD8"];
    NSString *StatusStr = [NSString stringWithFormat:@"%@",self.jianyiM.opinionStatus];
    NSLog(@"StatusStr==%@",StatusStr);
    
    if ([StatusStr isEqualToString:@"1"])
    {
        stateLab1.text=@"已回复";
    }
    else
    {
        stateLab1.text=@"已查看";
    }
    
    [headView addSubview:stateLab1];

    adviceTB =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) style:UITableViewStyleGrouped];
    adviceTB.dataSource=self;
    adviceTB.delegate=self;
    adviceTB.tableHeaderView=headView;
    adviceTB.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
    adviceTB.separatorStyle =UITableViewCellAccessoryNone;
    adviceTB.showsVerticalScrollIndicator=NO;
    [self.view addSubview:adviceTB];
    
//    __block __typeof(self)weakSelf = self;
//    [adviceTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
//        [weakSelf viewDisloadRefresh];
//    }];
//    
//    [adviceTB addLegendFooterWithRefreshingBlock:^{//上拉加载更多
//            }];
//    [self.view addSubview:adviceTB];
    



}

-(void)viewDisloadRefresh
{
    
    QueryCommentModel *queryM =[QueryCommentModel new];
    QueryCommentHandler *queryH =[QueryCommentHandler new];
   
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 _jianyiM.ID,@"complaintId",
                                 @"UNIVERSAL",@"complaintType",
                                 nil];
    queryM.queryMap = queryMapDic;
    
    [queryH queryAdvicecomment:queryM success:^(id obj) {
        NSLog(@"22222%@",obj);
        
        if ([adviceTB.header isRefreshing]) {
            [adviceTB.header endRefreshing];
        }
        
        huifuCommentStr =(NSString *)obj;
        [adviceTB reloadData];
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//        [adviceTB reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:obj isShow:YES];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_jianyiM.opinionStatus isEqualToString:@"1"])
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return (self.view.frame.size.width-10 * 2) *98 /698 +5;
            break;
        case 1:
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
        
        return cell.height;
    }
    if (indexPath.section==1)
    {
        return jianyiConnetView.frame.size.height;
    }
    return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        view.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
        //当前处理状态
        NSString *StatusStr = [NSString stringWithFormat:@"%@",self.jianyiM.opinionStatus];
        CGFloat interval = 10;
        UIImageView *backimgV =[[UIImageView alloc]initWithFrame:CGRectMake(interval, 0 , self.view.frame.size.width-interval * 2, (self.view.frame.size.width-interval * 2) *98 /698)];
        if ([StatusStr isEqualToString:@"1"])
        {
            backimgV.image=[UIImage imageNamed:@"advice3"];
        }
        else
        {
            backimgV.image=[UIImage imageNamed:@"advice2"];
        }
        [view addSubview:backimgV];
        return view;
        
    }
    else if(section==1)
    {
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        view.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
        UILabel *CommentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
        CommentLab.text=@"建议回复";
        [view addSubview:CommentLab];
        return view;

       
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
        [cell setAdviceData:self.jianyiM];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier= @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        jianyiConnetView=[[UIView alloc]init];
        jianyiConnetView.backgroundColor=[UIColor whiteColor];
        
        UILabel *textLabe = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, IPHONE_WIDTH-20, 30)];
        textLabe.text = huifuCommentStr;
        textLabe.numberOfLines = 0;
        textLabe.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [textLabe sizeThatFits:CGSizeMake(textLabe.frame.size.width, MAXFLOAT)];
        textLabe.frame =CGRectMake(10, 10, IPHONE_WIDTH-20, size.height);
        textLabe.font = [UIFont systemFontOfSize:14];
        [jianyiConnetView addSubview:textLabe];
        
        UILabel *timeLab  =[[UILabel alloc]init];
        timeLab.frame=CGRectMake(IPHONE_WIDTH-170, CGRectGetMaxY(textLabe.frame), 140, 25);
        timeLab.textAlignment=NSTextAlignmentRight;
        timeLab.font=[UIFont systemFontOfSize:14];
        //timeLab.backgroundColor=[UIColor blueColor];
        timeLab.text=_jianyiM.createTimeStr;
        [jianyiConnetView addSubview:timeLab];
        
        
        jianyiConnetView.frame=CGRectMake(10, 0, textLabe.frame.size.width, CGRectGetMaxY(timeLab.frame));
        jianyiConnetView.layer.masksToBounds=YES;
        jianyiConnetView.layer.cornerRadius=5;
        [cell.contentView addSubview:jianyiConnetView];
        cell.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];

        return cell;
    }
}

//-(void)didimg
//{
//    multShow =[[MultiShowing alloc]init];
//    
//    NSMutableArray *imgArr = [NSMutableArray array];
//    [_jianyiM.imgPath enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        WebImage *webImg = [WebImage new];
//        webImg.url = obj;
//        [imgArr addObject:webImg];
//    }];
//    
//    [multShow ShowImageGalleryFromView:adviceTB ImageList:imgArr ImgType:ImgTypeFromWeb Scale:2.0];
//    
//}

@end
