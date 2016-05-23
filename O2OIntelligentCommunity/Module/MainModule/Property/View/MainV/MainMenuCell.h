//
//  MenuCell.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//


typedef void (^MenuCellClickBlock)(NSUInteger buttonTag);

#import <UIKit/UIKit.h>

@interface MainMenuCell : UITableViewCell
@property (nonatomic, copy) MenuCellClickBlock aCellClick;
@end
