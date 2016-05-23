//
//  AdvertiseHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AdvertiseHandler.h"
#import "NSArray+wrapper.h"

@implementation AdvertiseHandler
- (id)init {
    self = [super init];
    if (self) {
        self.mainAdPNumber = @"1";
        self.mainAdPCount =  @"1";
        self.mainAdArr = [NSMutableArray array];
    }
    return self;
}

//首页获取顶部广告
- (void)executeMainTopAdvertiseTaskWithUser:(ADEntity *)adE
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           adE.companyId,@"companyId",
                           adE.communityhouseId,@"communityhouseId",
                           adE.code,@"code",
                           nil];
    NSLog(@"AdvertiseTask dic = %@",dict);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:LifeHomeData] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"AdvertiseTask recvDic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success && ![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"]) {
            success([self decodeArrayLifeAdv:dic]);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
    }];
}

- (NSArray *)decodeArrayLifeAdv:(NSDictionary *)dict{
    NSMutableArray *reArr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:dict[@"list"]]) {
        NSArray *recvArr = dict[@"list"];
        [recvArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            ADEntity * model    = [[ADEntity alloc] init];
            model.imageID       = [NSString stringFromat:recvDic[@"id"]];
            model.imageAddres   = [NSString stringFromat:recvDic[@"imageAddres"]];
            model.linkCode      = [NSString stringFromat:recvDic[@"linkCode"]];
            model.type          = [NSString stringFromat:recvDic[@"type"]];
            model.productId     = [NSString stringFromat:recvDic[@"productId"]];
            model.merchantId    = [NSString stringFromat:recvDic[@"merchantId"]];
            model.operationId   = [NSString stringFromat:recvDic[@"operationId"]];
            model.rzstatus      = [NSString stringFromat:recvDic[@"rzstatus"]];
            model.productType   = [NSString stringFromat:recvDic[@"productType"]];
            [reArr addObject:model];
        }];
    }
    return [reArr copy];
}

//首页获取底部广告
- (void)executeMainButtomAdvertiseTaskWithUser:(ADEntity *)adE
                                       success:(SuccessBlock)success
                                        failed:(FailedBlock)failed
                                      isHeader:(BOOL)isheader {
    if (isheader) {
        self.mainAdPNumber = @"1";
        self.mainAdPCount =  @"1";
    }
    else {
        if (self.mainAdPNumber.integerValue > self.mainAdPCount.integerValue) {
            success(self.mainAdArr);
            return;
        }
        self.mainAdPNumber = [NSString stringWithFormat:@"%d",self.mainAdPNumber.integerValue + 1];
    }
    
    adE.pageNumber = self.mainAdPNumber;

    NSDictionary * paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              adE.companyId,@"companyId",
                              adE.communityhouseId,@"communityhouseId",
                              adE.code,@"code",
                              adE.pageNumber,@"pageNumber",
                              adE.pageSize,@"pageSize",
                              nil];
//    NSLog(@"executeMainButtomAdvertiseTaskWithUser paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_MAIN_AD] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"executeMainButtomAdvertiseTaskWithUser recvDic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            ADEntity *adRecvE = [self decodeMainButtomAdDataWithJson:dic];
            self.mainAdPCount = adRecvE.pageCount;
            
            if (isheader) {
                self.mainAdArr = [adRecvE.list mutableCopy];
            }
            else {
                [adRecvE.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.mainAdArr addObject:obj];
                }];
            }
            
            success(nil);
            return;

        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
    }];
}

- (ADEntity *)decodeMainButtomAdDataWithJson:(NSDictionary *)adDic {
    ADEntity *adE = [ADEntity new];
    adE.pageSize = [NSString stringFromat:adDic[@"pageSize"]];
    adE.pageNumber = [NSString stringFromat:adDic[@"pageNumber"]];
    adE.pageCount = [NSString stringFromat:adDic[@"pageCount"]];
    adE.list = [self decodeArrayLifeAdv:adDic];
    return adE;
}
@end
