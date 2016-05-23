//
//  NoticeEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface NoticeEntity : BaseEntity
@property (nonatomic, copy) NSString *pageNumber; //当前页  传入参数必须填写
@property (nonatomic, copy) NSString *pageSize; //每页显示条数 传入参数必须填写
@property (nonatomic, strong) NSDictionary *queryMap; //查询集合
@property (nonatomic, copy) NSString *dateCreated; //时间  按时间排序

@property (nonatomic, copy) NSString *orderBy; //排序
@property (nonatomic, copy) NSString *orderType; //排序类型  两种排序方式： asc、desc
@property (nonatomic, copy) NSString *totalCount; //总条数
@property (nonatomic, copy) NSString *pageCount; //总页数

@property (nonatomic, strong) NSDictionary *imgUrl; //图片集合
@property (nonatomic, copy) NSString *entityId; //父级ID
@property (nonatomic, copy) NSString *filetype; //文件类型
@property (nonatomic, copy) NSString *filesize; //文件大小
@property (nonatomic, copy) NSString *path; //文件路径

//查询的对象集合类型
@property (nonatomic, strong) NSArray *list; //
@property (nonatomic, copy) NSNumber *idID; //
@property (nonatomic, copy) NSString *wyNo; //物业ID
@property (nonatomic, copy) NSString *xqNo; //小区ID
@property (nonatomic, copy) NSString *noticeType; //公告类型
@property (nonatomic, copy) NSString *noticeTitle; //公告标题
@property (nonatomic, copy) NSString *noticeContent; //公告内容
@property (nonatomic, copy) NSString *noticeStatus; //公告状态  0:未发布 1;已发布 2:屏蔽话题
@property (nonatomic, copy) NSString *createdBy; //公告发起人
@property (nonatomic, copy) NSString *cityId; //城市ID
@property (nonatomic, copy) NSString *createTimeStr; //创建时间
@property (nonatomic, strong) NSArray *imgPath; //图片的URL
@property (nonatomic, copy) NSString *type; //1:重要且紧急 2：紧急 3：重要 0:无
@end
