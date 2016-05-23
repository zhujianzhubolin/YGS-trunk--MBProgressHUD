//
//  TableViewCellThree.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CellThreeDelegate <NSObject>

- (void)cellClick:(id)data;

@end


@protocol TuanGou <NSObject>

- (void)clickMore;

@end

@interface TableViewCellThree : UITableViewCell

@property (nonatomic, weak) id<CellThreeDelegate>delegate;

@property(nonatomic,weak) id<TuanGou> goudelegate;

- (void)setTuaData:(id)data;

@end
