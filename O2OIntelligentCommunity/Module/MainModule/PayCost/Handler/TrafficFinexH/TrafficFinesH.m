//
//  TrafficFinesH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TrafficFinesH.h"
#import "WeChatPayClass.h"
#import "AppDelegate.h"
#import "TrafficCityModel.h"    

@implementation TrafficFinesH

//查询对应缴费省所包含的市
- (void)ZJ_requestForGetTrafficProvinceIncludeCitiesWithPara:(id)paraDic
                                                     success:(SuccessBlock)success
                                                      failed:(FailedBlock)failed {
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP
                                                                            WithPort:A_PORT_SUP
                                                                            WithPath:API_TRAFFIC_PROVINCE_INCLUDE_CITIES]
                                         requestType:ZJHttpRequestGet
                                          parameters:paraDic
                                      prepareExecute:^{
                                          
      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
          NSLog(@"dic_json = %@",dic_json);
          if (![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
              id recvM = [self decodeProvinceIncludeCities:dic_json];
              success(recvM);
              return;
          }
          failed([NSString stringFromat:dic_json[@"message"]]);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failed(W_ALL_FAIL_GET_DATA);
          NSLog(@"request failed = %@",error);
      }];
}

- (id)decodeProvinceIncludeCities:(NSDictionary *)jsonDic {
    NSArray *list = jsonDic[@"list"];
    
    NSMutableArray *recvArr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:list]) {
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *cityDic = obj;
            TrafficCityModel *cityM = [TrafficCityModel new];
            cityM.city = [NSString stringFromat:cityDic[@"city"]];
            [recvArr addObject:cityM];
        }];
    }
    return recvArr;
}

//查询所有可缴费省
- (void)ZJ_requestForGetAllTrafficProvinceWithsuccess:(SuccessBlock)success
                                               failed:(FailedBlock)failed {
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP
                                                                            WithPort:A_PORT_SUP
                                                                            WithPath:API_TRAFFIC_ALLPROVINCE]
                                         requestType:ZJHttpRequestGet
                                          parameters:nil
                                      prepareExecute:^{
                                          
      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
          NSLog(@"dic_json = %@",dic_json);
          if (![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
              id recvM = [self decodeAllTrafficProvince:dic_json];
              success(recvM);
              return;
          }
          failed([NSString stringFromat:dic_json[@"message"]]);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failed(W_ALL_FAIL_GET_DATA);
          NSLog(@"request failed = %@",error);
      }];
}

- (id)decodeAllTrafficProvince:(NSDictionary *)jsonDic {
    NSArray *list = jsonDic[@"list"];
    
    NSMutableArray *recvArr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:list]) {
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *provinceDic = obj;
            TrafficCityModel *cityM = [TrafficCityModel new];
            cityM.province = [NSString stringFromat:provinceDic[@"province"]];
            [recvArr addObject:cityM];
        }];
    }
    
    return [recvArr copy];
}

- (void)ZJ_requestForGetCurrentTrafficCityWithPara:(id)paraDic
                                           success:(SuccessBlock)success
                                            failed:(FailedBlock)failed {
    NSLog(@"ZJ_requestForGetTrafficCitiesWithParaw paraDic = %@",paraDic);
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP
                                                                            WithPort:A_PORT_SUP
                                                                            WithPath:API_TRAFFIC_CITY]
                                         requestType:ZJHttpRequestGet
                                          parameters:paraDic
                                      prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if (![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            id recvM = [self decodeTrafficCity:dic_json];
            success(recvM);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (id)decodeTrafficCity:(NSDictionary *)jsonDic {
    TrafficCityModel *cityM = [TrafficCityModel new];
    cityM.city = [NSString stringFromat:jsonDic[@"city"]];
    cityM.province = [NSString stringFromat:jsonDic[@"province"]];
    return cityM;
};
            
- (void)executeGetTrafficFinesTaskWithUser:(TrafficOrderE *)trafficE
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             trafficE.carnumber,@"carnumber",
                             trafficE.carcode,@"carcode",
                             trafficE.cardrivenumber,@"cardrivenumber",
                             nil];
    NSLog(@"GetTrafficFines paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP
                                                                            WithPort:A_PORT_SUP
                                                                            WithPath:API_TRAFFIC_ORDER]
                                         requestType:ZJHttpRequestGet
                                          parameters:paraDic
                                      prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSArray *trafficArr = [self decodeTrafficFinesList:dic_json];
            if (trafficArr.count > 0) {
                success(trafficArr);
                return;
            }
        }
        failed(W_TRAFFIC_QUERING);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (NSArray *)decodeTrafficFinesList:(NSDictionary *)dicJson {
    NSMutableArray *recvArr = [NSMutableArray array];
    NSArray *listArr = dicJson[@"list"];
    if (![NSArray isArrEmptyOrNull:listArr] && listArr.count > 0) {
        [listArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            TrafficOrderE *trafficE = [TrafficOrderE new];
            trafficE.time               = recvDic[@"Time"];
            trafficE.code               = recvDic[@"Code"];
            trafficE.location           = recvDic[@"Location"];
            trafficE.reason             = recvDic[@"Reason"];
            trafficE.count              = recvDic[@"count"];
            trafficE.Degree             = recvDic[@"Degree"];
            trafficE.poundage           = recvDic[@"Poundage"];
            trafficE.canProcess         = recvDic[@"CanProcess"];
            trafficE.SecondaryUniqueCode = recvDic[@"SecondaryUniqueCode"];
            trafficE.Archive            = recvDic[@"Archive"];
            trafficE.LocationName       = recvDic[@"LocationName"];
            [recvArr addObject:trafficE];
        }];
    }
    return [recvArr copy];
}


//获取车架号和发动机号的位数
- (void)executeGetTrafficCarBitsTaskWithUser:(TrafficCarBitsE *)trafficBitsE
                                     success:(SuccessBlock)success
                                      failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             trafficBitsE.province,@"province",
                             trafficBitsE.city,@"city",
                             nil];
    NSLog(@"GetTrafficCarBits paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_TRAFFIC_CAR_BITS] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"GetTrafficCarBitsdic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] &&
            success &&
            ![NSString isEmptyOrNull:dic_json[@"code"]] &&
            [dic_json[@"code"] isEqualToString:@"success"]) {
            success([self decodeTrafficCarBitsWithJson:dic_json]);
            return;
        }
        failed(@"未查询车辆相应信息");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (TrafficCarBitsE *)decodeTrafficCarBitsWithJson:(NSDictionary *)dic_json {
    TrafficCarBitsE *carBitsE = [TrafficCarBitsE new];
    carBitsE.carCodeLen = dic_json[@"carCodeLen"];
    carBitsE.carEngineLen = dic_json[@"carEngineLen"];
    return carBitsE;
}

@end
