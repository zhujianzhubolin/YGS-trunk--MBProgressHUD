//
//  ZJAdvertisementHandler.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/31.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJAdvertisementHandler.h"

@implementation ZJAdvertisementHandler

-(id)init
{
    self =[super init];
    if (self)
    {
        self.gGaocurrentPage = @"1";
        self.gGaopageCount   = @"1";
        self.gGaoArray = [NSMutableArray array];
    }
    return self;
}

//规则
-(void)queryAdvertisementListInfo:(ZJAdvertisementModel *)advertisementM
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed
                         isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.gGaocurrentPage =@"1";
        self.gGaopageCount =@"1";
    }
    else
    {
        if (self.gGaocurrentPage.intValue > self.gGaopageCount.intValue)
        {
            success(self.gGaoArray);
            return;
        }
        self.gGaocurrentPage = [NSString stringWithFormat:@"%d",self.gGaocurrentPage.intValue +1];
    }
    
    advertisementM.pageNumber=self.gGaocurrentPage;
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           advertisementM.pageNumber,@"pageNumber",
                           advertisementM.pageSize,@"pageSize",
                           advertisementM.wyNo,@"wyNo",
                           advertisementM.xqNo,@"xqNo",
                           advertisementM.terminalNo,@"terminalNo",
                           nil];
    
    
    NSLog(@"postBuyListDict  ===== %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_ADVERTISEMENT_RULE] requestType:ZJHttpRequestGet parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"postBuyListRecvDic==%@",dic );
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            ZJAdvertisementModel *adverM =[self QueryAdvertisementJson:dic];
            self.gGaopageCount=adverM.pageCount;
            if (isheader)
            {
                self.gGaoArray = [adverM.list mutableCopy];
            }
            else
            {
                [adverM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.gGaoArray addObject:obj];
                }];
            }
            success(self.gGaoArray);
            return ;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}


-(ZJAdvertisementModel *)QueryAdvertisementJson:(NSDictionary *)dic
{
    ZJAdvertisementModel *queryM =[ZJAdvertisementModel new];
    queryM.pageNumber   =dic[@"pageNumber"];
    queryM.pageSize     =dic[@"pageSize"];
    queryM.pageCount    =dic[@"pageCount"];
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
//            NSDictionary *mbMemberDic =recvDic[@"mbMember"];
//            NSDictionary *memberProfileDic =mbMemberDic[@"memberProfile"];
//            NSLog(@"mbMemberDic==%@",mbMemberDic[@"nickName"]);
            
            ZJAdvertisementModel *queryM =[ZJAdvertisementModel new];
            queryM.ID                   =[NSString stringWithFormat:@"%@",recvDic[@"id"]];
            queryM.wyNo                 =[NSString stringWithFormat:@"%@",recvDic[@"wyNo"]];
            queryM.xqNo                 =[NSString stringWithFormat:@"%@",recvDic[@"xqNo"]];
            queryM.chargeType           =[NSString stringWithFormat:@"%@",recvDic[@"chargeType"]];
            queryM.chargeAmout          =[NSString stringWithFormat:@"%@",recvDic[@"chargeAmout"]];
            queryM.serviceRegular       =[NSString stringWithFormat:@"%@",recvDic[@"serviceRegular"]];
            queryM.terminalNo           =[NSString stringWithFormat:@"%@",recvDic[@"terminalNo"]];
            
            [arr addObject:queryM];
        }];
        queryM.list=[arr copy];
    }
    return queryM;
}

//客户端上传素材并下订单
-(void)subminMaterialOrders:(NSDictionary *)Dict
            success:(SuccessBlock)success
             failed:(FailedBlock)failed
{
    NSLog(@"Dict=%@",Dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_SUBMITORDER] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic == %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic);
            return ;
        }
        failed(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}

//下单
-(void)subminOrders:(NSDictionary *)Dict
            success:(SuccessBlock)success
             failed:(FailedBlock)failed
{
    NSLog(@"Dict=%@",Dict);
    
    NSString *Urlstr = [NSString stringForUrlFromPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_DWONORDER] paramaters:Dict];
    NSLog(@"Urlstr==%@",Urlstr);

    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_DWONORDER] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"subminOrders Dict==%@",[NSString jsonStringWithDictionary:dic]);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic);
            return ;
        }
        failed(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}
//小蜜机器人的个数
-(void)requestXiaoMiNumber:(ZJAdvertisementModel *)model
                   success:(SuccessBlock)success
                    failed:(FailedBlock)failed
{
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           model.pageNumber,@"pageNumber",
                           model.pageSize,@"pageSize",
                           model.wyNo,@"wyNo",
                           model.xqNo,@"xqNo",
                           nil];
    NSLog(@"para = %@",[NSString jsonStringWithDictionary:Dict]);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_XIAOMINUMBER] requestType:ZJHttpRequestGet parameters:Dict prepareExecute:^{
 
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"小蜜机器的个数==%@",dic );
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success(dic);
            return ;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];


    
}

@end
