//
//  QiangGouCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@protocol QianggouDetail <NSObject>

- (void)toDetail:(id)goodsID;

@end

@interface QiangGouCell : UITableViewCell

@property(nonatomic,weak) id<QianggouDetail>cellDelegate;

- (void)setModelData:(id)model;

@end
