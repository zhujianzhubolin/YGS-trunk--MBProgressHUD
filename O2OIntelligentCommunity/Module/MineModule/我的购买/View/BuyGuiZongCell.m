//
//  BuyGuiZongCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BuyGuiZongCell.h"
#import "MineBuyShiGoodM.h"
#import "NSArray+wrapper.h"

@implementation BuyGuiZongCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat interval = 10;
        CGFloat labelHigth =30;
        CGFloat btnWidth=80,btnHigth=30,btnInterval =35;
        self.numberLab = [[UILabel alloc] initWithFrame:CGRectMake(interval, 0, IPHONE_WIDTH - interval * 2, labelHigth)];
        self.numberLab.font = [UIFont systemFontOfSize:18];
        self.numberLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.numberLab];
        
//        _img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, IPHONE_WIDTH, 1)];
//        _img.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
//        [self addSubview:_img];
        UIFont *btnFont = [UIFont systemFontOfSize:14];
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame =CGRectMake(IPHONE_WIDTH- 90, btnInterval, btnWidth, btnHigth);
        [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button1.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
        [_button1.layer setMasksToBounds:YES];
        [_button1.layer setCornerRadius:5];
        _button1.titleLabel.font = btnFont;
        [_button1 setTitle:@"1" forState:UIControlStateNormal];
        [self addSubview:_button1];
        
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(IPHONE_WIDTH -180, btnInterval, btnWidth, btnHigth);
        [_button2 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
        [_button2.layer setMasksToBounds:YES];
        [_button2.layer setCornerRadius:5];
        [_button2.layer setBorderWidth:1];
        [_button2.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
        [_button2 setTitle:@"2" forState:UIControlStateNormal];
        _button2.titleLabel.font = btnFont;
        [self addSubview:_button2];
        
        _button3 =[UIButton buttonWithType:UIButtonTypeCustom];
        _button3.frame = CGRectMake(IPHONE_WIDTH -270, btnInterval, btnWidth, btnHigth);
        [_button3 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
        [_button3.layer setMasksToBounds:YES];
        [_button3.layer setCornerRadius:5];
        [_button3.layer setBorderWidth:1];
        [_button3.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
        [_button3 setTitle:@"3" forState:UIControlStateNormal];
        _button3.titleLabel.font = btnFont; 
        [self addSubview:_button3];
        
        UIImageView *linImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 30, IPHONE_WIDTH, 1)];
        linImg.backgroundColor=[AppUtils colorWithHexString:@"EDEFEB"];
        [self addSubview:linImg];
    }
    return self;
}

-(void)setButton:(MineBuyShopsM *)buyM tuanGouOrShangcheng:(NSString *)str
{
    NSArray *shopArr = buyM.orderSubInfoList;
    
    if ([str isEqualToString:@"shangcheng"])
    {
        NSString *str1 = [NSString stringWithFormat:@"共1件商品,实付:"];;
        
        if (![NSArray isArrEmptyOrNull:shopArr]) {
            MineBuyorderM *orderM = shopArr[0];
            
            __block int goodsCount = 0;
            [orderM.orderItemInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MineBuyShiGoodM *goodM = obj;
                goodsCount += goodM.saleNum.intValue;
            }];
            
            str1 = [NSString stringWithFormat:@"共%d件商品,实付:",goodsCount];
        }
        
        NSString *str2=[NSString stringWithFormat:@"%0.2f",[buyM.totalPayAmount floatValue]];
        NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@元",str1,str2]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fa6900"] range:NSMakeRange(str1.length, str2.length)];
        self.numberLab.attributedText=str;
        
        NSString *statusStr =[NSString stringWithFormat:@"%@",buyM.statusTotal];
        if ([statusStr isEqualToString:@"0130"] )//待付款
        {
            _button1.hidden=NO;
            _button2.hidden=NO;
            _button3.hidden=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"立即付款" forState:UIControlStateNormal];
                [_button2 setTitle:@"取消订单" forState:UIControlStateNormal];
            });
        }
        else if ([statusStr isEqualToString:@"0131"])//已取消
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0120"])//已支付
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0170"])//待收货
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"确认收货" forState:UIControlStateNormal];
                [_button2 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=NO;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0180"])//待评价
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"去评价" forState:UIControlStateNormal];
                [_button2 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=NO;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0182"])//已完成
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0172"])//退款驳回
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"查看物流" forState:UIControlStateNormal];
                
            });
            _button1.hidden=NO;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0173"])//订单退款中
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0174"])//订单退款完成
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
      

    }
    else
    {
        NSString *str1 = [NSString stringWithFormat:@"金额:"];
        
        if (![NSArray isArrEmptyOrNull:shopArr]) {
            MineBuyorderM *orderM = shopArr[0];
            
            __block int goodsCount = 0;
            [orderM.orderItemInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MineBuyShiGoodM *goodM = obj;
                goodsCount += goodM.saleNum.intValue;
            }];
            
            str1 = [NSString stringWithFormat:@"金额:"];
        }
        
        NSString *str2=[NSString stringWithFormat:@"%0.2f",[buyM.totalPayAmount floatValue]];
        NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@元",str1,str2]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fa6900"] range:NSMakeRange(str1.length, str2.length)];
        self.numberLab.attributedText=str;
        NSString *statusStr =[NSString stringWithFormat:@"%@",buyM.statusTotal];
        if ([statusStr isEqualToString:@"0130"] )//待付款
        {
            _button1.hidden=NO;
            _button2.hidden=NO;
            _button3.hidden=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"立即付款" forState:UIControlStateNormal];
                [_button2 setTitle:@"取消订单" forState:UIControlStateNormal];
            });
        }
        else if ([statusStr isEqualToString:@"0131"])//已取消
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0120"])//已支付
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0170"])//待收货
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"确认收货" forState:UIControlStateNormal];
                [_button2 setTitle:@"查看物流" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=NO;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0180"])//待评价
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_button1 setTitle:@"去评价" forState:UIControlStateNormal];
            });
            _button1.hidden=NO;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0182"])//已完成
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            [_button1 setTitle:@"评价" forState:UIControlStateNormal];
            //            [_button2 setTitle:@"删除订单" forState:UIControlStateNormal];
            //        });
        }
        else if ([statusStr isEqualToString:@"0132"])//系统自动取消
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0183"])
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
        }
        else if ([statusStr isEqualToString:@"0184"])
        {
            _button1.hidden=YES;
            _button2.hidden=YES;
            _button3.hidden=YES;
            
        }
        else
        {
            
                _button1.hidden=YES;
                _button2.hidden=YES;
                _button3.hidden=YES;
    

        }


    }
    
    
    
    
    
}

@end
