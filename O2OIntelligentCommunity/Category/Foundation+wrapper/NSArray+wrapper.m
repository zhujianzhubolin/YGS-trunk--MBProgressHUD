//
//  NSArray+wrapper.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NSArray+wrapper.h"

@implementation NSArray(wrapper)

//- (Boolean)isArrEmptyOrNull {
//    if (!self) {
//        return YES;
//    }
//    else if ([self isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    else if ([self isKindOfClass:[NSArray class]] && self.count == 0) {
//        return YES;
//    }
//    else {
//        return NO;
//    }
//}

+ (Boolean)isArrEmptyOrNull:(NSArray *)arr {
    if (!arr) {
        return YES;
    }
    else if ([arr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else if ([arr isKindOfClass:[NSArray class]] && arr.count == 0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        if ([categoryArray containsObject:array[i]] == NO) {
            [categoryArray addObject:array[i]];
        }
    }
                                 
    return [categoryArray copy];
}
@end
