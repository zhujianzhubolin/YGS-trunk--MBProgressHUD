//
//  MoneyBagVC.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoneyBagVC.h"
#import "MoneyBagCell.h"
#import "UserManager.h"
#import "RechargeVC.h"
#import "MoneyBagSet.h"
#import "WXApi.h"
#import "HoneyVC.h"
#import "ZJWebProgrssView.h"
#import "UINavigationItem+custom.h"

//获取钱包缴费数据
#import "MoneyBaghandler.h"
#import "MoneybagModel.h"

#import "UserEntity.h"
#import "UserHandler.h"

//获取钱包信息
#import "MoneyBagInfoModel.h"
#import "MoneyBaginfoHandler.h"
#import "AppDelegate.h"


#ifdef SmartComJYZX

#elif SmartComYGS
#import "ZYXiaoMiPayVC.h"

#else

#endif


@interface MoneyBagVC () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation MoneyBagVC
{
    UITableView *moneyTB;
    NSArray *moneyiconArray;
    MoneyBagInfoModel *monem;
    UIButton *rechargeBtn;
    ZJWebProgrssView *progressV;
    BOOL isWx;
    MoneyBaghandler *moneyBagH;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    [progressV startAnimation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    [self getmonaybaginfo];
    [self refreshMoneyListData];
}

- (void)refreshMoneyListData {
    if ([NSArray isArrEmptyOrNull:moneyBagH.moneyBagArray]) {
        [progressV startAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self postmoneyIsHeader:YES];
        });
    }
}

-(void)initData
{
    if ([WXApi isWXAppInstalled]) {
        isWx = YES;
    }else{
        isWx = NO;
    }
    
    moneyiconArray=[[NSArray alloc]initWithObjects:@"jiaotong",@"tingche",@"shuifei",@"meiqifei",@"wuyefei",@"dianfei",@"huafei", nil];
    moneyBagH =[MoneyBaghandler new];
}

-(void)initUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seting"] style:UIBarButtonItemStylePlain target:self action:@selector(SetMoneyBagArr)];
    
     __weak typeof(self)weakSelf = self;
    [self.navigationItem addLeftItemWithImgName:@"backIcon" action:^{
        [weakSelf backRootMineVC];
    }];
    self.title=@"我的钱包";
    
    UIView *monehandV =[[UIView alloc]init];
    monehandV.backgroundColor=[UIColor whiteColor];
    monehandV.frame=CGRectMake(0, 10, self.view.frame.size.width, 180);
    UIImageView *moneimgV =[[UIImageView alloc]init];
    moneimgV.frame=CGRectMake(10, 10, self.view.frame.size.width-20, 160);
    moneimgV.image=[UIImage imageNamed:@"ZYMoneyImg"];
    [monehandV addSubview:moneimgV];
    
    CGFloat interval =10;
    UILabel *balanceDatalab =[[UILabel alloc]init];
    balanceDatalab.frame=CGRectMake(interval *2, 40, IPHONE_WIDTH - interval *2, 60);
    balanceDatalab.textAlignment = NSTextAlignmentCenter;
    balanceDatalab.textColor=[AppUtils colorWithHexString:@"FE9D09"];
    balanceDatalab.text=@"0元";
    balanceDatalab.tag=400;
    balanceDatalab.font=[UIFont fontWithName:@"Helvetica-Bold" size:35];
    [monehandV addSubview:balanceDatalab];

    rechargeBtn =[[UIButton alloc]init];
    rechargeBtn.frame=CGRectMake(10, 130, self.view.frame.size.width-20, 40);
    rechargeBtn.backgroundColor=[UIColor clearColor];
    [rechargeBtn setTitle:@"充       值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(RechargeArr) forControlEvents:UIControlEventTouchUpInside];
    [monehandV addSubview:rechargeBtn];
    
    
    moneyTB= [[UITableView alloc]init];
    moneyTB.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    moneyTB.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    moneyTB.dataSource=self;
    moneyTB.delegate=self;
    moneyTB.tableHeaderView=monehandV;
    moneyTB.tableFooterView =[AppUtils tableViewsFooterView];
    [self.view addSubview:moneyTB];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [rechargeBtn setTintColor:[UIColor lightGrayColor]];
    rechargeBtn.userInteractionEnabled = NO;
    
    
    [moneyTB addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getmonaybaginfo];
        [weakSelf postmoneyIsHeader:YES];
    }];
    
    [moneyTB addLegendFooterWithRefreshingBlock:^{
        
        [weakSelf postmoneyIsHeader:NO];
    }];
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(monehandV.frame),
                                                                   IPHONE_WIDTH,
                                                                   IPHONE_HEIGHT-(CGRectGetMaxY(monehandV.frame)))];
    [moneyTB addSubview:progressV];
    progressV.loadBlock = ^ {
        [weakSelf postmoneyIsHeader:YES];
    };
}



//获取钱包支付信息
-(void)postmoneyIsHeader:(BOOL)isheader
{
    MoneybagModel   *moneM =[MoneybagModel new];
    moneM.pageSize= @"5";
    moneM.memberId =[UserManager shareManager].userModel.memberId;
    
    [moneyBagH postjiaoyixinxi:moneM success:^(id obj) {
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:moneyBagH.moneyBagArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:moneyTB];
        [moneyTB reloadData];
    } failed:^(id obj) {
        [AppUtils tableViewEndMJRefreshWithTableV:moneyTB];
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:moneyBagH.moneyBagArray]];
    } isHeader:isheader];
    
}

//获取钱包信息
-(void)getmonaybaginfo
{
    MoneyBagInfoModel *moneyM =[MoneyBagInfoModel new];
    MoneyBaginfoHandler *moneyH = [MoneyBaginfoHandler new];
    moneyM.memberId=[UserManager shareManager].userModel.memberId;
    
    [moneyH moneybaginfo:moneyM success:^(id obj) {
         monem =(MoneyBagInfoModel *)obj;
        NSLog(@"%@",monem.amount);
        if ([monem.code isEqualToString:@"success"])
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"余额: %.2f元",monem.amount.doubleValue]];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            
            UILabel *labe =(UILabel *)[self.view viewWithTag:400];
            dispatch_async(dispatch_get_main_queue(), ^{
                labe.attributedText = str;
            });
            
            NSLog(@"monem.isFreeze==%d",monem.isFreeze);
            if (monem.isFreeze==NO) {
                self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [rechargeBtn setTintColor:[UIColor whiteColor]];
                rechargeBtn.userInteractionEnabled = YES;
            }
            else {
                self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [rechargeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                rechargeBtn.userInteractionEnabled = NO;
                
                UIAlertView *abnormalAlertV = [[UIAlertView alloc] initWithTitle:@"您的钱包存在异常行为,为了您的资金安全暂不可使用" message:[NSString stringWithFormat:@"请联系客服:%@",P_SERVICE_PHONE] delegate:self cancelButtonTitle:@"联系客服" otherButtonTitles:@"确定", nil];
                [abnormalAlertV show];
            }
        }
       
    } failed:^(id obj) {
        [AppUtils showErrorMessage:@"未获取到钱包信息" isShow:self.viewIsVisible];
    }];
}

- (void)backRootMineVC
{
    
#ifdef SmartComJYZX
#elif SmartComYGS
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ZYXiaoMiPayVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }

#else
    
#endif
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myTBVC.selectedIndex != 2)
    {
        appDelegate.myTBVC.selectedIndex = 2;
    }
    
}


//设置
-(void)SetMoneyBagArr
{
    MoneyBagSet *moneySetvc =[[MoneyBagSet alloc]init];
    [self.navigationController pushViewController:moneySetvc animated:YES];
}
//充值
-(void)RechargeArr
{
    if (isWx)
    {
        RechargeVC *recharg =[[RechargeVC alloc]init];
        recharg.rechargeSucBlock = ^{
            [self getmonaybaginfo];
            [moneyTB.header beginRefreshing];
        };
        
        [self.navigationController pushViewController:recharg animated:YES];
    }
    else
    {
        [AppUtils showAlertMessageTimerClose:@"为了您的资金安全，请先下载并安装微信。"];
        
    }
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return moneyBagH.moneyBagArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array =[moneyBagH.moneyBagArray objectAtIndex:section];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array =[moneyBagH.moneyBagArray objectAtIndex:section];
    MoneybagModel *moneyM= array[0];
    
    UIView *headview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
    headview.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH, 30)];
    
    lab.text=[NSString stringWithFormat:@"%@年%@月",[moneyM.dateCreated substringWithRange:NSMakeRange(0, 4)],[moneyM.dateCreated substringWithRange:NSMakeRange(5, 2)]];
    [headview addSubview:lab];
    return headview;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *moneyidentifier= @"moneycell";
    MoneyBagCell *cell =[tableView dequeueReusableCellWithIdentifier:moneyidentifier];
    if (cell ==nil)
    {
        cell =[[MoneyBagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moneyidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array =[moneyBagH.moneyBagArray objectAtIndex:indexPath.section];
    [cell setMoneyBaginfo:array[indexPath.row]];
    
    return cell;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [AppUtils callPhone:P_SERVICE_PHONE];
    }
    else if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
