//
//  ShengShiJiaE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ShengSJDataE : BaseEntity

@property(nonatomic,strong)NSArray *list;

@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *orderBy;
@property(nonatomic,copy)NSString *orderType;

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数
@property(nonatomic, strong) NSDictionary *queryMap;

@property(nonatomic,copy)NSString *type;//请求类型 1：话题   2：房屋租售  3：咨询服务  4：管理报告 5:社区政务
@property(nonatomic,copy)NSString *transactionType;//房屋出售交易类型 1:出租 2：出售 3：求租
@property(nonatomic,copy)NSString *consultationType;//咨询服务分类 1:法务咨询 2:财务咨询 3:税务咨询
@property(nonatomic,copy)NSString *reportType;//管理报告分类 1:财务收支报告 2: 管理服务报告

@property(nonatomic,copy)NSString *word; // 发布信息内容 H5更格式内容
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *activityType;//话题类型
@property(nonatomic,copy)NSString *title;//标题
@property(nonatomic,copy)NSString *activityContent;//内容
@property(nonatomic,copy)NSString *xqNo;//小区ID
@property(nonatomic,copy)NSString *wyNo;//物业ID
@property(nonatomic,copy)NSString *activityTime;//活动时间
@property(nonatomic,copy)NSString *activityAddress;//活动地点
@property(nonatomic,copy)NSString *activityMoney;//活动费用
@property(nonatomic,copy)NSString *prize;//转让价
@property(nonatomic,copy)NSString *price;//出售/出租价格
@property(nonatomic,copy)NSString *createTimeStr;//创建时间
@property(nonatomic,copy)NSString *status;//状态  0:置顶，1：屏蔽 ，2：未发布，3：已发布
@property(nonatomic,strong)NSArray *imgPath;//图片
@property(nonatomic,copy)NSNumber *commentNumber;//评论数
@property(nonatomic,copy)NSNumber *flowerCount;//鲜花数
@property(nonatomic,copy)NSString *accountName;//用户名
@property(nonatomic,copy)NSString *haedimgurl;//头像
@property(nonatomic,copy)NSString *complaintType;//话题类型
@property(nonatomic,copy)NSString *specialty;//咨询服务类：擅长领域
@property(nonatomic,copy)NSString *dateCreated;//创建时间
@property(nonatomic,copy)NSString *phone;//电话
@property(nonatomic,copy)NSString *opinionStatus;//建议状态
@property(nonatomic,copy)NSString *photourl;
@property(nonatomic,copy)NSString *updateTimeStr;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *fleaMarketType;

@property(nonatomic,copy) id  dataDict;//方便字典参数使用者的调用
@end
