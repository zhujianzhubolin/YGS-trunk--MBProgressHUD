//
//  FeedPaidStorage.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeesPaidStorage : NSObject

//保存水电燃缴费的用户编号
+ (void)saveFeesPaidUserID:(NSString *)userID;
+ (NSString *)feesPaidUserID;

@end
