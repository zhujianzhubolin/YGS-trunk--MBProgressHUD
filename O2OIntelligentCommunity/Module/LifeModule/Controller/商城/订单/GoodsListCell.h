//
//  GoodsListCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/18.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGoodsModel.h"

@interface GoodsListCell : UITableViewCell

//商城订单
- (void)setCellData:(id)data;

//团购订单
- (void)TGCellData:(TGGoodsModel *)model;

@end
