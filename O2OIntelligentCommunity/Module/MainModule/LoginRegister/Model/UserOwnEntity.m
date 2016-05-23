//
//  UserOwnEntity.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "UserOwnEntity.h"
#import "LoginStorage.h"

@implementation UserOwnEntity

- (void)setMemberId:(NSString *)memberId {
    _memberId= memberId;
    [LoginStorage saveUid:_memberId];
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [LoginStorage savePhone:_phone];
}

@end
