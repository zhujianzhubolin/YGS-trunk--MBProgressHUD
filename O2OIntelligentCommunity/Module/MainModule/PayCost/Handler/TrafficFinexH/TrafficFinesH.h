//
//  TrafficFinesH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "TrafficOrderE.h"
#import "TrafficCarBitsE.h"

@interface TrafficFinesH : BaseHandler

//查询对应缴费省所包含的市
- (void)ZJ_requestForGetTrafficProvinceIncludeCitiesWithPara:(id)paraDic
                                                     success:(SuccessBlock)success
                                                      failed:(FailedBlock)failed;

//查询所有可缴费省
- (void)ZJ_requestForGetAllTrafficProvinceWithsuccess:(SuccessBlock)success
                                               failed:(FailedBlock)failed;

//获取cityID查询当前缴费的省市
- (void)ZJ_requestForGetCurrentTrafficCityWithPara:(id)paraDic
                                           success:(SuccessBlock)success
                                            failed:(FailedBlock)failed;

//获取罚款信息
- (void)executeGetTrafficFinesTaskWithUser:(TrafficOrderE *)trafficE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed;

//获取车架号和发动机号的位数
- (void)executeGetTrafficCarBitsTaskWithUser:(TrafficCarBitsE *)trafficBitsE
                                     success:(SuccessBlock)success
                                      failed:(FailedBlock)failed;
@end
