//
//  ADEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ADEntity : BaseEntity

//传给后台的数据
//物业ID
@property (nonatomic,copy) NSNumber * companyId;
//小区ID
@property(nonatomic,copy) NSNumber * communityhouseId;
//广告位置类型
@property(nonatomic,copy) NSString * code;

@property(nonatomic,copy) NSString * pageNumber;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * pageCount;

@property(nonatomic,strong) NSArray * list;
//后台返回的数据小区广告
@property(nonatomic,copy) NSString * imageAddres;
@property(nonatomic,strong) NSArray *imagpath;
@property(nonatomic,copy) NSString * imageID;
@property(nonatomic,copy) NSString * imagename;
@property(nonatomic,copy) NSString * imagedescription;
@property(nonatomic,copy) NSString * type; //图片的类型 product商品,merchant商家,advertisement广告
@property(nonatomic,copy) NSString * linkCode; //广告的链接地址，为空直接放大图片

@property(nonatomic,copy) NSString * productId; //商品ID
@property(nonatomic,copy) NSString * merchantId; //商家ID
@property(nonatomic,copy) NSString * operationId; //操作ID
@property(nonatomic,copy) NSString * rzstatus; //认证状态
@property(nonatomic,copy) NSString * productType; //商品类型  Group  团购  Quickly  小时送  Supplier 网上商城商品
@end
