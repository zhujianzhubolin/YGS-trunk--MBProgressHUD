//
//  QiangGouCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "QiangGouCell.h"

@implementation QiangGouCell

{
    __weak IBOutlet UILabel *priceLable;
    __weak IBOutlet UIImageView *productImage;
    __weak IBOutlet UILabel *marketPriceLable;
    __weak IBOutlet UILabel *nameLable;
    
    NSString * goodsID;
    
    NSDictionary * dict;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelData:(id)model{

    NSLog(@"cellModel>>>>>>%@",model);
    dict = (NSDictionary *)model;
    goodsID = model[@"id"];
    [productImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model[@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    priceLable.text = [NSString stringWithFormat:@"￥%@",model[@"price"]];
    marketPriceLable.text =[NSString stringWithFormat:@"￥%@", model[@"market_price"]];
    nameLable.text = model[@"name"];
}
- (IBAction)ToGoodsDetail:(UIButton *)sender {
    
//    NSLog(@"%@",dict);    
    NSDictionary * goodslist = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"addNumber",dict,@"goodslist",dict[@"id"],@"id",dict[@"name"],@"name",dict[@"storeId"],@"storeId",@"YES",@"isSelect",nil];
    
    NSMutableArray * shoparray =[NSMutableArray array];
    [shoparray addObject:goodslist];
    
    
    NSDictionary * shoplist = [NSDictionary dictionaryWithObjectsAndKeys:shoparray,@"goodsList",dict[@"storeId"],@"storeId", nil];
    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:shoplist];
    
    NSLog(@"%@",array);
    
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(toDetail:)]) {
        
        [_cellDelegate toDetail:array];
        
    }
    
}

@end
