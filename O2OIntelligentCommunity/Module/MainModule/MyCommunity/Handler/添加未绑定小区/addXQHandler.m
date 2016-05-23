//
//  addXQHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "addXQHandler.h"

@implementation addXQHandler

//添加小区
-(void)addXQ:(AddXQModel *)addxq success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary * Dict =[NSDictionary dictionaryWithObjectsAndKeys:addxq.xqNo,@"xqNo",addxq.memberId,@"memberId", nil];
    NSLog(@"%@",Dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineaddXQ ] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"addXQresponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic])
        {
            if (success) {
                
                if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
                {
                    success(dic[@"message"]);
                    return;
                }

            }
            
            NSLog(@"yes");
            
        }
        
        //NSLog(@"response dic = %@",dic);
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}
//
//-(AddXQModel *)addxqJson:(NSDictionary *)dicJson
//{
//    AddXQModel *addxqM = [AddXQModel new];
//    
//    addxqM.messages =dicJson[@"message"];
//    
//    
//    return addxqM;
//}



@end
