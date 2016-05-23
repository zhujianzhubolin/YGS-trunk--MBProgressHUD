//
//  PropertyChargeH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PropertyChargeH.h"
#import "PropertyShowM.h"

@implementation PropertyChargeH

- (void)executeGetPropertyOrderTaskWithUser:(PropertyChargeE *)propertyE
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             propertyE.membenInfoPid,@"membenInfoPid",
//                             propertyE.consumeType,@"consumeType",
                             propertyE.xqNo,@"xqNo",
                             propertyE.wyID,@"wyNo",
                             propertyE.buildNo,@"buildNo",
                             propertyE.unitNo,@"unitNo",
                             propertyE.houseNo,@"houseNo",
                             propertyE.cityNo,@"cityNo",
//                             propertyE.STATUS,@"STATUS",
//                             propertyE.pageNumber,@"pageNumber",
//                             propertyE.pageSize,@"pageSize",
                             
                             nil];
    NSLog(@"GetPropertyOrder paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_PRO_PROPERTY_ORDER] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSArray *propertyArr = [self decodePropertyChargeInfo:dic_json];
            if (propertyArr.count > 0) {
                success(propertyArr);
                return;
            }
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (NSArray *)decodePropertyChargeInfo:(NSDictionary *)dicJson {
    NSMutableArray *recvArr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:dicJson[@"wt"]]) {
        [dicJson[@"wt"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            PropertyChargeE *propertyE = [PropertyChargeE new];
            
            propertyE.endDate           = [NSString stringFromat:recvDic[@"endDate"]];
            propertyE.domesticWasteFee  = [NSString stringFromat:recvDic[@"domesticWasteFee"]];
            propertyE.ontologyGold      = [NSString stringFromat:recvDic[@"ontologyGold"]];
            propertyE.dischargeFee      = [NSString stringFromat:recvDic[@"dischargeFee"]];
            propertyE.managementFee     = [NSString stringFromat:recvDic[@"managementFee"]];
            propertyE.electricity       = [NSString stringFromat:recvDic[@"electricity"]];
            propertyE.water             = [NSString stringFromat:recvDic[@"water"]];
            propertyE.coal              = [NSString stringFromat:recvDic[@"coal"]];
            propertyE.ids               = [NSString stringFromat:recvDic[@"id"]];
            propertyE.overdueFine       = [NSString stringFromat:recvDic[@"overdueFine"]];
            propertyE.saleAmount        = [NSString stringFromat:recvDic[@"saleAmount"]];
            propertyE.chargeUnit        = [NSString stringFromat:recvDic[@"chargeUnit"]];
            [recvArr addObject:propertyE];
        }];
    }
    return [recvArr copy];
}


- (void)executeGetParkingTypeTaskWithUser:(PropertyChargeE *)parkingE
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             parkingE.xqNo,@"xqNo",
                             parkingE.wyID,@"wyNo",
                             parkingE.cityNo,@"cityNo",
                             parkingE.licenseNumber,@"licenseNumber",
                             nil];
    NSLog(@"GetParkingType paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_PRO_PARK_ORDER] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            PropertyChargeE *propertyE = [self decodeParkingChargeInfo:dic_json];
            if (propertyE.monthlyFee.floatValue > 0) {
                success(propertyE);
                return;
            }
        }
        failed(W_PARK_NO_CAR_NUM);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (PropertyChargeE *)decodeParkingChargeInfo:(NSDictionary *)dicJson {
    NSDictionary *bwtDic = dicJson[@"map"];
    PropertyChargeE *propertyE = [PropertyChargeE new];
    
    if (![NSDictionary isDicEmptyOrNull:bwtDic]) {
        propertyE.monthlyFee    = [NSString stringFromat:bwtDic[@"monthlyFee"]];
        propertyE.parkingType   = [NSString stringFromat:bwtDic[@"parkingType"]];
        propertyE.infoNo        = [NSString stringFromat:bwtDic[@"id"]];
    }

    return propertyE;
}

#ifdef SmartComJYZX
//获取物业费订单
- (void)requestForPropertyCostsOrdersWithPara:(NSDictionary *)paraDic
                                      success:(SuccessBlock)success
                                       failed:(FailedBlock)failed {
    NSLog(@"paraDic = %@",[NSString jsonStringWithDictionary:paraDic]);
    NSString *requesstURL = [BaseHandler requestUrlWithHost:A_HOST_SUP
                                                   WithPort:A_PORT_SUP
                                                   WithPath:API_PRO_PROPERTY_ORDER];
    [[NetworkRequest defaultRequest] requestWithPath:requesstURL
                                         requestType:ZJHttpRequestGet
                                          parameters:paraDic
                                      prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            success &&
            ![NSString isEmptyOrNull:dic_json[@"code"]] &&
            [dic_json[@"code"] isEqualToString:@"success"]) {
            
            PropertyShowM *showM = [PropertyShowM new];
            showM.message = dic_json[@"message"];
            showM.chargeArr = [self decodePropertyChargeInfo:dic_json];
            success(showM);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

#elif SmartComYGS

#else

#endif
@end
