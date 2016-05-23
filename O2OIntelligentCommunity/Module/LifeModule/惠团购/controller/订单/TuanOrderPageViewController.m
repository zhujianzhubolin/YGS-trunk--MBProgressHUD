//
//  TuanOrderPageViewController.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/15.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TuanOrderPageViewController.h"
#import "GoodsListCell.h"
#import "TuanGouQuanViewCOntroller.h"
#import "UserManager.h"
#import "Life_First.h"
#import "TGPayPagViewController.h"
#import "WXApi.h"
#import "OpenMoneyBagVC.h"
#import "CicleVuew.h"

#import "DaiJinQuanModel.h"
#import "DaiJinQunHandel.h"

@interface TuanOrderPageViewController ()<UITableViewDataSource,UITableViewDelegate,SendQuanModel>

{
    __weak IBOutlet UITableView *orderinfor;
    UIButton * qianbaoPay;
    UIButton * wxPay;
    
    CGFloat TTMoney;
    
    __weak IBOutlet UILabel *showMoneyLable;
    
    BOOL isWx;

    UILabel * quanNum;
    //可使用的券Model
    NSMutableArray * quanModelsArray;
    CicleVuew * quanView;
    UILabel * totoalPrice;
    
    DaiJinQuanModel * myQuanModel;
    //建一个临时Model，防止进去没选择券，将上次的选择覆盖
    DaiJinQuanModel * temModel;
    
    //传过来的商家券数组
    NSMutableArray * huiTGQSelecgedArr;
}

@end

@implementation TuanOrderPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"确认订单";
    huiTGQSelecgedArr = [NSMutableArray arrayWithObject:@""];
    if ([WXApi isWXAppInstalled]) {
        isWx = YES;
    }else{
        isWx = NO;
    }
    
    NSLog(@"%@",self.goodsInfor.storeName);
    
    orderinfor.delegate = self;
    orderinfor.dataSource = self;
    
    quanModelsArray = [NSMutableArray array];
    
    orderinfor.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 10)];
    
    [orderinfor registerNib:[UINib nibWithNibName:@"GoodsListCell" bundle:nil] forCellReuseIdentifier:@"MyGoodsListCell"];
    
    [self viewDidLayoutSubviewsForTableView:orderinfor];
    
    TTMoney = [self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue];

    showMoneyLable.text = [NSString stringWithFormat:@"  实付款:%.2f元",TTMoney];
    
    NSLog(@"下单商品数量>>>>%@",self.goodsInfor.goodsNum);
    
#ifdef SmartComJYZX

#elif SmartComYGS
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(START_NET_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDaiJinQuanStatue];
    });
    
#else
    
#endif
    
    
}

- (void)getDaiJinQuanStatue{

    DaiJinQuanModel * model = [DaiJinQuanModel new];
    DaiJinQunHandel * handel = [DaiJinQunHandel new];
    
    model.memberId = [UserManager shareManager].userModel.memberId;
    model.storeId = self.goodsInfor.storeId;
    model.status = @"1";
    
    [handel getStoreAvailbleQuan:model success:^(id obj) {
        
        NSLog(@"代金券 Model>>>>%@",obj);
        [quanView stopMoving];
        [quanModelsArray removeAllObjects];
        
        for (DaiJinQuanModel * model1 in obj[0]) {
            CGFloat payMoney = [self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue];
            CGFloat bound = [model1.bound floatValue];
            if ( fabs(payMoney-bound) < 1e-7 || payMoney > bound) {//满足使用条件
                [quanModelsArray addObject:model1];
            }
        }
        [self updateQuanUI];
    } failed:^(id obj) {
        quanNum.text = @"点击查询";
        [quanView stopMoving];
    }];

}

- (void)updateQuanUI {
    if (quanModelsArray.count <= 0) {
        quanNum.text = @"无可用";
    }else{
        quanNum.text = [NSString stringWithFormat:@"%ld张适用",quanModelsArray.count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else{
        
        if (isWx) {
            return 2;
        }else{
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        GoodsListCell * cellofgoods = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsListCell"];
        
        if (cellofgoods == nil) {
            
            cellofgoods = [[GoodsListCell alloc] init];
            
        }
        
        [cellofgoods TGCellData:self.goodsInfor];
        
        return cellofgoods;
        
        
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //选择支付方式
        if (indexPath.section == 1) {
            
            if (isWx) {
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 29, 26)];
                [cell.contentView addSubview:imageView];
                
                NSArray * array = [NSArray arrayWithObjects:@"钱包支付",@"微信支付", nil];
                
                [UILabel addlable:cell.contentView frame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 13, imageView.frame.origin.y, 100, imageView.frame.size.height) text:[array objectAtIndex:indexPath.row] textcolor:[UIColor blackColor]];
                
                if (indexPath.row == 0) {
                    imageView.image = [UIImage imageNamed:@"moneybag"];
                    
                    qianbaoPay = [UIButton buttonWithType:UIButtonTypeCustom];
                    qianbaoPay.selected = YES;
                    qianbaoPay.frame = CGRectMake(IPHONE_WIDTH - 30, 12, 20, 20);
                    [qianbaoPay setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
                    [qianbaoPay setImage:[UIImage imageNamed:@"gou_h"] forState:UIControlStateSelected];
                    [cell.contentView addSubview:qianbaoPay];
                    
                }else{
                    imageView.image = [UIImage imageNamed:@"lfweixin"];
                    
                    wxPay = [UIButton buttonWithType:UIButtonTypeCustom];
                    wxPay.frame = CGRectMake(IPHONE_WIDTH - 30, 12, 20, 20);
                    [wxPay setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
                    [wxPay setImage:[UIImage imageNamed:@"gou_h"] forState:UIControlStateSelected];
                    [cell.contentView addSubview:wxPay];
                }

            }else{//没有安装微信
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 29, 26)];
                [cell.contentView addSubview:imageView];
                
                NSArray * array = [NSArray arrayWithObjects:@"钱包支付", nil];
                
                [UILabel addlable:cell.contentView frame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 13, imageView.frame.origin.y, 100, imageView.frame.size.height) text:[array objectAtIndex:indexPath.row] textcolor:[UIColor blackColor]];
                
                if (indexPath.row == 0) {
                    imageView.image = [UIImage imageNamed:@"moneybag"];
                    
                    qianbaoPay = [UIButton buttonWithType:UIButtonTypeCustom];
                    qianbaoPay.selected = YES;
                    qianbaoPay.frame = CGRectMake(IPHONE_WIDTH - 30, 12, 20, 20);
                    [qianbaoPay setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
                    [qianbaoPay setImage:[UIImage imageNamed:@"gou_h"] forState:UIControlStateSelected];
                    [cell.contentView addSubview:qianbaoPay];
                    
                }
            }
            
        }
        
        return cell;
    }

}


//确认订单
- (IBAction)makeSureOrder:(UIButton *)sender {
    
    //测试商城下单
    if(TTMoney <= 0)
    {
        [AppUtils showAlertMessageTimerClose:@"商品总价必须大于0，订单信息异常！"];
        return;
    }

    NSMutableDictionary * uploaddict = [NSMutableDictionary dictionary];//最终上传的字典
    NSMutableArray * omDtoarray = [NSMutableArray array];
    for (int i = 0; i < 1; i ++) {/*商家*/
        NSMutableDictionary * shopDict = [NSMutableDictionary dictionary];//创建商家字典
        [omDtoarray addObject:shopDict];//商家加到商家大数组
        [shopDict setValue:@"惠团购地址写死" forKey:@"customerName"];//用户名称
        [shopDict setValue:@"0" forKey:@"ifPayOnArrival"];//是否在线支付
        [shopDict setValue:[UserManager shareManager].userModel.memberId forKey:@"memberNo"];//用户ID
        [shopDict setValue:@"10" forKey:@"memberVipCardLevel"];//会员等级
        


        
        [shopDict setValue:[NSString stringWithFormat:@"%@",self.goodsInfor.storeId] forKey:@"merchantNo"];//商家ID
        [shopDict setValue:@"自营" forKey:@"merchantType"];//营销方式
        [shopDict setValue:@"0" forKey:@"needInvoice"];
        [shopDict setValue:@"APP" forKey:@"orderSource"];//订单来源
        [shopDict setValue:@"GROUP_BUY" forKey:@"orderType"];//订单类型
        [shopDict setValue:@"0" forKey:@"weight"];
        
        //添加商户跟物业ID
        [shopDict setObject:[UserManager shareManager].comModel.wyId forKey:@"wyNo"];
        [shopDict setObject:[NSString stringWithFormat:@"%@",self.goodsInfor.storeName] forKey:@"merchantName"];
        
        if (myQuanModel == nil) {
            if (temModel == nil) {
                [shopDict setValue:@"" forKey:@"voucherNo"];//代金券号
            }else{
                [shopDict setValue:temModel.couponNo forKey:@"voucherNo"];//代金券号
            }
        }else{
            [shopDict setValue:myQuanModel.couponNo forKey:@"voucherNo"];//代金券号
        }
        
        [shopDict setObject:@"" forKey:@"transportFee"];
        
        //每个商家里面的一个数组
        NSMutableArray * onlyOne = [NSMutableArray array];
        [shopDict setValue:onlyOne forKey:@"osDTOs"];
        //商家字典
        NSMutableDictionary * onlydict = [NSMutableDictionary dictionary];
        [onlyOne addObject:onlydict];
        [onlydict setValue:@"惠团购地址写死" forKey:@"addressDetail"];
        [onlydict setValue:@"0" forKey:@"distributeType"];
        [onlydict setValue:@"13652426051" forKey:@"mobPhoneNum"];
        [onlydict setValue:@"惠团购" forKey:@"userName"];
        

        
        NSMutableArray * goodsListArray = [NSMutableArray array];
        
        //商品数组
        for (int j = 0; j < 1; j ++) {//商品数组字典
            
            NSMutableDictionary * goodsdict = [NSMutableDictionary dictionary];
            
            CGFloat TTAllM = [self.goodsInfor.price floatValue] * [self.goodsInfor.goodsNum intValue];
            NSString * allM = [NSString stringWithFormat:@"%.2f",TTAllM];
            
            [goodsdict setObject:allM forKey:@"saleAmount"];
            [goodsdict setObject:@"1" forKey:@"promotionType"];
            [goodsdict setObject:[UserManager shareManager].userModel.phone forKey:@"receiveMobile"];
            [goodsdict setObject:self.goodsInfor.price forKey:@"unitPrice"];
            [goodsdict setObject:self.goodsInfor.name forKey:@"productName"];
            [goodsdict setObject:self.goodsInfor.goodsNum forKey:@"saleNum"];
            [goodsdict setObject:self.goodsInfor.goodsid forKey:@"productCode"];
            
            [goodsListArray addObject:goodsdict];
        }
        [onlydict setValue:goodsListArray forKey:@"oivDTOs"];
        

        //一个商家里面的总价
        [shopDict setValue:[NSString stringWithFormat:@"%.2f",TTMoney] forKey:@"totalPayAmount"];
        [shopDict setValue:[NSString stringWithFormat:@"%.2f",TTMoney] forKey:@"totalProductPrice"];
    }
    [uploaddict setObject:omDtoarray forKey:@"omDTO"];
    [uploaddict setObject:@"201506160001" forKey:@"batchNum"];
    [uploaddict setObject:@"APP" forKey:@"trade_type"];
    [uploaddict setObject:@"" forKey:@"openid"];
    [uploaddict setObject:ENVIRONMENT forKey:@"attach"];
    [uploaddict setObject:[LocalUtils chargeBodyForCharegeType:ChargeTypeOnlineShop] forKey:@"body"];
    [uploaddict setObject:@"c5ls2v7znidfowbg4ua6q3impg6uwm2p" forKey:@"nonce_str"];
    [uploaddict setObject:@"8.8.8.8" forKey:@"spbill_create_ip"];
    
    NSString * upLoadMoney = [NSString stringWithFormat:@"%.2f",TTMoney];
    [uploaddict setObject:[NSString stringWithFormat:@"%@",upLoadMoney] forKey:@"total_fee"];//以一分为单位>>>> 最后结算的总价格
    
    if (wxPay.selected) {//选择微信支付
        [uploaddict setObject:@"wxPay" forKey:@"payType"];
    }else{
        
        if ([[UserManager shareManager].userModel.isCardActivate isEqualToString:@"1"]) {//已经开通了钱包1 未开通是0
            [uploaddict setObject:@"qbPay" forKey:@"payType"];

        }else{
        
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未开通钱包，请前往 我的->钱包开通" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
            [alert show];
            
            return;
        }
        
    }
    
    
    
    NSLog(@"下单数据>>>>%@",uploaddict);
    
    Life_First * handel = [Life_First new];
    
    [AppUtils showProgressMessage:W_ALL_PROGRESS withType:SVProgressHUDMaskTypeClear];
    
    [handel GetOrderNo:uploaddict success:^(id obj) {
        
        
        NSLog(@"下单返回>>>>>%@",obj);
        NSLog(@"下单返回>>>>>%@",obj[@"message"]);
        
        if ([obj[@"code"] isEqualToString:@"success"]) {
            [AppUtils dismissHUD];
            TGPayPagViewController * pay = [[TGPayPagViewController alloc] init];
            
            if (wxPay.selected) {//微信支付
                pay.method = WXPayMethod;
            }else{//钱包支付
                pay.method = QianBaoMethod;
            }
            
            pay.totalFee = [NSString stringWithFormat:@"%.2f",TTMoney];
            pay.orderinformation = (NSDictionary *)obj;
            [self.navigationController pushViewController:pay animated:YES];
        }else{

            [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@",obj[@"message"]]];
        
        }

    } failed:^(id obj) {
        [AppUtils showErrorMessage:W_ALL_FAIL_GET_DATA isShow:self.viewIsVisible];
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 30;

    }else{
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
    #ifdef SmartComJYZX
        return 30;
    #elif SmartComYGS
        return 70;
    #else
            
    #endif
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        UILabel * shopName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
        shopName.backgroundColor = [UIColor whiteColor];
        shopName.text =[NSString stringWithFormat:@"  %@",self.goodsInfor.storeName];
        shopName.textColor = [UIColor  orangeColor];
        return shopName;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 10)];
        return view;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
        backView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel * numLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH/2, 30)];
        numLable.text = [NSString stringWithFormat:@"  %@件",self.goodsInfor.goodsNum];
        numLable.font = [UIFont systemFontOfSize:14];
        [backView addSubview:numLable];
        
        totoalPrice = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH/2,0, IPHONE_WIDTH/2 -10, 30)];
        totoalPrice.backgroundColor = [UIColor whiteColor];
        totoalPrice.text = [NSString stringWithFormat:@"小计%.2f元  ",[self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue]];
        totoalPrice.font = [UIFont systemFontOfSize:14];
        totoalPrice.textAlignment = NSTextAlignmentRight;
        totoalPrice.textColor = [UIColor  orangeColor];
        [backView addSubview:totoalPrice];
        
#ifdef SmartComJYZX
        
#elif SmartComYGS
        UILabel * lineLable = [UILabel addlable:backView frame:CGRectMake(0, 30, IPHONE_WIDTH, 1) text:@"" textcolor:[UIColor lightGrayColor]];
        lineLable.backgroundColor = [AppUtils colorWithHexString:@"DCDCDC"];
        
        //代金券
        UIButton * daijinquan = [UIButton buttonWithType:UIButtonTypeCustom];
        daijinquan.titleLabel.font = [UIFont systemFontOfSize:14];
        [daijinquan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        daijinquan.frame = CGRectMake(0, 31, IPHONE_WIDTH, 40);
        [daijinquan setTitle:@"  代金券" forState:UIControlStateNormal];
        [daijinquan addTarget:self action:@selector(chooseQuan:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:daijinquan];
        daijinquan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIImageView * jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - G_INTERVAL /2 - G_INTERVAL, 15, G_INTERVAL /2, G_INTERVAL)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [daijinquan addSubview:jiantou];
        quanNum = [UILabel addlable:daijinquan frame:CGRectMake(60, 0, daijinquan.frame.size.width - 60 - jiantou.frame.size.width - G_INTERVAL, 40) text:@"" textcolor:[UIColor orangeColor]];
        quanNum.textAlignment = NSTextAlignmentRight;
        quanNum.textColor = [UIColor orangeColor];
    
        //        quanNum.text = @"满100减20";
        
        
        quanView = [[CicleVuew alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 50, 0, 40, 40)];
        quanView.tag = 10000 + section;
        [quanView startMoving];
        [daijinquan addSubview:quanView];
#else
        
#endif
        
        return backView;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 10)];
        return view;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            qianbaoPay.selected = YES;
            wxPay.selected = NO;
        }else{
            qianbaoPay.selected = NO;
            wxPay.selected = YES;

        }
        
    }

}

//选择代金券、
- (void)chooseQuan:(UIButton *)btn{
    
    CicleVuew * senderView;
    for (UIView * subViews in btn.subviews) {
        if ([subViews isKindOfClass:[CicleVuew class]]) {
            senderView = (CicleVuew *)subViews;
        }
    }
    if (senderView != nil) {
        
//        [senderView startMoving];
//        [self getDaiJinQuanStatue];
        
        if ([quanNum.text isEqualToString:@"点击查询"]) {
            
        }else{
//            if (quanModelsArray.count <= 0) {
//                [AppUtils showAlertMessageTimerClose:@"暂无该商家可使用代金券"];
//            }else{
            TuanGouQuanViewCOntroller * quan = [[TuanGouQuanViewCOntroller alloc] init];
            quan.quanDelegate = self;
//                quan.selectQuanID = myQuanModel.id1;
            quan.selectArray = [huiTGQSelecgedArr mutableCopy];
            quan.mystyle = TuanGouType;
            quan.shopId = self.goodsInfor.storeId;
            quan.bounds = [NSString stringWithFormat:@"%.2f",[self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue]];
            [self.navigationController pushViewController:quan animated:YES];
//            }
        }
    }
}

//选择代金券代理
- (void)quanModel:(DaiJinQuanModel *)model{
    NSLog(@"model>>>>>%@",model);
    if (model == nil) {
        [huiTGQSelecgedArr replaceObjectAtIndex:0 withObject:@""];
        if (temModel == nil) {//一次也没有选择，正常显示
            
        }else{//第一次进去选择了，第二次没有选择
            
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"用满%@减%@",temModel.bound,temModel.parValue]];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(1,str.length - 1)];
//            quanNum.attributedText = str;
            [self updateQuanUI];
            TTMoney = [self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue] - [temModel.parValue floatValue];
            [self updatePayMoneyUI];
        }
    }else{
        [huiTGQSelecgedArr replaceObjectAtIndex:0 withObject:model];
        NSLog(@"传过来的可使用金额>>>>%@",model.parValue);
        myQuanModel = model;
        temModel = model;
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"用满%@减%@",model.bound,model.parValue]];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(1,str.length - 1)];
        quanNum.text = model.couponTemplateName;
        TTMoney = [self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue] - [model.parValue floatValue];
        [self updatePayMoneyUI];
    }
}

- (void)updatePayMoneyUI {
    showMoneyLable.text = [NSString stringWithFormat:@"  实付款:%.2f元",TTMoney];
    totoalPrice.text = [NSString stringWithFormat:@"小计%.2f元  ",[self.goodsInfor.goodsNum intValue] * [self.goodsInfor.price floatValue]];
}

@end
