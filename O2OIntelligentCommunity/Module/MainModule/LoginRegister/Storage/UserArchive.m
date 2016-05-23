//
//  UserArchive.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
static NSString * const kUser_Info   = @"User_Info";

#import "UserArchive.h"

@implementation UserArchive
#pragma mark - NSCoding
//通过一个给定的archiver把消息接收者进行编码。
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userInfo forKey:kUser_Info];
}

//从一个给定unarchiver的数据中返回一个初始化对象。
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.userInfo = [aDecoder decodeObjectForKey:kUser_Info];
    }
    return self;
}

//返回消息接收者的一个复制的新实例。
#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    UserArchive *copy = [[[self class] allocWithZone:zone] init];
    copy.userInfo = [self.userInfo copyWithZone:zone];
    return copy;
}

@end
