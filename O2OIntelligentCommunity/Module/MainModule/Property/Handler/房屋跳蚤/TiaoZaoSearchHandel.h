//
//  TiaoZaoSearchHandel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "TiaoZaoSearch.h"

@interface TiaoZaoSearchHandel : BaseHandler

//跳蚤搜索
- (void)TiaoZaoSearch:(TiaoZaoSearch *)model success:(SuccessBlock)success failed:(FailedBlock)failed;


//房屋搜索
- (void)HouseSearch:(TiaoZaoSearch *)model success:(SuccessBlock)success failed:(FailedBlock)failed;


@end
