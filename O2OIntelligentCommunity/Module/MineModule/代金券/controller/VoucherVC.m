//
//  VoucherVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/2.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "VoucherVC.h"
#import "YGSDaiJinCell.h"
#import "ZJWebProgrssView.h"
#import "ConvertVC.h"
#import "UserManager.h"

#import "DaiJinQunHandel.h"
#import "DaiJinQuanModel.h"

@interface VoucherVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *voucherTB;
    ZJWebProgrssView  *progressV;
    
    NSMutableArray *quanListArray;
    DaiJinQunHandel *handel;
}

@end

@implementation VoucherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    [progressV startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDaiJinQuanListIsHeader:YES];
    });

    
}



-(void)initData{
    handel=[DaiJinQunHandel new];
    quanListArray = [NSMutableArray array];
}

-(void)initUI
{
    self.title = @"可用代金券";
    self.view.backgroundColor = [AppUtils colorWithHexString:@"DDDDDD"];
    
    CGFloat rightBtnWidth = 25;
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,rightBtnWidth *2,rightBtnWidth)];
    [rightButton setTitleColor:[AppUtils colorWithHexString:@"fa6900"] forState:UIControlStateNormal];
    [rightButton setTitle:@"兑券" forState:UIControlStateNormal];
    rightButton.layer.cornerRadius = 5;
    [rightButton addTarget:self action:@selector(duiHuanAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

   
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 5)];
    view.backgroundColor = [AppUtils colorWithHexString:@"DDDDDD"];
  

    voucherTB  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    voucherTB.tableFooterView = [AppUtils tableViewsFooterView];
    voucherTB.delegate=self;
    voucherTB.dataSource=self;
    voucherTB.backgroundColor = [AppUtils colorWithHexString:@"DDDDDD"];
    voucherTB.tableHeaderView = view;
    [self.view addSubview:voucherTB];
    [voucherTB registerNib:[UINib nibWithNibName:@"YGSDaiJinCell" bundle:nil] forCellReuseIdentifier:@"YGSDaiJinCell"];
    

    
     __block __typeof(self)weakTableView = self;
    [voucherTB addLegendHeaderWithRefreshingBlock:^{
        [weakTableView getDaiJinQuanListIsHeader:YES];
    }];
    
    //__block __typeof(pageNum)weakpageNum = pageNum;
    [voucherTB addLegendFooterWithRefreshingBlock:^{
        [weakTableView getDaiJinQuanListIsHeader:NO];
    }];
    
    progressV =[[ZJWebProgrssView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    progressV.loadBlock= ^{
        [weakTableView getDaiJinQuanListIsHeader:YES];
    };
    [self.view addSubview:progressV];
    
}
// 前往兑换
-(void)duiHuanAction
{
    ConvertVC *conver = [[ConvertVC alloc]init];
//    conver.duihuanSuccessBlock=^{
//        //[self getDaiJinQuanList];
//    };
    [self.navigationController pushViewController:conver animated:YES];
}

-(void)getDaiJinQuanListIsHeader:(BOOL)Isheader
{
    DaiJinQuanModel *model =[DaiJinQuanModel new];
    
    model.memberId =[UserManager shareManager].userModel.memberId;
    model.storeId  =@"";
    model.status   =@"1";
    model.pageNumber = handel.voucherPNumber;
    model.pageSize   = @"5";
    
    [handel getStoreQuan:model success:^(id obj) {
        quanListArray = obj;
        [voucherTB.header endRefreshing];
        [voucherTB.footer endRefreshing];

        if ([NSArray isArrEmptyOrNull:quanListArray])
        {
            [AppUtils showAlertMessageTimerClose:@"无可用代金券"];
        }
        
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:quanListArray]];
        [voucherTB reloadData];
    } failed:^(id obj) {
        [voucherTB.header endRefreshing];
        [voucherTB.footer endRefreshing];
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:quanListArray]];
    } isHeader:Isheader];
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [AppUtils tableViewFooterPromptWithPNumber:handel.voucherPNumber.integerValue
                                    withPCount:handel.voucherPCount.integerValue
                                     forTableV:tableView];
    return quanListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentiferID = @"YGSDaiJinCell";
    YGSDaiJinCell *Cell =[tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
    if (Cell==nil)
    {
        Cell = [[YGSDaiJinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
    }
    UIButton *button = [Cell.contentView viewWithTag:10000];
    button.hidden=YES;
    if (![NSArray isArrEmptyOrNull:quanListArray])
    {
        [Cell setQuanModel:[quanListArray objectAtIndex:indexPath.row]];
    }
    
    
    return Cell;
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
