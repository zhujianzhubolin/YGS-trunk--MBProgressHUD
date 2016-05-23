//
//  RegisterHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "RegisterEntity.h"

@interface RegisterHandler : BaseHandler
/**
 *  用户注册业务逻辑处理
 *
 *  @param user
 *  @param success
 *  @param failed
 */

- (void)excuteRegisterTaskWithUser:(RegisterEntity *)user
                           success:(SuccessBlock)success
                            failed:(FailedBlock)failed;

@end
