//
//  RetrievePassH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RetrievePassH.h"
#import "NetworkRequest.h"
#import "NSString+wrapper.h"

@implementation RetrievePassH
- (void)excuteRetrievePassTaskWithUser:(RetrieveEntity *)user
                                success:(SuccessBlock)success
                                 failed:(FailedBlock)failed {

    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:user.phone,@"phone",
                                                                       user.nPass,@"newPassword",
                                                                       user.reference,@"reference",
                                                                       nil];
    NSLog(@"paraDic = %@",paraDic);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_RETRIEVE] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"excuteRetrievePassTaskWithUser dic_json=  %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"] && success) {
            success(nil);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

- (void)excuteUpdatePassTaskWithUser:(UpdatePassEntity *)user
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:user.memberId,@"memberId",user.passwordOld,@"oldPassword",user.passwordNew,@"newPassword",user.salt,@"salt",user.verifyName,@"verifyName",nil];
    [[NetworkRequest defaultRequest] requestSerializerDefailt];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_UPDATE_PASS] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"dic_json = %@",dic_json);
            success(nil);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
        NSLog(@"request failed = %@",error);
    }];
}
@end
