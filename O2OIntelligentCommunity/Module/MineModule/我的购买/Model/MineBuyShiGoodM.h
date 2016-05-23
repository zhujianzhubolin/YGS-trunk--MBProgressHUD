//
//  GoodsModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MineBuyGoodM.h"

@interface MineBuyShiGoodM : MineBuyGoodM

//商品信息订单
@property (nonatomic,copy)NSString *shangpinID;//商品订单ID
@property (nonatomic,copy)NSString *saleNum;    //销售数量
@property (nonatomic,copy)NSString *unitPrice;  //销售单价:折前价
@property (nonatomic,copy)NSString *unitDiscount;//销售单件折扣
@property (nonatomic,copy)NSString *itemDiscount;//销售单件折扣
@property (nonatomic,copy)NSString *unitDeductedPrice;//折后单价
@property (nonatomic,copy)NSString *payAmount;//折后总价
@property (nonatomic,copy)NSString *commodityName;//商品名称
@property (nonatomic,copy)NSString *orderItemNo;//订单行号
@property (nonatomic,copy)NSString *imgPath;//商品图片
@property (nonatomic,copy)NSString *commodityId;// 商品id

//团购订单数据

@property (nonatomic,copy)NSString *orderItemVirtualNo;
@property (nonatomic,copy)NSString *orderItemClass;
@property (nonatomic,copy)NSString *productCode;
@property (nonatomic,copy)NSString *saleAmount;
@property (nonatomic,copy)NSString *checkCode;
@property (nonatomic,copy)NSString *barCode;
@property (nonatomic,copy)NSString *startDate;
@property (nonatomic,copy)NSString *endDate;
@property (nonatomic,copy)NSString *validityDate;
@property (nonatomic,copy)NSString *productName;
@property (nonatomic,strong)NSDictionary *orderRefundRecord;

@end
