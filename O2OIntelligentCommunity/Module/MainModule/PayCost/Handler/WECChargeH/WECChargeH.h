//
//  WECChargeH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "WECChargeE.h"

@interface WECChargeH : BaseHandler

//获取缴费单位
- (void)executeChaXunShoufeiDanWeiTaskWithUser:(WECChargeE *)chargeE
                                       success:(SuccessBlock)success
                                        failed:(FailedBlock)failed;

//查询缴费订单
- (void)executeChaXunShoufeiOrderTaskWithUser:(WECChargeE *)chargeE
                                       success:(SuccessBlock)success
                                        failed:(FailedBlock)failed;


@end
