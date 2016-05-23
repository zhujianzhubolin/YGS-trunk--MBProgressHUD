//
//  ADEntity.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ADEntity.h"

@implementation ADEntity

- (id)init {
    self = [super init];
    if (self) {
        self.imagpath = [NSArray array];
        self.list = [NSArray array];
    }
    return self;
}

@end
