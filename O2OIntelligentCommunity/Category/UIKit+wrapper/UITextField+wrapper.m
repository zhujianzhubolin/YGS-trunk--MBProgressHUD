//
//  UITextField+wrapper.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "UITextField+wrapper.h"

@implementation UITextField (wrapper)
+ (UIView *)addSideViewWithfillImg:(UIImage *)img
{
    CGFloat interval = 5;
    UIView *fillView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25 + interval, 25)];
    UIImageView *fillImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fillView.frame.size.width - interval, fillView.frame.size.height)];
    [fillView addSubview:fillImgView];
    fillImgView.image = img;
    return fillView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
