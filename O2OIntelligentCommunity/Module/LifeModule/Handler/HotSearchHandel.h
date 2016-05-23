//
//  HotSearchHandel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/8.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "HotSearchModel.h"

@interface HotSearchHandel : BaseHandler


//获取热搜标签
- (void)getHotSearch:(HotSearchModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
