//
//  RegisterHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RegisterHandler.h"
#import "NetworkRequest.h"
#import "APIConfig.h"
#import "BaseHandler.h"
#import "NSString+wrapper.h"
#import <SVProgressHUD.h>

@implementation RegisterHandler
- (void)excuteRegisterTaskWithUser:(RegisterEntity *)user
                           success:(SuccessBlock)success
                            failed:(FailedBlock)failed {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             user.accountName,@"accountName",
                             user.password,@"password",
                             user.salt,@"salt",
                             user.reference,@"reference",
                             user.verCode,@"verCode",
                             user.registerType,@"registerType",
                             user.orgcode,@"orgcode",
                             user.channel,@"channel",
                             nil];
    
    if (user.recomPhone.length > 0) {
        [paraDic setObject:user.recomPhone forKey:@"recomPhone"];
    }
    
    NSLog(@"RegisterTaskparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerGetMima];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_REGISTER] requestType:ZJHttpRequestPost parameters:[paraDic copy] prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"dic_json = %@",dic_json);
            NSLog(@"message = %@",dic_json[@"message"]);
            if (![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
                success(dic_json[@"message"]);
                return;
            }
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

@end
