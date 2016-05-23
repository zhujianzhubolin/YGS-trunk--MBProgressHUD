//
//  SearchOrderDetailHandel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "OrderSearchModel.h"

@interface SearchOrderDetailHandel : BaseHandler

- (void)SearchOrderDetail:(OrderSearchModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
