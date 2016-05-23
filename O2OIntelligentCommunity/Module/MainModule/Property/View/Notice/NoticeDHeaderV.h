//
//  NoticeDHeaderView.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeEntity.h"    

@protocol NoticeDHeaderVDelegate <NSObject>

- (void)commentClickNextVC;

@end

@interface NoticeDHeaderV : UIView

@property (nonatomic, weak) id<NoticeDHeaderVDelegate>delegate;
@property (nonatomic, assign) CGFloat contentHeight;
- (void)reloadHeaderVDataWithModel:(NoticeEntity *)noticeE;
- (void)refreshCommentNum:(NSUInteger)commentNum;

@end
