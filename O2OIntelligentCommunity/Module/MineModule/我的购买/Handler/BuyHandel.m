//
//  BuyHandel.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BuyHandel.h"
#import "NSString+wrapper.h"
#import "MineBuyShopsM.h"
#import "MineBuyShiGoodM.h"
#import "MineBuyorderM.h"
#import "MineBuyXuniGoodM.h"

@implementation BuyHandel

-(id)init
{
    self = [super init];
    if (self) {
        self.allcurrentPage = @"1";
        self.allpageCount =  @"1";
        self.allbuyArray = [NSMutableArray array];
        self.isAllBuyUpdate = YES;
        
        self.paymentcurrentPage=@"1";
        self.paymentpageCount=@"1";
        self.paymentbuyArray = [NSMutableArray array];
        self.isPaymentUpdate = YES;
        
        self.goodscurrentPage = @"1";
        self.goodspageCount=@"1";
        self.goodsbuyArray = [NSMutableArray array];
        self.isGoodsUpdate = YES;
        
        self.evaluatecurrentPage =@"1";
        self.evaluatepageCount =@"1";
        self.evaluatbuyArray = [NSMutableArray array];
        self.isEvaluatBuyUpdate = YES;
        
        self.allTuanGouCurrentPage = @"1";
        self.allTuanGouPageCount   = @"1";
        self.allTuanGouArray       = [NSMutableArray array];
        self.isAllTuanGouUpdate    = YES;
        
        self.EnableTuanGouCurrentPage = @"1";
        self.EnableTuanGouPageCount   = @"1";
        self.EnableTuanGouArray       = [NSMutableArray array];
        self.isEnableTuanGouUpdate       = YES;
    }
    return self;
}

//获取我的所有团购订单
-(void)postAllTuanGouList:(MineBuyShopsM *)allTuangouM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.allTuanGouCurrentPage =@"1";
        self.allTuanGouPageCount =@"1";
    }
    else
    {
        if (self.allTuanGouCurrentPage.intValue > self.allTuanGouPageCount.intValue)
        {
            success(self.allTuanGouArray);
            return;
        }
        self.allTuanGouCurrentPage = [NSString stringWithFormat:@"%d",self.allTuanGouCurrentPage.intValue +1];
    }
    
    allTuangouM.pageNumber=self.allTuanGouCurrentPage;
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           allTuangouM.pageNumber,@"pageNumber",
                           allTuangouM.pageSize,@"pageSize",
                           allTuangouM.orderBy,@"orderBy",
                           allTuangouM.orderType,@"orderType",
                           allTuangouM.queryMap,@"queryMap", nil];
    
    
    NSLog(@"postBuyListDict  ===== %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"postBuyListRecvDic==%@",dic );
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            MineBuyShopsM *buyshopM =[self decodeMineTaunGouOrder:dic];
            NSLog(@"buyshopM.list%@",buyshopM.list);
            
            self.allTuanGouPageCount=buyshopM.pageCount;
            if (isheader)
            {
                self.allTuanGouArray = [buyshopM.list mutableCopy];
            }
            else
            {
                [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.allTuanGouArray addObject:obj];
                }];
            }
            success(self.allTuanGouArray);
            return ;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}

//获取我的所有团购订单
-(void)postEnableTuanGouList:(MineBuyShopsM *)allTuangouM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.EnableTuanGouCurrentPage =@"1";
        self.EnableTuanGouPageCount =@"1";
    }
    else
    {
        if (self.EnableTuanGouCurrentPage.intValue > self.EnableTuanGouPageCount.intValue)
        {
            success(self.EnableTuanGouArray);
            return;
        }
        self.EnableTuanGouCurrentPage = [NSString stringWithFormat:@"%d",self.EnableTuanGouCurrentPage.intValue +1];
    }
    
    allTuangouM.pageNumber=self.EnableTuanGouCurrentPage;
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           allTuangouM.pageNumber,@"pageNumber",
                           allTuangouM.pageSize,@"pageSize",
                           allTuangouM.orderBy,@"orderBy",
                           allTuangouM.orderType,@"orderType",
                           allTuangouM.queryMap,@"queryMap", nil];
    
    
    NSLog(@"postBuyListDict  ===== %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"postBuyListRecvDic==%@",dic );
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            MineBuyShopsM *buyshopM =[self decodeMineTaunGouOrder:dic];
            NSLog(@"buyshopM.list%@",buyshopM.list);
            
            self.EnableTuanGouPageCount=buyshopM.pageCount;
            if (isheader)
            {
                self.EnableTuanGouArray = [buyshopM.list mutableCopy];
            }
            else
            {
                [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.EnableTuanGouArray addObject:obj];
                }];
            }
            success(self.EnableTuanGouArray);
            return ;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}




//获取我的所有订单列表
-(void)postAllBuyList:(MineBuyShopsM *)allM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.allcurrentPage =@"1";
        self.allpageCount =@"1";
        }
    else
    {
        if (self.allcurrentPage.intValue > self.allpageCount.intValue)
        {
            success(self.allbuyArray);
            return;
        }
        self.allcurrentPage = [NSString stringWithFormat:@"%d",self.allcurrentPage.intValue +1];
    }
    
    allM.pageNumber=self.allcurrentPage;
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               allM.pageNumber,@"pageNumber",
                               allM.pageSize,@"pageSize",
                               allM.orderBy,@"orderBy",
                               allM.orderType,@"orderType",
                               allM.queryMap,@"queryMap", nil];
    
    
        NSLog(@"postBuyListDict  ===== %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{

    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"postBuyListRecvDic==%@",dic );

        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            MineBuyShopsM *buyshopM =[self decodeMineAllOrder:dic];
            NSLog(@"buyshopM.list%@",buyshopM.list);
    
            self.allpageCount=buyshopM.pageCount;
            if (isheader)
            {
                self.allbuyArray = [buyshopM.list mutableCopy];
            }
            else
            {
                [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.allbuyArray addObject:obj];
                }];
            }
            success(self.allbuyArray);
            return ;
        }
    
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            failed(nil);
            NSLog(@"%@",error);
            
    }];

}
////获取待付款订单列表
//-(void)postPaymentBuyList:(MineBuyShopsM *)paymentM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
//{
//    if (isheader)
//    {
//        self.paymentcurrentPage =@"1";
//        self.paymentpageCount =@"1";
//    }
//    else
//    {
//        if (self.paymentcurrentPage.intValue > self.paymentpageCount.intValue)
//        {
//            success(self.paymentbuyArray);
//            return;
//        }
//        self.paymentcurrentPage = [NSString stringWithFormat:@"%d",self.paymentcurrentPage.intValue +1];
//    }
//    
//    paymentM.pageNumber=self.paymentcurrentPage;
//    
//    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                           paymentM.pageNumber,@"pageNumber",
//                           paymentM.pageSize,@"pageSize",
//                           paymentM.orderBy,@"orderBy",
//                           paymentM.orderType,@"orderType",
//                           paymentM.queryMap,@"queryMap", nil];
//    
//    
//    NSLog(@"postBuyListDict  ===== %@",Dict);
//    
//    [[NetworkRequest defaultRequest] requestSerializerJson];
//    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
//        
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"postBuyListRecvDic==%@",dic );
//        
//        if ([NSJSONSerialization isValidJSONObject:dic] && success)
//        {
//            MineBuyShopsM *buyshopM =[self decodeMineAllOrder:dic];
//            
//            self.paymentpageCount=buyshopM.pageCount;
//            
//            NSMutableArray *filterArr = [NSMutableArray array];
//            [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                MineBuyShopsM *shopM   = obj;
//                if (![NSString isEmptyOrNull:shopM.statusTotal] && [shopM.statusTotal isEqualToString:@"0130"]) {
//                    [filterArr addObject:shopM];
//                }
//            }];
//            
//            if (isheader)
//            {
//                self.paymentbuyArray= [filterArr mutableCopy];
//            }
//            else
//            {
//                [filterArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [self.paymentbuyArray addObject:obj];
//                }];
//            }
//            success(self.paymentbuyArray);
//            return ;
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        failed(nil);
//        NSLog(@"%@",error);
//        
//    }];
//
//}
////获取待收货订单列表
//-(void)postGoodsBuyList:(MineBuyShopsM *)goodsM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
//{
//    if (isheader)
//    {
//        self.goodscurrentPage =@"1";
//        self.goodspageCount =@"1";
//        
//    }
//    else
//    {
//        if (self.goodscurrentPage.intValue > self.goodspageCount.intValue)
//        {
//            success(self.goodsbuyArray);
//            return;
//        }
//        self.goodscurrentPage = [NSString stringWithFormat:@"%d",self.goodscurrentPage.intValue +1];
//    }
//    
//    goodsM.pageNumber=self.goodscurrentPage;
//    
//    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                           goodsM.pageNumber,@"pageNumber",
//                           goodsM.pageSize,@"pageSize",
//                           goodsM.orderBy,@"orderBy",
//                           goodsM.orderType,@"orderType",
//                           goodsM.queryMap,@"queryMap", nil];
//    
//    
//    NSLog(@"postBuyListDict  ===== %@",Dict);
//    
//    [[NetworkRequest defaultRequest] requestSerializerJson];
//    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
//        
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"postBuyListRecvDic==%@",dic );
//        
//        if ([NSJSONSerialization isValidJSONObject:dic] && success)
//        {
//            MineBuyShopsM *buyshopM =[self decodeMineAllOrder:dic];
//            
//            self.goodspageCount=buyshopM.pageCount;
//            
//            NSMutableArray *filterArr = [NSMutableArray array];
//            [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                MineBuyShopsM *shopM   = obj;
//                if (![NSString isEmptyOrNull:shopM.statusTotal] && [shopM.statusTotal isEqualToString:@"0170"]) {
//                    [filterArr addObject:shopM];
//                }
//            }];
//            
//            if (isheader)
//            {
//                self.goodsbuyArray= [filterArr mutableCopy];
//            }
//            else
//            {
//                [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [filterArr addObject:obj];
//                }];
//            }
//            success(self.goodsbuyArray);
//            return ;
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        failed(nil);
//        NSLog(@"%@",error);
//        
//    }];
//
//}
////获取待评价订单列表
//-(void)postEvaluateBuyList:(MineBuyShopsM *)evaluateM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
//{
//    if (isheader)
//    {
//        self.evaluatecurrentPage =@"1";
//        self.evaluatepageCount =@"1";
//        
//    }
//    else
//    {
//        if (self.evaluatecurrentPage.intValue > self.evaluatepageCount.intValue)
//        {
//            success(self.evaluatbuyArray);
//            return;
//        }
//        self.evaluatecurrentPage = [NSString stringWithFormat:@"%d",self.evaluatecurrentPage.intValue +1];
//    }
//    
//    evaluateM.pageNumber=self.evaluatecurrentPage;
//    
//    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                           evaluateM.pageNumber,@"pageNumber",
//                           evaluateM.pageSize,@"pageSize",
//                           evaluateM.orderBy,@"orderBy",
//                           evaluateM.orderType,@"orderType",
//                           evaluateM.queryMap,@"queryMap", nil];
//    
//    
//    NSLog(@"postBuyListDict  ===== %@",Dict);
//    
//    [[NetworkRequest defaultRequest] requestSerializerJson];
//    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
//        
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"postBuyListRecvDic==%@",dic );
//        
//        if ([NSJSONSerialization isValidJSONObject:dic] && success)
//        {
//            MineBuyShopsM *buyshopM =[self decodeMineAllOrder:dic];
//            
//            self.evaluatepageCount=buyshopM.pageCount;
//            
//            NSMutableArray *filterArr = [NSMutableArray array];
//            [buyshopM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                MineBuyShopsM *shopM   = obj;
//                if (![NSString isEmptyOrNull:shopM.statusTotal] && [shopM.statusTotal isEqualToString:@"0180"]) {
//                    [filterArr addObject:shopM];
//                }
//            }];
//            
//            if (isheader)
//            {
//                self.evaluatbuyArray= [filterArr mutableCopy];
//            }
//            else
//            {
//                [filterArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [self.evaluatbuyArray addObject:obj];
//                }];
//            }
//            success(self.evaluatbuyArray);
//            return ;
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        failed(nil);
//        NSLog(@"%@",error);
//        
//    }];
//
//}

- (MineBuyShopsM *)decodeMineAllOrder:(NSDictionary *)dic {
    
    MineBuyShopsM *buyshopsM =[MineBuyShopsM new];
    
    buyshopsM.pageNumber =[NSString stringFromat:dic[@"pageNumber"]];
    buyshopsM.pageSize   =[NSString stringFromat:dic[@"pageSize"]];
    buyshopsM.pageCount  =[NSString stringFromat:dic[@"pageCount"]];
    NSLog(@"%d",buyshopsM.pageNumber.intValue);
    //创建商家数组
    NSMutableArray *shopArr = [NSMutableArray array];
    
    NSArray *shopList = dic[@"list"];
    if ([NSArray isArrEmptyOrNull:shopList]) {
        return buyshopsM;
    }
    
    //商家数组
    [shopList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *shopDic = (NSDictionary *)obj;
        MineBuyShopsM *shopM   = [MineBuyShopsM new];
        shopM.aliasOrderNo     = [NSString stringWithFormat:@"%@",shopDic[@"aliasOrderNo"]];
        shopM.isDeleted        = [NSString stringWithFormat:@"%@",shopDic[@"isDeleted"]];
        shopM.memberNo         = [NSString stringWithFormat:@"%@",shopDic[@"memberNo"]];
        shopM.discountAmount   = [NSString stringWithFormat:@"%@",shopDic[@"discountAmount"]];
        if (![NSDictionary isDicEmptyOrNull:shopDic[@"orderRefundRecord"]])
        {
            shopM.orderRefundRecord =shopDic[@"orderRefundRecord"];
        }
        if (![NSString isEmptyOrNull:shopDic[@"merchantName"]]) {
            shopM.merchantName     = [NSString stringWithFormat:@"%@",shopDic[@"merchantName"]];
        }
        
        shopM.merchantNo       = [NSString stringWithFormat:@"%@",shopDic[@"merchantNo"]];
        shopM.orderNo          = [NSString stringWithFormat:@"%@",shopDic[@"orderNo"]];
        shopM.orderTime        = [NSString stringWithFormat:@"%@",shopDic[@"orderTime"]];
        shopM.orderTimeStr     = [NSString stringWithFormat:@"%@",shopDic[@"orderTimeStr"]];
        shopM.orderType        = [NSString stringWithFormat:@"%@",shopDic[@"orderType"]];
        shopM.payType          = [NSString stringWithFormat:@"%@",shopDic[@"payType"]];
        shopM.statusPay        = [NSString stringWithFormat:@"%@",shopDic[@"statusPay"]];
        shopM.statusTotal      = [NSString stringWithFormat:@"%@",shopDic[@"statusTotal"]];
        NSLog(@"shopM.statusTotal = %@",shopM.statusTotal);
        shopM.totalPayAmount   = [NSString stringWithFormat:@"%@",shopDic[@"totalPayAmount"]];
        shopM.transportFee     = [NSString stringWithFormat:@"%@",shopDic[@"transportFee"]];
        
        //创建订单列表
        NSMutableArray *orderArr = [NSMutableArray array];
        NSArray *orderSubInfoList = shopDic[@"orderSubInfoList"];
        
        if (![NSArray isArrEmptyOrNull:orderSubInfoList]) {
            //订单列表
            [orderSubInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *orderDic = (NSDictionary *)obj;
                MineBuyorderM *orderM = [MineBuyorderM new];
                orderM.addressDetail     = [NSString stringWithFormat:@"%@",orderDic[@"addressDetail"]];
                orderM.email             = [NSString stringWithFormat:@"%@",orderDic[@"email"]];
                orderM.mobPhoneNum       = [NSString stringWithFormat:@"%@",orderDic[@"mobPhoneNum"]];
                orderM.orderSubNo        = [NSString stringWithFormat:@"%@",orderDic[@"orderSubNo"]];
                orderM.deliveryMerchantType =[NSString stringWithFormat:@"%@",orderDic[@"deliveryMerchantType"]];
                orderM.deliveryMerchantNo = [NSString stringWithFormat:@"%@",orderDic[@"deliveryMerchantNo"]];
                //实体商品列表
                NSMutableArray *shiGoodArr = [NSMutableArray array];
                NSArray *orderItemInfoList = orderDic[@"orderItemInfoList"];
                if (![NSArray isArrEmptyOrNull:orderItemInfoList]) {
                    [orderItemInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *shiGoodDic = (NSDictionary *)obj;
                        MineBuyShiGoodM *shiGoodM = [MineBuyShiGoodM new];
                        shiGoodM.isShiti = YES;
                        shiGoodM.shangpinID         = [NSString stringWithFormat:@"%@",shiGoodDic[@"id"]];
                        shiGoodM.saleNum            = [NSString stringWithFormat:@"%@",shiGoodDic[@"saleNum"]];
                        shiGoodM.unitPrice          = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitPrice"]];
                        shiGoodM.unitDiscount       = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitDiscount"]];
                        shiGoodM.itemDiscount       = [NSString stringWithFormat:@"%@",shiGoodDic[@"itemDiscount"]];
                        if ([NSString isEmptyOrNull:shiGoodDic[@"unitDeductedPrice"]])
                        {
                            shiGoodM.unitDeductedPrice  = @"未知";
                        }
                        else
                        {
                            shiGoodM.unitDeductedPrice  = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitDeductedPrice"]];
                        }
                        
                        shiGoodM.payAmount          = [NSString stringWithFormat:@"%@",shiGoodDic[@"payAmount"]];
                        shiGoodM.commodityName      = [NSString stringWithFormat:@"%@",shiGoodDic[@"commodityName"]];
                        shiGoodM.commodityId        = [NSString stringWithFormat:@"%@",shiGoodDic[@"commodityId"]];
                        shiGoodM.orderItemNo        = [NSString stringWithFormat:@"%@",shiGoodDic[@"orderItemNo"]];
                        shiGoodM.imgPath            = [NSString stringWithFormat:@"%@",shiGoodDic[@"imgPath"]];
                        [shiGoodArr addObject:shiGoodM];
                    }];
                orderM.orderItemInfoList = [shiGoodArr copy];
//                    orderM.orderList = [orderM.orderItemInfoList copy];
                orderM.phoneNum          = [NSString stringWithFormat:@"%@",orderDic[@"phoneNum"]];
                orderM.postCode          = [NSString stringWithFormat:@"%@",orderDic[@"postCode"]];
                orderM.userName          = [NSString stringWithFormat:@"%@",orderDic[@"userName"]];
                    
                if (![NSArray isArrEmptyOrNull:orderM.orderItemInfoList]) {
                    [orderArr addObject:orderM];
                }
                }
            }];
            shopM.orderSubInfoList = [orderArr copy];
        }
        
        if (![NSArray isArrEmptyOrNull:shopM.orderSubInfoList]) {
            [shopArr addObject:shopM];
        }
    }];
    
    buyshopsM.list=[shopArr copy];
    return buyshopsM;
}

- (MineBuyShopsM *)decodeMineTaunGouOrder:(NSDictionary *)dic {
    
    MineBuyShopsM *buyshopsM =[MineBuyShopsM new];
    
    buyshopsM.pageNumber =[NSString stringFromat:dic[@"pageNumber"]];
    buyshopsM.pageSize   =[NSString stringFromat:dic[@"pageSize"]];
    buyshopsM.pageCount  =[NSString stringFromat:dic[@"pageCount"]];
    NSLog(@"%d",buyshopsM.pageNumber.intValue);
    //创建商家数组
    NSMutableArray *shopArr = [NSMutableArray array];
    
    NSArray *shopList = dic[@"list"];
    if ([NSArray isArrEmptyOrNull:shopList]) {
        return buyshopsM;
    }
    
    //商家数组
    [shopList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *shopDic = (NSDictionary *)obj;
        MineBuyShopsM *shopM   = [MineBuyShopsM new];
        shopM.aliasOrderNo     = [NSString stringWithFormat:@"%@",shopDic[@"aliasOrderNo"]];
        shopM.isDeleted        = [NSString stringWithFormat:@"%@",shopDic[@"isDeleted"]];
        shopM.memberNo         = [NSString stringWithFormat:@"%@",shopDic[@"memberNo"]];
        shopM.merchantPhone    = [NSString stringWithFormat:@"%@",shopDic[@"merchantPhone"]];
        shopM.discountAmount   = [NSString stringWithFormat:@"%@",shopDic[@"discountAmount"]];
        if (![NSDictionary isDicEmptyOrNull:shopDic[@"orderRefundRecord"]])
        {
            shopM.orderRefundRecord =shopDic[@"orderRefundRecord"];
        }
        if (![NSString isEmptyOrNull:shopDic[@"merchantName"]]) {
            shopM.merchantName     = [NSString stringWithFormat:@"%@",shopDic[@"merchantName"]];
        }
        
        shopM.merchantNo       = [NSString stringWithFormat:@"%@",shopDic[@"merchantNo"]];
        shopM.orderNo          = [NSString stringWithFormat:@"%@",shopDic[@"orderNo"]];
        shopM.orderTime        = [NSString stringWithFormat:@"%@",shopDic[@"orderTime"]];
        shopM.orderTimeStr     = [NSString stringWithFormat:@"%@",shopDic[@"orderTimeStr"]];
        shopM.orderType        = [NSString stringWithFormat:@"%@",shopDic[@"orderType"]];
        shopM.payType          = [NSString stringWithFormat:@"%@",shopDic[@"payType"]];
        shopM.statusPay        = [NSString stringWithFormat:@"%@",shopDic[@"statusPay"]];
        shopM.statusTotal      = [NSString stringWithFormat:@"%@",shopDic[@"statusTotal"]];
        shopM.totalPayAmount   = [NSString stringWithFormat:@"%@",shopDic[@"totalPayAmount"]];
        shopM.transportFee     = [NSString stringWithFormat:@"%@",shopDic[@"transportFee"]];
        
        //创建订单列表
        NSMutableArray *orderArr = [NSMutableArray array];
        NSArray *orderSubInfoList = shopDic[@"orderSubInfoList"];
        
        if (![NSArray isArrEmptyOrNull:orderSubInfoList]) {
            //订单列表
            [orderSubInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *orderDic = (NSDictionary *)obj;
                MineBuyorderM *orderM = [MineBuyorderM new];
                orderM.addressDetail     = [NSString stringWithFormat:@"%@",orderDic[@"addressDetail"]];
                orderM.email             = [NSString stringWithFormat:@"%@",orderDic[@"email"]];
                orderM.mobPhoneNum       = [NSString stringWithFormat:@"%@",orderDic[@"mobPhoneNum"]];
                orderM.orderSubNo        = [NSString stringWithFormat:@"%@",orderDic[@"orderSubNo"]];
                orderM.deliveryMerchantType =[NSString stringWithFormat:@"%@",orderDic[@"deliveryMerchantType"]];
                orderM.deliveryMerchantNo = [NSString stringWithFormat:@"%@",orderDic[@"deliveryMerchantNo"]];
                //实体商品列表
                NSMutableArray *shiGoodArr = [NSMutableArray array];
                NSArray *orderItemInfoList = orderDic[@"orderItemVirtualList"];
                if (![NSArray isArrEmptyOrNull:orderItemInfoList]) {
                    [orderItemInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *shiGoodDic = (NSDictionary *)obj;
                        MineBuyShiGoodM *shiGoodM = [MineBuyShiGoodM new];
                        shiGoodM.isShiti = YES;
                        shiGoodM.shangpinID         = [NSString stringWithFormat:@"%@",shiGoodDic[@"id"]];
                        shiGoodM.orderItemVirtualNo = [NSString stringWithFormat:@"%@",shiGoodDic[@"orderItemVirtualNo"]];
                        shiGoodM.productCode        = [NSString stringWithFormat:@"%@",shiGoodDic[@"productCode"]];
                        shiGoodM.saleNum            = [NSString stringWithFormat:@"%@",shiGoodDic[@"saleNum"]];
                        shiGoodM.unitPrice          = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitPrice"]];
                        shiGoodM.saleAmount         = [NSString stringWithFormat:@"%@",shiGoodDic[@"saleAmount"]];
                        shiGoodM.checkCode          = [NSString stringWithFormat:@"%@",shiGoodDic[@"checkCode"]];
                        shiGoodM.barCode            = [NSString stringWithFormat:@"%@",shiGoodDic[@"barCode"]];
                        shiGoodM.startDate          = [NSString stringWithFormat:@"%@",shiGoodDic[@"startDate"]];
                        shiGoodM.endDate            = [NSString stringWithFormat:@"%@",shiGoodDic[@"endDate"]];
                        shiGoodM.validityDate       = [NSString stringWithFormat:@"%@",shiGoodDic[@"validityDate"]];
                        if (![NSDictionary isDicEmptyOrNull:shiGoodDic[@"orderRefundRecord"]])
                        {
                            shiGoodM.orderRefundRecord =shiGoodDic[@"orderRefundRecord"];
                        }
                        if ([NSString isEmptyOrNull:shiGoodDic[@"unitDeductedPrice"]])
                        {
                            shiGoodM.unitDeductedPrice  = @"未知";
                        }
                        else
                        {
                            shiGoodM.unitDeductedPrice  = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitDeductedPrice"]];
                        }
                        shiGoodM.productName       = [NSString stringWithFormat:@"%@",shiGoodDic[@"productName"]];
                        shiGoodM.imgPath            = [NSString stringWithFormat:@"%@",shiGoodDic[@"imgPath"]];
                        
                        [shiGoodArr addObject:shiGoodM];
                    }];
                    orderM.orderItemInfoList = [shiGoodArr copy];
                    //                    orderM.orderList = [orderM.orderItemInfoList copy];
                    orderM.phoneNum          = [NSString stringWithFormat:@"%@",orderDic[@"phoneNum"]];
                    orderM.postCode          = [NSString stringWithFormat:@"%@",orderDic[@"postCode"]];
                    orderM.userName          = [NSString stringWithFormat:@"%@",orderDic[@"userName"]];
                    
                    if (![NSArray isArrEmptyOrNull:orderM.orderItemInfoList]) {
                        [orderArr addObject:orderM];
                    }
                }
            }];
            shopM.orderSubInfoList = [orderArr copy];
        }
        
        if (![NSArray isArrEmptyOrNull:shopM.orderSubInfoList]) {
            [shopArr addObject:shopM];
        }
    }];
    
    buyshopsM.list=[shopArr copy];
    return buyshopsM;
}


+(NSString *)shopDinDanState:(NSString *)statusPayStr
{
    if ([statusPayStr isEqualToString:@"0130"] )
    {
        return @"待付款";
    }
    else if ([statusPayStr isEqualToString:@"0131"])
    {
        return @"已取消";
    }
    else if ([statusPayStr isEqualToString:@"0120"])
    {
        return @"待发货";
    }
    else if ([statusPayStr isEqualToString:@"0170"])
    {
        return @"待收货";
    }
    else if ([statusPayStr isEqualToString:@"0180"])
    {
        return @"待评价";
    }
    else if ([statusPayStr isEqualToString:@"0182"])
    {
        return @"已评价";
    }
    else if ([statusPayStr isEqualToString:@"0172"])
    {
        return @"退款驳回";
    }
    else if ([statusPayStr isEqualToString:@"0173"])
    {
        return @"订单退款中";
    }
    else if ([statusPayStr isEqualToString:@"0174"])
    {
         return @"订单退款完成";
    }
    return nil;
}
+(NSString *)grouponDinDanState:(NSString *)statusPayStr
{
    if ([statusPayStr isEqualToString:@"0130"] )
    {
        return @"待付款";
    }
    else if ([statusPayStr isEqualToString:@"0131"])
    {
        return @"已取消";
    }
    else if ([statusPayStr isEqualToString:@"0132"])
    {
        return @"已失效";
    }
    else if ([statusPayStr isEqualToString:@"0120"])
    {
        return @"可使用";
    }
    else if ([statusPayStr isEqualToString:@"0180"])
    {
        return @"待评价";
    }
    else if ([statusPayStr isEqualToString:@"0182"])
    {
        return @"已评价";
    }
    else if ([statusPayStr isEqualToString:@"0183"])
    {
        return @"已退款";
    }
    else if ([statusPayStr isEqualToString:@"0184"])
    {
        return @"部分退款";
    }
    else if ([statusPayStr isEqualToString:@"0185"])
    {
        return @"订单退款中";
    }
    return nil;
}


@end
