//
//  MoneyBagCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoneyBagCell.h"
#import "NSString+wrapper.h"


@implementation MoneyBagCell
{
    UIImageView *iconimgV;
    UILabel     *nameLabe;
    UILabel     *timeLabe;
    UILabel     *moneyLabe;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{   
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        iconimgV =[[UIImageView alloc]init];
//        iconimgV.frame=CGRectMake(10, 15, 35, 35);
//        iconimgV.image=[UIImage imageNamed:@"shuifei"];
//        [self.contentView addSubview:iconimgV];
        
        nameLabe =[[UILabel alloc]init];
        nameLabe.frame=CGRectMake(20, 5, 120, 25);
        [self.contentView addSubview:nameLabe];
        
        timeLabe =[[UILabel alloc]init];
        timeLabe.frame=CGRectMake(20, 35, 200, 25);
        timeLabe.text=@"2015-09-11";
        [self.contentView addSubview:timeLabe];
        
        moneyLabe = [[UILabel alloc]init];
        moneyLabe.frame=CGRectMake(IPHONE_WIDTH-110, 20, 100, 30);
        moneyLabe.text=@"32434";
        moneyLabe.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:moneyLabe];
    }
    return self;
}

-(void)setMoneyBaginfo:(MoneybagModel *)moneyM
{
    if ([moneyM.businessType isEqualToString:@"dc_recharge"])
    {
        nameLabe.text=@"线下代付";
    }
    else if ([moneyM.businessType isEqualToString:@"cz_rechargeing"])
    {
        nameLabe.text=@"充值中";
    }
    else if ([moneyM.businessType isEqualToString:@"cz_recharge"])
    {
        nameLabe.text=@"网上充值";
    }
    else if ([moneyM.businessType isEqualToString:@"payment"])
    {
        nameLabe.text=@"支付";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment0000"])
    {
        nameLabe.text=@"购物";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment4"])
    {
        nameLabe.text=@"手机充值";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment5"])
    {
        nameLabe.text=@"支付交通罚款";
    }
    else if ([moneyM.businessType isEqualToString:@"payment6011"])
    {
        nameLabe.text=@"支付水费";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment6012"])
    {
        nameLabe.text=@"支付电费";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment6013"])
    {
        nameLabe.text=@"支付燃气费";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment6031"])
    {
        nameLabe.text=@"支付物业费";
    }
    
    else if ([moneyM.businessType isEqualToString:@"payment6032"])
    {
        nameLabe.text=@"支付停车费";
    }
    else if([moneyM.businessType isEqualToString:@"refund"])
    {
        nameLabe.text=@"退款";
    }
    else if([moneyM.businessType isEqualToString:@"integralExchange"])
    {
        nameLabe.text=@"积分兑换";
    }

    
    
    if(![NSString isEmptyOrNull:moneyM.dateCreated])
    {
        timeLabe.text=[moneyM.dateCreated substringToIndex:10];
    }
    else
    {
        timeLabe.text=@"未知";
    }
    
    moneyLabe.textColor=[AppUtils colorWithHexString:@"FE9D09"];
    
    if([moneyM.businessType isEqualToString:@"refund"] || [moneyM.businessType isEqualToString:@"cz_recharge"] || [moneyM.businessType isEqualToString:@"integralExchange"] || [moneyM.businessType isEqualToString:@"dc_recharge"])
    {
        moneyLabe.text=[NSString stringWithFormat:@"+%@元",moneyM.businessAmount];
        moneyLabe.textColor =[AppUtils colorWithHexString:@"fa6900"];
    }
    else if ([moneyM.businessType isEqualToString:@"cz_rechargeing"])
    {
        moneyLabe.text=[NSString stringWithFormat:@"%@元",moneyM.businessAmount];
    }
    else
    {
        moneyLabe.text=[NSString stringWithFormat:@"-%@元",moneyM.businessAmount];
        moneyLabe.textColor =[UIColor blackColor];
    }
    
}

@end
