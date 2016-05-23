//
//  AddNewInforModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface AddNewInforModel : BaseEntity

@property(nonatomic,copy) NSString * memberid;
@property(nonatomic,copy) NSString * wyNo;
@property(nonatomic,copy) NSString * xqNo;
@property(nonatomic,copy) NSString * activityType;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * activityContent;
@property(nonatomic,copy) NSString * fileId;
@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString * transactionType;
@property(nonatomic,copy) NSString * fleaMarketType;
@property(nonatomic,copy) NSString * price;
@property(nonatomic,copy) NSString * phone;
@property(nonatomic,copy) NSString * cityId;
@property(nonatomic,copy) NSString * status;

@end
