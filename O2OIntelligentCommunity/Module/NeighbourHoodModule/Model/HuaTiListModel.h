//
//  HuaTiListModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface HuaTiListModel : BaseEntity

@property(nonatomic,strong)NSArray *list;

@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *orderBy;
@property(nonatomic,copy)NSString *orderType;

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数

@property (nonatomic, strong) NSDictionary *queryMap;


@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *activityType;//话题类型
@property(nonatomic,copy)NSString *title;//标题
@property(nonatomic,copy)NSString *activityContent;//内容
@property(nonatomic,copy)NSString *xqNo;//小区ID
@property(nonatomic,copy)NSString *wyNo;//物业ID
@property(nonatomic,copy)NSString *activityTime;//活动时间
@property(nonatomic,copy)NSString *activityAddress;//活动地点
@property(nonatomic,copy)NSString *activityMoney;//活动费用
@property(nonatomic,copy)NSString *prize;//转让价
@property(nonatomic,copy)NSString *createTimeStr;//创建时间
@property(nonatomic,copy)NSString *status;//状态
@property(nonatomic,strong)NSArray *imgPath;//图片
@property(nonatomic,copy)NSNumber *commentNumber;//评论数
@property(nonatomic,copy)NSNumber *flowerCount;//鲜花数
@property(nonatomic,copy)NSString *accountName;//用户名
@property(nonatomic,copy)NSString *photourl;//头像
@property(nonatomic,copy)NSString *complaintType;//话题类型
@property(nonatomic,copy)NSString *nickName;//昵称
@property(nonatomic,copy)NSString *version;//标准版还是定制版




@end
