//
//  TGShopModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TGShopModel : BaseEntity

@property(nonatomic,copy) NSString * address;
@property(nonatomic,copy) NSString * areaCode;
@property(nonatomic,copy) NSString * atStatus;
@property(nonatomic,copy) NSString * count;
@property(nonatomic,copy) NSString * distance;
@property(nonatomic,copy) NSString * filed1;
@property(nonatomic,copy) NSString * filed2;
@property(nonatomic,copy) NSString * latitude;
@property(nonatomic,copy) NSString * longitude;
@property(nonatomic,copy) NSString * path;
@property(nonatomic,copy) NSString * range;
@property(nonatomic,copy) NSString * score;
@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * storeEndDate;
@property(nonatomic,copy) NSString * storeId;
@property(nonatomic,copy) NSString * storeName;
@property(nonatomic,copy) NSString * storeStartDate;

//商家商品数组
@property(nonatomic,strong) NSMutableArray * goodsArray;

@end
