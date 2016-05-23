//
//  RegisterEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface RegisterCodeEntity : BaseEntity

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *smsType;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *numberCode;
@property (nonatomic, copy) NSString *smstype;
@property (nonatomic, copy) NSString *telphone;

@end
