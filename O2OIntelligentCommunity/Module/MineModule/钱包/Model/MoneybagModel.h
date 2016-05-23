//
//  MoneybagModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface MoneybagModel : BaseEntity

@property(nonatomic,strong)NSArray *list;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数
@property (nonatomic, strong) NSDictionary *queryMap;

@property(nonatomic,copy)NSString *dateCreated;//创建日期
@property(nonatomic,copy)NSString *businessType;//交易类型
@property(nonatomic,copy)NSString *businessDate;//交易时间
@property(nonatomic,copy)NSString *businessAmount;//交易金额

@end
