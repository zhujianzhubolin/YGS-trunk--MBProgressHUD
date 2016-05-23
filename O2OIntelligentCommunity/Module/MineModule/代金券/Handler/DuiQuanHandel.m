//
//  DuiQuanHandel.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/2.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "DuiQuanHandel.h"

@implementation DuiQuanHandel
//兑券
- (void)duiquanRequest:(DuiQuanModel*)model success:(SuccessBlock)success failed:(FailedBlock)failed
{
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           model.memberId,@"memberId",
                           model.couponNo,@"couponNo",
                           model.password,@"password",
                           nil];
    NSLog(@"dic %@",Dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:DuiQuanRequest] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"＝＝%@",dic);
       
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic);
            return ;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        failed(W_ALL_FAIL_GET_DATA);
    }];
}

@end
