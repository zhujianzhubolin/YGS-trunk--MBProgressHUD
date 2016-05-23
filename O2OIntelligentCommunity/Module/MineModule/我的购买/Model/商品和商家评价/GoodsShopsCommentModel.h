//
//  GoodsShopsCommentModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface GoodsShopsCommentModel : BaseEntity

@property(nonatomic,copy)NSString *storeId;//商家ID
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *storeType;//商家分类
@property(nonatomic,copy)NSString *serverId;//服务类型ID
@property(nonatomic,copy)NSString *conformityDegree;//相似度
@property(nonatomic,copy)NSString *serviceAttitude;//服务态度
@property(nonatomic,copy)NSString *deliverySpeed;//发货速度
@property(nonatomic,copy)NSString *score;//评分
@property(nonatomic,copy)NSString *description;//评论描述
@property(nonatomic,copy)NSString *storeImg;//图片ID

@property (nonatomic, strong) NSDictionary *queryMap;//集合

@end
