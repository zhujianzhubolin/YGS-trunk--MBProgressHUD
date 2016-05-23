//
//  PhoneH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/12/31.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"

@interface PhoneH : BaseHandler

//查询话费归属地
- (void)executeTaskForQueryPhoneAttribution:(id)parametor
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed;

@end
