//
//  ShopGoodsCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/4.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "ShopGoodsCell.h"

@implementation ShopGoodsCell

{
    __weak IBOutlet UIImageView *hongdian;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UILabel *number;
    __weak IBOutlet UILabel *title;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//商品数量加
- (IBAction)goodsAdd:(UIButton *)sender {
    
    self.goodsAdd(hongdian);
}

//商品数量减
- (IBAction)goodsJian:(UIButton *)sender {
    
    self.goodsjian(hongdian);
    
}

@end
