//
//  CollectionShangpinCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@interface CollectionShangpinCell : UITableViewCell

@property (strong,nonatomic)UIImageView *goodsImg;
@property (strong,nonatomic)UILabel     *nameLabe;
@property (strong,nonatomic)UILabel     *miaosuLabe;
@property (strong,nonatomic)UILabel     *spTypeLabe;
@property (strong,nonatomic)UILabel     *spPriceLale;
@property (strong,nonatomic)UIButton    *immediatelyBut;
@property (strong,nonatomic)UIImageView *xianimg;

-(void)setcellDic:(CollectionModel *)dicM;
@end
