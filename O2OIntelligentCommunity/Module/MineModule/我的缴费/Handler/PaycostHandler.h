//
//  PaycostHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "PaycostModel.h"

@interface PaycostHandler : BaseHandler
//缴费
-(void)Paycost:(PaycostModel *)pay success:(SuccessBlock)success failed:(FailedBlock)failed;


@end
