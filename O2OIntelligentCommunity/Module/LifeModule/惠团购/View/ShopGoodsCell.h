//
//  ShopGoodsCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/4.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopGoodsCell : UITableViewCell

@property(nonatomic,copy) void (^goodsAdd)(UIImageView * imageView);

@property(nonatomic,copy) void (^goodsjian)(UIImageView * imageView);


@end
