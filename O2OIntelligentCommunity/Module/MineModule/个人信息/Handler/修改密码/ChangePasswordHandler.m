//
//  ChangePasswordHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ChangePasswordHandler.h"

@implementation ChangePasswordHandler
//修改密码
-(void)ChangePassword:(ChangePasswordModel *)changepassword success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        changepassword.memberId,@"memberId",
                        changepassword.oldPassword,@"oldPassword",
                        changepassword.NewPassword,@"newPassword",
                        changepassword.salt,@"salt",
                        changepassword.reference,@"reference",
                        changepassword.verifyName,@"verifyName",
                        nil];
    NSLog(@"dic >> %@",dic);
    
    [[NetworkRequest defaultRequest] requestSerializerDefailt];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:ChangePasswordinterface] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic[@"message"]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
            {
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
