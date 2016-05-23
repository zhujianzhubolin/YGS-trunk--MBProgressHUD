//
//  MoneyBaghandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoneyBaghandler.h"

@implementation MoneyBaghandler
-(id)init
{
    self =[super init];
    if (self) {
        [self resetData];
    }
    return self;
}

- (void)resetData {
    self.moneyBagcurrentPage=@"1";
    self.moneyBagpageCount=@"1";
    self.moneyBagArray =[NSMutableArray array];
    self.recvArr = [NSMutableArray array];
}
//获取钱包支付信息记录
-(void)postjiaoyixinxi:(MoneybagModel *)moneyinfo success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.moneyBagcurrentPage = @"1";
        self.moneyBagpageCount   = @"1";
    }
    else
    {
        if(self.moneyBagcurrentPage.intValue > self.moneyBagpageCount.intValue)
        {
            success(self.moneyBagArray);
            return;
        }
        self.moneyBagcurrentPage = [NSString stringWithFormat:@"%d",self.moneyBagcurrentPage.intValue +1];
    }
    
    moneyinfo.pageNumber = self.moneyBagcurrentPage;
    
    NSDictionary *moneydic =[NSDictionary dictionaryWithObjectsAndKeys:
                        moneyinfo.pageNumber,@"pageNumber",
                        moneyinfo.pageSize,@"pageSize",
                        moneyinfo.memberId,@"memberId",
                        nil];
    
    NSLog(@"获取钱包缴费信息=%@",moneydic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:MineMoneyInfointerface] requestType:ZJHttpRequestGet parameters:moneydic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取钱包缴费数据=%@",dict);
        if ([NSJSONSerialization isValidJSONObject:dict] && success) {
            MoneybagModel *moneym = [self moneyBagPayJson:dict isHeader:isheader];
            self.moneyBagpageCount = moneym.pageCount;
            self.moneyBagArray = [moneym.list mutableCopy];
            
            success(self.moneyBagArray);
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}


-(MoneybagModel *)moneyBagPayJson:(NSDictionary *)dicJson isHeader:(BOOL)isheader
{
    MoneybagModel *moneyM =[MoneybagModel new];
    moneyM.pageNumber =dicJson[@"pageNumber"];
    moneyM.pageSize   =dicJson[@"pageSize"];
    moneyM.pageCount  =dicJson[@"pageCount"];
    
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]]) {
        if (isheader) {
            [self.recvArr removeAllObjects];
        }
        
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = obj;
            MoneybagModel *moneyM = [MoneybagModel new];
            moneyM.dateCreated    = [NSString stringWithFormat:@"%@",recvDic[@"dateCreated"]];
            moneyM.businessType   = [NSString stringWithFormat:@"%@",recvDic[@"businessType"]];
            moneyM.businessDate   = [NSString stringWithFormat:@"%@",recvDic[@"businessDate"]];
            moneyM.businessAmount = [NSString stringWithFormat:@"%@",recvDic[@"businessAmount"]];
            
            [self.recvArr addObject:moneyM];
        }];
    }

    moneyM.list = [self combinationMoneyPayInfo:self.recvArr];
    return moneyM;
}

- (NSArray *)combinationMoneyPayInfo:(NSArray *)payList {
    NSMutableArray *list = [NSMutableArray array];
    NSLog(@"paylist.count = %d",payList.count);
    [payList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MoneybagModel *moneyM1 = obj;
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
        if (moneyM1.dateCreated.length > interceptionLenth) {
            detailDate1 = [moneyM1.dateCreated substringToIndex:interceptionLenth];
            NSLog(@"detailDate1 = %@",detailDate1);
        }
        
        MoneybagModel *moneyM2 = payList[idx + 1];
        NSString *detailDate2 = nil;
        if (moneyM2.dateCreated.length > interceptionLenth) {
            detailDate2 = [moneyM2.dateCreated substringToIndex:interceptionLenth];
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

@end
