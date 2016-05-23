//
//  NoticeDiscussE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface CommentEntity : BaseEntity

@property (nonatomic, copy) NSString *pageNumber; //当前页  传入参数必须填写
@property (nonatomic, copy) NSString *pageSize; //每页显示条数
@property (nonatomic, strong) NSDictionary *queryMap; //查询集合
@property (nonatomic, copy) NSString *memberId; //会员ID
@property (nonatomic, copy) NSNumber *complaintId; //要评论信息的ID
@property (nonatomic, copy) NSString *complaintType; //评论类型

@property (nonatomic, copy) NSString *orderBy; //排序 两种排序方式： asc、desc
@property (nonatomic, copy) NSString *orderType; //排序类型
@property (nonatomic, copy) NSString *totalCount; //总条数
@property (nonatomic, copy) NSString *pageCount; //总页数
@property (nonatomic, copy) NSArray *list; //对象集合
@property (nonatomic, copy) NSString *idID; //评论类型
@property (nonatomic, copy) NSString *helpfulCount; //有用计数
@property (nonatomic, copy) NSString *unhelpfulCount; //无用计数
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *rating; //评分
@property (nonatomic, copy) NSString *content; //内容
@property (nonatomic, copy) NSString *status; //状态  状态 1:删除  2：屏蔽  0:正常
@property (nonatomic, copy) NSString *createTimeStr; //创建时间
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *accountName; //用户账号
@property (nonatomic, copy) NSString *dateCreateStr;//显示过去多少时间

@property (nonatomic, copy) NSString *auditId; //被举报人的ID
@end
