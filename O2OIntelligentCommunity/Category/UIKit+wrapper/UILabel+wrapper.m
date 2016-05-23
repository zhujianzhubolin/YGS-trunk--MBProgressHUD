//
//  UILabel+wrapper.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/25.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "UILabel+wrapper.h"

@implementation UILabel (wrapper)

+ (nonnull UILabel *)addWithFrame:(CGRect)rect
                        textColor:(nullable UIColor *)textColor
                         fontSize:(CGFloat)fontSize
                             text:(nullable NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+ (nonnull UILabel *)addlable:(nonnull UIView *)view
                        frame:(CGRect)frame
                         text:(nullable NSString *)text
                    textcolor:(nullable UIColor *)txtcolor {
    UILabel * lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = txtcolor;
    lable.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lable];
    return lable;
}

@end
