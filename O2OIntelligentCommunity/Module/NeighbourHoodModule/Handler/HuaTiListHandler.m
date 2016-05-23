//
//  HuaTiListHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "HuaTiListHandler.h"

@implementation HuaTiListHandler
- (id)init {
    self = [super init];
    if (self) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
        self.htArray = [NSMutableArray array];
        self.isHuaTiNeedUpdate = YES;
        
        self.myHtPCount = @"1";
        self.myHtPCount = @"1";
        self.isMyHtNeedUpdate=YES;
        self.myHtArr = [NSMutableArray array];
    }
    return self;
}


//获取话题列表
-(void)PostHuatiList:(HuaTiListModel *)huati success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{

    if (isheader)
    {
        self.currentPage = @"1";
        self.pageCount   = @"1";
    }
    else
    {
        if (self.currentPage.intValue <= self.pageCount.intValue)
        {
            self.currentPage =[NSString stringWithFormat:@"%d",self.currentPage.intValue +1];
        }
    }
    huati.pageNumber = self.currentPage;
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         huati.pageNumber,@"pageNumber",
                         huati.pageSize,@"pageSize",
                         huati.queryMap,@"queryMap",
                         huati.orderBy,@"orderBy",
                         huati.orderType,@"orderType",
                         nil];
    NSLog(@"PostHuatiListdict %@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:HuatiList] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"PostHuatiListresponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            HuaTiListModel *huatiM =[self huatiListJSon:dic];
            if ([NSArray isArrEmptyOrNull:huatiM.list])
            {
                self.currentPage =huatiM.pageNumber;
            }
            
            self.pageCount =huatiM.pageCount;
            if (isheader)
            {
                self.htArray = [huatiM.list mutableCopy];
            }
            else
            {
                [huatiM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.htArray addObject:obj];
                }];
            }
        
            success(self.htArray);
            return ;
            
        }
        failed(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);

    }];
}

//查询我自己的话题
-(void)postUserHuaTiList:(HuaTiListModel *)huati success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.myHtPNumber = @"1";
        self.myHtPCount   = @"1";
    }
    else
    {
        if (self.myHtPNumber.intValue <= self.myHtPCount.intValue)
        {
            self.myHtPNumber =[NSString stringWithFormat:@"%d",self.myHtPNumber.intValue +1];
        }
    }
    huati.pageNumber = self.myHtPNumber;
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         huati.pageNumber,@"pageNumber",
                         huati.pageSize,@"pageSize",
                         huati.queryMap,@"queryMap",
                         huati.orderBy,@"orderBy",
                         huati.orderType,@"orderType",
                         nil];
    NSLog(@"PostHuatiListdict %@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:HuatiList] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"PostHuatiListresponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            HuaTiListModel *huatiM =[self huatiListJSon:dic];
            if ([NSArray isArrEmptyOrNull:huatiM.list])
            {
                self.myHtPNumber =huatiM.pageNumber;
            }
            
            self.myHtPCount =huatiM.pageCount;
            if (isheader)
            {
                self.myHtArr = [huatiM.list mutableCopy];
            }
            else
            {
                [huatiM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.myHtArr addObject:obj];
                }];
            }
            
            success(self.myHtArr);
            return ;
            
        }
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

-(HuaTiListModel *)huatiListJSon:(NSDictionary *)dic
{
    HuaTiListModel *huatiM =[HuaTiListModel new];
    huatiM.pageNumber    =dic[@"pageNumber"];
    huatiM.pageSize      =dic[@"pageSize"];
    huatiM.orderBy       =dic[@"orderBy"];
    huatiM.orderType     =dic[@"orderType"];
    huatiM.pageCount     =dic[@"pageCount"];
    NSMutableArray *recvArr =[NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSArray *jsonArr = dic[@"list"];
        [jsonArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            NSDictionary *mbMemberDic =recvDic[@"mbMember"];
            
            HuaTiListModel *huatiM =[HuaTiListModel new];
            huatiM.ID              =[NSString stringWithFormat:@"%@",recvDic[@"id"]];
            huatiM.activityType    =[NSString stringWithFormat:@"%@",recvDic[@"activityType"]];
            huatiM.title           =[NSString stringWithFormat:@"%@",recvDic[@"title"]];
            huatiM.activityContent =[NSString stringWithFormat:@"%@",recvDic[@"activityContent"]];
            huatiM.xqNo            =[NSString stringWithFormat:@"%@",recvDic[@"xqNo"]];
            huatiM.wyNo            =[NSString stringWithFormat:@"%@",recvDic[@"wyNo"]];
            huatiM.activityTime    =[NSString stringWithFormat:@"%@",recvDic[@"activityTime"]];
            huatiM.activityAddress =[NSString stringWithFormat:@"%@",recvDic[@"activityAddress"]];
            huatiM.activityMoney   =[NSString stringWithFormat:@"%@",recvDic[@"activityMoney"]];
            huatiM.prize           =[NSString stringWithFormat:@"%@",recvDic[@"prize"]];
            huatiM.createTimeStr   =[NSString stringWithFormat:@"%@",recvDic[@"createTimeStr"]];
            huatiM.status          =[NSString stringWithFormat:@"%@",recvDic[@"status"]];
            huatiM.imgPath         =recvDic[@"imgPath"];
            huatiM.commentNumber   =recvDic[@"commentNumber"];
            huatiM.flowerCount     =recvDic[@"flowerCount"];
            huatiM.nickName        =[NSString stringWithFormat:@"%@",mbMemberDic[@"nickName"]];
            huatiM.photourl      =[NSString stringWithFormat:@"%@",mbMemberDic[@"photourl"]];
            huatiM.accountName     =[NSString stringWithFormat:@"%@",mbMemberDic[@"accountName"]];
            huatiM.complaintType   =[NSString stringWithFormat:@"%@",recvDic[@"complaintType"]];
            [recvArr addObject:huatiM];
        }];
        huatiM.list =[recvArr copy];
    }
    return huatiM;
}


//查询话题详情
-(void)queryHuaTiDetails111:(NSDictionary *)Dic success:(SuccessBlock)success failed:(FailedBlock)failed;
{
    
    NSLog(@"dic =%@",Dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:HuatiList] requestType:ZJHttpRequestPost parameters:Dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"PostHuatiListresponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            HuaTiListModel *huatiM =[self huatiListJSon:dic];
            success(huatiM);

            return ;
            
        }
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}



@end
