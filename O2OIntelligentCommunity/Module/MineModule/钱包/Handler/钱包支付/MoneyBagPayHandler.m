//
//  MoneyBagPayHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/19.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoneyBagPayHandler.h"

@implementation MoneyBagPayHandler
//钱包支付
-(void)moneybagpay:(MoneyBagPayModel *)payM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        payM.memberId,@"memberId",
                        payM.payPassWord,@"payPassWord",
                        payM.amount,@"amount",
                        payM.payOrderNo,@"payOrderNo",
                         nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:MineMoneyBagPayinterface] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
            {
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
