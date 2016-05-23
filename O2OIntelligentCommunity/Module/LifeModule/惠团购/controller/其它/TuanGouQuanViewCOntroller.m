//
//  TuanGouQuanViewCOntroller.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/15.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TuanGouQuanViewCOntroller.h"
#import "YGSDaiJinCell.h"
#import "DaiJinQunHandel.h"
#import "ZJWebProgrssView.h"
#import "DaiJinQuanModel.h"
#import "UserManager.h"

@interface TuanGouQuanViewCOntroller ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    __weak IBOutlet UITableView *daijinquan;
    
    NSMutableArray * quanListArray;
    ZJWebProgrssView * progress;
    DaiJinQuanModel * quanModel1;
    
    //传过来的，里面含有代金券的数组，另外存起来
    NSMutableArray * hasQuanModelArray;
    DaiJinQunHandel * handel;
}

@end

@implementation TuanGouQuanViewCOntroller

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    handel = [DaiJinQunHandel new];
    daijinquan.delegate = self;
    daijinquan.dataSource = self;
    
    NSLog(@">>>>%@",self.selectArray);
    quanListArray = [NSMutableArray array];
    hasQuanModelArray = [NSMutableArray array];
    
    //过滤掉里面含有代金券的
    for (id selectModel in self.selectArray) {
        if ([selectModel isKindOfClass:[DaiJinQuanModel class]]) {
            [hasQuanModelArray addObject:selectModel];
        }
    }
    
    self.title = @"选择代金券";
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 5)];
    view.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    daijinquan.tableHeaderView = view;
    
    [daijinquan registerNib:[UINib nibWithNibName:@"YGSDaiJinCell" bundle:nil] forCellReuseIdentifier:@"QUAN"];
    
    
    __block typeof(self) weakSelf = self;
    progress = [[ZJWebProgrssView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    progress.loadBlock = ^{
        
        [weakSelf getDaiJinQuanStatueIsHeader:YES];
    
    };
    [progress startAnimation];
    [self.view addSubview:progress];
    
    [daijinquan addLegendHeaderWithRefreshingBlock:^{
        [self getDaiJinQuanStatueIsHeader:YES];
    }];
    
    [daijinquan addLegendFooterWithRefreshingBlock:^{
        [self getDaiJinQuanStatueIsHeader:NO];
    }];
    
    [self getDaiJinQuanStatueIsHeader:YES];
}

- (void)getDaiJinQuanStatueIsHeader:(BOOL)isHeader{
    
    DaiJinQuanModel * model = [DaiJinQuanModel new];
    
    //有实际数据时修改
    model.memberId = [UserManager shareManager].userModel.memberId;
    model.storeId = self.shopId;
    model.status = @"1";
    model.pageNumber = handel.voucherPNumber;
    model.pageSize = @"5";

    [handel getStoreQuan:model success:^(id obj) {
        quanListArray = obj;
        NSLog(@"%@",obj);
        
        [daijinquan.header endRefreshing];
        [daijinquan.footer endRefreshing];

        [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:quanListArray]];
        [daijinquan reloadData];
        
    } failed:^(id obj) {
        [daijinquan.header endRefreshing];
        [daijinquan.footer endRefreshing];
        [progress stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:quanListArray]];
    } isHeader:isHeader];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return quanListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [AppUtils tableViewFooterPromptWithPNumber:handel.voucherPNumber.integerValue
                                    withPCount:handel.voucherPCount.integerValue
                                     forTableV:tableView];
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YGSDaiJinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QUAN"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        
        cell = [[YGSDaiJinCell alloc] init];
        
    }

    if (hasQuanModelArray.count <= 0) {//没有选择任何券的时候
        [cell setQuanModel:quanListArray[indexPath.section] bounds:self.bounds];
    }else{//有选择券的时候
        [cell hasSelect:quanListArray[indexPath.section]
                 quanID:hasQuanModelArray
                 shopId:self.shopId
                 bounds:self.bounds];
        NSLog(@"有券");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 5)];
    view.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DaiJinQuanModel * qM = quanListArray[indexPath.section];
    
    if ([self.bounds floatValue] < [qM.bound floatValue]) {
        [AppUtils showAlertMessageTimerClose:@"不满足使用条件"];
    }else{

        YGSDaiJinCell * quan = (YGSDaiJinCell *)[daijinquan cellForRowAtIndexPath:indexPath];

        if (quan.isHasShopUse) {
            [AppUtils showAlertMessage:@"一张代金券仅使用一个商家"];
            return;
        }
        
        if (!quan.isMeetCondition) {
            [AppUtils showAlertMessage:@"不满足使用条件"];
            return;
        }
        
        UIImageView * seleImage = (UIImageView *)[quan viewWithTag:1000];
        seleImage.image = [UIImage imageNamed:@"quanBack_S"];
        
        UIButton * gou = (UIButton *)[quan viewWithTag:10000];

        if (gou.selected) {
            [AppUtils showAlertMessageTimerClose:@"取消选择"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                quanModel1 = nil;
                quanModel1.shopId = nil;
                //判断商城跟团购的
                if (self.mystyle == StoreType) {
                    if (_shangchengquanDelegate && [_shangchengquanDelegate respondsToSelector:@selector(shangCheng:index:)])
                    {
                        [_shangchengquanDelegate shangCheng:quanModel1 index:self.section];
                    }
                }else{
                    if (_quanDelegate && [_quanDelegate respondsToSelector:@selector(quanModel:)])
                    {
                        [_quanDelegate quanModel:quanModel1];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];

            });
            return;
            
        }else{
            gou.selected = YES;
        }
        
        [AppUtils showAlertMessageTimerClose:@"已选择"];
        
        quanModel1 = (DaiJinQuanModel *)quanListArray[indexPath.section];
        quanModel1.shopId = self.shopId;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            //判断商城跟团购的
            if (self.mystyle == StoreType) {
                if (_shangchengquanDelegate && [_shangchengquanDelegate respondsToSelector:@selector(shangCheng:index:)])
                {
                    [_shangchengquanDelegate shangCheng:quanModel1 index:self.section];
                }
            }else{
                if (_quanDelegate && [_quanDelegate respondsToSelector:@selector(quanModel:)])
                {
                    [_quanDelegate quanModel:quanModel1];
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
