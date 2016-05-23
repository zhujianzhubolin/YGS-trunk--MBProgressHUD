//
//  PingLunList.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "PingLunList.h"

@implementation PingLunList

//发布一条评论
- (void)AddPingLun:(PinLunListModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.merberId forKey:@"memberId"];
    [upLoadDict setObject:model.complaintId forKey:@"complaintId"];
    [upLoadDict setObject:model.complaintType forKey:@"complaintType"];
    [upLoadDict setObject:model.content forKey:@"content"];
    NSLog(@"%@",upLoadDict);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:ADDPINGLUNHOUSE] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
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
        NSLog(@"%@",error);
        
    }];
    
}


//获取评论列表
- (void)GetHousePingLUn:(PinLunLieBiao *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary * queryMapDict = [NSMutableDictionary dictionary];
    [queryMapDict setObject:model.memberid forKey:@"memberId"];
    [queryMapDict setObject:model.complaintId forKey:@"complaintId"];
    [queryMapDict setObject:model.complaintType forKey:@"complaintType"];
    [queryMapDict setObject:model.status forKey:@"status"];

    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDict forKey:@"queryMap"];
    [upLoadDict setObject:model.orderType forKey:@"orderType"];
    [upLoadDict setObject:model.orderBy forKey:@"orderBy"];

    NSLog(@"upLoadDict = %@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:PINLUNLISTHOUSE] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}

@end
