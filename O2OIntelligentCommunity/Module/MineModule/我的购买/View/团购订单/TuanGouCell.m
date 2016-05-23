//
//  TuanGouCell.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TuanGouCell.h"
#import <UIImageView+AFNetworking.h>

@implementation TuanGouCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTaunGouCellDeta:(MineBuyGoodM *)tuangouM
{
    MineBuyShiGoodM *tuanGouM = (MineBuyShiGoodM *)tuangouM;
    [_headImgV setImageWithURL:[NSURL URLWithString:tuanGouM.imgPath] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    _NameLab.text= tuanGouM.productName;
    _priceLab.textColor=[AppUtils colorWithHexString:@"fa6900"];
    _priceLab.text = [NSString stringWithFormat:@"%0.2f 元",[tuanGouM.unitDeductedPrice floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
