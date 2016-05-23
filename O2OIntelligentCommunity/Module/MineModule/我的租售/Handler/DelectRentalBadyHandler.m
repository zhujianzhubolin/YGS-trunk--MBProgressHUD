//
//  DelectRentalBadyHandler.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 15/12/15.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "DelectRentalBadyHandler.h"

@implementation DelectRentalBadyHandler

//删除我的宝贝和我租售
-(void)delectRentalBady:(ShengSJDataE *)delectRB success:(SuccessBlock)success
                 failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        delectRB.memberId,@"memberid",
                        delectRB.ID,@"id",nil];
    NSLog(@"dic==%@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineDelectRentalBady] requestType:ZJHttpRequestGet parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic[@"message"]);
            return ;
        }
        
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

    
}
@end
