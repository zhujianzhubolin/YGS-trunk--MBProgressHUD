//
//  QueryCommentHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "QueryCommentModel.h"

@interface QueryCommentHandler : BaseHandler
@property (nonatomic,copy)NSString *currentPage;
@property (nonatomic,copy)NSString *pageCount;
@property (nonatomic, assign) BOOL isUserCommentUpdate;
@property (nonatomic,strong)NSMutableArray *huatipinglunArr;

@property (nonatomic,copy)NSString *topicCurrentPage;
@property (nonatomic,copy)NSString *topicPageCount;
@property (nonatomic,strong)NSMutableArray *topicArr;

@property (nonatomic,copy)NSString *myRentalPage;
@property (nonatomic,copy)NSString *myRentalCount;
@property (nonatomic, assign) BOOL ismyRentalCommentUpdate;
@property (nonatomic,strong)NSMutableArray *myRentalDataArr;

@property (nonatomic,copy)NSString *myBadyPage;
@property (nonatomic,copy)NSString *myBadyCount;
@property (nonatomic, assign) BOOL ismyBadyCommentUpdate;
@property (nonatomic,strong)NSMutableArray *myBadyDataArr;


//查询我的评论
-(void)queryComment:(QueryCommentModel *)queryM
            success:(SuccessBlock)success
             failed:(FailedBlock)failed
           isHeader:(BOOL)isheader;

//查询话题评论
-(void)queryTopicComment:(QueryCommentModel *)queryM
                 success:(SuccessBlock)success
                  failed:(FailedBlock)failed
                isHeader:(BOOL)isheader;

//查询我的宝贝评论
-(void)queryBadyComment:(QueryCommentModel *)queryM
            success:(SuccessBlock)success
             failed:(FailedBlock)failed
           isHeader:(BOOL)isheader;

//查询租售信息的评论
-(void)queryRentalComment:(QueryCommentModel *)queryM
                success:(SuccessBlock)success
                 failed:(FailedBlock)failed
               isHeader:(BOOL)isheader;

//查询建议回复
-(void)queryAdvicecomment:(QueryCommentModel *)queryM
                  success:(SuccessBlock)success
                   failed:(FailedBlock)failed;












@end
