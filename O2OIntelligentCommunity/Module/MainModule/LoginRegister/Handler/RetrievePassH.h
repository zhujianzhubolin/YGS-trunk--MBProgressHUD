//
//  RetrievePassH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RegisterHandler.h"
#import "RetrieveEntity.h"
#import "UpdatePassEntity.h"    

@interface RetrievePassH : RegisterHandler
/**
 *  用户重置密码业务逻辑处理
 *
 *  @param user
 *  @param success
 *  @param failed
 */
//重置密码确认
- (void)excuteRetrievePassTaskWithUser:(RetrieveEntity *)user
                                success:(SuccessBlock)success
                                 failed:(FailedBlock)failed;
//修改密码
- (void)excuteUpdatePassTaskWithUser:(UpdatePassEntity *)user
                               success:(SuccessBlock)success
                                failed:(FailedBlock)failed;
@end
