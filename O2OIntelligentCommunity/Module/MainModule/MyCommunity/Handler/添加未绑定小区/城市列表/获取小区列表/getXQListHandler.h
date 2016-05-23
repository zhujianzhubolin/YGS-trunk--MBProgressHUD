//
//  getXQListHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "getXQListModel.h"

@interface getXQListHandler : BaseHandler

-(void)postXQList:(getXQListModel *)postXQ success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
