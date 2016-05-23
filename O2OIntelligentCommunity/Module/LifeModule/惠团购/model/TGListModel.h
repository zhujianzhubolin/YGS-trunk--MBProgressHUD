//
//  TGListModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TGListModel : BaseEntity

@property(nonatomic,copy) NSString * pageNumber;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * longitude;
@property(nonatomic,copy) NSString * latitude;
@property(nonatomic,copy) NSString * companyId;
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * sort;
@property(nonatomic,copy) NSString * xqId;
@property(nonatomic,copy) NSString * storeName;
@property(nonatomic,copy) NSString * areaId;
@property(nonatomic,copy) NSString * areaName;
@property(nonatomic,copy) NSString * catalogId;
@property(nonatomic,copy) NSString * quantity;

//商家里面的
@property(nonatomic,copy) NSString * storeId;
@property(nonatomic,copy) NSString * memberId;

@end
