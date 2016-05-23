//
//  NSDictionary+wrapper.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NSDictionary+wrapper.h"

@implementation NSDictionary(wrapper)

+ (BOOL)isDicEmptyOrNull:(NSDictionary *)dic {
    if (!dic) {
        return YES;
    }
    else if ([dic isEqual:[NSNull null]]) {
        return YES;
    }
    else if (![dic isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    else if ([dic isKindOfClass:[NSDictionary class]] && dic.allKeys.count == 0 && dic.allValues.count == 0) {
        return YES;
    }
    return NO;
}

@end
