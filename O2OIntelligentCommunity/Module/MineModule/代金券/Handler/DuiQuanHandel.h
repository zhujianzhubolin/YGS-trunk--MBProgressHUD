//
//  DuiQuanHandel.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/2.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "DuiQuanModel.h"

@interface DuiQuanHandel : BaseHandler
//兑券
- (void)duiquanRequest:(DuiQuanModel*)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
