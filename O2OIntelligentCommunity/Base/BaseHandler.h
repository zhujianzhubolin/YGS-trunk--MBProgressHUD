//
//  BaseHandler.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"
#import "NSString+wrapper.h"
#import "NSArray+wrapper.h"
#import "NSDictionary+wrapper.h"
#import <MJExtension.h>

/**
 *  Handler处理完成后调用的Block
 */
typedef void (^CompleteBlock)();

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(id obj);

@interface BaseHandler : NSObject

/**
 *  获取请求URL
 *
 *  @param path
 *  @return 拼装好的URL
 */
+ (NSString *)requestUrlWithHost:(NSString *)Host WithPort:(NSString *)port WithPath:(NSString *)path;

@end
