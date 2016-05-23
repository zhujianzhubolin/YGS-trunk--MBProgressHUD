//
//  HouseAndGoods.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "HouseAndGoods.h"

@implementation HouseAndGoods

//发布一则新的消息----房屋租售
- (void)AddNewHouseInfor:(AddNewInforModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * uploadDict = [NSMutableDictionary dictionary];
    [uploadDict setObject:model.memberid forKey:@"memberid"];
    [uploadDict setObject:model.wyNo forKey:@"wyNo"];
    [uploadDict setObject:model.xqNo forKey:@"xqNo"];
    [uploadDict setObject:model.title forKey:@"title"];
    [uploadDict setObject:model.activityContent forKey:@"activityContent"];
    [uploadDict setObject:model.activityType forKey:@"activityType"];
    [uploadDict setObject:model.status forKey:@"status"];
    [uploadDict setObject:model.cityId forKey:@"cityId"];
    //图片
    [uploadDict setObject:model.fileId forKey:@"fileId"];
    [uploadDict setObject:model.type forKey:@"type"];
    [uploadDict setObject:model.transactionType forKey:@"transactionType"];
    [uploadDict setObject:model.price forKey:@"price"];
    [uploadDict setObject:model.phone forKey:@"phone"];

    NSLog(@"上传提交的数据>>>>%@",uploadDict);
    
    [AppUtils showProgressMessage:@"正在提交..."];
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:ADDNEWTOPIC] requestType:ZJHttpRequestPost parameters:uploadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                [SVProgressHUD dismiss];
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
    
}

//发布一则新的消息----跳蚤市场
- (void)AddNewGoodsInfor:(AddNewInforModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    NSMutableDictionary * uploadDict = [NSMutableDictionary dictionary];
    [uploadDict setObject:model.memberid forKey:@"memberid"];
    [uploadDict setObject:model.wyNo forKey:@"wyNo"];
    [uploadDict setObject:model.xqNo forKey:@"xqNo"];
    [uploadDict setObject:model.title forKey:@"title"];
    [uploadDict setObject:model.activityContent forKey:@"activityContent"];
    [uploadDict setObject:model.activityType forKey:@"activityType"];
    [uploadDict setObject:model.status forKey:@"status"];
    [uploadDict setObject:model.cityId forKey:@"cityId"];

    //图片
    [uploadDict setObject:model.fileId forKey:@"fileId"];
    [uploadDict setObject:model.type forKey:@"type"];
    [uploadDict setObject:model.fleaMarketType forKey:@"fleaMarketType"];
    [uploadDict setObject:model.price forKey:@"price"];
    [uploadDict setObject:model.phone forKey:@"phone"];
    
    NSLog(@"%@",uploadDict);
    
    [AppUtils showProgressMessage:@"正在提交..."];
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:ADDNEWTOPIC] requestType:ZJHttpRequestPost parameters:uploadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            
            NSLog(@"yes");
            
        }
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                [SVProgressHUD dismiss];
                success(dic);
                return;
            }
            NSLog(@"yes");
            
        }
        
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];


}

@end
