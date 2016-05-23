//
//  YesIsNOCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "YesIsNOCell.h"

@implementation YesIsNOCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        UIFont *btnFont = [UIFont systemFontOfSize:14];
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
        [_button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button1.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
        _button1.titleLabel.font=btnFont;
        [_button1.layer setMasksToBounds:YES];
        [_button1.layer setCornerRadius:5];
        [_button1 setTitle:@"1" forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(SelectChilk1) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_button1];
        
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
        [_button2 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
        _button2.titleLabel.font=btnFont;
        [_button2.layer setMasksToBounds:YES];
        [_button2.layer setCornerRadius:5];
        [_button2.layer setBorderWidth:1];
        [_button2.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
        [_button2 setTitle:@"2" forState:UIControlStateNormal];
        [self.contentView addSubview:_button2];
        
        _button3 =[UIButton buttonWithType:UIButtonTypeCustom];
        _button3.frame = CGRectMake(IPHONE_WIDTH -270, 10, 80, 30);
        [_button3 setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
        _button3.titleLabel.font=btnFont;
        [_button3.layer setMasksToBounds:YES];
        [_button3.layer setCornerRadius:5];
        [_button3.layer setBorderWidth:1];
        [_button3.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
        [_button3 setTitle:@"3" forState:UIControlStateNormal];
        [self.contentView addSubview:_button3];
    }
    return self;
}

- (void)SelectChilk1 {
    NSLog(@"SelectChilk");
}

-(void)setButton:(MineBuyShopsM *)shopM
{
    
    self.backgroundColor=[UIColor redColor];
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH-20, 25)];
    textLab.font=[UIFont systemFontOfSize:14];
    textLab.textColor=[UIColor lightGrayColor];
    textLab.numberOfLines=3;
    [self.contentView addSubview:textLab];
    
    
    if (![NSDictionary isDicEmptyOrNull:shopM.orderRefundRecord])
    {
        NSDictionary *tuikuanDic = shopM.orderRefundRecord;
        textLab.text=[NSString stringWithFormat:@"客服留言：\n%@",tuikuanDic[@"advice"]];
    }

    
    CGSize labSize = [AppUtils sizeWithString:textLab.text font:textLab.font size:CGSizeMake(textLab.frame.size.width, 75)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        textLab.frame=CGRectMake(G_INTERVAL, G_INTERVAL, IPHONE_WIDTH-G_INTERVAL*2, labSize.height);
    });

    textLab.hidden=YES;
    
    
    if ([shopM.statusTotal isEqualToString:@"0172"] && ![NSDictionary isDicEmptyOrNull:shopM.orderRefundRecord] )
    {
        textLab.hidden=NO;
        _button1.frame =CGRectMake(IPHONE_WIDTH- 90, labSize.height + G_INTERVAL*2, 80, 30);
        _button2.frame = CGRectMake(IPHONE_WIDTH -180,labSize.height + G_INTERVAL*2, 80, 30);
        _button3.frame = CGRectMake(IPHONE_WIDTH -270, labSize.height + G_INTERVAL*2, 80, 30);
    }
    else
    {
        textLab.hidden=YES;
        _button1.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
        _button2.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
        _button3.frame = CGRectMake(IPHONE_WIDTH -270, 10, 80, 30);
    }

    NSString *statusStr =[NSString stringWithFormat:@"%@",shopM.statusTotal];
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
            [_button1 setTitle:@"联系客服" forState:UIControlStateNormal];
            [_button2 setTitle:@"查看物流" forState:UIControlStateNormal];
        });
        _button1.hidden=NO;
        _button2.hidden=NO;
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
    
    CGRect  cellRect = self.frame;
    cellRect.size.height = G_INTERVAL *3 +CGRectGetMaxY(_button3.frame);
    self.frame = cellRect;


}

@end
