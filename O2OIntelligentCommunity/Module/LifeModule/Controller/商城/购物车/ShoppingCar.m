//
//  ShoppingCar.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShoppingCar.h"
#import "CarCell.h"
#import "ShangChengDingDan.h"
#import "ShoppingCarDataSocure.h"
#import "ShangChengGoodsDeatil.h"

@interface ShoppingCar ()<UITableViewDataSource,UITableViewDelegate,SenderNumber,GouSelectOrNot,UIAlertViewDelegate>

{
    int viewwidth;
    int viewheight;
    __weak IBOutlet UITableView *carView;
    UIButton * button;
    __weak IBOutlet UILabel *allMoney;
    NSMutableArray * dataSocure;
    __weak IBOutlet UIButton *uploadBtn;
    
    
    //每一段里面的数据
    NSMutableArray * goodsSocure;
    NSMutableArray * priceArray;
    NSMutableArray * numberArray;
    NSNumber *sum;
    BOOL isShow;
    NSMutableArray * allMoneyWithNoYUnFei;
    NSMutableArray * yunfeiArray;
    
    NSIndexPath * deleIndexpath;
}

@end

@implementation ShoppingCar

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hidetabbar];
    self.navigationController.navigationBar.translucent = NO;

    if ([[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum] <= 0) {
        [self showEmptyLable];
        [self allMoneyAfterSelect];
    }else{
        [self getShoppingList];
        [self allMoneyAfterSelect];
    }
    
    [carView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"购物车";
    goodsSocure = [NSMutableArray array];
    priceArray = [NSMutableArray array];
    numberArray = [NSMutableArray array];
    
    allMoneyWithNoYUnFei = [NSMutableArray array];
    yunfeiArray = [NSMutableArray array];
    
    if (VIEW_IPhone4_INCH) {
        viewwidth = 320;
        viewheight = 480;
    }else if (VIEW_IPhone5_INCH){
        viewwidth = 320;
        viewheight = 568;
    }else if (VIEW_IPhone6_INCH){
        viewwidth = 375;
        viewheight = 667;
    }else{
        viewwidth = 414;
        viewheight = 736;
    }
    
//    UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0,0,54,30)];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [backButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [backButton setTitle:@"完成" forState:UIControlStateSelected];
//    backButton.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,-40);
//    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

//- (void)doClickBackAction:(UIButton *)btn{
//    btn.selected = ! btn.selected;
//    if (btn.selected) {
//        isShow = YES;
//        [carView setEditing:YES animated:YES];
//    }else{
//        isShow = NO;
//        [carView setEditing:NO animated:NO];
//
//    }
//    [carView reloadData];
//}

- (void)initUI{

    carView.delegate = self;
    carView.dataSource = self;
    
    [self viewDidLayoutSubviewsForTableView:carView];
    [carView registerNib:[UINib nibWithNibName:@"CarCell" bundle:nil] forCellReuseIdentifier:@"CarCellID"];
    CGRect frame=CGRectMake(0, 0, 0, CGFLOAT_MIN);
    carView.tableHeaderView=[[UIView alloc]initWithFrame:frame];
    carView.tableFooterView = [[UIView alloc] initWithFrame:frame];

}

//获取购物车的所有商品列表
- (void)getShoppingList{
    if ([[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarNum] > 0) {
        dataSocure = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData];
        for (NSMutableDictionary * shopDict in dataSocure) {
            for (NSMutableDictionary * goodsDict in shopDict[@"goodsList"]) {
                goodsDict[@"isSelect"] = @"YES";
            }
        }
        NSLog(@"购物车数据源>>>>>%@",dataSocure);
        [self initUI];
    }else{
        [self showEmptyLable];
    }
}

- (void)showEmptyLable{
    
    UIView * nodataView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    nodataView.backgroundColor = [AppUtils colorWithHexString:@"EBEBF1"];
    [self.view addSubview:nodataView];

    UIImageView * myimageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewwidth/2-50, viewheight/2-100,100,80)];
    myimageView.image = [UIImage imageNamed:@"ZJ_web_noData"];
    [nodataView addSubview:myimageView];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, myimageView.frame.size.height + myimageView.frame.origin.y, viewwidth, 40)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"购物车空空如也~";
    [nodataView addSubview:lable];
}
//提交订单
- (IBAction)tijiaodingdan:(UIButton *)sender {
    
    NSMutableArray * orderArray = [NSMutableArray array];
    //筛选出勾选的商家里面的商品
    for (NSDictionary * dict in dataSocure) {
        for (NSDictionary * dict1 in dict[@"goodsList"]) {
            if ([dict1[@"isSelect"] isEqualToString:@"YES"]) {
                [orderArray addObject:dict1];
            }
        }
    }
    NSMutableArray * nextArray = [self arrangeArray:orderArray key:@"storeId"];
    
//    NSLog(@"传过去的数组>>>%@",nextArray);
    
    if (nextArray.count > 0) {
        ShangChengDingDan * dingdan = [[ShangChengDingDan alloc] init];
        dingdan.isMine = self.isMine;
        dingdan.totalPrice = sum;
        dingdan.dataArray = nextArray;
        [self.navigationController pushViewController:dingdan animated:YES];
    }else{
        
        [AppUtils showAlertMessage:@"您的购物车为空，暂无可提交订单！"];
    }
    
}

//将数组里面的元素分类处理
- (NSMutableArray *)arrangeArray:(NSMutableArray *)myarray key:(NSString *)key{
    
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    NSMutableArray *array = [NSMutableArray arrayWithArray:myarray];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *sdict = array[i];  //2014 04 01
        NSMutableArray *mytempArray = [@[] mutableCopy];
        [mytempArray addObject:sdict];
        for (int j = i+1; j < array.count; j ++) {
            NSDictionary *jdict = array[j];
            if([sdict[key] isEqualToString:jdict[key]]){
                [mytempArray addObject:jdict];
            }
        }
        NSDictionary * goodslist = [NSDictionary dictionaryWithObjectsAndKeys:mytempArray,@"goodsList", nil];
        [dateMutablearray addObject:goodslist];
        [array removeObjectsInArray:mytempArray];
        i -= 1;    //去除重复数据 新数组开始遍历位置不变
    }
    return dateMutablearray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 83;
}

//分段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return dataSocure.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataSocure[section][@"goodsList"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"CarCellID";
    
    CarCell * mycell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (mycell == nil) {
        mycell = [[CarCell alloc] init];
    }
    mycell.numdele = self;
    mycell.gouSelect = self;
    [mycell setCellData:(NSMutableDictionary *)dataSocure[indexPath.section][@"goodsList"][indexPath.row] isShow:isShow index:indexPath];
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ShangChengGoodsDeatil * detail = [[ShangChengGoodsDeatil alloc] initWithNibName:@"ShangChengGoodsDeatil" bundle:nil];
    detail.productId = dataSocure[indexPath.section][@"goodsList"][indexPath.row][@"id"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//删除一条记录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    deleIndexpath = indexPath;
    
    NSLog(@"点击了删除");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该商品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        NSLog(@"%ld>>>>>%ld",(long)deleIndexpath.section,(long)deleIndexpath.row);
        NSString * delShopID = dataSocure[deleIndexpath.section][@"goodsList"][0][@"storeId"];
        NSString *  delGoodsID = dataSocure[deleIndexpath.section][@"goodsList"][deleIndexpath.row][@"id"];
        [[ShoppingCarDataSocure sharedShoppingCar] DeleGoodsFromShoppingCar:delShopID goodsID:delGoodsID];
        
        [self getShoppingList];
        [self allMoneyAfterSelect];
        
        [carView reloadData];
    }
}


//勾选之后判断段头是否该勾选
- (void)finishGou:(NSIndexPath *)indexPath2{
    
    //结算
    //一下是UI选择部分 button 的Tag 是section 加 100
    UIButton * headBtn = (UIButton *)[carView viewWithTag:indexPath2.section + 100001];
    NSMutableArray * selectStateArray = [NSMutableArray array];
    NSMutableArray * myShopCar = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData];
    for (NSMutableDictionary * goodsDict in myShopCar[indexPath2.section][@"goodsList"]) {
        [selectStateArray addObject:goodsDict[@"isSelect"]];
    }
    
    if ([selectStateArray containsObject:@"YES"]) {
        headBtn.selected = YES;
    }else{
        headBtn.selected = NO;
    }
    
    [self allMoneyAfterSelect];

}

//勾选后结算
-(void)allMoneyAfterSelect{
    
    [allMoneyWithNoYUnFei removeAllObjects];
    [yunfeiArray removeAllObjects];
    //计算商家的运费
    //计算每一商家的总价格
    //以商家为单位，取出每个商家里面的金额总数
    for (NSDictionary * shopDict in dataSocure) {
        CGFloat lastAlMoey = 0.0;
        for (NSDictionary * goodsdict in shopDict[@"goodsList"]) {
            if ([goodsdict[@"isSelect"] isEqualToString:@"YES"]) {
                int number = [goodsdict[@"addNumber"] intValue];
                CGFloat price = [goodsdict[@"goodslist"][@"entity"][@"price"] floatValue];
                lastAlMoey += price * number;
            }
        }
        [allMoneyWithNoYUnFei addObject:[NSString stringWithFormat:@"%.2f",lastAlMoey]];
    }
    NSLog(@"不含运费的所有>>>>>%@",allMoneyWithNoYUnFei);
    
    //取出每一个商家里面的商家运费
    for (int i = 0; i < dataSocure.count; i ++) {
        //每个商家里面的实际消费价格
        NSString * eachPrice = allMoneyWithNoYUnFei[i];
        if ([eachPrice floatValue] <= 0) {
            [yunfeiArray addObject:@"0"];
        }else{
            //每个商家里面的运费
            if ([dataSocure[i][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"] isEqual:[NSNull null]]) {
                [yunfeiArray addObject:@"0"];
            }else{
                
                NSString * fullYunFei = dataSocure[i][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"];
                if ([eachPrice floatValue] >= [fullYunFei floatValue]) {
                    [yunfeiArray addObject:@"0"];
                }else{
                    if ([dataSocure[i][@"goodsList"][0][@"goodslist"][@"entity"][@"notFullMoney"] isEqual:[NSNull null]]) {
                        [yunfeiArray addObject:@"0"];
                    }else{
                        [yunfeiArray addObject:dataSocure[i][@"goodsList"][0][@"goodslist"][@"entity"][@"notFullMoney"]];
                    }
                }
            }
        }
 
    }
    NSLog(@"运费数组>>>%@",yunfeiArray);
    NSMutableArray * totalarray = [NSMutableArray array];
    //运费加商品，每个商家的总价格
    for (int i = 0; i < allMoneyWithNoYUnFei.count; i ++) {
        CGFloat shangjiaTotal = [allMoneyWithNoYUnFei[i] floatValue] + [yunfeiArray[i] floatValue];
        [totalarray addObject:[NSString stringWithFormat:@"%.2f",shangjiaTotal]];
    }
    sum = [totalarray valueForKeyPath:@"@sum.floatValue"];
    CGFloat twoPoint = [sum floatValue];
    NSString * twoPointStr = [NSString stringWithFormat:@"%.2f",twoPoint];
    allMoney.text = [NSString stringWithFormat:@"  订单总金额:%@元",twoPointStr];
   
/***********************************没有算运费进去的**************************************/
//    
//    [priceArray removeAllObjects];
//    [numberArray removeAllObjects];
//    
//    for (NSDictionary * dict in dataSocure) {
//        for (NSDictionary * dict1 in dict[@"goodsList"]) {
//            if ([dict1[@"isSelect"] isEqualToString:@"YES"]) {
//                [priceArray addObject:[NSString stringWithFormat:@"%@",dict1[@"goodslist"][@"entity"][@"price"]]];
//                [numberArray addObject:[NSString stringWithFormat:@"%@",dict1[@"addNumber"]]];
//            }
//        }
//    }
//
//    NSMutableArray * totalarray = [NSMutableArray array];
//    for (int m = 0; m < numberArray.count; m ++) {
//        CGFloat  uniprice = [[priceArray objectAtIndex:m] floatValue];
//        CGFloat unnumber = [[numberArray objectAtIndex:m] floatValue];
//        [totalarray addObject:[NSString stringWithFormat:@"%.2f",uniprice * unnumber]];
//    }
//    
//    NSLog(@"商家里面的总价格>>>>>%@",totalarray);
//
//    sum = [totalarray valueForKeyPath:@"@sum.floatValue"];
//    allMoney.text = [NSString stringWithFormat:@"     合计:￥%@元",sum];
}


//主要用于刷新表格
-(void)senderGoodsNum:(NSIndexPath *)index1{
    NSLog(@"刷新");
    if (dataSocure.count == 0) {
        
        [carView reloadData];
        [self showEmptyLable];
        sum = [NSNumber numberWithFloat:0];
        CGFloat twoP = [sum floatValue];
        NSString * twoStrin = [NSString stringWithFormat:@"%.2f",twoP];
        allMoney.text = [NSString stringWithFormat:@"  订单总金额:%@元",twoStrin];
    }else{

        [carView reloadData];
        [self allMoneyAfterSelect];
    }
    
    
    NSLog(@"%@",dataSocure);
}

//设置段头View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //勾选按钮
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.selected = YES;
    button.tag = section + 100001;
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [button setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"gou_h"] forState:UIControlStateSelected];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -viewwidth+25, 0, 0)];

    [button addTarget:self action:@selector(groupSelect:) forControlEvents:UIControlEventTouchUpInside];
    //商家名称
    UILabel * shopName = [UILabel addlable:button frame:CGRectMake(30, 0, 200, 40) text:[NSString stringWithFormat:@"%@",dataSocure[section][@"goodsList"][0][@"goodslist"][@"entity"][@"storeName"]] textcolor:[UIColor blackColor]];
    shopName.font = [UIFont systemFontOfSize:15];
    shopName.numberOfLines = 0;
    shopName.backgroundColor = [UIColor clearColor];
    
    //运费状态
    UILabel * price = [UILabel addlable:button frame:CGRectMake(button.frame.size.width - 120, 10, 110, 22) text:@"" textcolor:[UIColor blackColor]];
//    NSString * fullMoney = dataSocure[section][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"];
//    NSString * notFullMoney = dataSocure[section][@"goodsList"][0][@"goodslist"][@"entity"][@"notFullMoney"];
    
    if ([dataSocure[section][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"] isEqual:[NSNull null]]){
        price.text = @"免运费";
    }else{
    
        
        
        if ([dataSocure[section][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"] floatValue] == 0) {
            price.text = @"免运费";
        }else{
            price.text = [NSString stringWithFormat:@"满%@免运费",dataSocure[section][@"goodsList"][0][@"goodslist"][@"entity"][@"fullMoney"]];
        }
        
    }
    
    price.textAlignment = NSTextAlignmentRight;
    price.backgroundColor = [UIColor clearColor];
    return button;
}

#pragma 有数据的时候开始写这一部分
- (void)groupSelect:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [dataSocure enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray * goodsArray = (NSMutableArray *)obj[@"goodsList"];
            [goodsArray enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx1, BOOL *stop1) {
            UITableViewCell * cell = [carView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx1 inSection:sender.tag - 100001]];
                UIButton * btn = (UIButton *)[cell viewWithTag:10];
                btn.selected = YES;
                
            }];
        }];
    }else{
        [dataSocure enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray * goodsArray = (NSMutableArray *)obj[@"goodsList"];
            [goodsArray enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx1, BOOL *stop1) {
                UITableViewCell * cell = [carView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx1 inSection:sender.tag - 100001]];
                UIButton * btn = (UIButton *)[cell viewWithTag:10];
                btn.selected = NO;
            }];
        }];
    }
    
    
    
    NSMutableDictionary * xiugai = dataSocure[sender.tag - 100001];
    
    if (sender.selected) {
        for (NSMutableDictionary * goodsDict in xiugai[@"goodsList"]) {
            goodsDict[@"isSelect"] = @"YES";
        }
    }else{
        for (NSMutableDictionary * goodsDict in xiugai[@"goodsList"]) {
            goodsDict[@"isSelect"] = @"NO";
        }
    }
    dataSocure[sender.tag - 100001] = xiugai;

    
    NSLog(@"勾选之后>>>>%@",dataSocure);
    //遍历勾选数据源
    [self allMoneyAfterSelect];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

- (void)showMessage:(NSString *)msg{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
