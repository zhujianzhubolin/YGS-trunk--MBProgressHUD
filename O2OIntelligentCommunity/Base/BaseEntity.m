//
//  BaseEntity.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

static NSString * const MSG = @"msg";
static NSString * const STATUS = @"status";
static NSString * const RES = @"res";

@implementation BaseEntity

+(BaseEntity* )parseResponseErrorJSON:(id)json
{
    NSString *responseJSON = [NSString stringWithFormat:@"%@",json];
    NSLog(@"%@",responseJSON);
    NSData *jsonData = [responseJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    if ([NSJSONSerialization isValidJSONObject:dic_json]) {
        BaseEntity *baseEntity = [[BaseEntity alloc] init];
//        baseEntity.status = [((NSNumber *)[dic_json objectForKey:STATUS]) intValue];
//        baseEntity.msg = [dic_json objectForKey:MSG];
        return baseEntity;
    }
    return nil;
}

+ (BaseEntity *)parseResponseStatusJSON:(id)json
{
    NSLog(@"json = %@",json);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    //格式化打印输出至控制台
    NSString *responseJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseJSON);
    NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    if ([NSJSONSerialization isValidJSONObject:dic_json]) {
//        NSNumber *status = (NSNumber *)[dic_json objectForKey:STATUS];
        BaseEntity *baseEntity = [[BaseEntity alloc] init];
//        baseEntity.status = [status intValue];
//        baseEntity.msg = [dic_json objectForKey:MSG];
        return baseEntity;
    }
    return nil;
}

+(BaseEntity *)parseResponseUpdateJSON:(id)json
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    //格式化打印输出至控制台
    NSString *responseJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseJSON);
    NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    if ([NSJSONSerialization isValidJSONObject:dic_json]) {
//        NSNumber *status = (NSNumber *)[dic_json objectForKey:STATUS];
        BaseEntity *baseEntity = [[BaseEntity alloc] init];
//        baseEntity.status = [status intValue];
//        id res = [dic_json objectForKey:RES];
//        baseEntity.version = [res objectForKey:@"v"];
//        baseEntity.updateURL = [res objectForKey:@"url"];
        return baseEntity;
    }
    return nil;
}
@end
