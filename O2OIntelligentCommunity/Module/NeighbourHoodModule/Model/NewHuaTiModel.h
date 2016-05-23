//
//  NewHuaTiModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface NewHuaTiModel : BaseEntity

@property (nonatomic,copy)NSString *memberid;          //用户id
@property (nonatomic,copy)NSString *wyNo;              //物业ID
@property (nonatomic,copy)NSString *xqNo;              //小区Id
@property (nonatomic,copy)NSString *activityType;      //活动类型
@property (nonatomic,copy)NSString *title;             //标题
@property (nonatomic,copy)NSString *activityContent;   //内容
@property (nonatomic,copy)NSString *fileId;            //图片Id
@property (nonatomic,copy)NSString *complaintType;//话题类型
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *message;
@end
