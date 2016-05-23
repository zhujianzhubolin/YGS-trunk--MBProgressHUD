//
//  MineBuyXuniGoodM.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MineBuyGoodM.h"

@interface MineBuyXuniGoodM : MineBuyGoodM

//虚拟订单信息
@property (nonatomic,copy)NSString *xuniDingdanID;//虚拟订单号
@property (nonatomic,copy)NSString *orderItemVirtualNo;//订单行号
@property (nonatomic,copy)NSString *orderItemClass;//虚拟商品类型
@property (nonatomic,copy)NSString *productCode;//电影票票号、礼卡卡号、手机号等
@property (nonatomic,copy)NSString *saleAmount; //销售总金额
@property (nonatomic,copy)NSString *productName;//商品名称
@property (nonatomic,copy)NSString *saleNum;
@property (nonatomic,copy)NSString *unitPrice;

@end
