//
//  KaiQiangCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreQiangGou <NSObject>

- (void)getMoreQiangGou;

@end

@interface KaiQiangCell : UITableViewCell

@property (nonatomic,weak) id<MoreQiangGou> qianggouDelegate;

- (void)SetEndTime:(NSString *)endTime;

@end
