//
//  BaseHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "APIConfig.h"

@implementation BaseHandler
+ (NSString *)requestUrlWithHost:(NSString *)Host WithPort:(NSString *)port WithPath:(NSString *)path
{
    return [@"http://" stringByAppendingString:[[Host stringByAppendingString:port] stringByAppendingString:path]];
}
@end
