//
//  OpinionFeedbackHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "OpinionFeedbackHandler.h"

@implementation OpinionFeedbackHandler
//意见反馈
-(void)opinionfeedback:(OpinionFeedbackModel *)opfbM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        opfbM.memberInfoid,@"memberInfoid",
                        opfbM.content,@"content",
                        opfbM.devicetype,@"devicetype",
                        opfbM.versioncode,@"versioncode",
                        opfbM.appname,@"appname",
                        nil];
    NSLog(@"dic==%@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineOpinionFeedback] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic[@"message"]);
            return ;
        }
        
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];

}

@end
