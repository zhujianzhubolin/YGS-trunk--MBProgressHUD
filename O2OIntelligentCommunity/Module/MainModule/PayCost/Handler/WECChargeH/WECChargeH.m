//
//  WECChargeH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "WECChargeH.h"
#import "NSDictionary+wrapper.h"

@implementation WECChargeH

- (void)executeChaXunShoufeiDanWeiTaskWithUser:(WECChargeE *)chargeE
                               success:(SuccessBlock)success
                                failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             chargeE.sdmType,@"sdmType",
                             chargeE.areaCity,@"areaCity",
                             nil];
    NSLog(@"ChaXunShoufeiDanWei 1paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_CHAXUN_UNIT] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_Json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_Json = %@",dic_Json);
        if ([NSJSONSerialization isValidJSONObject:dic_Json] && success) {
            if (![NSString isEmptyOrNull:dic_Json[@"code"]] && [dic_Json[@"code"] isEqualToString:@"success"]) {
                success([self decodeShouFeiDanWeiDic:dic_Json]);
                return;
            }
        }
        failed([NSString stringFromat:dic_Json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (NSArray *)decodeShouFeiDanWeiDic:(NSDictionary *)dicJson {
    NSMutableArray *arr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]]) {
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            WECChargeE *chargeE = [WECChargeE new];
            chargeE.BizIncrSdmTestid = recvDic[@"BizIncrSdmTestid"];
            chargeE.BizIncrSdmTestname = recvDic[@"BizIncrSdmTestname"];
            [arr addObject:chargeE];
        }];
    }
    return [arr copy];
}

//查询缴费订单
- (void)executeChaXunShoufeiOrderTaskWithUser:(WECChargeE *)chargeE
                                      success:(SuccessBlock)success
                                       failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             chargeE.sdmType,@"sdmType",
                             chargeE.consNo,@"consNo",
                             chargeE.sdmCompanyId,@"sdmCompanyId",
                             chargeE.areaCity,@"areaCity",
                             nil];
    NSLog(@"ChaXunShoufeiOrder paraDic = %@",paraDic);

    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_WATER_ELEC_COAR_ORDER] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_Json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"executeChaXunShoufeiOrderTaskWithUser dic_Json = %@",dic_Json);
        if ([NSJSONSerialization isValidJSONObject:dic_Json] &&
            success &&
            ![NSString isEmptyOrNull:dic_Json[@"code"]] && [dic_Json[@"code"] isEqualToString:@"success"] ){
            success([self decodeShoufeiOrder:dic_Json]);
            return;
        }
        
        NSString *message = dic_Json[@"message"];
        if ([NSString isEmptyOrNull:message]) {
            failed(W_ALL_FAIL_GET_DATA);
        }
        else {
            failed(message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (WECChargeE *)decodeShoufeiOrder:(NSDictionary *)jsonDic {
    WECChargeE *wecE = [WECChargeE new];
    NSDictionary *beanDic = jsonDic[@"bean"];
    if (![NSDictionary isDicEmptyOrNull:beanDic]) {
        wecE.sdmMoney       = beanDic[@"sdmMoney"];
        wecE.sdmName        = beanDic[@"sdmName"];
        wecE.prepaIdFlag    = beanDic[@"prepaIdFlag"];
        wecE.sdmRemarks     = beanDic[@"sdmRemarks"];
        wecE.contNo         = beanDic[@"contNo"];
        wecE.contentNo      = beanDic[@"contentNo"];
        wecE.address        = beanDic[@"address"];
        wecE.prepayBal      = beanDic[@"prepayBal"];
    }

    return wecE;
}
@end
