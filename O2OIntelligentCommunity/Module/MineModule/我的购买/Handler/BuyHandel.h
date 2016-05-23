//
//  BuyHandel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#include "MineBuyShopsM.h"

@interface BuyHandel : BaseHandler
@property (nonatomic, copy) NSString *allcurrentPage;
@property (nonatomic, copy) NSString *allpageCount;
@property (nonatomic, strong) NSMutableArray *allbuyArray;
@property (nonatomic, assign) BOOL isAllBuyUpdate;

@property (nonatomic, copy) NSString *paymentcurrentPage;
@property (nonatomic, copy) NSString *paymentpageCount;
@property (nonatomic, strong) NSMutableArray *paymentbuyArray;
@property (nonatomic, assign) BOOL isPaymentUpdate;

@property (nonatomic, copy) NSString *goodscurrentPage;
@property (nonatomic, copy) NSString *goodspageCount;
@property (nonatomic, strong) NSMutableArray *goodsbuyArray;
@property (nonatomic, assign) BOOL isGoodsUpdate;

@property (nonatomic, copy) NSString *evaluatecurrentPage;
@property (nonatomic, copy) NSString *evaluatepageCount;
@property (nonatomic, strong) NSMutableArray *evaluatbuyArray;
@property (nonatomic, assign) BOOL isEvaluatBuyUpdate;

@property (nonatomic, copy) NSString *allTuanGouCurrentPage;
@property (nonatomic, copy) NSString *allTuanGouPageCount;
@property (nonatomic, strong) NSMutableArray *allTuanGouArray;
@property (nonatomic, assign) BOOL isAllTuanGouUpdate;

@property (nonatomic, copy) NSString *EnableTuanGouCurrentPage;
@property (nonatomic, copy) NSString *EnableTuanGouPageCount;
@property (nonatomic, strong) NSMutableArray *EnableTuanGouArray;
@property (nonatomic, assign) BOOL isEnableTuanGouUpdate;

//获取我的所有团购订单
-(void)postAllTuanGouList:(MineBuyShopsM *)allTuangouM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;
-(void)postEnableTuanGouList:(MineBuyShopsM *)allTuangouM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;


//获取我的所有订单列表
-(void)postAllBuyList:(MineBuyShopsM *)allM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;
////获取待付款订单列表
//-(void)postPaymentBuyList:(MineBuyShopsM *)paymentM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;
////获取待收货订单列表
//-(void)postGoodsBuyList:(MineBuyShopsM *)goodsM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;
////获取待评价订单列表
//-(void)postEvaluateBuyList:(MineBuyShopsM *)evaluateM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;



//根据传入的参数反回不同的状态
+(NSString *)shopDinDanState:(NSString *)str;
+(NSString *)grouponDinDanState:(NSString *)str;


@end
