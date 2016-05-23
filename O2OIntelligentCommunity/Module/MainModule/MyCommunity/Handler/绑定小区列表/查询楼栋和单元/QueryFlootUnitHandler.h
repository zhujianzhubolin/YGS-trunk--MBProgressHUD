//
//  QueryFlootUnitHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "QueryFlootUnitModel.h"

@interface QueryFlootUnitHandler : BaseHandler

//根据小区查询楼栋或者单元
- (void)QueryFlootUnit:(QueryFlootUnitModel *)queryflootunit
               success:(SuccessBlock)success
                failed:(FailedBlock)failed;
@end
