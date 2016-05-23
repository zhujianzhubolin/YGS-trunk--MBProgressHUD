//
//  TGGoodsModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TGGoodsModel : BaseEntity

@property(nonatomic,copy) NSString * address;
@property(nonatomic,copy) NSString * atStatus;
@property(nonatomic,copy) NSString * details;
@property(nonatomic,copy) NSString * effectiveTime;
@property(nonatomic,copy) NSString * fullMoney;
@property(nonatomic,copy) NSString * goodsid;
@property(nonatomic,copy) NSString * img;
@property(nonatomic,copy) NSString * listImg;
@property(nonatomic,copy) NSString * madein;
@property(nonatomic,copy) NSString * marketStatus;
@property(nonatomic,copy) NSString * market_price;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * notFullMoney;
@property(nonatomic,copy) NSString * num;
@property(nonatomic,copy) NSString * price;
@property(nonatomic,copy) NSString * shortDescription;
@property(nonatomic,copy) NSString * standard;
@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * stock;
@property(nonatomic,copy) NSString * storeEndDate;
@property(nonatomic,copy) NSString * storeId;
@property(nonatomic,copy) NSString * storeName;
@property(nonatomic,copy) NSString * storeStartDate;

@property(nonatomic,copy) NSString * groupEndDate;
@property(nonatomic,copy) NSString * groupStartDate;
@property(nonatomic,copy) NSString * serverTime;


//商品数量
@property(nonatomic,copy) NSString * goodsNum;



@end
