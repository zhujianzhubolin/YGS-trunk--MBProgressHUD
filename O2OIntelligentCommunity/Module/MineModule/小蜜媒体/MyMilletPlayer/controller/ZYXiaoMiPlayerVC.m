//
//  ZYMilletPlayerVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZYXiaoMiPlayerVC.h"
#import "ZYMilletPlayerCell.h"
#import "ZJWebProgrssView.h"
#import "UserManager.h"
#import "ZYMilletDetailsVC.h"

#import "ZYXiaoMiPlayerHandler.h"
#import "ZYXiaoMiPlayerModel.h"
#import "ZJSandboxHelper.h"

@interface ZYXiaoMiPlayerVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZYXiaoMiPlayerVC
{
    UITableView *playerTB;
    ZJWebProgrssView *progressV;
    ZYXiaoMiPlayerHandler *milletH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"56=%@",[ZJSandboxHelper docPath]);
    [self initData];
    [self initUI];
    
//    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [progressV startAnimation];
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(postMilletInfo) userInfo:nil repeats:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hidetabbar];
    

}

-(void)initData
{
    milletH =[ZYXiaoMiPlayerHandler new];
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)postMilletInfo
{
    [self startNetworkGetMilletIsHeader:YES];
}
-(void)initUI
{
    self.title=@"我的媒体";
    __weak typeof(self)weakSelf = self;
    [self.navigationItem addLeftItemWithImgName:@"backIcon" action:^{
        [weakSelf backRootVC];
    }];
    
    playerTB =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT+CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    playerTB.dataSource=self;
    playerTB.delegate=self;
    [playerTB registerNib:[UINib nibWithNibName:@"ZYMilletPlayerCell" bundle:nil] forCellReuseIdentifier:@"MilletPlayerCell"];
    playerTB.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    
    [self.view addSubview:playerTB];

    [playerTB addLegendHeaderWithRefreshingBlock:^{//下拉刷新
        [weakSelf startNetworkGetMilletIsHeader:YES];
    }];
    
    [playerTB addLegendFooterWithRefreshingBlock:^{//上拉刷新
        [weakSelf startNetworkGetMilletIsHeader:NO];
    }];
    
    progressV = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0,
                                                                   0,IPHONE_WIDTH,IPHONE_HEIGHT)];
    [playerTB addSubview:progressV];
    
    progressV.loadBlock = ^ {
        [weakSelf startNetworkGetMilletIsHeader:YES];
    };
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [playerTB addGestureRecognizer:leftSwipeGestureRecognizer];
}

-(void)backRootVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)startNetworkGetMilletIsHeader:(BOOL)isHeader
{
    ZYXiaoMiPlayerModel *millerM =[ZYXiaoMiPlayerModel new];
    millerM.pageSize=@"10";
    millerM.memberId=[UserManager shareManager].userModel.memberId;
//    millerM.memberId=@"4061";
    
    [milletH queryMillerList:millerM success:^(id obj) {
        [progressV stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:milletH.millerArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:playerTB];
        [playerTB reloadData];
    } failed:^(id obj) {
        [progressV stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:milletH.millerArray]];
        [AppUtils tableViewEndMJRefreshWithTableV:playerTB];
    } isHeader:isHeader];
}

#pragma mark <UITableViewDataSource,UITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [AppUtils tableViewFooterPromptWithPNumber:milletH.milletPage.integerValue
                                    withPCount:milletH.millerCount.integerValue
                                     forTableV:playerTB];
    return milletH.millerArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [milletH.millerArray objectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
    return lable;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
        UILabel *textL = (UILabel *)view;
        NSArray *array = [milletH.millerArray objectAtIndex:section];
        ZYXiaoMiPlayerModel *millwtM = array[0];
        NSArray *dateArr = [millwtM.dateCreated componentsSeparatedByString:@" "];
        
        if (dateArr.count == 2) {
            NSString *yearMonthStr = dateArr[0];
            NSArray *yearMonthArr = [yearMonthStr componentsSeparatedByString:@"-"];
            if (yearMonthArr.count == 3) {
                textL.text = [NSString stringWithFormat:@"  %@年%@月",yearMonthArr[0],yearMonthArr[1]];
            }
        }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifer =@"MilletPlayerCell";
    ZYMilletPlayerCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell =[[ZYMilletPlayerCell alloc]init];
    }
    NSArray *array = [milletH.millerArray objectAtIndex:indexPath.section];
    //ZYMilletPlayerModel *milletM = array[indexPath.row];
    [cell milletData:array[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = [milletH.millerArray objectAtIndex:indexPath.section];
    ZYXiaoMiPlayerModel *mod=array[indexPath.row];
    NSLog(@"ID=%@",mod.ID);
    
    ZYMilletDetailsVC *details = [[ZYMilletDetailsVC alloc]init];
    details.ID = mod.ID;
    
    [self.navigationController pushViewController:details animated:YES];
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
