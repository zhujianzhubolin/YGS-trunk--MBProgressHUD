//
//  ShangjiaModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ShangjiaModel : BaseEntity

@property (nonatomic,strong)NSArray *list;//对象集合

@property (nonatomic,copy)NSString *pageNumber;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *memberId;

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数
@property (nonatomic, strong) NSDictionary *queryMap;

@property (nonatomic,copy)NSString *ID;//商家ID
@property (nonatomic,copy)NSString *OptionCode;//商家分类
@property (nonatomic,copy)NSString *name;//商家名称
@property (nonatomic,copy)NSString *img;//图片
@property (nonatomic,copy)NSString *score;//评分
@property (nonatomic,copy)NSString *storeID;//服务类型ID
@property (nonatomic,copy)NSString *cost;//费用描述
@property (nonatomic,copy)NSString *storeAddress;//地址
@property (nonatomic,copy)NSString *rzStatus;//认证状态
@property (nonatomic,copy)NSString *isDeleted;//标示








@end
