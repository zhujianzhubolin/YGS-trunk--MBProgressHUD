//
//  WTZhouBianKuaiSong.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "WTZhouBianKuaiSong.h"
#import "HuiTuanCell.h"
#import "WTTuanGouDetail.h"
#import "AllKuaiSongViewController.h"
#import "KuaiSongLanController.h"
#import "NIDropDown.h"
#import "TuanOrderPageViewController.h"
#import "TGShopDetailViewController.h"

#import "BingingXQModel.h"
#import "bindingHandler.h"
#import "UserManager.h"

#import "TGListModel.h"
#import "TGHandel.h"

#import "TGFenLei.h"
#import "TGGoodsModel.h"
#import "TGShopModel.h"

#import "TuanGouSearchViewController.h"
#import "ZJWebProgrssView.h"

#define LINEWIDETH IPHONE_WIDTH/3

@interface WTZhouBianKuaiSong ()<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate>
{
    __weak IBOutlet UITableView *kuaisonglist;
    __weak IBOutlet UIButton *paixuBtn;
    __weak IBOutlet UIButton *xiaoquBtn;
    __weak IBOutlet UIButton *fenleiBtn;
    __weak IBOutlet UIView *underLine;
    
    NSString * xqStr;
    NSString * fenLeiStr;
    NSString * paiXuStr;
    
    
    NSMutableArray * xiaoquModelArray;
    NSMutableArray * xiaoquArray;
    NSArray * paixuArray;
    
    NSMutableArray * fenLeiModelArray;
    NSMutableArray * nameArray;

    NSMutableArray * dataSocureArray;
    
    NSString * mylatitude;
    NSString * mylongitude;
    
    int pageNum;
    BOOL isRemoveAll;
    
    ZJWebProgrssView * progress;
    NSString * totalPage;
    
    NSString * xqNameStr;
    NSString * flNameStr;
    NSString * pxNameStr;
}

@end

@implementation WTZhouBianKuaiSong

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self hidetabbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"惠团购";
    
    fenLeiModelArray = [NSMutableArray array];
    nameArray = [NSMutableArray array];
    xiaoquModelArray = [NSMutableArray array];
    
    pageNum = 1;

    xqStr = @"";
    fenLeiStr = @"";
    paiXuStr = @"AWAY_NEAREST";
    mylongitude = [UserManager shareManager].comModel.longitude;
    mylatitude = [UserManager shareManager].comModel.latitude;
    
    isRemoveAll = NO;//"2016-01-28 14:21:53"
    
    [kuaisonglist registerNib:[UINib nibWithNibName:@"HuiTuanCell" bundle:nil] forCellReuseIdentifier:@"TuanCell"];
    
    progress = [[ZJWebProgrssView alloc] initWithFrame:CGRectMake(0, underLine.frame.origin.y + underLine.frame.size.height + 2, IPHONE_WIDTH, IPHONE_HEIGHT - underLine.frame.origin.y - underLine.frame.size.height -2)];
    [self.view addSubview:progress];
    __block typeof(self)weakSelf = self;
    progress.loadBlock = ^{
        [weakSelf reFreshUI];
    };
    [progress startAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(initData) userInfo:nil repeats:NO];

   [kuaisonglist addLegendHeaderWithRefreshingBlock:^{
       pageNum = 1;
       isRemoveAll = YES;
       [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(reFreshUI) userInfo:nil repeats:NO];
       
   }];
    
    [kuaisonglist addLegendFooterWithRefreshingBlock:^{
        pageNum ++;
        isRemoveAll = NO;
           [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(reFreshUI) userInfo:nil repeats:NO];
    }];
    
    [xiaoquBtn setTitle:[UserManager shareManager].comModel.xqName forState:UIControlStateNormal];
    [fenleiBtn setTitle:@"全部分类" forState:UIControlStateNormal];
    [paixuBtn setTitle:@"智能排序" forState:UIControlStateNormal];
    
    xqNameStr = [UserManager shareManager].comModel.xqName;
    flNameStr = @"全部分类";
    pxNameStr = @"智能排序";
    
    if ([AppUtils systemVersion] < 9) {
        [self buttonFit:xiaoquBtn];
        [self buttonFit:fenleiBtn];
        [self buttonFit:paixuBtn];

    }
}

- (void)reFreshUI{
    
    NSLog(@"%d",pageNum);

    [self TGlist:@"" code:fenLeiStr areaName:@"" catalogId:@"150" companyId:P_WYID xqId:xqStr areaId:@"" longitude:mylongitude latitude:mylatitude sort:paiXuStr quantity:@""];
    
    [kuaisonglist.header endRefreshing];
    [kuaisonglist.footer endRefreshing];
}

- (void)initData{

    [self getXiaoQuList];
    [self allFenlei];
    [self initUI];
    [self TGlist:@"" code:fenLeiStr areaName:@"" catalogId:@"150" companyId:P_WYID xqId:xqStr areaId:@"" longitude:mylongitude latitude:mylatitude sort:paiXuStr quantity:@""];
}

- (void)initUI{

    [self viewDidLayoutSubviewsForTableView:kuaisonglist];

    
    UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStylePlain target:self action:@selector(searchInfor)];
    self.navigationItem.rightBarButtonItem = search;
    
    xiaoquArray = [NSMutableArray array];
    paixuArray = [NSArray arrayWithObjects:@"最新发布",@"评价最高",@"距离最近",@"价格最低",nil];
    
    dataSocureArray = [NSMutableArray array];
    
    kuaisonglist.delegate = self;
    kuaisonglist.dataSource = self;
    
    
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    kuaisonglist.tableHeaderView = headView;
    kuaisonglist.tableFooterView = headView;
}

//查询全部分类
- (void)allFenlei{

    TGFenLei * model = [TGFenLei new];
    TGHandel * handel = [TGHandel new];
    model.catalogId = @"150";
    model.parentCategoryId = @"0";
    model.languageId = @"1";
    
    [handel searChTGFenlei:model success:^(id obj) {
        
        NSLog(@"目录列表>>>>>%@",obj);
        
        fenLeiModelArray = (NSMutableArray *)obj;
        [nameArray removeAllObjects];
        
        for (TGFenLei * fenlei in fenLeiModelArray){
            
            [nameArray addObject:fenlei.name];
        }
        
        
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
}

//获取团购列表---商品与商家名称公用storeName字段
- (void)TGlist:(NSString *)storeName code:(NSString *)code areaName:(NSString *)areaName catalogId:(NSString *)catalogId companyId:(NSString *)companyId xqId:(NSString *)xqId areaId:(NSString *)areaId longitude:(NSString *)longitude latitude:(NSString *)latitude sort:(NSString *)sort quantity:(NSString *)quantity{
    
    TGListModel * model = [TGListModel new];
    TGHandel * handel = [TGHandel new];
    
    model.pageNumber = [NSString stringWithFormat:@"%d",pageNum];
    model.pageSize = @"10";
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
        
//        NSMutableArray * shopA = (NSMutableArray *)obj;
//        //无更多商家时提示
//        if (pageNum > 1 && shopA.count <= 0) {
//            [AppUtils showAlertMessageTimerClose:@"无更多商家"];
//            return ;
//        }
        
        if (isRemoveAll) {
            [dataSocureArray removeAllObjects];
        }
        for (TGShopModel * shopModel in obj) {
            [dataSocureArray addObject:shopModel];
        }
        [progress stopAnimationNormalIsNoData:[NSArray isArrEmptyOrNull:dataSocureArray]];
        NSLog(@"团购列表数组>>>>>%@",dataSocureArray);
        totalPage = handel.totalPage;
        [AppUtils dismissHUD];
        [kuaisonglist reloadData];
    } failed:^(id obj) {
        [progress stopAnimationFailIsNoData:[NSArray isArrEmptyOrNull:dataSocureArray]];
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];

}


//获取小区列表
- (void)getXiaoQuList{

    BingingXQModel *bindM =[BingingXQModel new];
    bindingHandler *bindH =[bindingHandler new];
    bindM.pageNumber=@"1";
    bindM.pageSize=@"1000";
    
    bindM.wyId = [UserManager shareManager].comModel.wyId;
    bindM.merberId=[UserManager shareManager].userModel.memberId;
    bindM.orderType = @"asc";
    bindM.orderBy = @"dateCreated";
    
    [bindH requsetForGetCommunityDataForModel:bindM success:^(id obj) {
        
        xiaoquModelArray = (NSMutableArray *)obj ;
    
        for (BingingXQModel * model in xiaoquModelArray) {
            [xiaoquArray addObject:model.xqName];
        }
        
    } failed:^(id obj) {

    }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [AppUtils tableViewFooterPromptWithPNumber:pageNum withPCount:[totalPage intValue] forTableV:kuaisonglist];
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

    HuiTuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TuanCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HuiTuanCell" owner:self options:nil]  objectAtIndex:0];
    }
    
    cell.buyNow = ^(TGGoodsModel * goods){
        
        [self buyNowWithGoodsData:goods];
        
    };
    
    TGShopModel * shopModel = [dataSocureArray objectAtIndex:indexPath.section];
    
    [cell TGGoodsCellData:shopModel.goodsArray[indexPath.row]];

    return cell;
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
    buttonViewview.frame = CGRectMake(0, 2, self.view.frame.size.width, 46);
    buttonViewview.tag = 1000 + section;
    [buttonViewview addTarget:self action:@selector(tuangoushangjiadetail:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:buttonViewview];
    
    //商家名称
    UILabel * shopName = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, IPHONE_WIDTH/2 +10,46)];
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
    
    CGSize disTanceLable = [AppUtils sizeWithString:trueDis font:[UIFont systemFontOfSize:13] size:CGSizeMake(IPHONE_WIDTH/2, 46)];
    //距离小区多远
    UILabel * distanceArea = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH -disTanceLable.width -5,2,disTanceLable.width,46)];
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
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, CGFLOAT_MIN)];
        return view;
        
    }else{
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


//选择小区
- (IBAction)chooseXq:(UIButton *)sender {
    
    xiaoquBtn.selected = YES;
    fenleiBtn.selected = NO;
    paixuBtn.selected = NO;
    [self lineMove:sender];
    
    NSLog(@"%@%@%@",xqNameStr,flNameStr,pxNameStr);
    
    [xiaoquBtn setTitle:xqNameStr forState:UIControlStateNormal];
    [fenleiBtn setTitle:flNameStr forState:UIControlStateNormal];
    [paixuBtn setTitle:pxNameStr forState:UIControlStateNormal];


    long rowNum;
    
    if (xiaoquArray.count > 5) {
        rowNum = 5;
    }else{
        rowNum = xiaoquArray.count;
    }

    [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(0,64 + 42 +2, IPHONE_WIDTH, rowNum * 40) withButton:sender withArr:[xiaoquArray copy] withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentLeft isSelHide:YES];
    [NIDropDown dropDownInstance].delegate = self;
}

//选择分类
- (IBAction)chooseKind:(UIButton *)sender {
    
    xiaoquBtn.selected = NO;
    paixuBtn.selected = NO;
    fenleiBtn.selected = YES;
    [self lineMove:sender];

    NSLog(@"%@%@%@",xqNameStr,flNameStr,pxNameStr);
    
    [xiaoquBtn setTitle:xqNameStr forState:UIControlStateNormal];
    [fenleiBtn setTitle:flNameStr forState:UIControlStateNormal];
    [paixuBtn setTitle:pxNameStr forState:UIControlStateNormal];
    
    long rowNum;
    
    if (nameArray.count > 5) {
        rowNum = 5;
    }else{
        rowNum = nameArray.count;
    }
    
   [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(0,64 + 42 +2, IPHONE_WIDTH, rowNum * 40) withButton:sender withArr:[nameArray copy] withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentLeft isSelHide:YES];
    [NIDropDown dropDownInstance].delegate = self;
}

//排序方式
- (IBAction)arrangeMethod:(UIButton *)sender {
    
    xiaoquBtn.selected = NO;
    paixuBtn.selected = YES;
    fenleiBtn.selected = NO;
    [self lineMove:sender];
    
    NSLog(@"%@%@%@",xqNameStr,flNameStr,pxNameStr);
    
    [xiaoquBtn setTitle:xqNameStr forState:UIControlStateNormal];
    [fenleiBtn setTitle:flNameStr forState:UIControlStateNormal];
    [paixuBtn setTitle:pxNameStr forState:UIControlStateNormal];

    
   [[NIDropDown dropDownInstance] showDropDownWithRect:CGRectMake(0,64 + 42 +2, IPHONE_WIDTH, 4 * 40) withButton:sender withArr:[paixuArray copy] withAccessoryType:UITableViewCellAccessoryNone withTextAligment:NSTextAlignmentLeft isSelHide:YES];
    
    [NIDropDown dropDownInstance].delegate = self;
}

- (void)niDropDownDelegateMethod:(NSInteger)index forBtn:(UIButton *)button{
    
    [progress startAnimation];
    
    NSArray * sortarray = [NSArray arrayWithObjects:@"LATEST_RELEASE",@"HIGHEST_EVALUATION",@"AWAY_NEAREST",@"LOWEST_PRICE", nil];
    if (button.tag == 1000) {
        pageNum =1;
        BingingXQModel * xqModel = [xiaoquModelArray objectAtIndex:index];
        
        
        xqStr = xqModel.xqNo;
        mylatitude = xqModel.latitude;
        mylongitude = xqModel.longitude;
        [kuaisonglist.header beginRefreshing];
        
        xiaoquBtn.selected = YES;
        [xiaoquBtn setTitle:xqModel.xqName forState:UIControlStateSelected];
        
        if ([AppUtils systemVersion] < 9) {
            [self buttonFit:xiaoquBtn];
        }
        
        xqNameStr = xqModel.xqName;


    }else if (button.tag == 1001){
        pageNum =1;
        TGFenLei * fen = [fenLeiModelArray objectAtIndex:index];
        fenLeiStr = fen.code;
        
        [kuaisonglist.header beginRefreshing];
        
        fenleiBtn.selected = YES;
        [fenleiBtn setTitle:fen.name forState:UIControlStateSelected];
        
        if ([AppUtils systemVersion] < 9) {
            [self buttonFit:fenleiBtn];
        }
        
        flNameStr = fen.name;

    }else{
        pageNum =1;
        
        paiXuStr = [sortarray objectAtIndex:index];
        [kuaisonglist.header beginRefreshing];
        
        paixuBtn.selected = YES;
        [paixuBtn setTitle:[paixuArray objectAtIndex:index] forState:UIControlStateSelected];
        
        if ([AppUtils systemVersion] < 9) {
            [self buttonFit:paixuBtn];
        }
        
        pxNameStr = paixuArray[index];
        
    }

}


- (void)searchInfor{
    
    TuanGouSearchViewController * search = [[TuanGouSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


//立即购买
- (void)buyNowWithGoodsData:(TGGoodsModel *)model{

    NSLog(@"订单数据>>>>%@",model);
    
    TuanOrderPageViewController * order = [[TuanOrderPageViewController alloc] init];
    order.goodsInfor = model;
    [self.navigationController pushViewController:order animated:YES];
}


//挪动下划线
- (void)lineMove:(UIButton *)sender{

    [UIView animateWithDuration:0.2 animations:^{
        CGRect fooFrame = underLine.frame;
        fooFrame.origin.x = (sender.tag - 1000) * (IPHONE_WIDTH/3);
        underLine.frame = fooFrame;
    }];
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

- (void)buttonFit:(UIButton *)btn{

    [btn sizeToFit];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, 0, btn.imageView.frame.size.width);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width, 0, -btn.titleLabel.frame.size.width);
}

@end
