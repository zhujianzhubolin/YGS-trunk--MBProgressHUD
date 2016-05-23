//
//  ImgCollectionCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ImgCollectionCell.h"

@implementation ImgCollectionCell

- (void)awakeFromNib {
    self.imgButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgButton.imageView.clipsToBounds = YES;
}

@end
