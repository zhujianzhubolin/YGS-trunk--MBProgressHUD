//
//  MerchantsModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface MineBuyorderM : BaseEntity

//订单
@property (nonatomic,copy)NSString *userName;//收货人姓名
@property (nonatomic,copy)NSString *phoneNum;//收货人电话1
@property (nonatomic,copy)NSString *mobPhoneNum;//收货人电话2
@property (nonatomic,copy)NSString *postCode;//收货人邮编
@property (nonatomic,copy)NSString *email;       //邮箱
@property (nonatomic,strong)NSArray *orderItemInfoList;//实体商品
@property (nonatomic,copy)NSString *deliveryMerchantType;//物流类型
@property (nonatomic,copy)NSString *deliveryMerchantNo;//物流单号


//@property (nonatomic,strong)NSArray *orderItemVirtualList;//虚拟商品
//@property (nonatomic,strong)NSArray *orderList; //所有商品
@property (nonatomic,copy)NSString *addressDetail;//邮箱
@property (nonatomic,copy)NSString *orderSubNo;//本系统订单号

@end
