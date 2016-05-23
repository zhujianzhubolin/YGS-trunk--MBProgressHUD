//
//  DiscussH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "CommentEntity.h"

@interface CommentHandle : BaseHandler
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, strong) NSMutableArray *commentArr;
@property (nonatomic, assign) BOOL isNeedRefresh;

- (void)executeCommentTaskWithUser:(CommentEntity *)commentE success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isHeader;
- (void)executeDeleteCommentTaskWithUser:(NSString *)idID success:(SuccessBlock)success failed:(FailedBlock)failed;
- (void)executeSubmmitCommentTaskWithUser:(CommentEntity *)commentE success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
