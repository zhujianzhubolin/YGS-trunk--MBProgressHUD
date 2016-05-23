//
//  ZhifuHandel.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ZhifuHandel.h"

@implementation ZhifuHandel

//重新选择支付下单
-(void)AgainXiaDanZhiFu:(ZhifuModel *)zhifu success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         zhifu.attach,@"attach",
                         zhifu.trade_type,@"trade_type",
                         zhifu.openid,@"openid",
                         zhifu.body,@"body",
                         zhifu.nonce_str,@"nonce_str",
                         zhifu.spbill_create_ip,@"spbill_create_ip",
                         zhifu.total_fee,@"total_fee",
                         zhifu.payType,@"payType",
                         zhifu.orderNo,@"orderNo",
                         nil];
    NSLog(@"dict=%@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineZhifu ] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"addXQresponse dic = %@",dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
                if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
                {
                    NSLog(@"dic==%@",dic);
                    success(dic);
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
