//
//  ZYXiaoMiPaySuccessCell.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/6.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
#define M_PAY_TIME_SIZE  14
#import "ZYXiaoMiPaySuccessCell.h"

@implementation ZYXiaoMiPaySuccessCell

- (void)awakeFromNib {
    // Initialization code
    _imgV.image=[UIImage imageNamed:@"gouda"];
}

-(void)celltext:(NSString *)str
{

    NSMutableAttributedString *allContentStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"成功支付：%@ 元",str]];
    
     _MoneyLab.attributedText=[self resetAttributedStr:allContentStr textLength:str.length];

    
}

- (NSMutableAttributedString *)resetAttributedStr:(NSMutableAttributedString *)str
                                       textLength:(NSUInteger)textlength{
    
    NSRange numRange = NSMakeRange(5,textlength);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:numRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:M_PAY_TIME_SIZE] range:numRange];
    
    NSRange strRange = NSMakeRange(0 ,5);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:M_PAY_TIME_SIZE] range:strRange];
    
    return str;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
