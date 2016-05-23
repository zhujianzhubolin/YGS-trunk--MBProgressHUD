//
//  OpinionFeedbackHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "OpinionFeedbackModel.h"

@interface OpinionFeedbackHandler : BaseHandler
//意见反馈
-(void)opinionfeedback:(OpinionFeedbackModel *)opfbM success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
