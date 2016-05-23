//
//  QuxiaoDindanHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "QuxiaoDindanHandler.h"

@implementation QuxiaoDindanHandler

//取消订单
-(void)CancelDindan:(QuXiaoDindanModel *)canceM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                        canceM.orderSubNo,@"orderSubNo",
                        nil];
    NSLog(@"dict=%@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineCancelDindan] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"addXQresponse dic = %@--%@",dic,dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
                if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
                {
                    NSLog(@"dic==%@",dic);
                    success(dic[@"message"]);
                    return;
                }
        }

        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}

@end
