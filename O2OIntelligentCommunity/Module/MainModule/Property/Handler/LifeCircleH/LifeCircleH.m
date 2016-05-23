//
//  LifeCircleH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "LifeCircleH.h"

@implementation LifeCircleH

- (id)init {
    self = [super init];
    if (self) {
        self.aroundPNumber = @"1";
        self.aroundPCount =  @"1";
        self.aroundArr = [NSMutableArray array];
        self.isAroundNeedUpdate = YES;
        
        self.publicPNumber= @"1";
        self.publicPCount = @"1";
        self.publicArr = [NSMutableArray array];
        self.isPublicNeedUpdate = YES;
    }
    return self;
}

//获取生活圈商家分类
-(void)requestStoreCloseWithModel:(LifeCircleE *)circleE
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed
{
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:StoreCloseRequest] requestType:ZJHttpRequestGet parameters:nil prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"requestForAroundMerchantsWithModelPara recvdic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            
            NSArray *array =[self storeList:recvDic];
            success(array);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"error = %@",error);
    }];

}

-(NSArray *)storeList:(NSDictionary *)circleJson
{
    NSArray *listArr = circleJson[@"list"];
    if (![NSArray isArrEmptyOrNull:listArr]) {
        NSMutableArray *circleArr = [NSMutableArray array];
        [listArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *shopDic = obj;
            LifeCircleE *merchantE = [LifeCircleE new];
            merchantE.ID              = shopDic[@"id"];
            merchantE.name             = [NSString stringFromat:shopDic[@"name"]];
            
            [circleArr addObject:merchantE];
        }];
        listArr =[circleArr mutableCopy];
    }
    return listArr;

}

//获取生活圈周边商家信息
- (void)requestForAroundMerchantsWithModel:(LifeCircleE *)circleE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader {
    if (isheader) {
        self.aroundPNumber = @"1";
        self.aroundPCount =  @"1";
    }
    else {
        if (self.aroundPNumber.integerValue > self.aroundPCount.integerValue) {
            success(self.aroundArr);
            return;
        }
        self.aroundPNumber = [NSString stringWithFormat:@"%d",self.aroundPNumber.integerValue + 1];
    }
    
    circleE.pageNumber = self.aroundPNumber;
    
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:circleE.pageNumber,@"pageNumber",
                                                                       circleE.pageSize,@"pageSize",
                                                                       circleE.queryMap,@"queryMap",
                                                                        nil];
    NSLog(@"requestForAroundMerchantsWithModelPara paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLEASYSHOP] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"requestForAroundMerchantsWithModelPara recvdic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            LifeCircleE *recvCircleM =[self decodeLifeCircleWithJson:recvDic];
            self.aroundPCount = recvCircleM.pageCount;
            
            if (isheader) {
                self.aroundArr = [recvCircleM.list mutableCopy];
            }
            else {
                [recvCircleM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLog(@"obj = %@,index = %d",obj,idx);
                    [self.aroundArr addObject:obj];
                }];
            }
            success(self.aroundArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"error = %@",error);
    }];
}

//获取生活圈便民服务信息
- (void)requestForPublicServiceWithModel:(LifeCircleE *)circleE
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed
                                isHeader:(BOOL)isheader {
    if (isheader) {
        self.publicPNumber = @"1";
        self.publicPCount =  @"1";
    }
    else {
        if (self.publicPNumber.integerValue > self.publicPCount.integerValue) {
            success(self.publicArr);
            return;
        }
        self.publicPNumber = [NSString stringWithFormat:@"%d",self.publicPNumber.integerValue + 1];
    }
    
    circleE.pageNumber = self.publicPNumber;
    
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:circleE.pageNumber,@"pageNumber",
                             circleE.pageSize,@"pageSize",
                             circleE.queryMap,@"queryMap",
                             nil];
    NSLog(@"requestForPublicServiceWithModelPara paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLEASYSHOP] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"requestForPublicServiceWithModelPara recvdic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            LifeCircleE *recvCircleM =[self decodeLifeCircleWithJson:recvDic];
            self.publicPCount = recvCircleM.pageCount;
            
            if (isheader) {
                self.publicArr = [recvCircleM.list mutableCopy];
            }
            else {
                [recvCircleM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.publicArr addObject:obj];
                }];
            }
            success(self.publicArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"error = %@",error);
    }];
}

//搜索获取周边信息
- (void)requestForSearchWithModel:(LifeCircleE *)circleE
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:circleE.pageNumber,@"pageNumber",
                             circleE.pageSize,@"pageSize",
                             circleE.queryMap,@"queryMap",
                             nil];
    NSLog(@"requestForSearchWithModel paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ALLEASYSHOP] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"requestForSearchWithModel recvdic = %@",recvDic);
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success) {
            LifeCircleE *recvCircleM =[self decodeLifeCircleWithJson:recvDic];
            success(recvCircleM.list);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"error = %@",error);
    }];
}

- (LifeCircleE *)decodeLifeCircleWithJson:(NSDictionary *)jsonDic {
    LifeCircleE *circleE = [LifeCircleE new];
    circleE.pageNumber    =jsonDic[@"pageNumber"];
    circleE.pageSize      =jsonDic[@"pageSize"];
    circleE.pageCount     =jsonDic[@"pageCount"];
    NSArray *listArr = jsonDic[@"list"];
    if (![NSArray isArrEmptyOrNull:listArr]) {
        NSMutableArray *circleArr = [NSMutableArray array];
        [listArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *shopDic = obj;
            LifeCircleE *merchantE = [LifeCircleE new];
            merchantE.distance = [NSString stringFromat:shopDic[@"distance"]];
            merchantE.ID              = shopDic[@"id"];
            merchantE.img             = [NSString stringFromat:shopDic[@"img"]];
            merchantE.latitude        = [NSString stringFromat:shopDic[@"latitude"]];
            merchantE.longitude       = [NSString stringFromat:shopDic[@"longitude"]];
            merchantE.name            = [NSString stringFromat:shopDic[@"name"]];
            merchantE.phone           = [NSString stringFromat:shopDic[@"phone"]];
            merchantE.score           = [NSString stringFromat:shopDic[@"score"]];
            merchantE.storeAddress    = [NSString stringFromat:shopDic[@"storeAddress"]];
            merchantE.optionCode      = [NSString stringFromat:shopDic[@"optionCode"]];
            merchantE.rzStatus        = [NSString stringFromat:shopDic[@"rzStatus"]];
            merchantE.bizArea         = [NSString stringFromat:shopDic[@"bizArea"]];
            [circleArr addObject:merchantE];
        }];
        circleE.list = [circleArr copy];
    }
    return circleE;
}

@end
