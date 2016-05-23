//
//  UILabel+wrapper.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/25.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (wrapper)

+ (nonnull UILabel *)addWithFrame:(CGRect)rect
                        textColor:(nullable UIColor *)textColor
                         fontSize:(CGFloat)fontSize
                             text:(nullable NSString *)text;

+ (nonnull UILabel *)addlable:(nonnull UIView *)view
                        frame:(CGRect)frame
                         text:(nullable NSString *)text
                    textcolor:(nullable UIColor *)txtcolor;

@end
