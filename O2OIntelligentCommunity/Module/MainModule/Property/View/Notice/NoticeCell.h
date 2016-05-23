//
//  NoticeCell.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeEntity.h"

@interface NoticeCell : UITableViewCell

- (void)reloadDataWithModel:(NoticeEntity *)entity;
@end
