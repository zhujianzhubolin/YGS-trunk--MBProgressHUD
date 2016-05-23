//
//  QueryCommentModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface QueryCommentModel : BaseEntity

@property(nonatomic,strong)NSArray *list;
@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *complaintId;
@property(nonatomic,copy)NSString *complaintType;
@property(nonatomic,copy)NSString *orderType;
@property(nonatomic,copy)NSString *orderBy;
@property(nonatomic,copy)NSString *status;//状态  0：正常  1：删除 2：屏蔽

@property(nonatomic,strong)NSDictionary *queryMap;
@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数

@property(nonatomic,copy)NSString *dateTimeStr;//过去多久
@property(nonatomic,strong)NSArray *imgPath;//图片
@property(nonatomic,copy)NSString *createTimeStr;//创建时间
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *nickName;//昵称
@property(nonatomic,copy)NSString *photourl;//头像
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *dateCreateStr;



@end
