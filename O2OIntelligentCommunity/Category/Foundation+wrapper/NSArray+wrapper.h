//
//  NSArray+wrapper.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(wrapper)

//- (Boolean)isArrEmptyOrNull;
+ (Boolean)isArrEmptyOrNull:(NSArray *)arr;

//去掉数组中相同的对象
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array;
@end
