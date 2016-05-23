//
//  SellerCellGoods.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GouWuCheClickBlock)(CGPoint gouWuChePoint);

@protocol ChangeCarNum <NSObject>

- (void)setCarNum;

@end

@interface SellerCellGoods : UITableViewCell

@property (nonatomic, strong) GouWuCheClickBlock cellClickBlock;

@property(nonatomic,weak) id<ChangeCarNum>numdel;

- (void)setGoodsData:(id)mydata;

@end
