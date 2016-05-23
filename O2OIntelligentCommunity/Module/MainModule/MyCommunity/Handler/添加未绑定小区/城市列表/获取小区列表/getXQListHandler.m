//
//  getXQListHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "getXQListHandler.h"
#import "BingingXQModel.h"
#import "UserManager.h"

@implementation getXQListHandler

-(void)postXQList:(getXQListModel *)postXQ success:(SuccessBlock)success failed:(FailedBlock)failed
{
#ifdef SmartComJYZX
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:postXQ.comapyanyId,@"comapyanyId", nil];
#elif SmartComYGS
    NSDictionary *queryMapDic = [NSDictionary dictionaryWithObjectsAndKeys:postXQ.isCustomized,@"isCustomized", nil];
#else
   
#endif
    
    NSDictionary *Dict=[NSDictionary dictionaryWithObjectsAndKeys:postXQ.pageNumber,@"pageNumber",
                        postXQ.pageSize,@"pageSize",
                        queryMapDic,@"queryMap",
                        postXQ.orderBy,@"orderBy",
                        postXQ.orderType,@"orderType",
                        nil];
    NSLog(@"postXQList Dict===%@",Dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:PostXQList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"postXQListresponse dic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            getXQListModel *xqM=[self xqJson:dic];
            success(xqM.list);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];

}

-(getXQListModel *)xqJson:(NSDictionary *)dic
{
    getXQListModel *xqM =[getXQListModel new];
    xqM.pageNumber=dic[@"pageNumber"];
    xqM.pageSize  =dic[@"pageSize"];
    xqM.orderBy   =dic[@"orderBy"];
    xqM.orderType =dic[@"orderType"];
    xqM.cityId = dic[@"cityId"];
    xqM.comapyanyId =dic[@"comapyanyId"];
    xqM.code      =dic[@"code"];
    
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            
            BingingXQModel *xqM =[BingingXQModel new];
            xqM.xqAdress = recvDic[@"communityAddress"];
            if (![NSDictionary isDicEmptyOrNull:recvDic[@"propCity"]]) {
                xqM.cityName =recvDic[@"propCity"][@"areaname"];
            }
            xqM.xqName = recvDic[@"communityName"];
            xqM.cityid = recvDic[@"cityId"];
            xqM.xqNo = [NSString stringWithFormat:@"%@",recvDic[@"id"]];

            [arr addObject:xqM];
        }];
        xqM.list =[arr copy];
    }
    return xqM;

}

@end
