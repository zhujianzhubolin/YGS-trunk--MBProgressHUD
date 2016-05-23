//
//  ShengSJNewBuiltE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ShengSJNewBuiltE : BaseEntity

@property (nonatomic,copy)NSString *memberid;          //用户id
@property (nonatomic,copy)NSString *wyNo;              //物业ID
@property (nonatomic,copy)NSString *xqNo;              //小区Id
@property (nonatomic,copy)NSString *activityType;      //活动类型
@property (nonatomic,copy)NSString *title;             //标题
@property (nonatomic,copy)NSString *activityContent;   //内容
@property (nonatomic,copy)NSArray *fileId;            //图片Id
@property (nonatomic,copy)NSString *complaintType;    //话题类型
@property (nonatomic,copy)NSString *message;  
@property (nonatomic,copy)NSString *cityId;

@property (nonatomic,copy)NSString *type;   //请求类型 1、房屋租售 2、跳蚤市场
@property (nonatomic,copy)NSString *transactionType;   //房屋交易类型 1:出租 2：出售 3：求租
@property (nonatomic,copy)NSString *fleaMarketType;   //跳蚤市场分类 1：出售 2：求购

@end
