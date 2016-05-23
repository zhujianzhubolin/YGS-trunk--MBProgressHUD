//
//  SearchOrderDetailHandel.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SearchOrderDetailHandel.h"
#import "MineBuyShopsM.h"
#import "MineBuyorderM.h"
#import "MineBuyShiGoodM.h"
@implementation SearchOrderDetailHandel

- (void)SearchOrderDetail:(OrderSearchModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * queryMapDic = [NSMutableDictionary dictionary];
    [queryMapDic setObject:model.OrderNo forKey:@"orderNo"];

    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDic forKey:@"queryMap"];

    NSLog(@"%@",upLoadDict);//@"正在加载..."
    
    [AppUtils showProgressMessage:@"正在加载..."];
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineBuyList] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"返回>>>%@",dic);
        
        [SVProgressHUD dismiss];
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success([self decodeMineAllOrder:dic]);
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}

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
    
    NSLog(@">>>>>%@",shopList);
    
    
    //商家数组
    [shopList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *shopDic = (NSDictionary *)obj;
        MineBuyShopsM *shopM   = [MineBuyShopsM new];
        shopM.aliasOrderNo     = [NSString stringWithFormat:@"%@",shopDic[@"aliasOrderNo"]];
        shopM.isDeleted        = [NSString stringWithFormat:@"%@",shopDic[@"isDeleted"]];
        shopM.memberNo         = [NSString stringWithFormat:@"%@",shopDic[@"memberNo"]];
        shopM.merchantName     = [NSString stringWithFormat:@"%@",shopDic[@"merchantName"]];
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
        
        if ([NSArray isArrEmptyOrNull:orderSubInfoList]) {
            shopM.orderSubInfoList = [shopArr copy];
        }
        else {
            //订单列表
            [orderSubInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *orderDic = (NSDictionary *)obj;
                MineBuyorderM *orderM = [MineBuyorderM new];
                orderM.addressDetail     = [NSString stringWithFormat:@"%@",orderDic[@"addressDetail"]];
                orderM.email             = [NSString stringWithFormat:@"%@",orderDic[@"email"]];
                orderM.mobPhoneNum       = [NSString stringWithFormat:@"%@",orderDic[@"mobPhoneNum"]];
                orderM.orderSubNo        = [NSString stringWithFormat:@"%@",orderDic[@"orderSubNo"]];
                
                //实体商品列表
                NSMutableArray *shiGoodArr = [NSMutableArray array];
                NSArray *orderItemInfoList = orderDic[@"orderItemInfoList"];
                if ([NSArray isArrEmptyOrNull:orderItemInfoList]) {
                    orderM.orderItemInfoList = [shiGoodArr copy];
                }
                else
                {
                    [orderItemInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *shiGoodDic = (NSDictionary *)obj;
                        MineBuyShiGoodM *shiGoodM = [MineBuyShiGoodM new];
                        shiGoodM.isShiti = YES;
                        shiGoodM.shangpinID         = [NSString stringWithFormat:@"%@",shiGoodDic[@"id"]];
                        shiGoodM.saleNum            = [NSString stringWithFormat:@"%@",shiGoodDic[@"saleNum"]];
                        shiGoodM.unitPrice          = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitPrice"]];
                        shiGoodM.unitDiscount       = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitDiscount"]];
                        shiGoodM.itemDiscount       = [NSString stringWithFormat:@"%@",shiGoodDic[@"itemDiscount"]];
                        shiGoodM.unitDeductedPrice  = [NSString stringWithFormat:@"%@",shiGoodDic[@"unitDeductedPrice"]];
                        shiGoodM.payAmount          = [NSString stringWithFormat:@"%@",shiGoodDic[@"payAmount"]];
                        shiGoodM.commodityName      = [NSString stringWithFormat:@"%@",shiGoodDic[@"commodityName"]];
                        shiGoodM.orderItemNo        = [NSString stringWithFormat:@"%@",shiGoodDic[@"orderItemNo"]];
                        [shiGoodArr addObject:shiGoodM];
                    }];
                    orderM.orderItemInfoList = [shiGoodArr copy];
                }
                
                
//                orderM.orderList = [orderM.orderItemInfoList copy];
                
                orderM.phoneNum          = [NSString stringWithFormat:@"%@",orderDic[@"phoneNum"]];
                orderM.postCode          = [NSString stringWithFormat:@"%@",orderDic[@"postCode"]];
                orderM.userName          = [NSString stringWithFormat:@"%@",orderDic[@"userName"]];
                [orderArr addObject:orderM];
            }];
            shopM.orderSubInfoList = [orderArr copy];
        }
        [shopArr addObject:shopM];
    }];
    
    buyshopsM.list=[shopArr copy];
    return buyshopsM;
}

@end
