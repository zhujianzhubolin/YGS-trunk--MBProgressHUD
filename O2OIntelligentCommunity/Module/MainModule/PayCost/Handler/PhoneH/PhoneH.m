//
//  PhoneH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/12/31.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "PhoneH.h"

@implementation PhoneH

//查询话费归属地
- (void)executeTaskForQueryPhoneAttribution:(id)parametor
                                    success:(SuccessBlock)success
                                     failed:(FailedBlock)failed {
    
    [[NetworkRequest defaultRequest] requestWithPath:API_QUERE_PHONE_ATTRIBUTION requestType:ZJHttpRequestGet parameters:parametor prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@,reason = %@",dic_json,dic_json[@"reason"]);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSDictionary isDicEmptyOrNull:dic_json[@"result"]]) {
            NSDictionary *resultDic = dic_json[@"result"];
            NSMutableString *attributionStr = [NSMutableString new];
            
            if (![NSString isEmptyOrNull:resultDic[@"province"]]) {
                [attributionStr appendString:resultDic[@"province"]];
            }
            
            if (![NSString isEmptyOrNull:resultDic[@"card"]]) {
                [attributionStr appendFormat:@"-%@",resultDic[@"company"]];
            }
            
            success(attributionStr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

@end
