//
//  PinLunListModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface PinLunListModel : BaseEntity

//发布评论
@property(nonatomic,copy) NSString * merberId;

@property(nonatomic,copy) NSString * complaintId;

@property(nonatomic,copy) NSString * complaintType;

@property(nonatomic,copy) NSString * content;



@end
