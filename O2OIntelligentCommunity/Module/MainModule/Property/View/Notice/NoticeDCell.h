//
//  NoticeDCell.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef void (^DeleteCommentBlock)(NSString *idID);

#import <UIKit/UIKit.h>
#import "CommentEntity.h"

@interface NoticeDCell : UITableViewCell <UIAlertViewDelegate>
@property (nonatomic, strong) DeleteCommentBlock deleteBlock;
@property (nonatomic, assign) CGFloat contentHeight;
- (void)reloadDataWithModel:(CommentEntity *)entity withNum:(NSUInteger)num; //num为评论的顺序，最早的为一楼
+ (CGFloat)contentHeightForEntity:(CommentEntity *)entity;
@end
