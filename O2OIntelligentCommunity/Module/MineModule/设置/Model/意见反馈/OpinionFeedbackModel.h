//
//  OpinionFeedbackModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface OpinionFeedbackModel : BaseEntity

@property(nonatomic,copy)NSString *memberInfoid;
@property(nonatomic,copy)NSString *devicetype;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *versioncode;//版本号
@property(nonatomic,copy)NSString *appname;


@end
