//
//  ZJFormCollectionCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/2/17.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJFormCollectionCell.h"

@implementation ZJFormCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.showImgView) {
            self.showImgView = [[UIImageView alloc] initWithFrame:self.bounds];
            self.showImgView.contentMode = UIViewContentModeScaleAspectFill;
            self.showImgView.clipsToBounds = YES;
            [self addSubview:self.showImgView];
        }
    }
    return self;
}

@end
