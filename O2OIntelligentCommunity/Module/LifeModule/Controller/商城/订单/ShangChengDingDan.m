//
//  ShangChengDingDan.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



#import "ShangChengDingDan.h"
#import "AdressCell.h"
#import "PayDoneShangCheng.h"
#import "GoodsListCell.h"
#import "ShoppingCarDataSocure.h"
#import "Life_First.h"
#import "WXApi.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"
#import "MoRenAddress.h"
#import "AddNewAdress.h"
#import "UserManager.h"
#import "AdressAdd.h"
#import "UserManager.h"
#import "ShoppingCarDataSocure.h"
#import "ZSDPaymentView.h"
#import "OpenMoneyBagVC.h"
#import "MoneyBagPayModel.h"
#import "MoneyBagPayHandler.h"
#import "WXApi.h"
#import <MJRefresh.h>
#import "SetDefaultAdress.h"
#import "LocalUtils.h"
#import "TuanGouQuanViewCOntroller.h"
#import "NSDictionary+wrapper.h"

//支付页面
#import "PayViewController.h"
#import "DaiJinQuanModel.h"
#import "DaiJinQunHandel.h"
#import "CicleVuew.h"


@interface ShangChengDingDan ()<UITableViewDataSource,UITableViewDelegate,SendArdessInfo,UIAlertViewDelegate,StoreQuan>
{
    __weak IBOutlet UITableView *shangcheng;
    
    UITableView * cellTableView;
    UIImageView * gou_image;
    UIImageView * jifen_gou;
    NSMutableArray * dataSocure;
    NSString * lastMoney;
    NSInteger sectionNum;
    NSInteger rowNum;
    //最后的金额
    UILabel * ll;
    NSMutableArray * shopArray;
    NSDictionary * adressdict;
    
    BOOL isEmpty;
    UIButton * kuaijie;
    UIButton * weixin;
    UIView * bgV;
    UIView * buttomV;
    NSString * hebaoOrderNo;
    
    __weak IBOutlet UILabel *totalPriceLable;
    BOOL isWx;
    
    NSMutableArray * totalCountArray;
    NSMutableArray * totalPriceArray;
    NSMutableArray * totalYunFeiArray;
    NSMutableArray * lastMoneyArray;
    
    //没有使用代金券的金额数组
    NSMutableArray * totalPriceWithOutQuan;
    
    //最后所有的金额
    NSString * lastPayMoney_all;
    
    NSMutableArray * shopIDArray;
    NSMutableArray * goodsIDArray;
    
    NSString * wxOrderNum;
    NSString * qianbaoNum;
    
    NSArray * qianbaoOrderArray;
    NSArray * weixinOrderArray;
    NSString * shopIdStr;
    
    //传过来的商家券数组
    NSMutableArray * shopModelsArray;
    NSMutableArray * daijinquanArray;
    
    //代金券可用数组
    NSMutableArray * quanCanUseArray;
    
    NSInteger * tempSection;
    BOOL isNeedUpdateAddress;
}

@end

@implementation ShangChengDingDan

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isNeedUpdateAddress) {
        [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getAddress) userInfo:nil repeats:NO];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(UpdateAddress:)
                                                name:k_NOTI_ORDER_ADDORESS_CHANGE
                                              object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    isNeedUpdateAddress = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(UpdateAddress:)
                                                name:k_NOTI_ORDER_ADDORESS_CHANGE
                                              object:nil];

    
    NSLog(@"总共价格>>>>>%@",_totalPrice);
    //提交订单的时候用这个数据源
    NSLog(@"传过来的数据源>>>>>%@",_dataArray);
    shopArray = [NSMutableArray array];
    totalCountArray = [NSMutableArray array];
    totalPriceArray = [NSMutableArray array];
    totalYunFeiArray = [NSMutableArray array];
    lastMoneyArray = [NSMutableArray array];
    shopIDArray = [NSMutableArray array];
    daijinquanArray = [NSMutableArray array];
    totalPriceWithOutQuan = [NSMutableArray array];
    quanCanUseArray = [NSMutableArray array];
    
    if ([WXApi isWXAppInstalled]) {
        isWx = YES;
    }else{
        isWx = NO;
    }
    self.title = @"确认订单";
    [self initUI];
    
    isEmpty = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getAddress) userInfo:nil repeats:NO];
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
        [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(quanStaue) userInfo:nil repeats:NO];
#else
    
#endif
}

- (void)quanStaue{
    
    [self getShopQuanState:shopIdStr];
    
}
- (void)UpdateAddress:(NSNotification*)obj{
    isNeedUpdateAddress=YES;
}


//下单查询商家代金券情况
- (void)getShopQuanState:(NSString *)shopId{

    DaiJinQuanModel * model = [DaiJinQuanModel new];
    DaiJinQunHandel * handel = [DaiJinQunHandel new];
    
    model.memberId = [UserManager shareManager].userModel.memberId;
    model.storeId = shopId;
    model.status = @"1";
    
    [handel getStoreAvailbleQuan:model success:^(id obj) {
        
        NSLog(@"传过来的ShopModel>>>>%@",obj);
        
        shopModelsArray = (NSMutableArray *)obj;
        
        
        for (int i = 0; i < totalPriceWithOutQuan.count; i ++) {
            
            NSMutableArray * mshopArray = [NSMutableArray array];//商家数组
            
            NSString * perMoneyInShop = totalPriceWithOutQuan[i];//每个商家里面的金额
            
            for (DaiJinQuanModel * mQuanModel in shopModelsArray[i]){//遍历商家里面的代金券
                if ([perMoneyInShop floatValue] >= [mQuanModel.bound floatValue]) {
                    [mshopArray addObject:mQuanModel];
                }
            }
            
            [quanCanUseArray addObject:mshopArray];//加到外层大数组，商家
        }
        
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [shangcheng reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failed:^(id obj) {
        
    }];

}

//刷新地址的那个Cell
- (void)refreshAdressCell{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [shangcheng reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

//获取最新收货地址
- (void)getAddress{
    
    Life_First * handel = [Life_First new];
    AllAdressList * list = [AllAdressList new];
    list.memberId = [UserManager shareManager].userModel.memberId;
    [handel getAllAdress:list success:^(id obj) {
        NSLog(@"收货地址列表>>>>%@",obj);
        dataSocure = obj[@"list"];
        if (![obj[@"code"] isEqualToString:@"success"]) {
            isEmpty = YES;
        }else{
            if (![NSArray isArrEmptyOrNull:dataSocure])
            {
                isEmpty = NO;
                BOOL isHasDefaultAddress = NO;
                for (int i = 0; i < dataSocure.count; i++)
                {
                    NSDictionary *dic =dataSocure[i];
                    if (![NSDictionary isDicEmptyOrNull:dic])
                    {
                        BOOL isDefault = [dic[@"isDefault"] boolValue];
                        if (isDefault)
                        {
                            adressdict = dic;
                            isHasDefaultAddress = YES;
                        }
                    }
                }
                
                if (!isHasDefaultAddress) {
                    adressdict = nil;
                }
            }
            else {
                isEmpty = YES;
                adressdict = nil;
            }
        }
        [self refreshAdressCell];
    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
        isEmpty = YES;
    }];


//    Life_First * handel = [Life_First new];
//    MoRenAddress * address = [MoRenAddress new];
//    address.memberId = [UserManager shareManager].userModel.memberId;
//    [handel GetMoRenAddress:address success:^(id obj) {
//        
//        NSLog(@"收货地址>>>>>%@",obj);
//        
//        if (![obj[@"code"] isEqualToString:@"success"]) {
//            isEmpty = YES;
//            [self refreshAdressCell];
//        }else{
//           
//            isEmpty = NO;
//            
//            if (![obj[@"entity"] isEqual:[NSNull null]]) {
//                adressdict = obj[@"entity"];
//            }else{
//                isEmpty = YES;
//            }
//            
//            [self refreshAdressCell];
//        }
//
//        
//    } failed:^(id obj) {
//
//        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
//        isEmpty = YES;
//    }];
}

- (void)initUI{
    
    [self viewDidLayoutSubviewsForTableView:shangcheng];
    
    shangcheng.delegate = self;
    shangcheng.dataSource = self;
    
    if (!isEmpty) {
        
        [shangcheng registerNib:[UINib nibWithNibName:@"AdressCell" bundle:nil] forCellReuseIdentifier:@"AdressID"];
    }
    
    shangcheng.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    shangcheng.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

    //多少段
    sectionNum = _dataArray.count;
    //总共多少行
    rowNum = 0;
    for (int i = 0; i < _dataArray.count; i++) {
        rowNum += [_dataArray[i][@"goodsList"] count];
    }
    //取出每个商家的名称
    for (NSDictionary * dict in _dataArray) {
        //取出每一个商家里面的商品总数
        //        [totalCountArray addObject:[NSNumber numberWithInteger:[dict[@"goodsList"] count]]];
        int goodsNum = 0;
        for (NSDictionary * dict1 in dict[@"goodsList"]) {
            [shopIDArray addObject:dict1[@"storeId"]];
            //初始化代金券数组，默认代金券给一个空串
            [daijinquanArray addObject:@""];
            [shopArray addObject:dict1[@"goodslist"][@"entity"][@"storeName"]];
            goodsNum += [dict1[@"addNumber"] intValue];
        }
        [totalCountArray addObject:[NSNumber numberWithInt:goodsNum]];
    }
    shopIdStr = [shopIDArray componentsJoinedByString:@"|"];
    NSLog(@"%@",shopIdStr);
    NSLog(@"%@",daijinquanArray);
    //以商家为单位，取出每个商家里面的金额总数
    [self countMoney];
}


//计算金额
-(void)countMoney{

    [totalPriceArray removeAllObjects];
    
    for (int i = 0; i <_dataArray.count; i++) {
        
        CGFloat lastAlMoey = 0.0;
        for (NSDictionary * goodsdict in _dataArray[i][@"goodsList"]) {
            int number = [goodsdict[@"addNumber"] intValue];
            CGFloat price = [goodsdict[@"goodslist"][@"entity"][@"price"] floatValue];
            lastAlMoey += price * number;
        }
        
        //未使用代金券的数组
        [totalPriceWithOutQuan addObject:[NSString stringWithFormat:@"%.2f",lastAlMoey]];
        
        id myQuanModel = daijinquanArray[i];
        if ([myQuanModel isKindOfClass:[DaiJinQuanModel class]]) {
            DaiJinQuanModel * jianMoneyModel = (DaiJinQuanModel *)myQuanModel;
            lastAlMoey = lastAlMoey - [jianMoneyModel.parValue floatValue];
        }
        [totalPriceArray addObject:[NSString stringWithFormat:@"%.2f",lastAlMoey]];
    }
    
    NSMutableArray * arrayWithQuan = [NSMutableArray array];
    
    //要算完券的金额后，再来算运费
    [arrayWithQuan removeAllObjects];
    for (int i = 0; i <_dataArray.count; i++) {
        CGFloat lastAlMoey = 0.0;
        for (NSDictionary * goodsdict in _dataArray[i][@"goodsList"]) {
            int number = [goodsdict[@"addNumber"] intValue];
            CGFloat price = [goodsdict[@"goodslist"][@"entity"][@"price"] floatValue];
            lastAlMoey += price * number;
        }
        
        //减去代金券的金额后，计算相关运费
        if ([daijinquanArray[i] isKindOfClass:[DaiJinQuanModel class]]) {
            DaiJinQuanModel * quanModel = (DaiJinQuanModel *)daijinquanArray[i];
            lastAlMoey = lastAlMoey - [quanModel.parValue floatValue];
        }
        
        [arrayWithQuan addObject:[NSString stringWithFormat:@"%.2f",lastAlMoey]];
    }
    
    
    //取出每一个商家里面的商家运费
    [totalYunFeiArray removeAllObjects];
    for (int i = 0; i < [self.dataArray count]; i ++) {
        //每个商家里面的实际消费价格
        NSString * eachPrice = arrayWithQuan[i];
        //        每个商家里面的运费
        if ([self.dataArray[i][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"] isEqual:[NSNull null]]) {
            [totalYunFeiArray addObject:@"0"];
        }else{
            NSString * fullYunFei = self.dataArray[i][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"];
            if ([eachPrice floatValue] >= [fullYunFei floatValue]) {
                [totalYunFeiArray addObject:@"0"];
            }else{
                if ([self.dataArray[i][@"goodsList"][0][@"goodslist"][@"entity"][@"notFullMoney"] isEqual:[NSNull null]]) {
                    [totalYunFeiArray addObject:@"0"];
                }else{
                    [totalYunFeiArray addObject:self.dataArray[i][@"goodsList"][0][@"goodslist"][@"entity"][@"notFullMoney"]];
                }
            }
        }
    }
    
    //运费加商品，每个商家的总价格
    [lastMoneyArray removeAllObjects];
    
    for (int i = 0; i < totalPriceArray.count; i ++) {
        CGFloat shangjiaTotal = [totalPriceArray[i] floatValue] + [totalYunFeiArray[i] floatValue];
        [lastMoneyArray addObject:[NSString stringWithFormat:@"%.2f",shangjiaTotal]];
    }
    
    NSNumber * allSum = [lastMoneyArray valueForKeyPath:@"@sum.floatValue"];
    CGFloat myallmoney = [allSum floatValue];
    lastPayMoney_all = [NSString stringWithFormat:@"%.2f",myallmoney];
    totalPriceLable.text = [NSString stringWithFormat:@"  订单总额:%.2f元",myallmoney];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == shangcheng) {
        return 3;
    }else{
        return _dataArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == shangcheng) {
        if (section == 0) {
            
            return 1;
            
        }else if (section == 1) {
            
            return 1;
            
        }else{
            
            if (isWx) {
                return 2;
            }else{
                return 1;
            }
        }
    }else{
        return [_dataArray[section][@"goodsList"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == shangcheng) {
        if (indexPath.section == 0) {
            return 75;
        }else if(indexPath.section == 1){
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }else{
            return 60;
        }
    }else{
        
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == shangcheng) {
        
        if (indexPath.section == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"EmptyCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
            }
            
            UILabel * noticLable = [UILabel addlable:cell.contentView frame:CGRectMake(20, 0, IPHONE_WIDTH - 40, 70) text:@"添加收货地址" textcolor:[UIColor blackColor]];
            noticLable.font = [UIFont systemFontOfSize:17];
            noticLable.textAlignment = NSTextAlignmentCenter;
            if (isEmpty) {
                noticLable.text =@"添加收货地址";
                return cell;
            }else{
                if ([NSDictionary isDicEmptyOrNull:adressdict])
                {
                    noticLable.text =@"选择收货地址";
                    return cell;
                }
                else
                {
                    static NSString * strID = @"AdressID";
                    AdressCell * adress = [tableView dequeueReusableCellWithIdentifier:strID];
                    if (adress == nil) {
                        adress = [[AdressCell alloc] init];
                    }
                    
                    if (adressdict != nil) {
                        [adress cellData:adressdict];
                    }else{
                        
                    }
                    
                    return adress;

                }
            }
        }else if (indexPath.section == 1){
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_list"];
            cell.backgroundColor = [UIColor greenColor];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_list"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            CGFloat cellHeight = 120;
            #ifdef SmartComJYZX
                cellHeight = 80;
            #elif SmartComYGS
                        
            #else
                        
            #endif
            
            cellTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,IPHONE_WIDTH, 60 * rowNum + cellHeight *sectionNum/*+ 30 * sectionNum最后一段尾高度*/) style:UITableViewStyleGrouped];
            
            cellTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
            cellTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
            cellTableView.delegate = self;
            cellTableView.dataSource = self;
            cellTableView.scrollEnabled = NO;
            [cell.contentView addSubview:cellTableView];
            [self viewDidLayoutSubviewsForTableView:cellTableView];
            
            CGRect rect = cell.frame;
            rect.size.height = cellTableView.frame.size.height;
            cell.frame = rect;
            
            return cell;
            
        }else{
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSArray * titleArray;
            NSArray * imagearray;
            
            if (isWx) {
                titleArray = [NSArray arrayWithObjects:@"钱包支付",@"微信支付", nil];
                imagearray = [NSArray arrayWithObjects:@"myPay",@"weChatPay", nil];
            }else{
                titleArray = [NSArray arrayWithObjects:@"钱包支付", nil];
                imagearray = [NSArray arrayWithObjects:@"myPay", nil];
            }
            

                
                UILabel * lable = [UILabel addlable:cell.contentView frame:CGRectMake(0, 1, self.view.frame.size.width, 59) text:@"" textcolor:[UIColor whiteColor]];
                lable.backgroundColor = [UIColor whiteColor];
                //支付方式图标加文字
                [UIImageView addimageView:lable frame:CGRectMake(8, 15, 30, 30) imageName:[imagearray objectAtIndex:indexPath.row]];
                UILabel * method = [UILabel addlable:lable frame:CGRectMake(45, 0, 100, 59) text:[titleArray objectAtIndex:indexPath.row] textcolor:[UIColor blackColor]];
                method.font = [UIFont systemFontOfSize:15];
                
                if (indexPath.row == 0) {
                    kuaijie = [self addButton:cell.contentView frame:CGRectMake(self.view.frame.size.width-40, 20, 20, 20) selectImage:[UIImage imageNamed:@"gou_h"] norImage:[UIImage imageNamed:@"gou"]];
                }else{
                    weixin = [self addButton:cell.contentView frame:CGRectMake(self.view.frame.size.width-40, 20, 20, 20) selectImage:[UIImage imageNamed:@"gou_h"] norImage:[UIImage imageNamed:@"gou"]];
                }
                
                kuaijie.selected = YES;
            
            return cell;
        }

        
    }else{
    
        GoodsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsListCell"];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsListCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellData:_dataArray[indexPath.section][@"goodsList"][indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == shangcheng) {
        
        if (indexPath.section == 0) {
            
            if (isEmpty) {
                AdressAdd * add = [[AdressAdd alloc] init];
                add.isEmpty=YES;
                [self.navigationController pushViewController:add animated:YES];
            }else{
                AddNewAdress * add = [AddNewAdress new];
                add.adressdele = self;
                
                [self.navigationController pushViewController:add animated:YES];
            }
        }else if (indexPath.section == 2){/*选择支付方式*/
            
            if (indexPath.row == 0) {
                kuaijie.selected = YES;
                weixin.selected = NO;
            }
            
            if(indexPath.row == 1){
                weixin.selected = YES;
                kuaijie.selected = NO;
            }
        }else{
            
            
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == shangcheng) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
        return view;

    }else{

        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
        lable.text = [NSString stringWithFormat:@"  %@",shopArray[section]];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.font = [UIFont systemFontOfSize:17];
        [view addSubview:lable];
        return view;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == shangcheng) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGFLOAT_MIN)];
        return view;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        view1.backgroundColor = [UIColor whiteColor];
        [view addSubview:view1];
        //商品数量
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,IPHONE_WIDTH/3, 30)];
        lable.text = [NSString stringWithFormat:@"  共计%@件商品",totalCountArray[section]];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:lable];
        
        //价格及运费
        UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH/3, 0, 2 * IPHONE_WIDTH/3 -10, 30)];
        lable1.textColor = [UIColor orangeColor];
        
        CGFloat allM = [totalPriceWithOutQuan[section] floatValue];
        NSString * allMS = [NSString stringWithFormat:@"%.2f",allM];
        
        if ([totalYunFeiArray[section] floatValue] <= 0) {
            lable1.text = [NSString stringWithFormat:@"小计%@元(免运费)",allMS];
        }else{
            
            CGFloat YFall = [totalYunFeiArray[section] floatValue];
            allMS = [NSString stringWithFormat:@"%.2f",allM + YFall];
            NSString * YFas = [NSString stringWithFormat:@"%.2f",YFall];
            lable1.text = [NSString stringWithFormat:@"小计%@元(含%@元运费)",allMS,YFas];
        }
        lable1.textAlignment = NSTextAlignmentRight;
        lable1.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:lable1];
        

#ifdef SmartComJYZX
        
#elif SmartComYGS
        //代金券
        UIButton * daijinquan = [UIButton buttonWithType:UIButtonTypeCustom];
        daijinquan.titleLabel.font = [UIFont systemFontOfSize:14];
        daijinquan.backgroundColor = [UIColor whiteColor];
        [daijinquan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        daijinquan.frame = CGRectMake(0, 31, IPHONE_WIDTH, 40);
        daijinquan.tag = 100000 + section;
        [daijinquan setTitle:@"  代金券" forState:UIControlStateNormal];
        [daijinquan addTarget:self action:@selector(chooseQuan:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:daijinquan];
        daijinquan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIImageView * jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - G_INTERVAL /2 - G_INTERVAL, 15, G_INTERVAL /2, G_INTERVAL)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [daijinquan addSubview:jiantou];
        
        id quanM = daijinquanArray[section];
        
        DaiJinQuanModel * myquanMo;
        
        if ([quanM  isKindOfClass:[DaiJinQuanModel class]]) {
            myquanMo = quanM;
        }
        
        UILabel * quanNum = [UILabel addlable:daijinquan frame:CGRectMake(60, 0, daijinquan.frame.size.width - 60 - jiantou.frame.size.width - G_INTERVAL, 40) text:@"" textcolor:[UIColor orangeColor]];
        quanNum.tag = 10100;
        quanNum.textAlignment = NSTextAlignmentRight;
        
        if (myquanMo == nil) {
            if (quanCanUseArray.count > 0) {
                NSUInteger quanCount = [quanCanUseArray[section] count];
                if (quanCount > 0) {
                    quanNum.text = [NSString stringWithFormat:@"%ld张券适用",[quanCanUseArray[section] count]];
                }
                else {
                    quanNum.text = @"暂无可用";
                }
            }else{
                quanNum.text = @"暂无可用";
            }
            
        }else{
            quanNum.text = [NSString stringWithFormat:@"%@",myquanMo.couponTemplateName];
        }
#else
        
#endif
        return view;
    }
}

- (void)chooseQuan:(UIButton *)btn{

    TuanGouQuanViewCOntroller * quan = [[TuanGouQuanViewCOntroller alloc] init];
    quan.shopId = [shopIDArray objectAtIndex:btn.tag - 100000];
    quan.bounds = [totalPriceWithOutQuan objectAtIndex:btn.tag - 100000];
    //返回过来，走代理的时候指定刷新哪一段
    quan.section = btn.tag - 100000;
    quan.mystyle = StoreType;
    quan.selectArray = daijinquanArray;
    quan.shangchengquanDelegate = self;
    [self.navigationController pushViewController:quan animated:YES];
}

//选择代金券传过来的
- (void)shangCheng:(DaiJinQuanModel *)model index:(NSInteger)section{

    NSLog(@"选择代金券后%@>>>%ld",model,(long)section);
    if (model != nil) {
        [daijinquanArray replaceObjectAtIndex:section withObject:model];
    }else{
        [daijinquanArray replaceObjectAtIndex:section withObject:@""];
    }
    [self countMoney];
    
    
    NSLog(@"选择替换后的数组>>>>>>%@",daijinquanArray);
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [shangcheng reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == shangcheng) {
        if (section == 0){
            return CGFLOAT_MIN;
        }else if (section == 1){
            return 10;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == shangcheng) {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else if (section == 1){
            return CGFLOAT_MIN;
        }else{
            return 10;
        }
    }else{
        #ifdef SmartComJYZX
                return 30;
        #elif SmartComYGS
                return 80;
        #else
        
        #endif
    }
}

//选择地址传过来
- (void)SenAdress:(id)info{
    NSLog(@"传过来的地址>>>>>%@",info);
    isEmpty = NO;
    isNeedUpdateAddress=NO;
    adressdict = nil;
    adressdict = (NSDictionary *)info;
    [self refreshAdressCell];
}

- (UIView *)addView:(UIView *)view frame:(CGRect)frame backcolor:(UIColor *)color{
    UIView * MyView = [[UIView alloc] initWithFrame:frame];
    MyView.backgroundColor = color;
    [view addSubview:MyView];
    return MyView;
}

- (UIButton *)addbutton:(UIView *)view frame:(CGRect)frame title:(NSString *)title {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 5;
    [view addSubview:btn];
    return btn;
}

- (void)makeSureStoreOrder{

     CGFloat money = [lastPayMoney_all floatValue];
    if(money <= 0)
    {
        [AppUtils showAlertMessageTimerClose:@"商品总价必须大于0，订单信息异常！"];
        return;
    }

    NSLog(@"%@",[UserManager shareManager].userModel.isCardActivate);
    
    if (isEmpty) {
        [AppUtils showAlertMessageTimerClose:@"请先添加收货地址!"];
        return;
    }
    
    if (weixin.selected) {
        NSLog(@"微信支付");
        if (wxOrderNum == nil) {//订单不存在，下单支付
            NSMutableDictionary * uploaddict = [NSMutableDictionary dictionary];//最终上传的字典
            NSMutableArray * omDtoarray = [NSMutableArray array];
            for (int i = 0; i < _dataArray.count; i ++) {/*商家*/
                NSMutableDictionary * shopDict = [NSMutableDictionary dictionary];//创建商家字典
                [omDtoarray addObject:shopDict];//商家加到商家大数组
                [shopDict setValue:[NSString stringWithFormat:@"%@",adressdict[@"consignee"]] forKey:@"customerName"];//用户名称
                [shopDict setValue:@"0" forKey:@"ifPayOnArrival"];//是否在线支付
                [shopDict setValue:[UserManager shareManager].userModel.memberId forKey:@"memberNo"];//用户ID
                [shopDict setValue:@"10" forKey:@"memberVipCardLevel"];//会员等级
                
                [shopDict setValue:_dataArray[i][@"goodsList"][0][@"storeId"] forKey:@"merchantNo"];//商家ID
                [shopDict setValue:@"自营" forKey:@"merchantType"];//营销方式
                [shopDict setValue:@"0" forKey:@"needInvoice"];
                [shopDict setValue:@"APP" forKey:@"orderSource"];//订单来源
                [shopDict setValue:@"GENERAL" forKey:@"orderType"];//订单类型
                [shopDict setValue:@"0" forKey:@"weight"];
                
                //添加商户跟物业ID
                [shopDict setObject:[UserManager shareManager].comModel.wyId forKey:@"wyNo"];
                [shopDict setObject:[NSString stringWithFormat:@"%@",_dataArray[i][@"goodsList"][0][@"goodslist"][@"entity"][@"storeName"]] forKey:@"merchantName"];
                [shopDict setObject:totalYunFeiArray[i] forKey:@"transportFee"];
                
                NSString * quanCoup;
                
                if ([daijinquanArray[i] isKindOfClass:[DaiJinQuanModel class]]) {
                    DaiJinQuanModel * modelw = (DaiJinQuanModel *)daijinquanArray[i];
                    quanCoup = modelw.couponNo;
                }else{
                    quanCoup = @"";
                }
                
                [shopDict setObject:quanCoup forKey:@"voucherNo"];
                
                
                //每个商家里面的一个数组
                NSMutableArray * onlyOne = [NSMutableArray array];
                [shopDict setValue:onlyOne forKey:@"osDTOs"];
                //商家字典
                NSMutableDictionary * onlydict = [NSMutableDictionary dictionary];
                [onlyOne addObject:onlydict];
                [onlydict setValue:adressdict[@"addressName"] forKey:@"addressDetail"];
                [onlydict setValue:@"0" forKey:@"distributeType"];
                [onlydict setValue:adressdict[@"mobile"] forKey:@"mobPhoneNum"];
                [onlydict setValue:adressdict[@"consignee"] forKey:@"userName"];
                NSMutableArray * goodsListArray = [NSMutableArray array];
                NSMutableArray * allMoneyInShop = [NSMutableArray array];
                
                //商品数组
                for (int j = 0; j < [_dataArray[i][@"goodsList"] count]; j ++) {//商品数组字典
                    NSMutableDictionary * goodsdict = [NSMutableDictionary dictionary];
                    //商品ID
                    [goodsdict setValue:_dataArray[i][@"goodsList"][j][@"id"] forKey:@"commodityId"];
                    //此ID暂时不管
                    [goodsdict setValue:_dataArray[i][@"goodsList"][j][@"id"] forKey:@"commodityCode"];
                    [goodsdict setValue:_dataArray[i][@"goodsList"][j][@"name"] forKey:@"commodityName"];
                    
                    
                    [goodsdict setValue:@"type" forKey:@"productCategory"];
                    [goodsdict setValue:@"0" forKey:@"productPropertyFlag"];
                    [goodsdict setValue:@"1" forKey:@"promotionType"];
                    //该类商品的数量
                    NSString * uniNum = _dataArray[i][@"goodsList"][j][@"addNumber"];
                    NSString * uniPrice = _dataArray[i][@"goodsList"][j][@"goodslist"][@"entity"][@"price"];
                    
                    [goodsdict setValue:uniNum forKey:@"saleNum"];
                    [goodsdict setValue:@"kg" forKey:@"saleUnit"];
                    
                    //单价
                    [goodsdict setValue:uniPrice forKey:@"unitDeductedPrice"];
                    [goodsdict setValue:uniPrice forKey:@"unitPrice"];
                    [goodsdict setValue:@"0" forKey:@"weight"];
                    
                    //一个商品的总价
                    int number = [uniNum intValue];
                    CGFloat moneyUnit = [uniPrice floatValue];
                    CGFloat total = moneyUnit * number;
                    NSString * afterMoney = [NSString stringWithFormat:@"%.2f",total];
                    
                    [allMoneyInShop addObject:afterMoney];
                    
                    [goodsdict setValue:afterMoney forKey:@"payAmount"];
                    [goodsListArray addObject:goodsdict];
                }
                [onlydict setValue:goodsListArray forKey:@"oiDTOs"];
                
                //一个商家里面的总价
                //            NSNumber * sumMoney = [allMoneyInShop valueForKeyPath:@"@sum.floatValue"];
                
                NSString * sumMoney = [lastMoneyArray objectAtIndex:i];
                [shopDict setValue:[NSString stringWithFormat:@"%@",sumMoney] forKey:@"totalPayAmount"];
                [shopDict setValue:[NSString stringWithFormat:@"%@",sumMoney] forKey:@"totalProductPrice"];
            }
            [uploaddict setObject:omDtoarray forKey:@"omDTO"];
            [uploaddict setObject:@"201506160001" forKey:@"batchNum"];
            [uploaddict setObject:@"APP" forKey:@"trade_type"];
            [uploaddict setObject:@"" forKey:@"openid"];
            [uploaddict setObject:ENVIRONMENT forKey:@"attach"];
            [uploaddict setObject:[LocalUtils chargeBodyForCharegeType:ChargeTypeOnlineShop] forKey:@"body"];
            [uploaddict setObject:@"c5ls2v7znidfowbg4ua6q3impg6uwm2p" forKey:@"nonce_str"];
            [uploaddict setObject:@"8.8.8.8" forKey:@"spbill_create_ip"];
            
           
            NSString * upLoadMoney = [NSString stringWithFormat:@"%.2f",money];
            [uploaddict setObject:[NSString stringWithFormat:@"%@",upLoadMoney] forKey:@"total_fee"];//以一分为单位>>>> 最后结算的总价格
            [uploaddict setObject:@"wxPay" forKey:@"payType"];
            
            NSLog(@"上传数据 >>>>>%@",uploaddict);
            
            Life_First * handel = [Life_First new];
            [AppUtils showProgressMessage:W_ALL_PROGRESS withType:SVProgressHUDMaskTypeClear];
            [handel GetOrderNo:uploaddict success:^(id obj) {
                NSLog(@"下单成功>>>>%@",obj);
                NSLog(@"下单成功>>>>%@",obj[@"message"]);
                if ([obj[@"code"] isEqualToString:@"success"] && ![obj[@"wxOrderNo"] isEqual:[NSNull null]]) {
                    
                    
                    //设置默认收货地址
//                    [self setDefaultAdress:adressdict[@"id"]];
                    
                    wxOrderNum = [NSString stringWithFormat:@"%@",obj[@"wxOrderNo"]];
                    weixinOrderArray = obj[@"orderBean"];
                    
                    [AppUtils dismissHUD];
                    for (int i = 0; i < self.dataArray.count; i++) {//商家
                        for (int j = 0; j < [self.dataArray[i][@"goodsList"] count]; j ++) {//商品
                            [[ShoppingCarDataSocure sharedShoppingCar] DeleGoodsFromShoppingCar:self.dataArray[i][@"goodsList"][0][@"storeId"] goodsID:self.dataArray[i][@"goodsList"][j][@"id"]];
                        }
                    }
                    
                    PayViewController * payM = [[PayViewController alloc] init];
                    payM.method = WXPayMethod;
                    payM.orderNum = wxOrderNum;
                    payM.allMoney = lastPayMoney_all;
                    payM.isMine = self.isMine;
                    payM.orderlistArray = weixinOrderArray;
                    [self.navigationController pushViewController:payM animated:YES];
                    
                    
                }else{
                    
                    [AppUtils showAlertMessageTimerClose:@"微信下单失败!"];
                    
                }
            } failed:^(id obj) {
                [AppUtils dismissHUD];
            }];
        }else{//订单存在，直接用订单号支付
            
            //            [self wxPayMethod];
            
            PayViewController * payM = [[PayViewController alloc] init];
            payM.method = WXPayMethod;
            payM.orderNum = wxOrderNum;
            payM.allMoney = lastPayMoney_all;
            payM.isMine = self.isMine;
            payM.orderlistArray = weixinOrderArray;
            [self.navigationController pushViewController:payM animated:YES];
            
        }
        
    }else {//钱包支付
        if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"1"]) {//已经开通了钱包1 未开通是0
            
            if (qianbaoNum == nil) {
                //测试商城下单
                NSMutableDictionary * uploaddict = [NSMutableDictionary dictionary];//最终上传的字典
                NSMutableArray * omDtoarray = [NSMutableArray array];
                for (int i = 0; i < _dataArray.count; i ++) {/*商家*/
                    NSMutableDictionary * shopDict = [NSMutableDictionary dictionary];//创建商家字典
                    [omDtoarray addObject:shopDict];//商家加到商家大数组
                    [shopDict setValue:[NSString stringWithFormat:@"%@",adressdict[@"consignee"]] forKey:@"customerName"];//用户名称
                    [shopDict setValue:@"0" forKey:@"ifPayOnArrival"];//是否在线支付
                    [shopDict setValue:[UserManager shareManager].userModel.memberId forKey:@"memberNo"];//用户ID
                    [shopDict setValue:@"10" forKey:@"memberVipCardLevel"];//会员等级
                    
                    [shopDict setValue:_dataArray[i][@"goodsList"][0][@"storeId"] forKey:@"merchantNo"];//商家ID
                    [shopDict setValue:@"自营" forKey:@"merchantType"];//营销方式
                    [shopDict setValue:@"0" forKey:@"needInvoice"];
                    [shopDict setValue:@"APP" forKey:@"orderSource"];//订单来源
                    [shopDict setValue:@"GENERAL" forKey:@"orderType"];//订单类型
                    [shopDict setValue:@"0" forKey:@"weight"];
                    
                    //添加商户跟物业ID
                    [shopDict setObject:[UserManager shareManager].comModel.wyId forKey:@"wyNo"];
                    [shopDict setObject:[NSString stringWithFormat:@"%@",_dataArray[i][@"goodsList"][0][@"goodslist"][@"entity"][@"storeName"]] forKey:@"merchantName"];
                    [shopDict setObject:totalYunFeiArray[i] forKey:@"transportFee"];
                    
                    NSString * quanCoup;
                    
                    if ([daijinquanArray[i] isKindOfClass:[DaiJinQuanModel class]]) {
                        DaiJinQuanModel * modelw = (DaiJinQuanModel *)daijinquanArray[i];
                        quanCoup = modelw.couponNo;
                    }else{
                        quanCoup = @"";
                    }
                    
                    [shopDict setObject:quanCoup forKey:@"voucherNo"];
                    
                    //每个商家里面的一个数组
                    NSMutableArray * onlyOne = [NSMutableArray array];
                    [shopDict setValue:onlyOne forKey:@"osDTOs"];
                    //商家字典
                    NSMutableDictionary * onlydict = [NSMutableDictionary dictionary];
                    [onlyOne addObject:onlydict];
                    [onlydict setValue:adressdict[@"addressName"] forKey:@"addressDetail"];
                    [onlydict setValue:@"0" forKey:@"distributeType"];
                    [onlydict setValue:adressdict[@"mobile"] forKey:@"mobPhoneNum"];
                    [onlydict setValue:adressdict[@"consignee"] forKey:@"userName"];
                    NSMutableArray * goodsListArray = [NSMutableArray array];
                    
                    NSMutableArray * allMoneyInShop = [NSMutableArray array];
                    
                    //商品数组
                    for (int j = 0; j < [_dataArray[i][@"goodsList"] count]; j ++) {//商品数组字典
                        NSMutableDictionary * goodsdict = [NSMutableDictionary dictionary];
                        //此ID暂时不管
                        [goodsdict setValue:_dataArray[i][@"goodsList"][j][@"id"] forKey:@"commodityCode"];
                        [goodsdict setValue:_dataArray[i][@"goodsList"][j][@"name"] forKey:@"commodityName"];
                        //商品ID
                        [goodsdict setValue:_dataArray[i][@"goodsList"][j][@"id"] forKey:@"commodityId"];
                        
                        [goodsdict setValue:@"type" forKey:@"productCategory"];
                        [goodsdict setValue:@"0" forKey:@"productPropertyFlag"];
                        [goodsdict setValue:@"1" forKey:@"promotionType"];
                        //该类商品的数量
                        NSString * uniNum = _dataArray[i][@"goodsList"][j][@"addNumber"];
                        NSString * uniPrice = _dataArray[i][@"goodsList"][j][@"goodslist"][@"entity"][@"price"];
                        
                        [goodsdict setValue:uniNum forKey:@"saleNum"];
                        [goodsdict setValue:@"kg" forKey:@"saleUnit"];
                        
                        //单价
                        [goodsdict setValue:uniPrice forKey:@"unitDeductedPrice"];
                        [goodsdict setValue:uniPrice forKey:@"unitPrice"];
                        [goodsdict setValue:@"0" forKey:@"weight"];
                        
                        //一个商品的总价
                        int number = [uniNum intValue];
                        CGFloat moneyUnit = [uniPrice floatValue];
                        CGFloat total = moneyUnit * number;
                        NSString * afterMoney = [NSString stringWithFormat:@"%.2f",total];
                        
                        [allMoneyInShop addObject:afterMoney];
                        
                        [goodsdict setValue:afterMoney forKey:@"payAmount"];
                        [goodsListArray addObject:goodsdict];
                    }
                    [onlydict setValue:goodsListArray forKey:@"oiDTOs"];
                    
                    
                    //一个商家里面的总价
                    //                NSNumber * sumMoney = [allMoneyInShop valueForKeyPath:@"@sum.floatValue"];
                    NSString * sumMoney = [lastMoneyArray objectAtIndex:i];
                    [shopDict setValue:[NSString stringWithFormat:@"%@",sumMoney] forKey:@"totalPayAmount"];
                    [shopDict setValue:[NSString stringWithFormat:@"%@",sumMoney] forKey:@"totalProductPrice"];
                }
                [uploaddict setObject:omDtoarray forKey:@"omDTO"];
                [uploaddict setObject:@"201506160001" forKey:@"batchNum"];
                //            [uploaddict setObject:APP_ID forKey:@"appid"];
                //            [uploaddict setObject:MCH_ID forKey:@"mch_id"];
                //            [uploaddict setObject:PARTNER_ID forKey:@"key"];
                [uploaddict setObject:@"APP" forKey:@"trade_type"];
                [uploaddict setObject:@"" forKey:@"openid"];
                [uploaddict setObject:ENVIRONMENT forKey:@"attach"];
                [uploaddict setObject:[LocalUtils chargeBodyForCharegeType:ChargeTypeOnlineShop] forKey:@"body"];
                [uploaddict setObject:@"c5ls2v7znidfowbg4ua6q3impg6uwm2p" forKey:@"nonce_str"];
                [uploaddict setObject:@"8.8.8.8" forKey:@"spbill_create_ip"];
                
                CGFloat money = [lastPayMoney_all floatValue];
                NSString * upLoadMoney = [NSString stringWithFormat:@"%.2f",money];
                [uploaddict setObject:[NSString stringWithFormat:@"%@",upLoadMoney] forKey:@"total_fee"];//以一分为单位>>>> 最后结算的总价格
                
                [uploaddict setObject:@"qbPay" forKey:@"payType"];
                
                NSLog(@"上传数据 >>>>>%@",uploaddict);
                [AppUtils showProgressMessage:W_ALL_PROGRESS withType:SVProgressHUDMaskTypeClear];
                
                Life_First * handel = [Life_First new];
                [handel GetOrderNo:uploaddict success:^(id obj) {
                    NSLog(@"下单成功>>>>%@",obj);
                    NSLog(@"下单成功>>>>%@",obj[@"message"]);
                    
                    if ([obj[@"code"] isEqualToString:@"success"] && ![obj[@"wxOrderNo"] isEqual:[NSNull null]]) {
                        [AppUtils dismissHUD];
                        //设置默认收货地址
//                        [self setDefaultAdress:adressdict[@"id"]];

                        qianbaoNum = [NSString stringWithFormat:@"%@",obj[@"wxOrderNo"]];
                        qianbaoOrderArray = obj[@"orderBean"];
                        for (int i = 0; i < self.dataArray.count; i ++) {//商家
                            for (int j = 0; j < [self.dataArray[i][@"goodsList"] count]; j ++) {//商品
                                [[ShoppingCarDataSocure sharedShoppingCar] DeleGoodsFromShoppingCar:self.dataArray[i][@"goodsList"][0][@"storeId"] goodsID:self.dataArray[i][@"goodsList"][j][@"id"]];
                            }
                        }
                        NSLog(@"%@",adressdict[@"id"]);
                        
                        PayViewController * payM = [[PayViewController alloc] init];
                        payM.method = QianBaoMethod;
                        payM.orderNum = qianbaoNum;
                        payM.allMoney = lastPayMoney_all;
                        payM.isMine = self.isMine;
                        payM.orderlistArray = qianbaoOrderArray;
                        [self.navigationController pushViewController:payM animated:YES];
                        
                        
//                        //掉用钱包支付方法
//                        [self qianBaoPayMethod];
                        
                    }else{
                        [AppUtils showErrorMessage:obj[@"message"] isShow:self.viewIsVisible];
                    }
                } failed:^(id obj) {//钱包下单失败
                    
                    [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
                    
                }];
                
            }else{
            
//                [self qianBaoPayMethod];
                
                PayViewController * payM = [[PayViewController alloc] init];
                payM.method = QianBaoMethod;
                payM.orderNum = qianbaoNum;
                payM.allMoney = lastPayMoney_all;
                payM.isMine = self.isMine;
                payM.orderlistArray = qianbaoOrderArray;
                [self.navigationController pushViewController:payM animated:YES];
            }

        }else{//未开通钱包
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未开通钱包，请前往 我的->钱包开通" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
            [alert show];
        }
    }
}


//开通钱包跳转的提醒
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSLog(@"%ld",buttonIndex);//0取消 1确定
    
    if(buttonIndex == 1){
    
        OpenMoneyBagVC * bag = [[OpenMoneyBagVC alloc] init];
        [self.navigationController pushViewController:bag animated:YES];
        
    }else{
    
    }
}


//确认订单
- (IBAction)querendingdan:(UIButton *)sender {
    
    [self makeSureStoreOrder];
}


//添加button
- (UIButton *)addButton:(UIView *)view frame:(CGRect)frame selectImage:(UIImage *)simage norImage:(UIImage *)nImage{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:nImage forState:UIControlStateNormal];
    [btn setImage:simage forState:UIControlStateSelected];
    [view addSubview:btn];
    return btn;
}


- (void)setDefaultAdress:(NSString *)myadressID{

    Life_First * handel = [Life_First new];
    SetDefaultAdress * setDefault = [SetDefaultAdress new];
    setDefault.addressId = myadressID;
    
    [handel setDefaultAdress:setDefault success:^(id obj) {
        
        NSLog(@"设置默认收货地址>>>>>%@",obj);
        
    } failed:^(id obj) {
        
    }];
    

}


@end
