//
//  DeleteDingdanHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "DeleteDingdanModel.h"

@interface DeleteDingdanHandler : BaseHandler
//删除订单
-(void)DeleteDingDan:(DeleteDingdanModel *)deleteM success:(SuccessBlock)success failed:(FailedBlock)failed;

//确认收货
-(void)AffirmConsignee:(DeleteDingdanModel *)deleteM success:(SuccessBlock)success failed:(FailedBlock)failed;
@end
