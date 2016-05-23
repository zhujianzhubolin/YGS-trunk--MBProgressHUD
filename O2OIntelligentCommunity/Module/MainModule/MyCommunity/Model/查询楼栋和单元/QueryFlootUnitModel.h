//
//  QueryFlootUnitModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface QueryFlootUnitModel : BaseEntity

@property(nonatomic,strong)NSArray *list;//对象集合

@property(nonatomic,copy)NSString *xqId;//小区ID
@property(nonatomic,copy)NSString *type;//类型
@property(nonatomic,copy)NSString *parentId;//父级ID

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *pId;//物业Id
@property(nonatomic,copy)NSString *houseName;//楼栋名称
@property(nonatomic,copy)NSString *hId;//小区Id
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *room;//房号
@property(nonatomic,copy)NSString *roomId;//房号ID
@property(nonatomic,copy)NSString *phone;//手机号


@end
