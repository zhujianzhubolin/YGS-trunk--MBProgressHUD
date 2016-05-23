//
//  EvaluateDeletCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "EvaluateDeletCell.h"

@implementation EvaluateDeletCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _EvaluateBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _EvaluateBut.frame =CGRectMake(IPHONE_WIDTH- 90, 10, 80, 30);
        [_EvaluateBut setTitle:@"评价订单" forState:UIControlStateNormal];
        [_EvaluateBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _EvaluateBut.backgroundColor =[AppUtils colorWithHexString:@"fa6900"];
        [_EvaluateBut.layer setMasksToBounds:YES];
        [_EvaluateBut.layer setCornerRadius:5];
        [self addSubview:_EvaluateBut];
        
        _DeleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _DeleteBut.frame = CGRectMake(IPHONE_WIDTH -180, 10, 80, 30);
        [_DeleteBut setTitle:@"删除订单" forState:UIControlStateNormal];
        [_DeleteBut setTitleColor:[AppUtils colorWithHexString:@"20AADB"] forState:UIControlStateNormal];
        [_DeleteBut.layer setMasksToBounds:YES];
        [_DeleteBut.layer setCornerRadius:5];
        [_DeleteBut.layer setBorderWidth:1];
        [_DeleteBut.layer setBorderColor:[AppUtils colorWithHexString:@"20AADB"].CGColor];
        [self addSubview:_DeleteBut];

    }
    return self;
}

@end
