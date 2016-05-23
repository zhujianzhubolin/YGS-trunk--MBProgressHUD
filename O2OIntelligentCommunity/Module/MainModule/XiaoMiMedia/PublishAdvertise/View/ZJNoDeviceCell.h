//
//  ZJNoDeviceCell.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/7.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
extern NSString *const notiForComChange;

#import <UIKit/UIKit.h>
#import "CommunityViewCotroller.h"

@interface ZJNoDeviceCell : UITableViewCell

- (void)updateUIForComInfo:(BingingXQModel *)comM;
- (void)updateUIForXiaoMiJiQiNum:(NSUInteger)jiqiNum;

@end
