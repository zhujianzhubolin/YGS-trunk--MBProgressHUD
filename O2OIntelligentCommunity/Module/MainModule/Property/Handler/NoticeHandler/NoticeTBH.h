//
//  NoticeTBH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "NoticeEntity.h"

@interface NoticeTBH : BaseHandler
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, strong) NSMutableArray *noticeInfoArr;
@property (nonatomic, assign) BOOL isNoticeNeedUpdate;

- (void)executeNoticeContentTaskWithUser:(NoticeEntity *)noticeE
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed
                                isHeader:(BOOL)isHeader;

@end
