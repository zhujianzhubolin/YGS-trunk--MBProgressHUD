
//
//  MyCollectionHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MyCollectionHandler.h"

@implementation MyCollectionHandler

-(id)init
{
    self = [super init];
    if (self)
    {
        self.sjCurrentPage =@"1";
        self.sjPageCount   =@"1";
        self.isSJUpdate    = YES;
        self.SJArray =[NSMutableArray array];
        
        self.spCurrentPage =@"1";
        self.spCurrentPage =@"1";
        self.isSPUpdate    =YES;
        self.SPArray =[NSMutableArray array];
    }
    return self;
}
//获取我的收藏商品列表
-(void)PostSPList:(CollectionModel *)SPList success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.spCurrentPage = @"1";
        self.spPageCount   = @"1";
    }
    else
    {
        if (self.spCurrentPage.integerValue > self.spPageCount.integerValue) {
            success(self.SPArray);
            return;
        }
        self.spCurrentPage = [NSString stringWithFormat:@"%ld",self.spCurrentPage.integerValue+1];
    }
    
    SPList.pageNumber = self.spCurrentPage;
    
    NSDictionary * commenDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                SPList.pageNumber,@"pageNumber",
                                SPList.pageSize,@"pageSize" ,
                                SPList.queryMap, @"queryMap",nil];
    
    NSLog(@"PostSPListDic ==%@",commenDic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:MineSCList] requestType:ZJHttpRequestPost parameters:commenDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    
        NSLog(@"PostSPListresponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            CollectionModel *collectionSP =[self collectionJson:dic];
            if ([NSArray isArrEmptyOrNull:collectionSP.list])
            {
                self.spCurrentPage=collectionSP.pageNumber;
            }
            self.spPageCount=collectionSP.pageCount;
            if (isheader)
            {
                self.SPArray = [collectionSP.list mutableCopy];
            }
            else
            {
                NSMutableArray *listArr = [self.SPArray mutableCopy];
                [collectionSP.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [listArr addObject:obj];
                }];
                self.SPArray = [listArr mutableCopy];
            }
            success(self.SPArray);
            return ;
        }
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
    
}

-(CollectionModel *)collectionJson:(NSDictionary *)dicJson
{
    CollectionModel *collectionSP =[CollectionModel new];
    collectionSP.pageNumber =dicJson[@"pageNumber"];
    collectionSP.pageSize   =dicJson[@"pageSize"];
    collectionSP.memberId   =dicJson[@"memberId"];
    collectionSP.pageCount  =dicJson[@"pageCount"];
    
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            
            CollectionModel *collectionSP =[CollectionModel new];
            collectionSP.ID           =recvDic[@"id"];
            collectionSP.name         =[NSString stringWithFormat:@"%@",recvDic[@"name"]];
            collectionSP.price        =[NSString stringWithFormat:@"%@",recvDic[@"price"]];
            collectionSP.market_price =[NSString stringWithFormat:@"%@",recvDic[@"market_price"]];
            collectionSP.img          =[NSString stringWithFormat:@"%@",recvDic[@"img"]];
            collectionSP.desc         =[NSString stringWithFormat:@"%@",recvDic[@"description"]];
            collectionSP.stock        =[NSString stringWithFormat:@"%@",recvDic[@"stock"]];
            collectionSP.storeId      =[NSString stringWithFormat:@"%@",recvDic[@"storeId"]];
            collectionSP.storeName    =[NSString stringWithFormat:@"%@",recvDic[@"storeName"]];
            collectionSP.isMarket     =[NSString stringWithFormat:@"%@",recvDic[@"isMarket"]];
            collectionSP.fullMoney    =[NSString stringWithFormat:@"%@",recvDic[@"fullMoney"]];
            collectionSP.notFullMoney =[NSString stringWithFormat:@"%@",recvDic[@"notFullMoney"]];
            collectionSP.productType =[NSString stringWithFormat:@"%@",recvDic[@"productType"]];
            
            
            [arr addObject:collectionSP];
        }];
        
        collectionSP.list=[arr mutableCopy];
    }
    return collectionSP;
    
}


//获取我的收藏商家列表
-(void)PostSJList:(ShangjiaModel *)SJList success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.sjCurrentPage = @"1";
        self.sjPageCount   = @"1";
    }
    else
    {
        if (self.sjCurrentPage.integerValue > self.sjPageCount.integerValue) {
            success(self.SJArray);
            return;
        }
        self.sjCurrentPage = [NSString stringWithFormat:@"%ld",self.sjCurrentPage.integerValue+1];
    }
    
    SJList.pageNumber = self.sjCurrentPage;

    
    NSDictionary * commenDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                SJList.pageNumber,@"pageNumber",
                                SJList.pageSize,@"pageSize" ,
                                SJList.queryMap, @"queryMap",nil];
    
    NSLog(@"PostSJListDic ==%@",commenDic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:MineShangJia] requestType:ZJHttpRequestPost parameters:commenDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"PostSJListresponse dic = %@",dic);
    
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            ShangjiaModel *shangjiaM = [self ShangjiaJson:dic];
            self.sjPageCount =shangjiaM.pageCount;
            if (isheader)
            {
                self.SJArray = [shangjiaM.list mutableCopy];
            }
            else
            {
                NSMutableArray *listArr = [self.SJArray mutableCopy];
                [shangjiaM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [listArr addObject:obj];
                }];
                self.SJArray =[listArr mutableCopy];
            }
            success(self.SJArray);
            return ;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];

}

-(ShangjiaModel *)ShangjiaJson:(NSDictionary *)dic
{
    ShangjiaModel *shangjiaM =[ShangjiaModel new];
    shangjiaM.pageNumber  =dic[@"pageNumber"];
    shangjiaM.pageSize    =dic[@"pageSize"];
    shangjiaM.pageCount   =dic[@"pageCount"];
    
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        
        [dic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            
            ShangjiaModel *shangjiaM =[ShangjiaModel new];
            NSLog(@"recvDic[@""]==%@",recvDic[@"id"]);
            shangjiaM.ID        =recvDic[@"id"];
            shangjiaM.OptionCode=[NSString stringWithFormat:@"%@",recvDic[@"OptionCode"]];
            shangjiaM.name      =[NSString stringWithFormat:@"%@",recvDic[@"name"]];
            shangjiaM.img       =[NSString stringWithFormat:@"%@",recvDic[@"img"]];
            shangjiaM.score     =[NSString stringWithFormat:@"%@",recvDic[@"score"]];
            shangjiaM.storeAddress =[NSString stringWithFormat:@"%@",recvDic[@"storeAddress"]];
            shangjiaM.rzStatus  =[NSString stringWithFormat:@"%@",recvDic[@"rzStatus"]];
            
            [arr addObject:shangjiaM];
        }];
        
        shangjiaM.list =[arr copy];
    }
    return shangjiaM;
}

//删除收藏的商家
-(void)DeleteSJ:(ShangjiaModel *)sjM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        sjM.storeID,@"storeId",
                        sjM.memberId,@"memberId",
                        sjM.isDeleted,@"isDeleted",
                        nil];
    NSLog(@"dic==%@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:SHOUCANGSHANGJIA] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
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

//删除收藏的商品
-(void)DeleteSP:(CollectionModel *)spM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        spM.memberId,@"memberId",
                        spM.ID,@"productId",
                        nil];
    NSLog(@"dic==%@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:DELEGOODSSHOUCANG] requestType:ZJHttpRequestGet parameters:dic prepareExecute:^{
        
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
