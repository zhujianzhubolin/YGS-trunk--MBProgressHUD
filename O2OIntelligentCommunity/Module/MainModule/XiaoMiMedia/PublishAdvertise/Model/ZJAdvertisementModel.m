//
//  ZJAdvertisementModel.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/31.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJAdvertisementModel.h"

@implementation ZJAdvertisementModel

- (void)setServiceRegular:(NSString *)serviceRegular {
    if ([NSString isEmptyOrNull:serviceRegular]) {
        _serviceRegular = nil;
    }
    else if ([serviceRegular isEqualToString:@"40Pd"]) {
        _serviceRegular = @"每天60次，每次15秒";
    }
    else if ([serviceRegular isEqualToString:@"100Pd"]) {
        _serviceRegular = @"每天100次，每次15秒";
    }
    else {
        _serviceRegular = nil;
    }
}

@end
