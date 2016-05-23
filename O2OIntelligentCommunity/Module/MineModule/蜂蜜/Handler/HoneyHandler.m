//
//  HoneyHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/30.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "HoneyHandler.h"

@implementation HoneyHandler


-(id)init
{
    self = [super init];
    if (self) {
        [self honeyResetData];
    }
    return self;
}

-(void)honeyResetData{
    self.honeyPage  = @"1";
    self.honeyCount = @"1";
    self.honeyArr   = [NSMutableArray array];
    self.recvArr = [NSMutableArray array];

    
}

//查询会员相关的积分交易信息
-(void)queryHoneyTradeInfo:(HoneyTradeInfoModel *)honey success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.honeyPage  = @"1";
        self.honeyCount = @"1";
    }
    else
    {
        if (self.honeyPage.integerValue > self.honeyCount.integerValue)
        {
            success(self.honeyArr);
            return;
        }
        self.honeyPage = [NSString stringWithFormat:@"%ld",self.honeyPage.integerValue + 1];
    }
    honey.pageNumber = self.honeyPage;
    
    NSDictionary *honeyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              honey.pageNumber,@"pageNumber",
                              honey.pageSize,@"pageSize",
                              honey.memberId,@"memberId",
                              nil];
    
    NSLog(@"honeyDic = %@",honeyDic);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:POSTHONEYINFO] requestType:ZJHttpRequestGet parameters:honeyDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"honey json =%@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            HoneyTradeInfoModel *honeyMM =[self honeyJSon:dic isHeader:isheader];
            self.honeyCount =honeyMM.pageCount;
            self.honeyArr =[honeyMM.list mutableCopy];
            success(self.honeyArr);
            return;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}

//查询会员积分
-(void)queryVIPHoneyInfo:(HoneyTradeInfoModel *)honey success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        honey.memberId,@"memberId",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:POSTVipHoneyInfo] requestType:ZJHttpRequestGet parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"Honeyinforesponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            
            success(dic[@"point"]);
            return;
            
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}

//积分兑换
-(void)exchangeHoney:(HoneyTradeInfoModel *)honey success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        honey.memberId,@"memberId",
                        honey.integral,@"integral",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:PostExchangeHoney] requestType:ZJHttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"Honeyinforesponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            if(![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
            {
                success(dic);
                return;
            }
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}

-(HoneyTradeInfoModel *)honeyJSon:(NSDictionary *)dicJson isHeader:(BOOL)isheader
{
    HoneyTradeInfoModel *honeyM =[HoneyTradeInfoModel new];
    honeyM.pageNumber =dicJson[@"pageNumber"];
    honeyM.pageSize   =dicJson[@"pageSize"];
    honeyM.pageCount  =dicJson[@"pageCount"];

    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        if (isheader){
            [self.recvArr removeAllObjects];
        }
       
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *recvDic = (NSDictionary *)obj;
            NSLog( @"point =%@",recvDic[@"point"]);
            HoneyTradeInfoModel * honeyTradeM = [HoneyTradeInfoModel new];
            honeyTradeM.changeDesc =[NSString stringWithFormat:@"%@",recvDic[@"changeDesc"]];
            honeyTradeM.changTime  =[NSString stringWithFormat:@"%@",recvDic[@"changeTime"]];
            honeyTradeM.beforeBusinessPoint = [NSString stringWithFormat:@"%@",recvDic[@"beforeBusinessPoint"]];
            honeyTradeM.afterBusinessPoint = [NSString stringWithFormat:@"%@",recvDic[@"afterBusinessPoint"]];
            honeyTradeM.changeType = [NSString stringWithFormat:@"%@",recvDic[@"changeType"]];
            honeyTradeM.point = [NSString stringWithFormat:@"%@",recvDic[@"point"]];
            [self.recvArr addObject:honeyTradeM];
            
        }];
    }
    honeyM.list = [self honeyPayInfo:self.recvArr];
    return honeyM;
}

- (NSArray *)honeyPayInfo:(NSArray *)payList {
    NSMutableArray *list = [NSMutableArray array];
    NSLog(@"paylist.count = %d",payList.count);
    [payList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HoneyTradeInfoModel *moneyM1 = (HoneyTradeInfoModel *)obj;
        if (idx == 0) {
            NSMutableArray *listOne = [NSMutableArray array];
            [listOne addObject:moneyM1];
            [list addObject:listOne];
        }
        
        if (idx == payList.count - 1) {
            return;
        }
        
        NSString *detailDate1 = nil;
        NSUInteger interceptionLenth = 7;
        if (moneyM1.changTime.length > interceptionLenth) {
            detailDate1 = [moneyM1.changTime substringToIndex:interceptionLenth];
            NSLog(@"detailDate1 = %@",detailDate1);
        }
        
        HoneyTradeInfoModel *moneyM2 = payList[idx + 1];
        NSString *detailDate2 = nil;
        if (moneyM2.changTime.length > interceptionLenth) {
            detailDate2 = [moneyM2.changTime substringToIndex:interceptionLenth];
        }
        
        if (![NSString isEmptyOrNull:detailDate2] && [detailDate2 isEqualToString:detailDate1]) {
            NSMutableArray *lastList = list[list.count - 1];
            [lastList addObject:payList[idx + 1]];
        }
        else {
            NSMutableArray *listOther = [NSMutableArray array];
            [listOther addObject:payList[idx + 1]];
            [list addObject:listOther];
        }
    }];
    NSLog(@"list = %@",list);
    return  [list copy];

}


//多少蜂蜜对应1元
- (void)beeToOneYuan:(HoneyTradeInfoModel *)honey success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
//                        honey.memberId,@"memberId",
                        honey.reference,@"reference",
                        nil];
    NSLog(@"多少滴对应一元 = = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:BeeToOneYuan] requestType:ZJHttpRequestGet parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"多少滴对应一元 = %@",dic);
        
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            success([self sendOneYuan:dic]);
            return;
            
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
//        NSLog(@"多少滴对应一元 =>>>>%@",error);
    }];

}


- (NSString *)sendOneYuan:(NSDictionary *)data{

    if (![data[@"entity"] isEqual:[NSNull null]]) {
        return data[@"entity"][@"integralpoint"];
    }else{
        return @"";
    }
}

@end
