//
//  OrderGoodslistCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "OrderGoodslistCell.h"
#import <UIImageView+AFNetworking.h>
@implementation OrderGoodslistCell
{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *goodsName;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCellData:(id)data{

    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"goodslist"][@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    goodsName.text = [NSString stringWithFormat:@"%@",data[@"name"]];
}

@end
