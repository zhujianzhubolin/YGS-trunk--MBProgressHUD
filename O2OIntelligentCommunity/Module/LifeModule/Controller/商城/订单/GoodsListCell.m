//
//  GoodsListCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/18.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "GoodsListCell.h"
#import <UIImageView+AFNetworking.h>

@implementation GoodsListCell

{

    __weak IBOutlet UIImageView *headImage;
    
    __weak IBOutlet UILabel *name;
    
    __weak IBOutlet UILabel *price;
    
    __weak IBOutlet UILabel *number;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//商城订单显示
- (void)setCellData:(id)data{
    
    NSLog(@"Cell 里面的数据>>>%@",data);
    
    NSLog(@"cell data>>>>%@",data[@"goodslist"][@"entity"][@"img"]);
    NSLog(@"cell data>>>>%@",data[@"goodslist"][@"entity"][@"name"]);
    NSLog(@"cell data>>>>%@",data[@"goodslist"][@"entity"][@"price"]);
    NSLog(@"cell data>>>>%@",data[@"addNumber"]);

    NSString * myname = [NSString stringWithFormat:@"%@",data[@"name"]];
    NSString * myprice = [NSString stringWithFormat:@"%@元",data[@"goodslist"][@"entity"][@"price"]];
    NSString * num = [NSString stringWithFormat:@"%@",data[@"addNumber"]];
    NSString * myimage = [NSString stringWithFormat:@"%@",data[@"goodslist"][@"entity"][@"img"]];
    
    [headImage setImageWithURL:[NSURL URLWithString:myimage] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    name.text = [NSString stringWithFormat:@"%@",myname];
    price.text = [NSString stringWithFormat:@"%@",myprice];
    number.text = [NSString stringWithFormat:@"x%@",num];

}

//团购订单数据显示
- (void)TGCellData:(TGGoodsModel *)model{
    
    [headImage setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    
    number.text = [NSString stringWithFormat:@"x%@件",model.goodsNum];
    
    name.text = [NSString stringWithFormat:@"%@",model.name];
    
    price.text = [NSString stringWithFormat:@"%@元",model.price];
}

@end
