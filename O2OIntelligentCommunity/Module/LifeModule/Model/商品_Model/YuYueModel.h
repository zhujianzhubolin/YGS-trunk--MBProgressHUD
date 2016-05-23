//
//  YuYueModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface YuYueModel : BaseEntity

@property(nonatomic,copy) NSString * storeid;
@property(nonatomic,copy) NSString * userId;
@property(nonatomic,copy) NSString * serviceTime;
@property(nonatomic,copy) NSString * address;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * phone;
@property(nonatomic,copy) NSString * remarks;
@property(nonatomic,copy) NSString * serverId;

@end

