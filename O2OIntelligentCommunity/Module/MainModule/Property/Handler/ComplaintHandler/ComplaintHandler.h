//
//  ComplainHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ComplaintEntity.h"
#import "ComplaintSaveE.h"
#import "FilePostE.h"

@interface ComplaintHandler : BaseHandler

/**
 *  保修／投诉业务逻辑处理
 *
 *  @param complaint
 *  @param success
 *  @param failed
 */

- (void)executeGetTypeTaskWithUser:(ComplaintEntity *)complaint
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed;

- (void)executeSaveInfoTaskWithUser:(ComplaintSaveE *)complaint
                           success:(SuccessBlock)success
                            failed:(FailedBlock)failed;

- (void)excuteImgPostTask:(FilePostE *)imgPostE
                  success:(SuccessBlock)success
                   failed:(FailedBlock)failed;

@end
