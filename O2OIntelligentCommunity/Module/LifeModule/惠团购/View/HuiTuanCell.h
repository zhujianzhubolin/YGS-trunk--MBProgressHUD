//
//  HuiTuanCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGoodsModel.h"

typedef void(^HuiTuanBuyNow)(TGGoodsModel * model);

@interface HuiTuanCell : UITableViewCell

@property(nonatomic,strong) HuiTuanBuyNow buyNow;

- (void)setData:(id)mydata distance:(NSString *)distance;

- (void)TGGoodsCellData:(TGGoodsModel *)model;


//团购搜索专用
- (void)TGGoodsCellData:(TGGoodsModel *)model withKeyWords:(NSString *)keyWords;

@end
