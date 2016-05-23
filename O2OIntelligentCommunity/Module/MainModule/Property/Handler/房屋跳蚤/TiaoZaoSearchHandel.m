//
//  TiaoZaoSearchHandel.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TiaoZaoSearchHandel.h"

@implementation TiaoZaoSearchHandel

//跳蚤搜索
- (void)TiaoZaoSearch:(TiaoZaoSearch *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * queryMapDic = [NSMutableDictionary dictionary];
    [queryMapDic setObject:model.title forKey:@"title"];
    [queryMapDic setObject:model.type forKey:@"type"];
    [queryMapDic setObject:model.fleaMarketType forKey:@"fleaMarketType"];
    [queryMapDic setObject:model.status forKey:@"status"];
    [queryMapDic setObject:model.version forKey:@"version"];

    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDic forKey:@"queryMap"];
    [upLoadDict setObject:model.orderType forKey:@"orderType"];
    [upLoadDict setObject:model.orderBy forKey:@"orderBy"];
    
    NSLog(@"%@",upLoadDict);//@"正在加载..."
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        NSLog(@"%@",error);
        
    }];

}


//房屋搜索
- (void)HouseSearch:(TiaoZaoSearch *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * queryMapDic = [NSMutableDictionary dictionary];
//    [queryMapDic setObject:model.memberId forKey:@"memberid"];
    [queryMapDic setObject:model.type forKey:@"type"];
    [queryMapDic setObject:model.transactionType forKey:@"transactionType"];
    [queryMapDic setObject:model.title forKey:@"title"];
    [queryMapDic setObject:model.status forKey:@"status"];
    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDic forKey:@"queryMap"];
    [upLoadDict setObject:model.orderType forKey:@"orderType"];
    [upLoadDict setObject:model.orderBy forKey:@"orderBy"];
    
    NSLog(@"%@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TIAOZAOLIEBIAO] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppUtils showAlertMessageTimerClose:W_ALL_FAIL_GET_DATA];
        failed(nil);
        NSLog(@"%@",error);
        
    }];

    
}

@end
