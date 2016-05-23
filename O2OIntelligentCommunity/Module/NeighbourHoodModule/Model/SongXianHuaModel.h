//
//  SongXianHuaModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface SongXianHuaModel : BaseEntity
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *complaintType;//话题类型
@property(nonatomic,copy)NSString *activityId;//话题ID

@end
