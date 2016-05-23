//
//  FeedPaidStorage.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
static NSString * const feesPaidUserID = @"feesPaidUserID";

#import "FeesPaidStorage.h"

@implementation FeesPaidStorage

//保存水电燃缴费的用户编号
+ (void)saveFeesPaidUserID:(NSString *)userID {
    [UserDefaultsUtils saveValue:userID forKey:feesPaidUserID];
}

+ (NSString *)feesPaidUserID {
    return [UserDefaultsUtils valueWithKey:feesPaidUserID];
}

@end
