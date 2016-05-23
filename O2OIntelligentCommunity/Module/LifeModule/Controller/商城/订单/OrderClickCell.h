//
//  OrderClickCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeeOrderDetail <NSObject>

- (void)lookOrderDetail:(NSString *)orderStr;

@end

@interface OrderClickCell : UITableViewCell

@property(nonatomic,weak) id<SeeOrderDetail>orderDelegate;

- (void)setCellData:(id)data;

@end
