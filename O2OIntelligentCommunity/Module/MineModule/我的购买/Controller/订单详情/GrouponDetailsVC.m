//
//  GrouponDetailsVC.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "GrouponDetailsVC.h"
#import "TuanGouCell.h"
#import "TuanGouStaeCell.h"
#import "DES3EncryptUtil.h"
#import "NSArray+wrapper.h"
#import "LiJiFuKuanVC.h"
#import "UserManager.h"
#import "GoodsShopsCommentsVC.h"
#import "WebVC.h"
#import "TGShopDetailViewController.h"
#import "NSString+wrapper.h"

#import "WTTuanGouDetail.h"
#import "TGGoodsModel.h"


#import "DeleteDingdanHandler.h"
#import "DeleteDingdanModel.h"
#import "QuXiaoDindanModel.h"
#import "QuxiaoDindanHandler.h"


@interface GrouponDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tuanGouTB;
    
    UIAlertView *ConfirmAlertView;//确认收货
    UIAlertView *cancelOreder;//取消订单
    UIAlertView *wuLiuAlert;//查看物流
    UILabel *textLab;
    UILabel *textLab2;
}

@end

@implementation GrouponDetailsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

-(void)initUI
{
    
    self.title=@"订单详情";
    
    UIView *footoView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 50)];
    
    
    UIFont *btnFont = [UIFont systemFontOfSize:14];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
    button1.titleLabel.font=btnFont;
    [button1.layer setMasksToBounds:YES];
    [button1.layer setCornerRadius:5];
    [button1 setTitle:@"1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(Button1ChickAction:) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
    [button2 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
    button2.titleLabel.font=btnFont;
    [button2.layer setMasksToBounds:YES];
    [button2.layer setCornerRadius:5];
    [button2.layer setBorderWidth:1];
    [button2.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
    [button2 setTitle:@"2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(Button2ChickAction:) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:button2];
    
    UIButton *button3 =[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(IPHONE_WIDTH -270, 10, 80, 30);
    [button3 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
    button3.titleLabel.font=btnFont;
    [button3.layer setMasksToBounds:YES];
    [button3.layer setCornerRadius:5];
    [button3.layer setBorderWidth:1];
    [button3.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
    [button3 setTitle:@"3" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(Button3ChickAction:) forControlEvents:UIControlEventTouchUpInside];
    [footoView addSubview:button3];
    
    
    button1.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
    button2.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
    button3.frame = CGRectMake(IPHONE_WIDTH -270, 10, 80, 30);
    
    NSString *statusStr =[NSString stringWithFormat:@"%@",_mineshopsM.statusTotal];
    if ([statusStr isEqualToString:@"0130"] )//待付款
    {
        button1.hidden=NO;
        button2.hidden=NO;
        button3.hidden=YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [button1 setTitle:@"立即付款" forState:UIControlStateNormal];
            [button2 setTitle:@"取消订单" forState:UIControlStateNormal];
        });
    }
    else if ([statusStr isEqualToString:@"0131"])//已取消
    {
        button1.hidden=YES;
        button2.hidden=YES;
        button3.hidden=YES;
    }
    else if ([statusStr isEqualToString:@"0120"])//已支付
    {
        button1.hidden=YES;
        button2.hidden=YES;
        button3.hidden=YES;
    }
    else if ([statusStr isEqualToString:@"0170"])//待收货
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button1 setTitle:@"确认收货" forState:UIControlStateNormal];
            [button2 setTitle:@"查看物流" forState:UIControlStateNormal];
        });
        button1.hidden=NO;
        button2.hidden=NO;
        button3.hidden=YES;
    }
    else if ([statusStr isEqualToString:@"0180"])//待评价
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button1 setTitle:@"去评价" forState:UIControlStateNormal];
        });
        button1.hidden=NO;
        button2.hidden=YES;
        button3.hidden=YES;
    }
    else if ([statusStr isEqualToString:@"0182"])//已完成
    {
        button1.hidden=YES;
        button2.hidden=YES;
        button3.hidden=YES;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [_button1 setTitle:@"评价" forState:UIControlStateNormal];
        //            [_button2 setTitle:@"删除订单" forState:UIControlStateNormal];
        //        });
    }
    else if ([statusStr isEqualToString:@"0132"])//系统自动取消
    {
        button1.hidden=YES;
        button2.hidden=YES;
        button3.hidden=YES;
    }
    else if ([statusStr isEqualToString:@"0174"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button1 setTitle:@"评价" forState:UIControlStateNormal];
        });
        button1.hidden=NO;
        button2.hidden=YES;
        button3.hidden=YES;
        
    }
    else if ([statusStr isEqualToString:@"0172"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button1 setTitle:@"联系客服" forState:UIControlStateNormal];
        });
        button1.hidden=NO;
        button2.hidden=YES;
        button3.hidden=YES;
        
    }

    else
    {
        button1.hidden=YES;
        button2.hidden=YES;
        button3.hidden=YES;
    }
    
    
    
    
    
    
    tuanGouTB =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    [tuanGouTB registerNib:[UINib nibWithNibName:@"TuanGouStaeCell" bundle:nil] forCellReuseIdentifier:@"TuanGouStaeCell"];
    [tuanGouTB registerNib:[UINib nibWithNibName:@"TuanGouCell" bundle:nil] forCellReuseIdentifier:@"TuanGouCell"];
    tuanGouTB.dataSource=self;
    tuanGouTB.delegate  =self;
    tuanGouTB.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    
    tuanGouTB.tableFooterView = [AppUtils tableViewsFooterView];
    [AppUtils tableViewsFooterView];
    tuanGouTB.tableFooterView=footoView;
    [self.view addSubview:tuanGouTB];
}

-(void)initData
{
    
}

- (void)popLastVC {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)Button1ChickAction:(UIButton *)buton
{
    //判断是虚拟订单还是实体订单，如果是虚拟订单直接请求删除
    
    MineBuyorderM *orderM =[_mineshopsM.orderSubInfoList objectAtIndex:0];
    
    NSString *statusPayStr =[NSString stringWithFormat:@"%@",_mineshopsM.statusTotal];
    NSLog(@"%@",statusPayStr);
    if ([statusPayStr isEqualToString:@"0130"] )//待付款
    {
        LiJiFuKuanVC *ljfk =[[LiJiFuKuanVC alloc]init];
        ljfk.buyshopsM=_mineshopsM;
        ljfk.mobPhoneNum=orderM.mobPhoneNum;
        ljfk.paySuccessBlock=^()
        {
            if (self.tuanGouSuccessBlock)
            {
                self.tuanGouSuccessBlock();
            }
        };
        [self.navigationController pushViewController:ljfk animated:YES];
    }
    else if ([statusPayStr isEqualToString:@"0131"])//已取消
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0120"])//已支付
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0170"])//待收货
    {
        NSLog(@"待收货");
        DeleteDingdanHandler *querenH =[DeleteDingdanHandler new];
        DeleteDingdanModel   *querenM =[DeleteDingdanModel new];
        querenM.memberNo = [UserManager shareManager].userModel.memberId;
        querenM.orderNo = _mineshopsM.orderNo;
        
        [querenH AffirmConsignee:querenM success:^(id obj) {
            [AppUtils showAlertMessageTimerClose:@"已确认收货"];
            if (self.tuanGouSuccessBlock)
            {
                self.tuanGouSuccessBlock();
            }
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
        } failed:^(id obj) {
            [AppUtils showAlertMessageTimerClose:obj];
        }];
        
    }
    else if ([statusPayStr isEqualToString:@"0180"] || [statusPayStr isEqualToString:@"0174"])//待评价
    {
        NSLog(@"待评价");
        GoodsShopsCommentsVC *gsCommentVc= [GoodsShopsCommentsVC new];
        gsCommentVc.ifTgorSc =TgClass;
        gsCommentVc.orderM=orderM;
        gsCommentVc.mineshopsM = self.mineshopsM;
        gsCommentVc.commentSuccessBlock=^()
        {
            if (self.tuanGouSuccessBlock)
            {
                self.tuanGouSuccessBlock();
            }
        };
        [self.navigationController pushViewController:gsCommentVc animated:YES];
        
    }
    else if ([statusPayStr isEqualToString:@"0172"])//交易成功
    {
        [AppUtils callPhone:P_SERVICE_PHONE];
    }
    
}

-(void)Button2ChickAction:(UIButton *)buton
{
    NSString *statusPayStr =[NSString stringWithFormat:@"%@",_mineshopsM.statusTotal];
    if ([statusPayStr isEqualToString:@"0130"] )//待付款
    {
        cancelOreder =[[UIAlertView alloc]initWithTitle:nil message:M_MINEBUY_CANCELORDER delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认",@"取消", nil];
        [cancelOreder show];
        
    }
    else if ([statusPayStr isEqualToString:@"0131"])//已取消
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0120"])//已支付
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0170"])//待收货
    {
        if ([_mineorderM.deliveryMerchantType isEqualToString:@"0022"])
        {
            wuLiuAlert =[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"该商品为商家自己配送，可拨打商家电话查询配送情况！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [wuLiuAlert show];
        }
        else if([NSString isEmptyOrNull:_mineorderM.deliveryMerchantNo])
        {
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"没有快递单号" message:@"请联系商家！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [aler show];
        }
        else
        {
            NSLog(@"待收货");
            
            WebVC *logisticsvc = [WebVC new];
            logisticsvc.title = @"物流";
            NSString *urlStr =[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@#result",_mineorderM.deliveryMerchantType,_mineorderM.deliveryMerchantNo];
            logisticsvc.webURL = urlStr;
            [self.navigationController pushViewController:logisticsvc animated:YES];
        }
    }
    else if ([statusPayStr isEqualToString:@"0180"])//待评价
    {
        NSLog(@"待评价");
    }
    else if ([statusPayStr isEqualToString:@"0182"])//交易成功
    {
        
    }
    else if ([statusPayStr isEqualToString:@"0174"])
    {
        
        MineBuyorderM *orderM;
        NSArray *shopArr = _mineshopsM.orderSubInfoList;
        if (![NSArray isArrEmptyOrNull:shopArr])
        {
            orderM = shopArr[0];
        }

        GoodsShopsCommentsVC *gsCommentVc= [GoodsShopsCommentsVC new];
        gsCommentVc.orderM=orderM;
        gsCommentVc.mineshopsM = self.mineshopsM;
        gsCommentVc.commentSuccessBlock=^()
        {
        };
        [self.navigationController pushViewController:gsCommentVc animated:YES];

    }
    
}

-(void)Button3ChickAction:(UIButton *)buton
{
    
}

-(NSString *)StateType:(NSString *)stringType
{
    NSString *Str;
    if ([stringType isEqualToString:@"0130"])
    {
        Str=@"待付款";
    }
    else if ([stringType isEqualToString:@"0131"])
    {
        Str= @"已取消";
    }
    else if ([stringType isEqualToString:@"0132"])
    {
        Str= @"已失效";
    }
    
    else if ([stringType isEqualToString:@"0120"])
    {
        Str= @"可使用";
    }
    else if([stringType isEqualToString:@"0180"])
    {
        Str= @"待评价";
    }
    else if ([stringType isEqualToString:@"0182"])
    {
        Str =@"已完成";
    }
    else if ([stringType isEqualToString:@"0183"])
    {
        Str =@"已退款";
    }
    else if ([stringType isEqualToString:@"0184"])
    {
        Str =@"部分退款";
    }
    
    else if ([stringType isEqualToString:@"0172"])
    {
        Str = @"退款驳回";
    }
    else if ([stringType isEqualToString:@"0173"])
    {
        Str = @"订单退款中";
    }
    else if ([stringType isEqualToString:@"0174"])
    {
        Str = @"订单退款完成";
    }
    else if ([stringType isEqualToString:@"0185"])
    {
        Str = @"退款中";
    }

    return Str;
}

//团购券使用状态
-(NSString *)groupBuyStart:(NSString *)string
{
    NSString *stareStr;
    if([string isEqualToString:@"110"])
    {
        stareStr =@"未使用";
    }
    else if ([string isEqualToString:@"120"])
    {
        stareStr =@"已使用";
    }
    else if ([string isEqualToString:@"150"])
    {
        stareStr =@"已过期";
    }
    else if([string isEqualToString:@"183"])
    {
        stareStr =@"已退款";
    }
    else if ([string isEqualToString:@"184"])
    {
        stareStr =@"退款中";
    }
    else if ([string isEqualToString:@"185"])
    {
        stareStr =@"退款驳回";
    }
    return stareStr;
}

//-(NSInteger)ticketDecode:(NSString *)string
//{
//    return [DES3EncryptUtil decrypt:string];
//}

- (void)shopDetailClick {
    
    TGShopDetailViewController *tgVC =[[TGShopDetailViewController alloc]init];
    tgVC.shopId=_mineshopsM.merchantNo;
    [self.navigationController pushViewController:tgVC animated:YES];
}

- (void)shopPhoneClick:(UIButton *)btn{
    [AppUtils callPhone:btn.titleLabel.text];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#ifdef SmartComJYZX
//    return 4;
//#elif SmartComYGS
    if ([NSString isEmptyOrNull:_mineshopsM.discountAmount] || [_mineshopsM.discountAmount isEqualToString:@"0"]) {
        return 4;
    }
    else
    {
        return 5;
    }
    
//#else
//    
//#endif

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    MineBuyorderM *orderM;
    if (section==2)
    {
        if (
            [_mineshopsM.statusTotal isEqualToString:@"0130"] ||
            [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
            [_mineshopsM.statusTotal isEqualToString:@"0131"] )
        {
            return 1;
        }
        else
        {
            NSArray *shopArr = _mineshopsM.orderSubInfoList;
            if (![NSArray isArrEmptyOrNull:shopArr])
            {
                orderM = shopArr[0];
            }
            
            return orderM.orderItemInfoList.count+1;

        }
 
    }
    else
    {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    else if (section==1)
    {
        return 25;
    }
    else if (section==2)
    {
        return 1;
    }
    else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//#ifdef SmartComJYZX
//    if (indexPath.section==0)
//    {
//        return 70;
//    }
//    else if (indexPath.section==1)
//    {
//        if (indexPath.row==0)
//        {
//            return 70;
//        }
//        else
//        {
//            return 44;
//        }
//    }
//    else if (indexPath.section==2)
//    {
//        return 44;
//    }
//    else
//    {
//        return 60;
//    }
//    
//#elif SmartComYGS
    if (indexPath.section==0)
    {
        return 70;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            return 70;
        }
        else
        {
            return 44;
        }
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==_mineorderM.orderItemInfoList.count) {
            return 44;
        }
        else
        {
            MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
            MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
            if (![NSDictionary isDicEmptyOrNull:shitiM.orderRefundRecord])
            {
                if (![NSString isEmptyOrNull:shitiM.orderRefundRecord[@"advice"]])
                {
                    return 70;
                }
                else
                {
                    return 40;
                }
                
            }
            else
            {
                
                return 40;
            }
            
        }
       
    }
    else if (indexPath.section==3)
    {
        if ([NSString isEmptyOrNull:_mineshopsM.discountAmount] || [_mineshopsM.discountAmount isEqualToString:@"0"]) {
            return 60;
        }
        else
        {
            return 40;
        }

    }
    else
    {
        return 60;
    }

//#else
//    
//#endif
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *View = [[UIView alloc]init];
    View.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
    if (section==1)
    {
        View.frame=CGRectMake(0, 0, IPHONE_WIDTH, 25);
        UIButton *phoneLab = [UIButton buttonWithType:UIButtonTypeCustom];

        phoneLab.frame=CGRectMake(IPHONE_WIDTH-120, 0, 110, 25);
        if (![NSString isEmptyOrNull:_mineshopsM.merchantPhone])
        {
            [phoneLab setTitle:_mineshopsM.merchantPhone forState:UIControlStateNormal];
        }
        else
        {
            [phoneLab setTitle:@"" forState:UIControlStateNormal];
        }
        phoneLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        phoneLab.titleLabel.font=[UIFont systemFontOfSize:13];
        [phoneLab setTitleColor:[AppUtils colorWithHexString:@"fa6900"] forState:UIControlStateNormal];
        [phoneLab addTarget:self action:@selector(shopPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
        [View addSubview:phoneLab];
        
        
        UIButton *statPaymentLabe =[UIButton buttonWithType:UIButtonTypeCustom];
        statPaymentLabe.frame= CGRectMake(10, 0, IPHONE_WIDTH-phoneLab.frame.size.width-40, 25);
        [statPaymentLabe setTitleColor:[AppUtils colorWithHexString:@"fa6900"] forState:UIControlStateNormal];
        statPaymentLabe.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        statPaymentLabe.titleLabel.font = [UIFont systemFontOfSize:13];
        [statPaymentLabe setTitle:_mineshopsM.merchantName forState:UIControlStateNormal];
        [statPaymentLabe addTarget:self action:@selector(shopDetailClick) forControlEvents:UIControlEventTouchUpInside];
        [View addSubview:statPaymentLabe];
    }
    else
    {
        View.frame=CGRectMake(0, 0, IPHONE_WIDTH, 5);
        
    }
    return View;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//#ifdef SmartComJYZX
//    if(indexPath.section==0)
//    {
//        static NSString *CellIdentiferID = @"TuanGouStaeCell";
//        TuanGouStaeCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
//        if (Cell == nil)
//        {
//            Cell =[[TuanGouStaeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
//        }
//        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [Cell setStateData:_mineshopsM];
//        return Cell;
//    }
//    else if (indexPath.section==1)
//    {
//        
//        static NSString *CellIdentiferID = @"TuanGouCell";
//        TuanGouCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
//        if (Cell == nil)
//        {
//            Cell =[[TuanGouCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
//        }
//        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
//        [Cell setTaunGouCellDeta:goodM];
//        return Cell;
//        
//    }
//    else if (indexPath.section==2)
//    {
//        NSLog(@"_mineorderM.orderItemInfoList[indexPath.row] %@",_mineorderM.orderItemInfoList);
//        
//        if ([_mineshopsM.statusTotal isEqualToString:@"0130"] ||
//            [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
//            [_mineshopsM.statusTotal isEqualToString:@"0131"] )
//        {
//            MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
//            
//            MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
//            UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
//            if (Cell==nil)
//            {
//                Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
//                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            NSLog(@"_mineshopsM.statusTotal %@",_mineshopsM.statusTotal);
//            if ([_mineshopsM.statusTotal isEqualToString:@"0120"] ||
//                [_mineshopsM.statusTotal isEqualToString:@"0174"] ||
//                //                [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
//                [_mineshopsM.statusTotal isEqualToString:@"0180"] ||
//                [_mineshopsM.statusTotal isEqualToString:@"0182"])
//            {
//                NSMutableAttributedString *timerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效期至：%@",shitiM.validityDate]];
//                [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
//                [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, shitiM.validityDate.length)];
//                [timerString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, shitiM.validityDate.length)];
//                
//                Cell.textLabel.attributedText =timerString;
//            }
//            NSString *quanStr=[NSString stringWithFormat:@"%lu",_mineorderM.orderItemInfoList.count];
//            
//            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共:%@张团购券",quanStr]];
//            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, quanStr.length)];
//            [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, quanStr.length)];
//            
//            UILabel *tuangouQuan =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 0, 100, 44)];
//            tuangouQuan.attributedText=string;
//            tuangouQuan.textAlignment=NSTextAlignmentRight;
//            tuangouQuan.font=[UIFont systemFontOfSize:14];
//            [Cell.contentView addSubview:tuangouQuan];
//            
//            return Cell;
//            
//        }
//        else
//        {
//            if(indexPath.row==_mineorderM.orderItemInfoList.count)
//            {
//                MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
//                
//                MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
//                UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
//                if (Cell==nil)
//                {
//                    Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
//                    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    
//                    if ([_mineshopsM.statusTotal isEqualToString:@"0120"] ||
//                        [_mineshopsM.statusTotal isEqualToString:@"0174"] ||
//                        //[_mineshopsM.statusTotal isEqualToString:@"0132"] ||
//                        [_mineshopsM.statusTotal isEqualToString:@"0180"] ||
//                        [_mineshopsM.statusTotal isEqualToString:@"0182"])
//                    {
//                        NSMutableAttributedString *timerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效期至：%@",shitiM.validityDate]];
//                        [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
//                        [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, shitiM.validityDate.length)];
//                        [timerString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, shitiM.validityDate.length)];
//                        
//                        Cell.textLabel.attributedText =timerString;
//                    }
//                    NSString *quanStr=[NSString stringWithFormat:@"%lu",_mineorderM.orderItemInfoList.count];
//                    
//                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共:%@张团购券",quanStr]];
//                    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, quanStr.length)];
//                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, quanStr.length)];
//                    
//                    UILabel *tuangouQuan =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 0, 100, 44)];
//                    tuangouQuan.attributedText=string;
//                    tuangouQuan.textAlignment=NSTextAlignmentRight;
//                    tuangouQuan.font=[UIFont systemFontOfSize:14];
//                    [Cell.contentView addSubview:tuangouQuan];
//                    
//                }
//                return Cell;
//            }
//            else
//            {
//                MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
//                
//                MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
//                UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
//                if (Cell==nil)
//                {
//                    Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
//                    UILabel *stateLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-100, 0, 90, 44)];
//                    stateLab.textAlignment=NSTextAlignmentRight;
//                    stateLab.font=[UIFont systemFontOfSize:14];
//                    if ([shitiM.barCode isEqualToString:@"110"])
//                    {
//                        stateLab.textColor = [AppUtils colorWithHexString:@"fa6900"];
//                    }
//                    stateLab.text = [self groupBuyStart:shitiM.barCode];
//                    [Cell.contentView addSubview:stateLab];
//                    
//                }
//                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                Cell.textLabel.text=@"券号：";
//                Cell.textLabel.font=[UIFont systemFontOfSize:14];
//                
//                UITextView *quanTV =[[UITextView alloc]init];
//                quanTV.frame=CGRectMake(60, 4, 200, 40);
//                [quanTV setEditable:NO];
//                quanTV.font=[UIFont systemFontOfSize:14];
//                quanTV.text=[DES3EncryptUtil decrypt:shitiM.checkCode];
//                //quanTV.backgroundColor=[UIColor redColor];
//                [Cell.contentView addSubview:quanTV];
//                return Cell;
//            }
//            
//        }
//        
//    }
//    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
//    if (Cell==nil)
//    {
//        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
//        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *orderNoLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH-20, 20)];
//        orderNoLab.font=[UIFont systemFontOfSize:14];
//        orderNoLab.text=[NSString stringWithFormat:@"订单号：%@",_mineshopsM.orderNo];
//        [Cell.contentView addSubview:orderNoLab];
//        
//        UILabel *orderTimerLab =[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(orderNoLab.frame), IPHONE_WIDTH-20, 20)];
//        orderTimerLab.font=[UIFont systemFontOfSize:14];
//        orderTimerLab.text=[NSString stringWithFormat:@"订单时间：%@",_mineshopsM.orderTimeStr];
//        [Cell.contentView addSubview:orderTimerLab];
//        
//        
//    }
//    return Cell;
//        
//    
//   
//
//    
//#elif SmartComYGS
    
    if ([NSString isEmptyOrNull:_mineshopsM.discountAmount] || [_mineshopsM.discountAmount isEqualToString:@"0"])
    {
        if(indexPath.section==0)
        {
            static NSString *CellIdentiferID = @"TuanGouStaeCell";
            TuanGouStaeCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
            if (Cell == nil)
            {
                Cell =[[TuanGouStaeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
            }
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [Cell setStateData:_mineshopsM];
            return Cell;
        }
        else if (indexPath.section==1)
        {
            
            static NSString *CellIdentiferID = @"TuanGouCell";
            TuanGouCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
            if (Cell == nil)
            {
                Cell =[[TuanGouCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
            }
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
            [Cell setTaunGouCellDeta:goodM];
            return Cell;
            
        }
        else if (indexPath.section==2)
        {
            NSLog(@"_mineorderM.orderItemInfoList[indexPath.row] %@",_mineorderM.orderItemInfoList);
            
            if ([_mineshopsM.statusTotal isEqualToString:@"0130"] ||
                [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
                [_mineshopsM.statusTotal isEqualToString:@"0131"] )
            {
                MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
                
                MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
                UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
                if (Cell==nil)
                {
                    Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSLog(@"_mineshopsM.statusTotal %@",_mineshopsM.statusTotal);
                if ([_mineshopsM.statusTotal isEqualToString:@"0120"] ||
                    [_mineshopsM.statusTotal isEqualToString:@"0174"] ||
                    //                [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
                    [_mineshopsM.statusTotal isEqualToString:@"0180"] ||
                    [_mineshopsM.statusTotal isEqualToString:@"0182"])
                {
                    NSMutableAttributedString *timerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效期至：%@",shitiM.validityDate]];
                    [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
                    [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, shitiM.validityDate.length)];
                    [timerString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, shitiM.validityDate.length)];
                    
                    Cell.textLabel.attributedText =timerString;
                }
                NSString *quanStr=[NSString stringWithFormat:@"%lu",_mineorderM.orderItemInfoList.count];
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共:%@张团购券",quanStr]];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, quanStr.length)];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, quanStr.length)];
                
                UILabel *tuangouQuan =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 0, 100, 44)];
                tuangouQuan.attributedText=string;
                tuangouQuan.textAlignment=NSTextAlignmentRight;
                tuangouQuan.font=[UIFont systemFontOfSize:14];
                [Cell.contentView addSubview:tuangouQuan];
                
                return Cell;
                
            }
            else
            {
                if(indexPath.row==_mineorderM.orderItemInfoList.count)
                {
                    MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
                    
                    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
                    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
                    if (Cell==nil)
                    {
                        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        if ([_mineshopsM.statusTotal isEqualToString:@"0120"] ||
                            [_mineshopsM.statusTotal isEqualToString:@"0174"] ||
                            //[_mineshopsM.statusTotal isEqualToString:@"0132"] ||
                            [_mineshopsM.statusTotal isEqualToString:@"0180"] ||
                            [_mineshopsM.statusTotal isEqualToString:@"0182"])
                        {
                            NSMutableAttributedString *timerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效期至：%@",shitiM.validityDate]];
                            [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
                            [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, shitiM.validityDate.length)];
                            [timerString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, shitiM.validityDate.length)];
                            
                            Cell.textLabel.attributedText =timerString;
                        }
                        NSString *quanStr=[NSString stringWithFormat:@"%lu",_mineorderM.orderItemInfoList.count];
                        
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共:%@张团购券",quanStr]];
                        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, quanStr.length)];
                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, quanStr.length)];
                        
                        UILabel *tuangouQuan =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 0, 100, 44)];
                        tuangouQuan.attributedText=string;
                        tuangouQuan.textAlignment=NSTextAlignmentRight;
                        tuangouQuan.font=[UIFont systemFontOfSize:14];
                        [Cell.contentView addSubview:tuangouQuan];
                        
                    }
                    return Cell;
                }
                else
                {
                    MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
                    
                    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
                    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
                    if (Cell==nil)
                    {
                        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                        UILabel *stateLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-100, 0, 90, 44)];
                        stateLab.textAlignment=NSTextAlignmentRight;
                        stateLab.font=[UIFont systemFontOfSize:14];
                        if ([shitiM.barCode isEqualToString:@"110"])
                        {
                            stateLab.textColor = [AppUtils colorWithHexString:@"fa6900"];
                        }
                        stateLab.text = [self groupBuyStart:shitiM.barCode];
                        [Cell.contentView addSubview:stateLab];
                        
                    }
                    UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, 4, 60, 25)];
                    numberLab.text = @"券号：";
                    numberLab.font=[UIFont systemFontOfSize:14];
                    [Cell.contentView addSubview:numberLab];
                    
                    
                    UITextView *quanTV =[[UITextView alloc]init];
                    quanTV.frame=CGRectMake(60, 0, 200, 40);
                    [quanTV setEditable:NO];
                    quanTV.font=[UIFont systemFontOfSize:14];
                    quanTV.text=[DES3EncryptUtil decrypt:shitiM.checkCode];
                    //quanTV.backgroundColor=[UIColor redColor];
                    [Cell.contentView addSubview:quanTV];
                    
                    UILabel *tuikuanLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, 20, IPHONE_WIDTH-G_INTERVAL_BIG*2, 50)];
                    tuikuanLab.font=[UIFont systemFontOfSize:14];
                    [Cell.contentView addSubview:tuikuanLab];
                    
                    if (![NSDictionary isDicEmptyOrNull:shitiM.orderRefundRecord])
                    {
                        if (![NSString isEmptyOrNull:shitiM.orderRefundRecord[@"advice"]])
                        {
                            tuikuanLab.text= [NSString stringWithFormat:@"客服留言：%@",shitiM.orderRefundRecord[@"advice"]];
                            tuikuanLab.hidden=NO;
                        }
                        
                    }
                    else
                    {
                        
                        tuikuanLab.hidden=YES;
                    }
    
                    return Cell;
                }
                
            }
            
        }
        else
        {
            UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (Cell==nil)
            {
                Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *orderNoLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH-20, 20)];
                orderNoLab.font=[UIFont systemFontOfSize:14];
                orderNoLab.text=[NSString stringWithFormat:@"订单号：%@",_mineshopsM.orderNo];
                [Cell.contentView addSubview:orderNoLab];
                
                UILabel *orderTimerLab =[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(orderNoLab.frame), IPHONE_WIDTH-20, 20)];
                orderTimerLab.font=[UIFont systemFontOfSize:14];
                orderTimerLab.text=[NSString stringWithFormat:@"订单时间：%@",_mineshopsM.orderTimeStr];
                [Cell.contentView addSubview:orderTimerLab];
                
                
            }
            return Cell;
            
        }

    }
    else
    {
        if(indexPath.section==0)
        {
            static NSString *CellIdentiferID = @"TuanGouStaeCell";
            TuanGouStaeCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
            if (Cell == nil)
            {
                Cell =[[TuanGouStaeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
            }
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [Cell setStateData:_mineshopsM];
            return Cell;
        }
        else if (indexPath.section==1)
        {
            
            static NSString *CellIdentiferID = @"TuanGouCell";
            TuanGouCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferID];
            if (Cell == nil)
            {
                Cell =[[TuanGouCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferID];
            }
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
            [Cell setTaunGouCellDeta:goodM];
            return Cell;
            
        }
        else if (indexPath.section==2)
        {
            NSLog(@"_mineorderM.orderItemInfoList[indexPath.row] %@",_mineorderM.orderItemInfoList);
            
            if ([_mineshopsM.statusTotal isEqualToString:@"0130"] ||
                [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
                [_mineshopsM.statusTotal isEqualToString:@"0131"] )
            {
                MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
                
                MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
                UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
                if (Cell==nil)
                {
                    Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSLog(@"_mineshopsM.statusTotal %@",_mineshopsM.statusTotal);
                if ([_mineshopsM.statusTotal isEqualToString:@"0120"] ||
                    [_mineshopsM.statusTotal isEqualToString:@"0174"] ||
                    //                [_mineshopsM.statusTotal isEqualToString:@"0132"] ||
                    [_mineshopsM.statusTotal isEqualToString:@"0180"] ||
                    [_mineshopsM.statusTotal isEqualToString:@"0182"])
                {
                    NSMutableAttributedString *timerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效期至：%@",shitiM.validityDate]];
                    [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
                    [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, shitiM.validityDate.length)];
                    [timerString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, shitiM.validityDate.length)];
                    
                    Cell.textLabel.attributedText =timerString;
                }
                NSString *quanStr=[NSString stringWithFormat:@"%lu",_mineorderM.orderItemInfoList.count];
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共:%@张团购券",quanStr]];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, quanStr.length)];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, quanStr.length)];
                
                UILabel *tuangouQuan =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 0, 100, 44)];
                tuangouQuan.attributedText=string;
                tuangouQuan.textAlignment=NSTextAlignmentRight;
                tuangouQuan.font=[UIFont systemFontOfSize:14];
                [Cell.contentView addSubview:tuangouQuan];
                
                return Cell;
                
            }
            else
            {
                if(indexPath.row==_mineorderM.orderItemInfoList.count)
                {
                    MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
                    
                    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
                    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
                    if (Cell==nil)
                    {
                        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        if ([_mineshopsM.statusTotal isEqualToString:@"0120"] ||
                            [_mineshopsM.statusTotal isEqualToString:@"0174"] ||
                            //[_mineshopsM.statusTotal isEqualToString:@"0132"] ||
                            [_mineshopsM.statusTotal isEqualToString:@"0180"] ||
                            [_mineshopsM.statusTotal isEqualToString:@"0182"])
                        {
                            NSMutableAttributedString *timerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有效期至：%@",shitiM.validityDate]];
                            [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 5)];
                            [timerString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, shitiM.validityDate.length)];
                            [timerString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, shitiM.validityDate.length)];
                            
                            Cell.textLabel.attributedText =timerString;
                        }
                        NSString *quanStr=[NSString stringWithFormat:@"%lu",_mineorderM.orderItemInfoList.count];
                        
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共:%@张团购券",quanStr]];
                        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, quanStr.length)];
                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, quanStr.length)];
                        
                        UILabel *tuangouQuan =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 0, 100, 44)];
                        tuangouQuan.attributedText=string;
                        tuangouQuan.textAlignment=NSTextAlignmentRight;
                        tuangouQuan.font=[UIFont systemFontOfSize:14];
                        [Cell.contentView addSubview:tuangouQuan];
                        
                    }
                    return Cell;
                }
                else
                {
                    MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
                    
                    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
                    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
                    if (Cell==nil)
                    {
                        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                        UILabel *stateLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-100, 0, 90, 44)];
                        stateLab.textAlignment=NSTextAlignmentRight;
                        stateLab.font=[UIFont systemFontOfSize:14];
                        if ([shitiM.barCode isEqualToString:@"110"])
                        {
                            stateLab.textColor = [AppUtils colorWithHexString:@"fa6900"];
                        }
                        stateLab.text = [self groupBuyStart:shitiM.barCode];
                        [Cell.contentView addSubview:stateLab];
                        
                    }
                    UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL_BIG, 4, 60, 25)];
                    numberLab.text = @"券号：";
                    numberLab.font=[UIFont systemFontOfSize:14];
                    [Cell.contentView addSubview:numberLab];
                    
                    
                    UITextView *quanTV =[[UITextView alloc]init];
                    quanTV.frame=CGRectMake(60, 0, 200, 40);
                    [quanTV setEditable:NO];
                    quanTV.font=[UIFont systemFontOfSize:14];
                    quanTV.text=[DES3EncryptUtil decrypt:shitiM.checkCode];
                    //quanTV.backgroundColor=[UIColor redColor];
                    [Cell.contentView addSubview:quanTV];
                    
                    UILabel *tuikuanLab = [[UILabel alloc]initWithFrame:CGRectMake(G_INTERVAL, 20, IPHONE_WIDTH-G_INTERVAL_BIG*2, 50)];
                    tuikuanLab.font=[UIFont systemFontOfSize:14];
                    [Cell.contentView addSubview:tuikuanLab];
                    
                    if ([NSDictionary isDicEmptyOrNull:shitiM.orderRefundRecord])
                    {
                        tuikuanLab.hidden=YES;
                    }
                    else
                    {
                        tuikuanLab.text= [NSString stringWithFormat:@"客服留言：\n%@",shitiM.orderRefundRecord[@"advice"]];
                        tuikuanLab.hidden=NO;
                    }
                    return Cell;
                }
                
            }
            
        }
        else if(indexPath.section==3)
        {
            UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (Cell==nil)
            {
                Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UILabel *orderNoLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH-20, 20)];
            orderNoLab.font=[UIFont systemFontOfSize:14];
            orderNoLab.text=@"抵扣券";
            [Cell.contentView addSubview:orderNoLab];
            
            NSString *string;
            if (![NSString isEmptyOrNull:_mineshopsM.discountAmount])
            {
                string=[NSString stringWithFormat:@"- %@",_mineshopsM.discountAmount];
            }
            else
            {
                string=[NSString stringWithFormat:@"- %@",@"0"];
            }
            
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元",string]];
            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length, 1)];
            
            
            UILabel *freightLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-160, 10, 150, 20)];
            freightLab.textAlignment= NSTextAlignmentRight;
            freightLab.font=[UIFont systemFontOfSize:13];
            freightLab.attributedText = str;
            [Cell addSubview:freightLab];
            
            return Cell;
            
        }
        else
        {
            UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (Cell==nil)
            {
                Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
                Cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *orderNoLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH-20, 20)];
                orderNoLab.font=[UIFont systemFontOfSize:14];
                orderNoLab.text=[NSString stringWithFormat:@"订单号：%@",_mineshopsM.orderNo];
                [Cell.contentView addSubview:orderNoLab];
                
                UILabel *orderTimerLab =[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(orderNoLab.frame), IPHONE_WIDTH-20, 20)];
                orderTimerLab.font=[UIFont systemFontOfSize:14];
                orderTimerLab.text=[NSString stringWithFormat:@"订单时间：%@",_mineshopsM.orderTimeStr];
                [Cell.contentView addSubview:orderTimerLab];
                
                
            }
            return Cell;
            
        }

    }
//#else
//    
//#endif
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[0];
        MineBuyShiGoodM *tuanGouM = (MineBuyShiGoodM *)goodM;
        NSLog(@"shangpinID＝%@",tuanGouM.productCode);
        
        TGGoodsModel * goodsModel = [TGGoodsModel new];
        goodsModel.goodsid = tuanGouM.productCode;
        WTTuanGouDetail * detail = [[WTTuanGouDetail alloc] init];
        detail.goodsModel = goodsModel;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

#pragma mark -UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    MineBuyorderM *orderM =[_mineshopsM.orderSubInfoList objectAtIndex:0];
    if(alertView ==cancelOreder)
    {
        if (buttonIndex==0)
        {
            QuXiaoDindanModel *quxiaoM =[QuXiaoDindanModel new];
            QuxiaoDindanHandler *quxiaoH =[QuxiaoDindanHandler new];
            quxiaoM.orderSubNo =orderM.orderSubNo;
            [quxiaoH CancelDindan:quxiaoM success:^(id obj) {
                [AppUtils showSuccessMessage:obj];
                if (self.tuanGouSuccessBlock)
                {
                    self.tuanGouSuccessBlock();
                }
                
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
            } failed:^(id obj) {
                if (self.viewIsVisible) {
                    [AppUtils showAlertMessageTimerClose:obj];
                }
                else {
                    [AppUtils dismissHUD];
                }
            }];
            
        }
        
    }
    
    
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
