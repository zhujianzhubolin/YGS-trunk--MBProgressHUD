//
//  JingXuanShangJia.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/3.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface JingXuanShangJia : BaseEntity



//该接口不传参数给后台，是一个Get请求
//以下属性为后台返回数据定义
@property(nonatomic,copy) NSString * shangjiaid;
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * img;
@property(nonatomic,copy) NSString * phone;
@property(nonatomic,copy) NSString * storeAddress;

@end
