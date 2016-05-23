//
//  CityListModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface CityListModel : BaseEntity



@property (nonatomic,strong)NSMutableDictionary *listDic;     //对象集合

@property (nonatomic,strong)NSArray *list;//对象集合

@property (nonatomic,copy)NSString *cityid;       //城市id
@property (nonatomic,copy)NSString *hot;          //是否是热门城市
@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *areacode;     //城市首字母
@property (nonatomic,copy)NSString *areaname;     //城市名称
@property (nonatomic,copy)NSString *spell;        //城市拼音



@end
