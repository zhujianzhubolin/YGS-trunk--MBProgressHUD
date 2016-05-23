//
//  ChangePostionButton.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ChangePostionButton.h"

@implementation ChangePostionButton
{
    ButtonInternalPositionType currentPostionType;
    CGFloat currentSpacing;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    ////根据文字和按钮的X点的交换，实现文字和图片位置的交换
    if (self.titleLabel.text.length > 0 && self.imageView.image != nil && currentSpacing >= 0) {
        switch (currentPostionType) {
            case ButtonInternalLabelPositionLeft: {
                CGRect titleF = self.titleLabel.frame;
                CGRect imageF = self.imageView.frame;
                titleF.origin.x = (self.frame.size.width - titleF.size.width - imageF.size.width - 2) / 2;
                self.titleLabel.frame = titleF;
                imageF.origin.x = titleF.size.width + titleF.origin.x + currentSpacing;
                self.imageView.frame = imageF;
            }
                break;
            case ButtonInternalLabelPositionTop: {
                CGRect titleF = self.titleLabel.frame;
                CGRect imageF = self.imageView.frame;
                titleF.size.width = self.frame.size.width;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                titleF.origin.x = (self.frame.size.width - titleF.size.width) / 2;
                titleF.origin.y = (self.frame.size.height - titleF.size.height - imageF.size.height) / 2;
                self.titleLabel.frame = titleF;
                imageF.origin.x = (self.frame.size.width - imageF.size.width) / 2;
                imageF.origin.y = titleF.origin.y + titleF.size.height + currentSpacing;
                self.imageView.frame = imageF;

            }
                break;
            case ButtonInternalLabelPositionButtom: {
                CGRect titleF = self.titleLabel.frame;
                CGRect imageF = self.imageView.frame;
                titleF.size.width = self.frame.size.width;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                imageF.origin.x = (self.frame.size.width - imageF.size.width) / 2;
                imageF.origin.y = (self.frame.size.height - titleF.size.height - imageF.size.height) / 2;
                self.imageView.frame = imageF;
                
                titleF.origin.x = (self.frame.size.width - titleF.size.width) / 2;
                titleF.origin.y = imageF.origin.y + imageF.size.height + currentSpacing;
                self.titleLabel.frame = titleF;
            }
                break;
            case ButtonInternalLabelPositionRight: {
                CGRect titleF = self.titleLabel.frame;
                CGRect imageF = self.imageView.frame;
                titleF.origin.x = imageF.origin.x +imageF.size.width + currentSpacing;
                self.titleLabel.frame = titleF;
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)setInternalPositionType:(ButtonInternalPositionType)positionType spacing:(CGFloat)spacing {
    currentPostionType = positionType;
    currentSpacing = spacing;
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
