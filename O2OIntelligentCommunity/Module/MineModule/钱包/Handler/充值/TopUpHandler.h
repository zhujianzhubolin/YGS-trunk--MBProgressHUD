//
//  TopUpHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "TopUpModel.h"

@interface TopUpHandler : BaseHandler

//充值
-(void)topupRequst:(TopUpModel *)topup success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
