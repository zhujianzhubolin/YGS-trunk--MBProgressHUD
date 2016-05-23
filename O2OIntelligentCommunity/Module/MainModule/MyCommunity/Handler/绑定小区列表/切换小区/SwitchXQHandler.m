//
//  SwitchXQHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SwitchXQHandler.h"

@implementation SwitchXQHandler
//切换小区
- (void)switchXQH:(BingingXQModel *)switchXq
          success:(SuccessBlock)success
           failed:(FailedBlock)failed
{
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:switchXq.merberId,@"memberId",switchXq.xqNo,@"xqId",nil];
    NSLog(@"switchXQH Dict >> %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:SwitchXQinterface] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"switchXQH response dic = %@",dic);
            if ([NSJSONSerialization isValidJSONObject:dic] && success && ![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"]) {
                success(dic[@"message"]);
                return;
            }
            failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
    }];

}

@end
