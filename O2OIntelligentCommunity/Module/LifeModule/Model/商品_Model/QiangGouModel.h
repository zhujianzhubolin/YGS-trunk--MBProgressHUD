//
//  QiangGouModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"

@interface QiangGouModel : BaseHandler


//提供给后台的数据
@property(nonatomic,copy) NSNumber * bundleGroupId;
@property(nonatomic,copy) NSNumber * pageNumber;
@property(nonatomic,copy) NSNumber * pageSize;
@property(nonatomic,copy) NSString * nameUp;
//后台返回的数据

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * market_price;
@property(nonatomic,copy)NSString * img;

@end
