//
//  OrderClickCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "OrderClickCell.h"

@implementation OrderClickCell
{
    __weak IBOutlet UILabel *orderNum;
    
    NSString * senOrderNum;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)gotoOrderDetail:(UIButton *)sender {
    
    if (_orderDelegate && [_orderDelegate respondsToSelector:@selector(lookOrderDetail:)]) {
        [_orderDelegate lookOrderDetail:senOrderNum];
    }
}

- (void)setCellData:(id)data{
    senOrderNum = [NSString stringWithFormat:@"%@",data[@"orderNo"]];
    orderNum.text = [NSString stringWithFormat:@"%@",data[@"orderNo"]];
}

@end
