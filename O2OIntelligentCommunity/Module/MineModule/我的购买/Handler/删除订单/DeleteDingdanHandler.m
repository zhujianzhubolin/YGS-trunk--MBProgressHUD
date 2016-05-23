//
//  DeleteDingdanHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "DeleteDingdanHandler.h"

@implementation DeleteDingdanHandler

//删除订单
-(void)DeleteDingDan:(DeleteDingdanModel *)deleteM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         deleteM.orderNo,@"orderNo",
                         deleteM.memberNo,@"memberNo",
                         nil];
    NSLog(@"dict=%@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineDeleteDingDan ] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"addXQresponse dic = %@",dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic])
        {
            if (success) {
                
                if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
                {
                    NSLog(@"dic==%@",dic);
                    success(dic[@"message"]);
                    return;
                }
                
            }
            
            NSLog(@"yes");
            
        }
        
        //NSLog(@"response dic = %@",dic);
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];

}

//确认收货
-(void)AffirmConsignee:(DeleteDingdanModel *)deleteM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         deleteM.orderNo,@"orderNo",
                         deleteM.memberNo,@"memberNo",
                         nil];
    NSLog(@"dict=%@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_OMS WithPort:A_PORT_OMS WithPath:MineAffirmConsignee ] requestType:ZJHttpRequestGet parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"addXQresponse dic = %@",dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success){
            if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"]){
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
