//
//  TopUpHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TopUpHandler.h"

@implementation TopUpHandler

//充值
-(void)topupRequst:(TopUpModel *)topup success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        topup.memberId,@"memberId",
                        topup.attach,@"attach",
                        topup.body,@"body",
                        topup.trade_type,@"trade_type",
//                        topup.spbill_create_ip,@"spbill_create_ip",
                        topup.total_fee,@"total_fee",
//                        topup.payType,@"payType",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:MineTopUpinterface] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"] && ![NSString isEmptyOrNull:dic[@"id"]])
            {
                success(dic[@"id"]);
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
