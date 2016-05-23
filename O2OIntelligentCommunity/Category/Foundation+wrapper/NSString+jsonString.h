//
//  NSString+jsonString.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/5/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (jsonString)

+(NSString *)jsonStringWithString:(NSString *) string;
+(NSString *)jsonStringWithArray:(NSArray *)array;
+(NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *)jsonStringWithObject:(id) object;
    
@end
