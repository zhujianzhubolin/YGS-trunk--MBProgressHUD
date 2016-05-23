//
//  PayCostCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/9.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PayCostCell.h"
#import "PaycostHandler.h"

@implementation PayCostCell
{
    
    UIImageView *iconImgV;
    UILabel     *namelab;
    UILabel     *timelab;
    UILabel     *statuslab;
    UILabel     *moneylab;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        iconImgV =[[UIImageView alloc]init];
        iconImgV.frame=CGRectMake(10, 10, 30, 30);
        iconImgV.image=[UIImage imageNamed:@""];
        [self.contentView addSubview:iconImgV];
        
        namelab =[[UILabel alloc]init];
        namelab.frame=CGRectMake(50, 5, 100, 25);
        namelab.text=@"";
        [self.contentView addSubview:namelab];
        
        timelab = [[UILabel alloc]init];
        timelab.frame=CGRectMake(50, 25, 170, 25);
        timelab.text=@"";
        timelab.textColor=[UIColor grayColor];
        timelab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:timelab];
        
        statuslab = [[UILabel alloc]init];
        statuslab.frame=CGRectMake(IPHONE_WIDTH-110, 5, 100, 25);
        statuslab.text=@"";
        statuslab.textColor=[UIColor grayColor];
        statuslab.font=[UIFont systemFontOfSize:14];
        statuslab.textAlignment =NSTextAlignmentRight;
        [self.contentView addSubview:statuslab];
        
        moneylab = [[UILabel alloc]init];
        moneylab.frame=CGRectMake(IPHONE_WIDTH-110, 25, 100, 25);
        moneylab.text=@"";
        moneylab.textColor=[AppUtils colorWithHexString:@"FF6c00"];
        moneylab.font=[UIFont systemFontOfSize:14];
        moneylab.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:moneylab];
    }
    return self;
}

- (NSString *)timeCreatedCut:(NSString *)time {
    if (time.length > 10) {
        return [time substringToIndex:10];
    }
    else {
        return time;
    }
}

-(void)setpaycostData:(PaycostModel *)payDic
{
    NSLog(@"payDic.statusCN=%@",payDic.statusCN);
    if ([payDic.type isEqualToString:@"S"]) {
        iconImgV.image=[UIImage imageNamed:@"shuifei"];
        namelab.text=@"水费";
        timelab.text = [self timeCreatedCut:payDic.dateCreated];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.saleAmount];
        //statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
    }
    else if ([payDic.type isEqualToString:@"D"]) {
        iconImgV.image=[UIImage imageNamed:@"dianfei"];
        namelab.text=@"电费";
        timelab.text=[self timeCreatedCut:payDic.dateCreated];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.saleAmount];
        //statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
        
    } 
    else if ([payDic.type isEqualToString:@"M"])
    {
        iconImgV.image=[UIImage imageNamed:@"meiqifei"];
        namelab.text=@"燃气费";
        timelab.text=[self timeCreatedCut:payDic.dateUpdated];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.saleAmount];
        //statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
    }

    else if ([payDic.type isEqualToString:@"W"])
    {
        iconImgV.image=[UIImage imageNamed:@"wuyefei"];
        namelab.text=@"物业费";
        timelab.text=[self timeCreatedCut:payDic.dateCreated];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.saleAmount];
        //        statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
    }

    else if ([payDic.type isEqualToString:@"T"])
    {
        iconImgV.image=[UIImage imageNamed:@"tingche"];
        namelab.text=@"停车费";
        timelab.text=[self timeCreatedCut:payDic.dateCreated];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.saleAmount];
        //statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
    }

    else if ([payDic.type isEqualToString:@"H"])
    {
        iconImgV.image=[UIImage imageNamed:@"huafei"];
        namelab.text=@"话费";
        timelab.text=[self timeCreatedCut:payDic.createTime];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.saleAmount];
        //statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
    }

    else if ([payDic.type isEqualToString:@"J"])
    {
        iconImgV.image=[UIImage imageNamed:@"jiaotong"];
        namelab.text=@"交通罚款费";
        timelab.text=[self timeCreatedCut:payDic.createTime];
        moneylab.text=[NSString stringWithFormat:@"%@ 元",payDic.count];
        //statuslab.text=[PaycostHandler payStatusForSdmStatus:payDic.sdmStatus];
        statuslab.text=payDic.statusCN;
    }
    

}

@end
