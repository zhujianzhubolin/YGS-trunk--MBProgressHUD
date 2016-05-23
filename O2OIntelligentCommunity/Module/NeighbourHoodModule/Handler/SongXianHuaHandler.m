//
//  SongXianHuaHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SongXianHuaHandler.h"

@implementation SongXianHuaHandler

//送鲜花
-(void)SongHua:(SongXianHuaModel *)songhuaM success:(SuccessBlock)success
        failed:(FailedBlock)failed
{
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           songhuaM.memberId,@"memberid",
                           songhuaM.complaintType,@"complaintType",
                           songhuaM.activityId,@"activityId",
                           nil];
    
    
    NSLog(@"dic >> %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:SongXianHuainterface] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] &&
            success &&
            ![NSString isEmptyOrNull:dic[@"code"]] &&
            [dic[@"code"] isEqualToString:@"success"]) {
            success(dic[@"message"]);
            return;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
        
    }];

}

@end
