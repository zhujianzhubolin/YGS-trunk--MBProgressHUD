//
//  ZYTextField.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ZYTextField.h"

@implementation ZYTextField

-(id)initWithFrame:(CGRect)frame Icon:(UIImageView *)icon
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.leftView = icon;
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    return  self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}
@end
