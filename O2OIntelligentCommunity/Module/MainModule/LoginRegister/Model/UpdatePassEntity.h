//
//  UpdatePassEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface UpdatePassEntity : BaseEntity

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *passwordOld;
@property (nonatomic, copy) NSString *passwordNew;
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, copy) NSString *verifyName;
@property (nonatomic, copy) NSString *code;

@end
