//
//  HotSearchHandel.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/8.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "HotSearchHandel.h"

@implementation HotSearchHandel

//获取热搜标签
- (void)getHotSearch:(HotSearchModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * queryMapDic = [NSMutableDictionary dictionary];
    [queryMapDic setObject:model.code forKey:@"code"];
    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    [upLoadDict setObject:model.pageNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:queryMapDic forKey:@"queryMap"];
    NSLog(@"%@",upLoadDict);//@"正在加载..."
    [AppUtils showProgressMessage:@"正在加载..."];
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:HOTSEARCH] requestType:ZJHttpRequestPost parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        success([self JsonToModel:dic]);
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}

- (NSMutableArray *)JsonToModel:(id)data{
    
    NSMutableArray * modelArray = [NSMutableArray array];
    if (![data[@"list"] isEqual:[NSNull null]]) {
        for (NSDictionary * dict in data[@"list"]) {
            HotSearchModel * model = [HotSearchModel new];
            model.name = dict[@"name"];
            [modelArray addObject:model];
        }
    }
    return modelArray;
}

@end
