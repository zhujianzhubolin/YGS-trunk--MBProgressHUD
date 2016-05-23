//
//  OpenMoneyBagHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "OpenMoneyBagHandler.h"

@implementation OpenMoneyBagHandler

//开通钱包
-(void)openmoneybag:(OpenMoneyBagModel *)openm success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        openm.memberId,@"memberId",
                        openm.name,@"name",
                        openm.cardNo,@"cardNo",
                        openm.phone,@"phone",
                        openm.code,@"code",
                        openm.payPassword,@"payPassword",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:OPenMoneBaginterface] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
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

//忘记支付密码，
-(void)forgetzhifupassword:(OpenMoneyBagModel *)forgetpassword success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        forgetpassword.memberId,@"memberId",
                        forgetpassword.name,@"name",
                        forgetpassword.cardNo,@"cardNo",
                        forgetpassword.phone,@"phone",
                        forgetpassword.code,@"code",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:ForgetzhifuPasswordinterface] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic);
            return;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}

@end
