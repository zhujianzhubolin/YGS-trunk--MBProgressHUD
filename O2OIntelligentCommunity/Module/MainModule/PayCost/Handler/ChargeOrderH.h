//
//  PhoneChargeH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "PhoneChargeE.h"
#import "PropertyChargeE.h"
#import "ChargeOrderE.h"

@interface ChargeOrderH : BaseHandler

//话费充值
- (void)executePhoneChargeTaskWithOrder:(ChargeOrderE *)orderE
                                payType:(PayType)payType
                                success:(SuccessBlock)success
                                 failed:(FailedBlock)failed;
//缴物业费
- (void)executePropertyChargeTaskWithArr:(NSArray *)orderArr
                                 payType:(PayType)payType
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed;
//缴停车费
- (void)executeParkChargeTaskWithOder:(ChargeOrderE *)orderE
                              payType:(PayType)payType
                              success:(SuccessBlock)success
                               failed:(FailedBlock)failed;
//水电燃缴费
- (void)executeWECTaskWithOder:(ChargeOrderE *)orderE
                       payType:(PayType)payType
                       success:(SuccessBlock)success
                        failed:(FailedBlock)failed;

//交通罚款费
- (void)executeTrafficFinesChargeTaskWithUser:(NSArray *)trafficArr
                                      payType:(PayType)payType
                                      success:(SuccessBlock)success
                                       failed:(FailedBlock)failed;

@end
