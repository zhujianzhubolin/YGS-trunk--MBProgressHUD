//
//  BuyModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface MineBuyShopsM : BaseEntity

@property (nonatomic,strong)NSArray *list;//对象集合
@property (nonatomic,strong)NSArray *orderSubInfoList; //商家下的订单

@property (nonatomic,copy)NSString *pageNumber;//当前页
@property (nonatomic,copy)NSString *pageSize;  //每页显示条数
@property (nonatomic,copy)NSString *memberNo;  //会员ID

@property(nonatomic,copy)NSString *totalCount;//总条数
@property(nonatomic,copy)NSString *pageCount;//总页数
@property (nonatomic, strong) NSDictionary *queryMap;

//商家信息
@property (nonatomic,copy)NSString *orderNo;   //订单号
@property (nonatomic,copy)NSString *aliasOrderNo;//支付订单号
@property (nonatomic,copy)NSString *payType;//支付方式
@property (nonatomic,copy)NSString *orderType; //订单类型
@property (nonatomic,copy)NSString *orderBy;
@property (nonatomic,copy)NSString *merchantNo;//商家编号
@property (nonatomic,copy)NSString *merchantName;//商家名称
@property (nonatomic,copy)NSString *orderTimeStr;//订单产生时间
@property (nonatomic,copy)NSString *totalPayAmount;//支付金额的汇总
@property (nonatomic,copy)NSString *transportFee;//运费总额
@property (nonatomic,copy)NSString *isDeleted;//是否删除
@property (nonatomic,copy)NSString *statusPay; //支付状态
@property (nonatomic,copy)NSString *statusTotal;//订单状态
@property (nonatomic,copy)NSString *merchantPhone;
@property (nonatomic,copy)NSString *orderTime;

@property (nonatomic,copy)NSString *discountAmount;
@property (nonatomic,copy)NSDictionary  *orderRefundRecord;//退款驳回

//@property (nonatomic,assign) BOOL isShiti;//实体还是虚拟订单 自己添加
@end
