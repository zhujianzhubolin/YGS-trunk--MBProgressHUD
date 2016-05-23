//
//  CommunityCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingingXQModel.h"

@interface CommunityCell : UICollectionViewCell

@property (strong ,nonatomic)UIImageView *cellImg;
@property (strong ,nonatomic)UIButton    *deleteBut;
@property (strong ,nonatomic)UILabel     *textLabe;
@property (strong ,nonatomic)UIImageView *bangdingimg;
@property (strong ,nonatomic)UIImageView *defaultXqImgV;


-(void)reloadCellData:(BingingXQModel *)model;

@end
