//
//  getXQListModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface getXQListModel : BaseEntity


@property(nonatomic,strong)NSArray *list;//对象集合

@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *orderBy;
@property(nonatomic,copy)NSString *orderType;


@property(nonatomic,copy)NSString *cityId; //城市ID

@property(nonatomic,copy)NSString *communityAddress;//小区地址
@property(nonatomic,copy)NSString *communityName;//小区名称
@property(nonatomic,copy)NSString *ID;// 小区ID
@property(nonatomic,copy)NSString *comapyanyId;//物业Id

@property(nonatomic,copy)NSString *code;
@property (nonatomic, copy) NSString *isCustomized; //是否是定制版,标准版必须传，值为N。
@end
