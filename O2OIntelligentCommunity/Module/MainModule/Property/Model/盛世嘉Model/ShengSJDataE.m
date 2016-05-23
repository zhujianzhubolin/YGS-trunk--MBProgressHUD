//
//  ShengShiJiaE.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShengSJDataE.h"

@implementation ShengSJDataE

- (id)init {
    self = [super init];
    if (self) {
        self.list = [NSArray array];
        self.imgPath = [NSArray array];
        self.queryMap = [NSDictionary dictionary];
    }
    return self;
}

@end
