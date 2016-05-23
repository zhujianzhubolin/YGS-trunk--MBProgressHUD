//
//  BaoXiuTouSuModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface BaoXiuTouSuModel : BaseEntity


@property (nonatomic,strong)NSArray *list;//对象集合
@property (nonatomic,copy)NSString *pageNumber;//当前页
@property (nonatomic,copy)NSString *pageSize;  //每页显示条数
@property (nonatomic,copy)NSString *type;      //类型
@property (nonatomic,copy)NSString *orderBy;
@property (nonatomic,copy)NSString *orderType;

@property(nonatomic,strong)NSDictionary *queryMap;
@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *wyNo;//物业id
@property (nonatomic,copy)NSString *xqNo;//小区Id
@property (nonatomic,copy)NSString *complaintTitle;//标题
@property (nonatomic,copy)NSString *complaintContent;//内容
@property (nonatomic,copy)NSString *complaintStatus;//状态
@property (nonatomic,copy)NSString *contactPerson;//报修投诉联系人
@property (nonatomic,copy)NSString *contactPhone;//报修投诉联系电话
@property (nonatomic,copy)NSString *createTimeStr;//报修日期
@property (nonatomic,copy)NSString *contactAddress;//报修地址
@property (nonatomic,copy)NSArray  *imgPath;//图片列表
@property (nonatomic,copy)NSString *complaintType;//报修种类
@property (nonatomic,copy)NSString *communityName;//报修小区

@property (nonatomic,copy)NSString *code;

@end
