//
//  TuanGouSearchViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TuanGouSearchViewController.h"
#import "HuiTuanCell.h"
#import "Life_First.h"
#import "HuiTuanGouAllModel.h"

#import "TGListModel.h"
#import "TGHandel.h"
#import "UserManager.h"
#import "TGShopModel.h"
#import "TuanOrderPageViewController.h"
#import "WTTuanGouDetail.h"
#import "TGShopDetailViewController.h"
#import "AllKuaiSongViewController.h"
#import "ZJWebProgrssView.h"


@interface TuanGouSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    
    __weak IBOutlet UIView *backView;
    __weak IBOutlet UITextField *searchContent;
    __weak IBOutlet UITableView *huiTuanList;
    NSMutableArray * dataSocureArray;
    ZJWebProgrssView * progress;

}

@end

@implementation TuanGouSearchViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSocureArray = [NSMutableArray array];
    
    self.title = @"搜索";
    
    //搜索框相关设置
    searchContent.layer.cornerRadius = 3;
    searchContent.clipsToBounds = YES;
    searchContent.delegate = self;
    
    //搜索框底部
    UIView * backsearchview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 36)];
    backsearchview.backgroundColor = [UIColor clearColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    imageView.image = [UIImage imageNamed:@"sousuo"];
    [backsearchview addSubview:imageView];
    
    searchContent.leftView = backsearchview;
    searchContent.leftViewMode = UITextFieldViewModeAlways;
    
    huiTuanList.delegate = self;
    huiTuanList.dataSource = self;
    
    huiTuanList.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    
    [self setExtraCellLineHidden:huiTuanList];
    [self viewDidLayoutSubviewsForTableView:huiTuanList];
    [huiTuanList registerNib:[UINib nibWithNibName:@"HuiTuanCell" bundle:nil] forCellReuseIdentifier:@"TuanCell"];
    
    progress = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0,44, IPHONE_WIDTH, IPHONE_HEIGHT -44)];
    [self.view addSubview:progress];
    __block typeof(self)weakSelf = self;
    __block typeof(searchContent)weaksearchContent = searchContent;
    progress.loadBlock = ^{
    [weakSelf TGlist:weaksearchContent.text code:@"" areaName:@"" catalogId:@"150" companyId:P_WYID xqId:[UserManager shareManager].comModel.xqNo areaId:@"" longitude:[UserManager shareManager].comModel.longitude latitude:[UserManager shareManager].comModel.latitude sort:@"LATEST_RELEASE" quantity:@""];
        
    };
    
}

- (void)hidKeyBoard{
    [searchContent resignFirstResponder];
}



//搜索接口

//获取团购列表---商品与商家名称公用storeName字段
- (void)TGlist:(NSString *)storeName code:(NSString *)code areaName:(NSString *)areaName catalogId:(NSString *)catalogId companyId:(NSString *)companyId xqId:(NSString *)xqId areaId:(NSString *)areaId longitude:(NSString *)longitude latitude:(NSString *)latitude sort:(NSString *)sort quantity:(NSString *)quantity{
    
    [dataSocureArray removeAllObjects];

    
    
    NSString * searchWords = [storeName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchWords.length <= 0) {
        [AppUtils showAlertMessageTimerClose:@"输入不能为空!"];
        [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:dataSocureArray]];
        return;
    }else{
    
        TGListModel * model = [TGListModel new];
        TGHandel * handel = [TGHandel new];
        
        model.pageNumber = @"1";
        model.pageSize = @"100";
        model.storeName = storeName;
        model.code = code;
        model.areaName = areaName;
        model.catalogId = catalogId;
        model.companyId = companyId;
        model.xqId = xqId;
        model.areaId = areaId;
        model.longitude = longitude;
        model.latitude = latitude;
        model.sort = sort;
        model.quantity=quantity;
        
        [handel getHuiTuanList:model success:^(id obj) {
            
            
            NSLog(@"团购列表数组>>>>>%@",obj);
            dataSocureArray = (NSMutableArray *)obj;
            
            [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:dataSocureArray]];
            
            if (dataSocureArray.count <=0) {
                [AppUtils showAlertMessageTimerClose:W_ALL_NO_DATA_SEARCH];
            }
            
            [huiTuanList reloadData];
            
        } failed:^(id obj) {
            
            [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
            
            [progress stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:dataSocureArray]];
            
        }];
        
    }

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return dataSocureArray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    TGShopModel * shop = (TGShopModel *)dataSocureArray[section];
    return shop.goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HuiTuanCell * biaocell = [tableView dequeueReusableCellWithIdentifier:@"TuanCell"];
    
    if (biaocell == nil) {
        
        biaocell = [[HuiTuanCell alloc] init];
    }
    
    biaocell.buyNow = ^(TGGoodsModel * goods){
        
        [self buyNowWithGoodsData:goods];
        
    };
    
    TGShopModel * shopModel = [dataSocureArray objectAtIndex:indexPath.section];
    
    [biaocell TGGoodsCellData:shopModel.goodsArray[indexPath.row] withKeyWords:searchContent.text];
    
    return biaocell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TGShopModel * shopM = dataSocureArray[indexPath.section];
    TGGoodsModel * goodM = shopM.goodsArray[indexPath.row];
    
    WTTuanGouDetail * detail = [[WTTuanGouDetail alloc] init];
    detail.goodsModel = goodM;
    [self.navigationController pushViewController:detail animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    TGShopModel * shop = [dataSocureArray objectAtIndex:section];
    
    NSLog(@"商将商品数量>>>%@",shop.count);
    
    if ([shop.count intValue] <= shop.goodsArray.count) {
        return CGFLOAT_MIN;
    }else{
        return 40;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TGShopModel * shopModel = (TGShopModel *)dataSocureArray[section];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 50)];
    
    UIButton * buttonViewview = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonViewview.backgroundColor = [UIColor whiteColor];
    buttonViewview.frame = CGRectMake(0, 5, self.view.frame.size.width, 40);
    buttonViewview.tag = 1000 + section;
    [buttonViewview addTarget:self action:@selector(tuangoushangjiadetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:buttonViewview];
    
    //商家名称
    UILabel * shopName = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, IPHONE_WIDTH/2 +10,40)];
    shopName.text = [NSString stringWithFormat:@"%@",shopModel.storeName];
    shopName.textColor = [UIColor orangeColor];
    shopName.textAlignment = NSTextAlignmentLeft;
    shopName.font = [UIFont systemFontOfSize:15];
    [view addSubview:shopName];
    
    NSString * trueDis = nil;
    NSString * distance = shopModel.distance;
    
    if ([distance floatValue] < 1000) {
        trueDis = [NSString stringWithFormat:@"%@m",distance];
    }else{
        
        CGFloat juli = [distance floatValue]/1000;
        trueDis = [NSString stringWithFormat:@"%.2fkm",juli];
        
    }
    
    CGSize disTanceLable = [AppUtils sizeWithString:trueDis font:[UIFont systemFontOfSize:13] size:CGSizeMake(IPHONE_WIDTH/2, 30)];
    //距离小区多远
    UILabel * distanceArea = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH -disTanceLable.width -5,5,disTanceLable.width,40)];
    distanceArea.text = [NSString stringWithFormat:@"%@",trueDis];
    distanceArea.font = [UIFont systemFontOfSize:13];
    distanceArea.textAlignment = NSTextAlignmentRight;
    [view addSubview:distanceArea];
    
    UIImageView * localImage = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH -disTanceLable.width -18, 17, 11, 16)];
    localImage.image = [UIImage imageNamed:@"dingwei"];
    [view addSubview:localImage];
    
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    TGShopModel * shop = [dataSocureArray objectAtIndex:section];
    
    if ([shop.count intValue] <= shop.goodsArray.count) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 2)];
        return view;
        
    }else{
//        UIButton * buttonViewview = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttonViewview.backgroundColor = [AppUtils colorWithHexString:@"#F2F2F2"];
//        buttonViewview.frame = CGRectMake(0, 0, IPHONE_WIDTH, 40);
//        buttonViewview.tag = 10000 + section;
//        [buttonViewview addTarget:self action:@selector(seeAllTuanGou:) forControlEvents:UIControlEventTouchUpInside];
//        [buttonViewview setTitle:@"查看全部" forState:UIControlStateNormal];
//        [buttonViewview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        buttonViewview.titleLabel.font = [UIFont systemFontOfSize:13];
//        return buttonViewview;
        
        UIButton * buttonViewview = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonViewview.backgroundColor = [UIColor clearColor];
        buttonViewview.frame = CGRectMake(0, 0, IPHONE_WIDTH, 40);
        buttonViewview.tag = 10000 + section;
        [buttonViewview addTarget:self action:@selector(seeAllTuanGou:) forControlEvents:UIControlEventTouchUpInside];
        [buttonViewview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        buttonViewview.titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        UILabel * teLable = [UILabel addlable:buttonViewview frame:CGRectMake(IPHONE_WIDTH/2 - 30, 5, 60, 30) text:@"查看全部" textcolor:[AppUtils colorWithHexString:@"04b6e9"]];
        teLable.textAlignment = NSTextAlignmentCenter;
        teLable.layer.cornerRadius = 2;
        teLable.clipsToBounds = YES;
        
        
        UIView * startline = [[UIView alloc] initWithFrame:CGRectMake(10, 19, IPHONE_WIDTH/2 - 10 - teLable.frame.size.width/2 - 5, 1)];
        startline.backgroundColor = [AppUtils colorWithHexString:@"04b6e9"];
        [buttonViewview addSubview:startline];
        
        
        UIView * endLine = [[UIView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH/2 + teLable.frame.size.width/2 + 5, 19, IPHONE_WIDTH/2 -teLable.frame.size.width/2 - 5 - 10, 1)];
        endLine.backgroundColor = [AppUtils colorWithHexString:@"04b6e9"];
        [buttonViewview addSubview:endLine];
        
        return buttonViewview;
    }
    
}


//团购商家详情
- (void)tuangoushangjiadetail:(UIButton *)sender{
    
    TGShopModel * shopModelDetail = [dataSocureArray objectAtIndex:sender.tag - 1000];
    TGShopDetailViewController * detail = [[TGShopDetailViewController alloc] init];
    detail.shopId = shopModelDetail.storeId;
    [self.navigationController pushViewController:detail animated:YES];
}

//查看全部快送
- (void)seeAllTuanGou:(UIButton *)sender{
    
    TGShopModel * model = (TGShopModel *)dataSocureArray[sender.tag -10000];
    AllKuaiSongViewController * all = [[AllKuaiSongViewController alloc] init];
    all.shopId = model.storeId;
    [self.navigationController pushViewController:all animated:YES];
}


//立即购买
- (void)buyNowWithGoodsData:(TGGoodsModel *)model{
    
    NSLog(@"订单数据>>>>%@",model);
    
    
    TuanOrderPageViewController * order = [[TuanOrderPageViewController alloc] init];
    order.goodsInfor = model;
    [self.navigationController pushViewController:order animated:YES];
}




//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma UITextField代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self hidKeyBoard];
    
    [progress startAnimation];

    [self TGlist:textField.text code:@"" areaName:@"" catalogId:@"150" companyId:P_WYID xqId:[UserManager shareManager].comModel.xqNo areaId:@"" longitude:[UserManager shareManager].comModel.longitude latitude:[UserManager shareManager].comModel.latitude sort:@"LATEST_RELEASE" quantity:@""];
    return YES;
}

//提示框
-(void)showMessage:(NSString *)str{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}

@end
