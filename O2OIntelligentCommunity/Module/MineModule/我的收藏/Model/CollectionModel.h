//
//  CollectionModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface CollectionModel : BaseEntity

@property (nonatomic,strong)NSArray *list;//对象集合

@property (nonatomic,copy)NSString *pageNumber;
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *memberId;

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数
@property (nonatomic, strong) NSDictionary *queryMap;

@property (nonatomic,copy)NSString *ID;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic,copy)NSString *price;//销售价
@property (nonatomic,copy)NSString *market_price;//市场价
@property (nonatomic,copy)NSString *img;//商品图片
@property (nonatomic,copy)NSString *desc;//短描述
@property (nonatomic,copy)NSString *fullMoney;//满多少
@property (nonatomic,copy)NSString *notFullMoney;//减多少
@property (nonatomic,copy)NSString *isMarket;//上下架状态
@property (nonatomic,copy)NSString *productType;


@property (nonatomic,copy)NSString *stock;
@property (nonatomic,copy)NSString *storeId;
@property (nonatomic,copy)NSString *storeName;
@property (nonatomic,copy)NSString *isSelect;






@end
