//
//  BuyDeleteCheckCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BuyDeleteCheckCell.h"

@implementation BuyDeleteCheckCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.paymentBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.paymentBut.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
        [self.paymentBut setTitle:@"立即付款" forState:UIControlStateNormal];
        [self.paymentBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.paymentBut.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
        [self.paymentBut.layer setMasksToBounds:YES];
        [self.paymentBut.layer setCornerRadius:5];
        
        [self addSubview:self.paymentBut];
        
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
        [_cancelBut setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelBut setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
        [_cancelBut.layer setMasksToBounds:YES];
        [_cancelBut.layer setCornerRadius:5];
        [_cancelBut.layer setBorderWidth:1];
        [_cancelBut.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
        [self addSubview:_cancelBut];

    }
    return self;
}

@end
