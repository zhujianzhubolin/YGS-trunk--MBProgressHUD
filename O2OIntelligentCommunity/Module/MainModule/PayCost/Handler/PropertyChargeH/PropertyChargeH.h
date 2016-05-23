//
//  PropertyChargeH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "PropertyChargeE.h"

@interface PropertyChargeH : BaseHandler

//获取物业每月交费订单
- (void)executeGetPropertyOrderTaskWithUser:(PropertyChargeE *)phoneE
                               success:(SuccessBlock)success
                                failed:(FailedBlock)failed;
//获取停车缴费车库类型

- (void)executeGetParkingTypeTaskWithUser:(PropertyChargeE *)parkingE
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed;

#ifdef SmartComJYZX
//获取物业费订单
- (void)requestForPropertyCostsOrdersWithPara:(NSDictionary *)paraDic
                                      success:(SuccessBlock)success
                                       failed:(FailedBlock)failed;
#elif SmartComYGS

#else

#endif


@end
