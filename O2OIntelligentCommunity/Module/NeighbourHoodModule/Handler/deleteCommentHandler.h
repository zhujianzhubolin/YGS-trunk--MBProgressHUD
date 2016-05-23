//
//  deleteCommentHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "DeleteCommentModel.h"

@interface deleteCommentHandler : BaseHandler
//删除话题评论
-(void)deleteComment:(DeleteCommentModel *)deleteC success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
