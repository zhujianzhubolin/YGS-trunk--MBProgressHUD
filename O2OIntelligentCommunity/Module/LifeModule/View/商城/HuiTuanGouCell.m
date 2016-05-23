//
//  HuiTuanGouCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "HuiTuanGouCell.h"

@implementation HuiTuanGouCell

{
    
    __weak IBOutlet UILabel *desc;
    __weak IBOutlet UILabel *shopName;
    __weak IBOutlet UILabel *oldPrice;
    __weak IBOutlet UILabel *newPrice;
    __weak IBOutlet UIButton *lijigoumai;
    
}

- (void)awakeFromNib {
    
    lijigoumai.layer.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSDictionary *)dict{

//    NSLog(@"商品cell里面的数据>>>>>%@",dict);
    
    if ([dict[@"productDescription"] isEqual:[NSNull null]]) {
        desc.text = @"暂无商品描述";
    }else{
        desc.text = [NSString stringWithFormat:@"%@",dict[@"productDescription"]];
    }
    
    if ([dict[@"storeName"] isEqual:[NSNull null]]) {
        shopName.text = @"暂无商家名称";
    }else{
        shopName.text = [NSString stringWithFormat:@"%@",dict[@"storeName"]];
    }
    
    if ([dict[@"marketPrice"] isEqual:[NSNull null]]) {
        oldPrice.text = @"0";
    }else{
        oldPrice.text = [NSString stringWithFormat:@"￥%@",dict[@"marketPrice"]];
    }
    
    if ([dict[@"salePrice"] isEqual:[NSNull null]]) {
        newPrice.text = @"0";
    }else{
        newPrice.text = [NSString stringWithFormat:@"￥%@",dict[@"salePrice"]];
    }
    
    
    
}


- (IBAction)gouxuan:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}


@end
