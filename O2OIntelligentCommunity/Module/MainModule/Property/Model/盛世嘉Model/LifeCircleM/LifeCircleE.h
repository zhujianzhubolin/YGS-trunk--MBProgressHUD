//
//  LifeCircleE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface LifeCircleE : BaseEntity


@property(nonatomic,copy) NSString * pageNumber;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * pageCount;
@property(nonatomic,copy) NSString * storeName; //商家名称
@property(nonatomic,copy) NSString * optionId; //商家类型ID
@property(nonatomic,copy) NSString * commId; //小区ID
@property(nonatomic,copy) NSString * companyId; //物业ID

@property(nonatomic,copy) NSString * screening; //筛选项  最新发布 LATEST_RELEASE, 评价最高 HIGHEST_EVALUATION, 距离最近 AWAY_NEAREST
@property(nonatomic,copy) NSString * convenient; //商家分类 周边商家，peripheral_merchant；便民服务，convenient_service;
@property(nonatomic,strong) NSDictionary * queryMap; 

@property(nonatomic,strong) NSArray * list;
@property(nonatomic,copy) NSString * businessHours; //营业时间
@property(nonatomic,copy) NSString * communityId; //
@property(nonatomic,copy) NSString * conformityDegree; //
@property(nonatomic,copy) NSString * deliverySpeed; //
@property(nonatomic,copy) NSString * distance; //距离
@property(nonatomic,copy) NSNumber * ID; //商家ID long
@property(nonatomic,copy) NSString * img; //图片
@property(nonatomic,copy) NSString * latitude; //商家经度
@property(nonatomic,copy) NSString * longitude; //商家纬度
@property(nonatomic,copy) NSString * name; //商家名称
@property(nonatomic,copy) NSString * num; //
@property(nonatomic,copy) NSString * optionCode; //
@property(nonatomic,copy) NSString * phone; //电话
@property(nonatomic,copy) NSString * score; //商家评分
@property(nonatomic,copy) NSString * serviceAttitude; //
@property(nonatomic,copy) NSString * status; //
@property(nonatomic,copy) NSString * storeAddress; //商家地址
@property(nonatomic,copy) NSString * storeEndDate; //
@property(nonatomic,copy) NSString * storeStartDate; //
@property(nonatomic,copy) NSString * storeType; //
@property(nonatomic,copy) NSString * tmdmService; //
@property(nonatomic,copy) NSString * rzStatus; //认证信息
@property(nonatomic,copy) NSString * Option;//服务类型
@property(nonatomic,copy) NSString * bizArea;//商家经营范围 


@end
