//
//  LieBiaoHandel.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentOrIdleH.h"

@implementation RentOrIdleH
- (instancetype)init {
    self = [super init];
    if (self) {
        self.idleSellPNumber = @"1";
        self.idleSellPCount =  @"1";
        self.idleSellArr = [NSMutableArray array];
        self.isIdleSellNeedUpdate = YES;
        
        self.idleBuyPNumber = @"1";
        self.idleBuyPCount =  @"1";
        self.idleBuyArr = [NSMutableArray array];
        self.isIdleBuyNeedUpdate = YES;
        
        self.rentBuyHousePNumber = @"1";
        self.rentBuyHousePCount =  @"1";
        self.rentBuyHouseArr = [NSMutableArray array];
        self.isRentBuyHouseNeedUpdate = YES;
        
        self.rentRentHousePNumber = @"1";
        self.rentRentHousePCount =  @"1";
        self.rentRentHouseArr = [NSMutableArray array];
        self.isRentRentHouseNeedUpdate = YES;
        
        self.rentWantedRentPNumber = @"1";
        self.rentWantedRentPCount =  @"1";
        self.rentWantedRentArr = [NSMutableArray array];
        self.isRentWantedRentNeedUpdate = YES;
    }
    return self;
}

//跳蚤市场出售
- (void)excuteRequestIdelForSell:(RentOrIdleM *)model
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed
                        isHeader:(BOOL)isheader{

    if (isheader) {
        self.idleSellPNumber = @"1";
        self.idleSellPCount =  @"1";
    }
    else {
        if (self.idleSellPNumber.integerValue > self.idleSellPCount.integerValue) {
            success(self.idleSellArr);
            return;
        }
        self.idleSellPNumber = [NSString stringWithFormat:@"%d",self.idleSellPNumber.integerValue + 1];
    }
    
    NSDictionary *queryMapDic = @{@"status":model.status,
                                  @"type":model.type,
                                  @"fleaMarketType":model.fleaMarketType,
                                  @"wyNo":model.wyNo,@"version":model.version};
    
    NSDictionary *paraDic = @{@"pageNumber":self.idleSellPNumber,
                              @"pageSize":model.pageSize,
                              @"orderBy":model.orderBy,
                              @"orderType":model.orderType,
                              @"queryMap":queryMapDic};

    NSLog(@"excuteRequestIdelForSell paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"excuteRequestIdelForSell recvDic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
//            self.idleSellPCount = recvM.pageCount;
            self.idleSellPCount = recvDic[@"pageCount"];
            
            
            if (isheader) {
//                self.idleSellArr = [recvM.list mutableCopy];
                self.idleSellArr = [recvDic[@"list"] mutableCopy];
            }
            else {
                [recvDic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.idleSellArr addObject:obj];
                }];
            }
            success(self.idleSellArr);
            return;
        }
        failed(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
    }];
}

//跳蚤市场求购
- (void)excuteRequestIdelForWantedBuy:(RentOrIdleM *)model
                              success:(SuccessBlock)success
                               failed:(FailedBlock)failed
                             isHeader:(BOOL)isheader {
    
    if (isheader) {
        self.idleBuyPNumber = @"1";
        self.idleBuyPCount =  @"1";
    }
    else {
        if (self.idleBuyPNumber.integerValue > self.idleBuyPCount.integerValue) {
            success(self.idleBuyArr);
            return;
        }
        self.idleBuyPNumber = [NSString stringWithFormat:@"%d",self.idleBuyPNumber.integerValue + 1];
    }
    
    NSDictionary *queryMapDic = @{@"status":model.status,
                                  @"type":model.type,
                                  @"fleaMarketType":model.fleaMarketType,
                                  @"wyNo":model.wyNo,@"version":model.version};
    
    NSDictionary *paraDic = @{@"pageNumber":self.idleBuyPNumber,
                              @"pageSize":model.pageSize,
                              @"orderBy":model.orderBy,
                              @"orderType":model.orderType,
                              @"queryMap":queryMapDic};
    
    NSLog(@"excuteRequestIdelForWantedBuy paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"excuteRequestIdelForWantedBuy recvDic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            //            self.idleBuyPCount = recvM.pageCount;
            self.idleBuyPCount = recvDic[@"pageCount"];
            if (isheader) {
                //                self.idleBuyArr = [recvM.list mutableCopy];
                self.idleBuyArr = [recvDic[@"list"] mutableCopy];
            }
            else {
                [recvDic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.idleBuyArr addObject:obj];
                }];
            }
            success(self.idleBuyArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
    }];
}

//房屋租售－买房
- (void)excuteRequestRentBuyHouseForModel:(RentOrIdleM *)model
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed
                                 isHeader:(BOOL)isheader {
    if (isheader) {
        self.rentBuyHousePNumber = @"1";
        self.rentBuyHousePCount =  @"1";
    }
    else {
        if (self.rentBuyHousePNumber.integerValue > self.rentBuyHousePCount.integerValue) {
            success(self.rentBuyHouseArr);
            return;
        }
        self.rentBuyHousePNumber = [NSString stringWithFormat:@"%d",self.rentBuyHousePNumber.integerValue + 1];
    }
    
    NSDictionary *queryMapDic = @{@"status":model.status,
                                  @"type":model.type,
                                  @"transactionType":model.transactionType,
                                  @"wyNo":model.wyNo};
    
    NSDictionary *paraDic = @{@"pageNumber":self.rentBuyHousePNumber,
                              @"pageSize":model.pageSize,
                              @"orderBy":model.orderBy,
                              @"orderType":model.orderType,
                              @"queryMap":queryMapDic};
    
    NSLog(@"excuteRequestRentBuyHouseForModel paraDic = %@",paraDic);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"excuteRequestRentBuyHouseForModel recvDic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            //            self.rentBuyHousePCount = recvM.pageCount;
            self.rentBuyHousePCount = recvDic[@"pageCount"];
            if (isheader) {
                //                self.rentBuyHouseArr = [recvM.list mutableCopy];
                self.rentBuyHouseArr = [recvDic[@"list"] mutableCopy];
            }
            else {
                [recvDic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.rentBuyHouseArr addObject:obj];
                }];
            }
            success(self.rentBuyHouseArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}

//房屋租售－租房
- (void)excuteRequestRentRentHouseForModel:(RentOrIdleM *)model
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader {
    if (isheader) {
        self.rentRentHousePNumber = @"1";
        self.rentRentHousePCount =  @"1";
    }
    else {
        if (self.rentRentHousePNumber.integerValue > self.rentRentHousePCount.integerValue) {
            success(self.rentRentHouseArr);
            return;
        }
        self.rentRentHousePNumber = [NSString stringWithFormat:@"%d",self.rentRentHousePNumber.integerValue + 1];
    }
    
    NSDictionary *queryMapDic = @{@"status":model.status,
                                  @"type":model.type,
                                  @"transactionType":model.transactionType,
                                  @"wyNo":model.wyNo};
    
    NSDictionary *paraDic = @{@"pageNumber":self.rentRentHousePNumber,
                              @"pageSize":model.pageSize,
                              @"orderBy":model.orderBy,
                              @"orderType":model.orderType,
                              @"queryMap":queryMapDic};
    
    NSLog(@"excuteRequestRentRentHouseForModel paraDic = %@",paraDic);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"excuteRequestRentRentHouseForModel recvDic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            //            self.rentRentHousePCount = recvM.pageCount;
            self.rentRentHousePCount = recvDic[@"pageCount"];
            if (isheader) {
                //                self.rentRentHouseArr = [recvM.list mutableCopy];
                self.rentRentHouseArr = [recvDic[@"list"] mutableCopy];
            }
            else {
                [recvDic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.rentRentHouseArr addObject:obj];
                }];
            }
            success(self.rentRentHouseArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}

//房屋租售－求租
- (void)excuteRequestRentWantedRentForModel:(RentOrIdleM *)model
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed
                                   isHeader:(BOOL)isheader {
    if (isheader) {
        self.rentWantedRentPNumber = @"1";
        self.rentWantedRentPCount =  @"1";
    }
    else {
        if (self.rentWantedRentPNumber.integerValue > self.rentWantedRentPCount.integerValue) {
            success(self.rentWantedRentArr);
            return;
        }
        self.rentWantedRentPNumber = [NSString stringWithFormat:@"%d",self.rentWantedRentPNumber.integerValue + 1];
    }
    
    NSDictionary *queryMapDic = @{@"status":model.status,
                                  @"type":model.type,
                                  @"transactionType":model.transactionType,
                                  @"wyNo":model.wyNo};
    
    NSDictionary *paraDic = @{@"pageNumber":self.rentWantedRentPNumber,
                              @"pageSize":model.pageSize,
                              @"orderBy":model.orderBy,
                              @"orderType":model.orderType,
                              @"queryMap":queryMapDic};
    
    NSLog(@"excuteRequestRentRentHouseForModel paraDic = %@",paraDic);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"excuteRequestRentRentHouseForModel recvDic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            //            self.rentWantedRentPCount = recvM.pageCount;
            self.rentWantedRentPCount = recvDic[@"pageCount"];
            if (isheader) {
                //                self.rentWantedRentArr = [recvM.list mutableCopy];
                self.rentWantedRentArr = [recvDic[@"list"] mutableCopy];
            }
            else {
                [recvDic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.rentWantedRentArr addObject:obj];
                }];
            }
            success(self.rentWantedRentArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}
@end
