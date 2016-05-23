//
//  BingingXQModel.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BingingXQModel.h"
#import "NSString+wrapper.h"    

@implementation BingingXQModel

- (id)init {
    self = [super init];
    if (self) {
        self.imgPath = [NSArray array];
    }
    return self;
}

- (void)setIsCheckPass:(NSString *)isCheckPass {
    _isCheckPass = isCheckPass;
    
    //返回小区认证状态
    if ([NSString isEmptyOrNull:isCheckPass]) {
        self.isCheckPassType = XQRenZhengTypeNone;
        return;
    }
    
    if ([isCheckPass isEqualToString:@"1"]) {
        self.isCheckPassType = XQRenZhengTypeWaitCheck;
    }
    else if ([isCheckPass isEqualToString:@"2"]) {
        self.isCheckPassType = XQRenZhengTypeSuccess;
    }
    else if ([isCheckPass isEqualToString:@"3"]) {
        self.isCheckPassType = XQRenZhengTypeFailCheck;
    }
    else {
        self.isCheckPassType = XQRenZhengTypeNone;
    }
}

@end
