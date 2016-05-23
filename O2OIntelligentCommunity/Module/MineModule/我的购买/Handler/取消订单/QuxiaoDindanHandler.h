//
//  QuxiaoDindanHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "QuXiaoDindanModel.h"

@interface QuxiaoDindanHandler : BaseHandler
//取消订单
-(void)CancelDindan:(QuXiaoDindanModel *)canceM success:(SuccessBlock)success failed:(FailedBlock)failed;
@end
