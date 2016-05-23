//
//  GoodsShopsCommentHandel.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "GoodsShopsCommentHandel.h"

@implementation GoodsShopsCommentHandel

//商品和商家评论
-(void)goodShopComment:(GoodsShopsCommentModel *)commentM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSLog(@"dic==%@",commentM.queryMap);
    [[NetworkRequest defaultRequest]requestSerializerJson];
//    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:@"192.168.1.98:" WithPort:@"8888" WithPath:@"/mdm-rs/memberProductComments/saveOrderProductComments"] requestType:ZJHttpRequestPost parameters:commentM.queryMap prepareExecute:^{
     [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:GoodsShopSComment] requestType:ZJHttpRequestPost parameters:commentM.queryMap prepareExecute:^{
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
