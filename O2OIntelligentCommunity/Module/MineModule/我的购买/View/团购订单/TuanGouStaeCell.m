//
//  TuanGouStaeCell.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TuanGouStaeCell.h"

@implementation TuanGouStaeCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setStateData:(MineBuyShopsM *)stateM
{
    _headImgV.image=[UIImage imageNamed:[self StateImgType:stateM.statusTotal]];
    
    _stateLabe.text = [self StateType:stateM.statusTotal];
    
    NSString *dataStr=[NSString stringWithFormat:@"%0.2f",[stateM.totalPayAmount floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额：%@ 元",dataStr]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(3, dataStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, dataStr.length)];
    _detailsLab.attributedText=str;

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
        Str =@"已评价";
    }
    else if ([stringType isEqualToString:@"0172"])
    {
        Str =@"退款驳回";
    }
    else if ([stringType isEqualToString:@"0173"])
    {
        Str =@"订单退款中";
    }
    else if ([stringType isEqualToString:@"0174"])
    {
        Str =@"订单退款完成";
    }
    else if ([stringType isEqualToString:@"0185"])
    {
         Str =@"订单退款中";
    }

    return Str;
}

-(NSString *)StateImgType:(NSString *)stringType
{
    NSString *Str;
    if ([stringType isEqualToString:@"0130"])
    {
        Str=@"ZYdaifukuan";
    }
    else if ([stringType isEqualToString:@"0131"])
    {
        Str= @"ZYyiquxiao";
    }
    else if ([stringType isEqualToString:@"0120"])
    {
        Str= @"ZYkeshiyong";
    }
    else if ([stringType isEqualToString:@"0132"])
    {
        Str= @"ZYyiquxiao";
    }
    else if([stringType isEqualToString:@"0180"])
    {
        Str= @"ZYdaipingjia";
    }
    else if ([stringType isEqualToString:@"0182"])
    {
        Str =@"ZYyipingjia";
    }
    else if ([stringType isEqualToString:@"0172"])
    {
        Str =@"ZYtuikuanBoHui";
    }
    else if ([stringType isEqualToString:@"0173"])
    {
        Str =@"ZYtuiKuanZhong";
    }
    else if ([stringType isEqualToString:@"0173"])
    {
        Str =@"ZYyituikuan";
    }
    else if ([stringType isEqualToString:@"0185"])
    {
        Str =@"ZYtuiKuanZhong";
    }

    return Str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
