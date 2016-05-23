//
//  HoneyVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "HoneyVC.h"
#import "TableViewCell.h"
#import "BeeRulsViewController.h"
#import "DuiHuanViewController.h"
#import "UserManager.h"
#import "ZJWebProgrssView.h"
#import "WebVC.h"
#import "OpenMoneyBagVC.h"
//查询会员相关的积分交易数据接口类
#import "HoneyHandler.h"
#import "HoneyTradeInfoModel.h"

@interface HoneyVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * beeTableView;
    NSMutableArray *honeyInfoArr;
    ZJWebProgrssView *progressV;
    HoneyHandler *honeyH;
    NSString *honeyData;
    
    UIAlertView *honeyAlerV;
    UIAlertView *openMoneyBagAlerV;

    
}
@end

@implementation HoneyVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    [progressV startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(postHoneyInfo) userInfo:nil repeats:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self initHoneyData];
}

-(void)initData
{
    honeyInfoArr = [NSMutableArray array];
    honeyH =[HoneyHandler new];
}

-(void)postHoneyInfo
{
   
    
    [self startNetworkGetShopsIsHeader:YES];
    
}

-(void)initUI
{
    self.title = @"我的蜂蜜";
    
    beeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:beeTableView];
    beeTableView.delegate = self;
    beeTableView.dataSource = self;
    [beeTableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"BeeCell"];
    
    beeTableView.showsVerticalScrollIndicator = NO;
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(LookRuls)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    UIView * HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    HeadView.backgroundColor=[UIColor whiteColor];
    beeTableView.tableHeaderView = HeadView;
    
    //背景图片
    UIView * beeBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, HeadView.frame.size.width - 20, HeadView.frame.size.height -20)];
    beeBackView.clipsToBounds = YES;
    beeBackView.layer.cornerRadius = 5;
    [HeadView addSubview:beeBackView];
    
    UIImageView *honeyBackImgV= [[UIImageView alloc]initWithFrame:beeBackView.bounds];
    honeyBackImgV.image=[UIImage imageNamed:@"honey"];
    [beeBackView addSubview:honeyBackImgV];
    
    //蜂蜜余额
    UILabel * leftbee = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, HeadView.frame.size.width, 50)];
    leftbee.text = @"蜂蜜余额:";
    leftbee.tag = 1000;
    leftbee.textColor=[AppUtils colorWithHexString:@"1390D1"];
    leftbee.textAlignment = NSTextAlignmentCenter;
    leftbee.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
    [beeBackView addSubview:leftbee];
    
    UIButton * duihuan = [UIButton buttonWithType:UIButtonTypeCustom];
    duihuan.tag=456;
    duihuan.enabled=NO;
    duihuan.frame = CGRectMake(0, 90, beeBackView.frame.size.width, 40);
    [duihuan setTitle:@"立即兑换" forState:UIControlStateNormal];
    duihuan.backgroundColor = [UIColor clearColor];
    duihuan.titleLabel.textAlignment = NSTextAlignmentCenter;
    [duihuan addTarget:self action:@selector(duihuanNow) forControlEvents:UIControlEventTouchUpInside];
    [beeBackView addSubview:duihuan];
    
    __block __typeof(self)weakTableView = self;
    [beeTableView addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakTableView startNetworkGetShopsIsHeader:YES];
        [weakTableView initHoneyData];
    }];
    
    [beeTableView addLegendFooterWithRefreshingBlock:^{//上拉加载更多
        [weakTableView startNetworkGetShopsIsHeader:NO];
  
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0,
                                                                   HeadView.frame.size.height,
                                                                   IPHONE_WIDTH,
                                                                   IPHONE_HEIGHT-HeadView.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    [beeTableView addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [weakTableView startNetworkGetShopsIsHeader:YES];
       
    };
    
    


}

//获取积分数据
-(void)initHoneyData
{
    
    HoneyTradeInfoModel *honeyM = [HoneyTradeInfoModel new];
    //honeyM.memberId=[UserManager shareManager].userModel.memberId;
    //honeyM.memberId=@"2503";
    honeyM.memberId=[UserManager shareManager].userModel.memberId;
    [honeyH queryVIPHoneyInfo:honeyM success:^(id obj) {

        honeyData =(NSString *)obj;
        NSString *honeyDataInt = [NSString stringWithFormat:@"%.0f",[honeyData floatValue]];
        NSLog(@"honeyData==%@",honeyData);
        UILabel *honeyLab =(UILabel *)[self.view viewWithTag:1000];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *Str1 =@"蜂蜜余额:";
            NSString *Str2 =@"滴";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",Str1,honeyDataInt,Str2]];
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"1390D1"] range:NSMakeRange(0, Str1.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"1390D1"] range:NSMakeRange(Str1.length, honeyDataInt.length)];
            
            NSInteger length =Str1.length+ honeyDataInt.length;
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"1390D1"] range:NSMakeRange(Str2.length, 1)];
            
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:18.0] range:NSMakeRange(0, Str1.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:35.0] range:NSMakeRange(Str1.length, honeyDataInt.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:35.0] range:NSMakeRange(length, 1)];
            
            honeyLab.attributedText=str;
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:456];
            btn.enabled=YES;
        });
    } failed:^(id obj) {
        [AppUtils showAlertMessageTimerClose:obj];
    }];
    
}

- (void)startNetworkGetShopsIsHeader:(BOOL)isHeader{
        HoneyTradeInfoModel *honeyM =[HoneyTradeInfoModel new];
        honeyM.pageSize=@"10";
        honeyM.memberId=[UserManager shareManager].userModel.memberId;
        [honeyH queryHoneyTradeInfo:honeyM success:^(id obj)
         {
             [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:honeyH.honeyArr]];
             [AppUtils tableViewEndMJRefreshWithTableV:beeTableView];
             [beeTableView reloadData];
         } failed:^(id obj) {
             
             [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:honeyH.honeyArr]];
             [AppUtils tableViewEndMJRefreshWithTableV:beeTableView];
         } isHeader:isHeader];
}


//查看规则
- (void)LookRuls{
    
    WebVC *honeyV = [WebVC new];
    honeyV.title =@"蜂蜜规则";
    honeyV.webURL = @"http://wxssj.ygs001.com/bjsm/getHoneyRule.html";
    [self.navigationController pushViewController:honeyV animated:YES];
    
}

//立即兑换
- (void)duihuanNow{
    
    if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"1"])//开通钱包
    {
        if ([honeyData intValue] >=100) {
            DuiHuanViewController * dui = [[DuiHuanViewController alloc] init];
            dui.duihuanblock = ^(){
                [self initHoneyData];
                [progressV startAnimation];
            };
            [self.navigationController pushViewController:dui animated:YES];
            
        }
        else
        {
            honeyAlerV =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的蜂蜜余额不足100，暂时无法兑换。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"查看规则", nil];
            [honeyAlerV show];
        }

    }
    else//没有开通钱包
    {
        
        openMoneyBagAlerV =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您暂未开通钱包，蜂蜜兑换金额将直接到钱包金额内。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"开通钱包", nil];
        [openMoneyBagAlerV show];
        
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return honeyH.honeyArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [honeyH.honeyArr objectAtIndex:section];
    return array.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *moneyidentifier= @"BeeCell";
    TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:moneyidentifier];
    
    if (cell == nil) {
        cell =[[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moneyidentifier];
        
    }
    
    NSArray *array = [honeyH.honeyArr objectAtIndex:indexPath.section];
    
    
    HoneyTradeInfoModel *honeyMMM =array[indexPath.row];
    NSLog(@"honeyMMM.point=%@",honeyMMM.point);
    [cell setCellData:array[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *array = [honeyH.honeyArr objectAtIndex:section];
    HoneyTradeInfoModel *honeyM =array[0];
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
    lable.text = [NSString stringWithFormat:@"  %@年%@月",[honeyM.changTime substringWithRange:NSMakeRange(0, 4)],[honeyM.changTime substringWithRange:NSMakeRange(5, 2)]];
;
    
    return lable;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)  buttonIndex
{
    
    if (alertView==honeyAlerV)
    {
        if (buttonIndex==1)
        {
            WebVC *honeyV = [WebVC new];
            honeyV.title =@"蜂蜜规则";
            honeyV.webURL = @"http://wxssj.ygs001.com/bjsm/getHoneyRule.html";
            [self.navigationController pushViewController:honeyV animated:YES];

        }
    }
    else if (alertView==openMoneyBagAlerV)
    {
        if(buttonIndex==1)
        {
            OpenMoneyBagVC *monebay =[[OpenMoneyBagVC alloc]init];
            monebay.isPaegBack=@"honeyPage";
            [self.navigationController pushViewController:monebay animated:YES];

        }
    }
    
}

@end
