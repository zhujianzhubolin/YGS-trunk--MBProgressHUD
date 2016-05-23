//
//  AdCollectionCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AdCollectionCell.h"
@implementation AdCollectionCell

- (void)awakeFromNib {
    self.imgV.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

@end
