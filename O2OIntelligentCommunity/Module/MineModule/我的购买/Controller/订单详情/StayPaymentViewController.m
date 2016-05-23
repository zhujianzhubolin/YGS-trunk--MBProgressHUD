//
//  StayPaymentViewController.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "StayPaymentViewController.h"
#import "StayPaymentAddressCell.h"
#import "CommodityNumberCell.h"
#import "YesIsNOCell.h"
#import "WuLiuDetailcell.h"
#import "LiJiFuKuanVC.h"
#import "GoodsShopsCommentsVC.h"
#import "UserManager.h"
#import "ShangChengGoodsDeatil.h"

//取消订单接口类
#import "QuxiaoDindanHandler.h"
#import "QuXiaoDindanModel.h"
//删除和取消订单
#import "DeleteDingdanModel.h"
#import "DeleteDingdanHandler.h"
#import "WebVC.h"

@implementation StayPaymentViewController
{
    UIAlertView *ConfirmAlertView;//确认收货
    UIAlertView *cancelOreder;//取消订单
    UIAlertView *wuLiuAlert;//查看物流
}

- (void)setMineshopsM:(MineBuyShopsM *)mineshopsM {
    _mineshopsM = mineshopsM;
    NSLog(@" _mineshopsM.orderNo;==%@", _mineshopsM.orderNo);
    [_TableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航栏文字颜色
    
    self.title=@"订单详情";
    self.view.backgroundColor=[AppUtils colorWithHexString:@"ECECEC"];
    [self initUI];
    [_TableView reloadData];
}

-(void)initUI
{
    //_TableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _TableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _TableView.dataSource =self;
    _TableView.delegate =self;
    _TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _TableView.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
    _TableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_TableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#ifdef SmartComJYZX
//    return 5;
//#elif SmartComYGS
    if ([NSString isEmptyOrNull:_mineshopsM.discountAmount] || [_mineshopsM.discountAmount isEqualToString:@"0"])
    {
        return 5;
    }
    else
    {
         return 6;
    }
   
//#else
//    
//#endif

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSString *statusStr =[NSString stringWithFormat:@"%@",_mineshopsM.statusTotal];
    switch (section)
    {
        case 0:
        {
            return 1;
        }
        break;
        case 1:
            return _mineorderM.orderItemInfoList.count;
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //NSString *statusStr =[NSString stringWithFormat:@"%@",_mineshopsM.statusTotal];
    switch (section)
    {
        case 0:
            return 60;
            break;
        case 1:
            return 25;
            break;
        default:
            return 5;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1)
    {
        return 35;
        
    }
    else
    {
        return CGFLOAT_MIN;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    NSString *goodsNum = [NSString stringWithFormat:@"共%lu件商品 ",(unsigned long)_mineorderM.orderItemInfoList.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:goodsNum];
    [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(1, goodsNum.length - 5)];
    
    NSString *discountAmountStr;
    NSString *transportFeeStr;
    if ([NSString isEmptyOrNull:_mineshopsM.discountAmount]||[_mineshopsM.discountAmount isEqualToString:@"0"])
    {
        discountAmountStr=@"0";
    }
    else
    {
        discountAmountStr=_mineshopsM.discountAmount;
    }
    if ([NSString isEmptyOrNull:_mineshopsM.transportFee] || [_mineshopsM.transportFee isEqualToString:@"0"])
    {
        transportFeeStr=@"0";
    }
    else
    {
        transportFeeStr=_mineshopsM.transportFee;
    }
    
    NSString *moneyStr = [NSString stringWithFormat:@"合计%.2f元",[_mineshopsM.totalPayAmount floatValue]+[discountAmountStr floatValue]-[transportFeeStr floatValue]];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [str2 addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(2, str2.length - 3)];
    
    [str appendAttributedString:str2];
    if (section==1)
    {

        UIView *View =[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 35)];
        View.backgroundColor=[UIColor whiteColor];
        UILabel *numberlabe =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-20, 35)];
        numberlabe.textAlignment=NSTextAlignmentRight;
        numberlabe.font=[UIFont systemFontOfSize:14];
        numberlabe.attributedText= str;
        [View addSubview:numberlabe];
        
        UIImageView *lineImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, IPHONE_WIDTH, 1)];
        lineImg.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
        [View addSubview:lineImg];
        return View;

    }
    else
        return nil;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *View = [[UIView alloc]init];
    View.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];

    if (section ==0)
    {
        View.frame=CGRectMake(0, 0, IPHONE_WIDTH, 50);
        
        UIImageView *StayPaymentImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        //StayPaymentImg.image =[UIImage imageNamed:@"zyOrderInfo"];
        
        UILabel *StatPaymentLabe =[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 100, 30)];
        StatPaymentLabe.font = [UIFont systemFontOfSize:14];
        NSString *statusStr =[NSString stringWithFormat:@"%@",_mineshopsM.statusTotal];
        if ([statusStr isEqualToString:@"0130"] )//待付款
        {
            StatPaymentLabe.text=@"待付款";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYdaifukuan"];

        }
        else if ([statusStr isEqualToString:@"0172"])//退款驳回
        {
            StatPaymentLabe.text=@"退款驳回";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYtuikuanBoHui"];
        }
        else if ([statusStr isEqualToString:@"0173"])//退款中
        {
            StatPaymentLabe.text=@"退款中";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYtuiKuanZhong"];
        }


        else if ([statusStr isEqualToString:@"0131"])//已取消
        {
            StatPaymentLabe.text=@"已取消";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYyiquxiao"];
        }
        else if ([statusStr isEqualToString:@"0120"])//已支付
        {
            StatPaymentLabe.text=@"待发货";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYdaifahuo"];
        }
        else if ([statusStr isEqualToString:@"0170"])//待收货
        {
            StatPaymentLabe.text=@"待收货";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYdaishouhuo"];
        }
        else if ([statusStr isEqualToString:@"0180"])//待评价
        {
            StatPaymentLabe.text=@"待评价";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYdaipingjia"];
        }
        else if ([statusStr isEqualToString:@"0182"])//已完成
        {
            StatPaymentLabe.text=@"已评价";
            StayPaymentImg.image =[UIImage imageNamed:@"ZYyipingjia"];
        }
        else if([statusStr isEqualToString:@"0174"])
        {
            StatPaymentLabe.text=@"订单退款完成";
            StayPaymentImg.image =[UIImage imageNamed:@"gouda"];
        }

        
        UILabel *sumLabe =[[UILabel alloc]initWithFrame:CGRectMake(60, 30, IPHONE_WIDTH - 60 - 10, 30)];
        sumLabe.font = [UIFont systemFontOfSize:14];
        sumLabe.text=[NSString stringWithFormat:@"订单金额:%@元",_mineshopsM.totalPayAmount];
        [View addSubview:sumLabe];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:sumLabe.text];
        [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(5, _mineshopsM.totalPayAmount.length)];
        
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(5, _mineshopsM.totalPayAmount.length)];
        
        sumLabe.attributedText = str;
        
        [View addSubview:StatPaymentLabe];
        [View addSubview:StayPaymentImg];
    }
    else if (section ==1)
    {
        View.frame=CGRectMake(0, 0, IPHONE_WIDTH, 25);
        
        UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, IPHONE_WIDTH-20, 25)];
        shopName.textColor =[AppUtils colorWithHexString:@"fa6900"];
        shopName.font=[UIFont systemFontOfSize:15];
        shopName.text=_mineshopsM.merchantName;

        [View addSubview:shopName];
    
    }
    return View;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//#ifdef SmartComJYZX
//    if (indexPath.section==0)
//    {
//        return 80;
//    }
//    else if (indexPath.section==1)
//    {
//        return 80;
//    }
//    else if (indexPath.section==2)
//    {
//        return 40;
//    }
//    else if (indexPath.section==3)
//    {
//        return 50;
//    }
//    else if (indexPath.section==4)
//    {
//        return 50;
//    }
//    return 0;
//
//#elif SmartComYGS
    
    if ([NSString isEmptyOrNull:_mineshopsM.discountAmount] || [_mineshopsM.discountAmount isEqualToString:@"0"])
    {
        if (indexPath.section==0)
        {
            return 80;
        }
        else if (indexPath.section==1)
        {
            return 80;
        }
        else if (indexPath.section==2)
        {
            return 40;
        }
        else if (indexPath.section==3)
        {
            return 50;
        }
        else if (indexPath.section==4)
        {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
        }

        return 0;
        
    }
    else
    {
        if (indexPath.section==0)
        {
            return 80;
        }
        else if (indexPath.section==1)
        {
            return 80;
        }
        else if (indexPath.section==2)
        {
            return 40;
        }
        else if (indexPath.section==3)
        {
            return 40;
        }
        else if (indexPath.section==4)
        {
            return 50;
        }
        else if (indexPath.section==5)
        {
        
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
            
        }

        return 0;

    }
//#else
//    
//#endif

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//#ifdef SmartComJYZX
//    if (indexPath.section==0)
//    {
//        if (indexPath.row==0)
//        {
//            StayPaymentAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
//            if (cell == nil)
//            {
//                cell = [[StayPaymentAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//            }
//            [cell setuserinfo:_mineorderM];
//            return cell;
//            
//        }
//        else if(indexPath.row ==1)
//        {
//            WuLiuDetailcell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell4"];
//            if (cell==nil)
//            {
//                cell =[[WuLiuDetailcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            return cell;
//        }
//    }
//    else if (indexPath.section==1)
//    {
//        CommodityNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
//        if (cell == nil)
//        {
//            cell = [[CommodityNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//        }
//        
//        MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
//        if (goodM.isShiti)
//        {
//            [cell getShitiBuyM:goodM];
//        }
//        else
//        {
//            [cell getXuliBuyM:goodM];
//        }
//        return cell;
//    }
//    else if (indexPath.section==2)
//    {
//        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
//        if (cell==nil)
//        {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
//        }
//        UILabel *quanLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH, 20)];
//        quanLab.textColor = [UIColor grayColor];
//        quanLab.font=[UIFont systemFontOfSize:13];
//        quanLab.text = @"运费";
//        [cell addSubview:quanLab];
//        
//        NSString *string;
//        if (![NSString isEmptyOrNull:_mineshopsM.transportFee] && ![_mineshopsM.transportFee isEqualToString:@"0"])
//        {
//            string=[NSString stringWithFormat:@"+ %@",_mineshopsM.transportFee];
//        }
//        else
//        {
//            string=@"免运费";
//        }
//        NSMutableAttributedString *str;
//        
//        if (![NSString isEmptyOrNull:_mineshopsM.transportFee] && ![_mineshopsM.transportFee isEqualToString:@"0"])
//        {
//            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元",string]];
//            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
//            
//            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length, 1)];
//            
//        }
//        else
//        {
//            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",string]];
//            
//            [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
//            
//        }
//        
//        UILabel *freightLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-160, 10, 150, 20)];
//        freightLab.textAlignment= NSTextAlignmentRight;
//        freightLab.font=[UIFont systemFontOfSize:13];
//        freightLab.attributedText = str;
//        [cell addSubview:freightLab];
//        return cell;
//        
//    }
//    else if (indexPath.section==3)
//    {
//        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
//        if (cell==nil)
//        {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
//        }
//        
//        UILabel *formNumber= [[UILabel alloc]initWithFrame:CGRectMake(10, 5, IPHONE_WIDTH, 20)];
//        formNumber.textColor = [UIColor grayColor];
//        formNumber.font=[UIFont systemFontOfSize:13];
//        formNumber.text = [NSString stringWithFormat:@"订单编号:%@",_mineshopsM.orderNo];
//        [cell addSubview:formNumber];
//        
//        UILabel *formTime =[[UILabel alloc]initWithFrame:CGRectMake(10, 25, IPHONE_WIDTH, 20)];
//        formTime.textColor = [UIColor grayColor];
//        formTime.font=[UIFont systemFontOfSize:13];
//        formTime.text = [NSString stringWithFormat:@"订单时间:%@",_mineshopsM.orderTimeStr];
//        [cell addSubview:formTime];
//        
//        return cell;
//    }
//    YesIsNOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
//    if (cell == nil)
//    {
//        cell = [[YesIsNOCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
//        cell.button1.tag=indexPath.section;
//        [cell.button1 addTarget:self action:@selector(SelectChilk) forControlEvents:UIControlEventTouchUpInside];
//        cell.button2.tag=indexPath.section;
//        [cell.button2 addTarget:self action:@selector(quxiaoArr) forControlEvents:UIControlEventTouchUpInside];
//        cell.button3.tag=indexPath.section;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    [cell setButton:_mineshopsM];
//    cell.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
//    
//    return cell;
//
//    
//#elif SmartComYGS
    
    if ([NSString isEmptyOrNull:_mineshopsM.discountAmount] || [_mineshopsM.discountAmount isEqualToString:@"0"])
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                StayPaymentAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if (cell == nil)
                {
                    cell = [[StayPaymentAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                [cell setuserinfo:_mineorderM];
                return cell;
                
            }
            else if(indexPath.row ==1)
            {
                WuLiuDetailcell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (cell==nil)
                {
                    cell =[[WuLiuDetailcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return cell;
            }
        }
        else if (indexPath.section==1)
        {
            CommodityNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell == nil)
            {
                cell = [[CommodityNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
            if (goodM.isShiti)
            {
                [cell getShitiBuyM:goodM];
            }
            else
            {
                [cell getXuliBuyM:goodM];
            }
            return cell;
        }
        else if (indexPath.section==2)
        {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            UILabel *quanLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH, 20)];
            quanLab.textColor = [UIColor grayColor];
            quanLab.font=[UIFont systemFontOfSize:13];
            quanLab.text = @"运费";
            [cell addSubview:quanLab];
            
            NSString *string;
            if (![NSString isEmptyOrNull:_mineshopsM.transportFee] && ![_mineshopsM.transportFee isEqualToString:@"0"])
            {
                string=[NSString stringWithFormat:@"+ %@",_mineshopsM.transportFee];
            }
            else
            {
                string=@"免运费";
            }
            NSMutableAttributedString *str;
            
            if (![NSString isEmptyOrNull:_mineshopsM.transportFee] && ![_mineshopsM.transportFee isEqualToString:@"0"])
            {
                str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元",string]];
                [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
                
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length, 1)];
                
            }
            else
            {
                
                str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",string]];
                
                [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
                
                //[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length, 1)];
                
            }
            
            
            UILabel *freightLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-160, 10, 150, 20)];
            freightLab.textAlignment= NSTextAlignmentRight;
            freightLab.font=[UIFont systemFontOfSize:13];
            freightLab.attributedText = str;
            [cell addSubview:freightLab];
            return cell;
            
        }
        else if (indexPath.section==3)
        {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            
            UILabel *formNumber= [[UILabel alloc]initWithFrame:CGRectMake(10, 5, IPHONE_WIDTH, 20)];
            formNumber.textColor = [UIColor grayColor];
            formNumber.font=[UIFont systemFontOfSize:13];
            formNumber.text = [NSString stringWithFormat:@"订单编号:%@",_mineshopsM.orderNo];
            [cell addSubview:formNumber];
            
            UILabel *formTime =[[UILabel alloc]initWithFrame:CGRectMake(10, 25, IPHONE_WIDTH, 20)];
            formTime.textColor = [UIColor grayColor];
            formTime.font=[UIFont systemFontOfSize:13];
            formTime.text = [NSString stringWithFormat:@"订单时间:%@",_mineshopsM.orderTimeStr];
            [cell addSubview:formTime];
            
            return cell;
        }
        
        
        YesIsNOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil)
        {
            cell = [[YesIsNOCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        
        cell.button1.tag=indexPath.section;
        [cell.button1 addTarget:self action:@selector(SelectChilk) forControlEvents:UIControlEventTouchUpInside];
        cell.button2.tag=indexPath.section;
        [cell.button2 addTarget:self action:@selector(quxiaoArr) forControlEvents:UIControlEventTouchUpInside];
        cell.button3.tag=indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setButton:_mineshopsM];
        cell.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
        return cell;

    }
    else
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                StayPaymentAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if (cell == nil)
                {
                    cell = [[StayPaymentAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                [cell setuserinfo:_mineorderM];
                return cell;
                
            }
            else if(indexPath.row ==1)
            {
                WuLiuDetailcell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (cell==nil)
                {
                    cell =[[WuLiuDetailcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return cell;
            }
        }
        else if (indexPath.section==1)
        {
            CommodityNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell == nil)
            {
                cell = [[CommodityNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            MineBuyGoodM *goodM = _mineorderM.orderItemInfoList[indexPath.row];
            if (goodM.isShiti)
            {
                [cell getShitiBuyM:goodM];
            }
            else
            {
                [cell getXuliBuyM:goodM];
            }
            return cell;
        }
        else if (indexPath.section==2)
        {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            UILabel *quanLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH, 20)];
            quanLab.textColor = [UIColor grayColor];
            quanLab.font=[UIFont systemFontOfSize:13];
            quanLab.text = @"券抵扣";
            [cell addSubview:quanLab];
            
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
            
            
            UILabel *deductionLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-160, 10, 150, 20)];
            deductionLab.textAlignment= NSTextAlignmentRight;
            deductionLab.font=[UIFont systemFontOfSize:13];
            deductionLab.attributedText = str;
            [cell addSubview:deductionLab];
            return cell;
            
        }
        else if (indexPath.section==3)
        {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            UILabel *quanLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH, 20)];
            quanLab.textColor = [UIColor grayColor];
            quanLab.font=[UIFont systemFontOfSize:13];
            quanLab.text = @"运费";
            [cell addSubview:quanLab];
            
            NSString *string;
            if (![NSString isEmptyOrNull:_mineshopsM.transportFee] && ![_mineshopsM.transportFee isEqualToString:@"0"])
            {
                string=[NSString stringWithFormat:@"+ %@",_mineshopsM.transportFee];
            }
            else
            {
                string=@"免运费";
            }
            NSMutableAttributedString *str;
            
            if (![NSString isEmptyOrNull:_mineshopsM.transportFee] && ![_mineshopsM.transportFee isEqualToString:@"0"])
            {
                str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元",string]];
                [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
                
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length, 1)];
                
            }
            else
            {
                
                str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",string]];
                
                [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fc6d22"] range:NSMakeRange(0, string.length)];
                
                //[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(string.length, 1)];
                
            }
            
            
            UILabel *freightLab =[[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-160, 10, 150, 20)];
            freightLab.textAlignment= NSTextAlignmentRight;
            freightLab.font=[UIFont systemFontOfSize:13];
            freightLab.attributedText = str;
            [cell addSubview:freightLab];
            return cell;
            
        }
        else if (indexPath.section==4)
        {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
            }
            
            UILabel *formNumber= [[UILabel alloc]initWithFrame:CGRectMake(10, 5, IPHONE_WIDTH, 20)];
            formNumber.textColor = [UIColor grayColor];
            formNumber.font=[UIFont systemFontOfSize:13];
            formNumber.text = [NSString stringWithFormat:@"订单编号:%@",_mineshopsM.orderNo];
            [cell addSubview:formNumber];
            
            UILabel *formTime =[[UILabel alloc]initWithFrame:CGRectMake(10, 25, IPHONE_WIDTH, 20)];
            formTime.textColor = [UIColor grayColor];
            formTime.font=[UIFont systemFontOfSize:13];
            formTime.text = [NSString stringWithFormat:@"订单时间:%@",_mineshopsM.orderTimeStr];
            [cell addSubview:formTime];
            
            return cell;
        }
        YesIsNOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil)
        {
            cell = [[YesIsNOCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            
        }
        cell.button1.tag=indexPath.section;
        [cell.button1 addTarget:self action:@selector(SelectChilk) forControlEvents:UIControlEventTouchUpInside];
        cell.button2.tag=indexPath.section;
        [cell.button2 addTarget:self action:@selector(quxiaoArr) forControlEvents:UIControlEventTouchUpInside];
        cell.button3.tag=indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setButton:_mineshopsM];
        cell.backgroundColor=[AppUtils colorWithHexString:COLOR_MAIN];
        return cell;

    }
    
    
//#else
//    
//#endif

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section==1)
    {
        MineBuyShiGoodM *shitiM = _mineorderM.orderItemInfoList[indexPath.row];

        ShangChengGoodsDeatil *shangchengVC =[[ShangChengGoodsDeatil alloc]init];
        shangchengVC.productId=shitiM.commodityId;
        if (![NSString isEmptyOrNull:shitiM.commodityId])
        {
            [self.navigationController pushViewController:shangchengVC animated:YES];
        }

    }
}


- (void)popLastVC {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SelectChilk
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
            if (self.buySuccessBlock)
            {
                self.buySuccessBlock();
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
        querenM.memberNo =[UserManager shareManager].userModel.memberId;
        querenM.orderNo = _mineshopsM.orderNo;
        
        [querenH AffirmConsignee:querenM success:^(id obj) {
            [AppUtils showAlertMessageTimerClose:@"已确认收货"];
            if (self.buySuccessBlock)
            {
                self.buySuccessBlock();
            }
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popLastVC) userInfo:nil repeats:NO];
        } failed:^(id obj) {
            [AppUtils showAlertMessageTimerClose:obj];
        }];
        
    }
    else if ([statusPayStr isEqualToString:@"0180"])//待评价
    {
        NSLog(@"待评价");
        GoodsShopsCommentsVC *gsCommentVc= [GoodsShopsCommentsVC new];
        gsCommentVc.orderM=orderM;
        gsCommentVc.mineshopsM = self.mineshopsM;
        gsCommentVc.commentSuccessBlock=^()
        {
            if (self.buySuccessBlock)
            {
                self.buySuccessBlock();
            }
        };
        [self.navigationController pushViewController:gsCommentVc animated:YES];
        
    }

    else if ([statusPayStr isEqualToString:@"0182"])//交易成功
    {
        [self wuLiu:_mineorderM];
    }
    else if ([statusPayStr isEqualToString:@"0172"])//退款驳回
    {
        [AppUtils callPhone:P_SERVICE_PHONE];
    }
    else if ([statusPayStr isEqualToString:@"0173"])//订单退款中
    {
        [self wuLiu:_mineorderM];
    }
    else if ([statusPayStr isEqualToString:@"0174"])//订单退款完成
    {
        [self wuLiu:_mineorderM];
    }


    
}
-(void)wuLiu:(MineBuyorderM *)cancelorderMM
{
    if ([cancelorderMM.deliveryMerchantType isEqualToString:@"0022"])
    {
        wuLiuAlert =[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"该商品为商家自己配送，可拨打商家电话查询配送情况！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [wuLiuAlert show];
    }
    else if([NSString isEmptyOrNull:cancelorderMM.deliveryMerchantNo])
    {
        UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"没有快递单号" message:@"请联系商家！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [aler show];
    }
    else
    {
        NSLog(@"待收货");
        WebVC *logisticsvc = [WebVC new];
        logisticsvc.title = @"物流";
        NSString *urlStr =[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@#result",cancelorderMM.deliveryMerchantType,cancelorderMM.deliveryMerchantNo];
        logisticsvc.webURL = urlStr;
        [self.navigationController pushViewController:logisticsvc animated:YES];
    }
    
}


-(void)quxiaoArr
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
    else if ([statusPayStr isEqualToString:@"0172"])//退款驳回
    {
        [self wuLiu:_mineorderM];
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
                if (self.buySuccessBlock)
                {
                    self.buySuccessBlock();
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


@end
