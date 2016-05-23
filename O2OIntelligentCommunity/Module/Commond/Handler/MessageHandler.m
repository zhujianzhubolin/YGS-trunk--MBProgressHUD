//
//  MessageHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MessageHandler.h"

@implementation MessageHandler

//验证获取到的验证码的正确性
- (void)executeVerifyCodeIsRightTaskWithModel:(MessageModel *)codeE
                                      success:(SuccessBlock)success
                                       failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     codeE.smsType,@"smsType",
                                                     codeE.mobile,@"mobile",
                                                     codeE.code,@"code",
                                                     nil];

    NSLog(@"paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_VERTIFICATE_CODE_IS_RIGHT] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            NSLog(@"dic_json = %@",dic_json);

            success(dic_json[@"numberCode"]);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

//获取验证码，（除开注册,开通钱包）
- (void)executeGetVerifyCodeTaskWithModel:(MessageModel *)codeE
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             codeE.smsType,@"smsType",
                             codeE.mobile,@"mobile",
                             codeE.reference,@"reference",
                             nil];
    
    NSLog(@"GetVerifyCodeparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_PHONE_VERTIFICATE_CODE] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            success(dic_json[@"numberCode"]);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

//用户注册时获取验证码
- (void)executeRegisterGetVerifyCodeTaskWithModel:(MessageModel *)codeE
                                          success:(SuccessBlock)success
                                           failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             codeE.businessType,@"businessType",
                             codeE.mobilePhone,@"mobilePhone",
                             codeE.reference,@"reference",
                             nil];
    
    NSLog(@"RegisterGetVerifyCodeparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerGetMima];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_REGISTER_VERTIFICATE_CODE] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegisterGetVerifydic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            success(nil);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

//获取开通钱包的验证码
- (void)executeMoneyBagCodeTaskWithModel:(MessageModel *)codeE
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             codeE.businessType,@"businessType",
                             codeE.mobilePhone,@"mobilePhone",
                             codeE.memberId,@"memberId",
                             codeE.reference,@"reference",
                             nil];
    
    NSLog(@"RegisterGetVerifyCodeparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerGetMima];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_REGISTER_VERTIFICATE_CODE] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegisterGetVerifydic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            success(nil);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];
}

//绑定小区获取验证码
-(void)executeBindingXiaoQuWithModel:(MessageModel *)codeE
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed
{
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             codeE.smsType,@"smsType",
                             codeE.mobile,@"mobile",
                             codeE.reference,@"reference",
                             codeE.roomId,@"roomId",
                             nil];
    

    NSLog(@"RegisterGetVerifyCodeparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerGetMima];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_BINDINGXIAOQU_CODE] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegisterGetVerifydic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            success(nil);
            return;
        }
        failed([NSString stringFromat:dic_json[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"request failed = %@",error);
    }];

}

@end
