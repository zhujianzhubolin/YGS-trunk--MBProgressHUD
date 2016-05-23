//
//  SwitchXQHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "BingingXQModel.h"

@interface SwitchXQHandler : BaseHandler

//切换小区
- (void)switchXQH:(BingingXQModel *)switchXq
               success:(SuccessBlock)success
                failed:(FailedBlock)failed;

@end
