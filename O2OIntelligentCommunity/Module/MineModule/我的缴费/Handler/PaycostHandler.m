//
//  PaycostHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.

#define KEY_CTS @"ctS"//水
#define KEY_CTD @"ctD"//电
#define KEY_CTM @"ctM"//燃
#define KEY_CTW @"ctW"//物
#define KEY_CTT @"ctT"//停

#import "PaycostHandler.h"
#import "NSString+wrapper.h"

@implementation PaycostHandler
//缴费
-(void)Paycost:(PaycostModel *)pay success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:pay.memberId,@"memberId", nil];
    NSLog(@"dic==%@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:Paycostinterface] requestType:ZJHttpRequestGet parameters:dic prepareExecute:^{
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            PaycostModel *payM =[self PaycostJson:dic];
            NSLog(@"payM.list==%@",payM.list);
            success(payM.list);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}

-(PaycostModel *)PaycostJson:(NSDictionary *)dic
{
    PaycostModel *payM =[PaycostModel new];
    
    
    if (![NSArray isArrEmptyOrNull:dic[@"listObj"]])
    {
        NSMutableArray *monthList =[NSMutableArray array];
        [dic[@"listObj"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            NSMutableArray *monthChargeArr = [NSMutableArray array];
            NSArray *SArray =recvDic[@"S"];
            NSArray *DArray =recvDic[@"D"];
            NSArray *MArray =recvDic[@"M"];
            NSArray *TArray =recvDic[@"T"];
            NSArray *WArray =recvDic[@"W"];
            NSArray *HArray =recvDic[@"H"];
            NSArray *JArray =recvDic[@"J"];
            
            if (![NSArray isArrEmptyOrNull:SArray]) {
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailS:SArray]];
            }
            
            if (![NSArray isArrEmptyOrNull:DArray]) {
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailD:DArray]];
            }
            
            if (![NSArray isArrEmptyOrNull:MArray]){
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailM:MArray]];
            }
            
            if (![NSArray isArrEmptyOrNull:TArray]){
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailT:TArray]];
            }

            if (![NSArray isArrEmptyOrNull:WArray]){
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailW:WArray]];
            }

            if (![NSArray isArrEmptyOrNull:HArray]) {
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailH:HArray]];
            }
            
            if (![NSArray isArrEmptyOrNull:JArray]) {
                [monthChargeArr addObjectsFromArray:[self decodeChargeDetailJ:JArray]];
            }
            
            PaycostModel *paymodel = [PaycostModel new];
            if (![NSArray isArrEmptyOrNull:monthChargeArr])
            {
                paymodel.array=monthChargeArr;
                paymodel.consumeCycle=recvDic[@"consumeCycle"];
                [monthList addObject:paymodel];
            }
            
        }];
        
        payM.list =[monthList copy];
    }
    return payM;
}

-(NSArray *)decodeChargeDetailS:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"S";
        
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }

        if (![NSString isEmptyOrNull:chargeDic[@"preapidFlag"]]) {
            chargeM.preapidFlag   = [NSString stringWithFormat:@"%@",chargeDic[@"preapidFlag"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"chargeUnit"]]) {
            chargeM.chargeUnit   = [NSString stringWithFormat:@"%@",chargeDic[@"chargeUnit"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeCycle"]]) {
            chargeM.consumeCycle = [NSString stringWithFormat:@"%@",chargeDic[@"consumeCycle"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"dateUpdate"]]) {
            chargeM.dateUpdated   = [NSString stringWithFormat:@"%@",chargeDic[@"dateUpdate"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId      = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"saleAmount"]]) {
            chargeM.saleAmount   = [NSString stringWithFormat:@"%@",chargeDic[@"saleAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"sdmStatus"]]) {
            chargeM.sdmStatus    = [NSString stringWithFormat:@"%@",chargeDic[@"sdmStatus"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"sdmType"]]) {
            chargeM.sdmType      = [NSString stringWithFormat:@"%@",chargeDic[@"sdmType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"userNumber"]]) {
            chargeM.userNumber   = [NSString stringWithFormat:@"%@",chargeDic[@"userNumber"]];
        }

        if (![NSString isEmptyOrNull:chargeDic[@"customerName"]]) {
            chargeM.name        = [NSString stringWithFormat:@"%@",chargeDic[@"customerName"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"userAddress"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"userAddress"]];
        }
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}
-(NSArray *)decodeChargeDetailD:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"D";
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }

        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"preapidFlag"]]) {
            chargeM.preapidFlag   = [NSString stringWithFormat:@"%@",chargeDic[@"preapidFlag"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"chargeUnit"]]) {
            chargeM.chargeUnit   = [NSString stringWithFormat:@"%@",chargeDic[@"chargeUnit"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeCycle"]]) {
            chargeM.consumeCycle = [NSString stringWithFormat:@"%@",chargeDic[@"consumeCycle"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"dateCreated"]]) {
            chargeM.dateCreated   = [NSString stringWithFormat:@"%@",chargeDic[@"dateCreated"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId      = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"saleAmount"]]) {
            chargeM.saleAmount   = [NSString stringWithFormat:@"%@",chargeDic[@"saleAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"sdmStatus"]]) {
            chargeM.sdmStatus    = [NSString stringWithFormat:@"%@",chargeDic[@"sdmStatus"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }

        
        if (![NSString isEmptyOrNull:chargeDic[@"sdmType"]]) {
            chargeM.sdmType      = [NSString stringWithFormat:@"%@",chargeDic[@"sdmType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"userNumber"]]) {
            chargeM.userNumber   = [NSString stringWithFormat:@"%@",chargeDic[@"userNumber"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"customerName"]]) {
            chargeM.name         = [NSString stringWithFormat:@"%@",chargeDic[@"customerName"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"userAddress"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"userAddress"]];
        }
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}
-(NSArray *)decodeChargeDetailM:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"M";
        
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"preapidFlag"]]) {
            chargeM.preapidFlag   = [NSString stringWithFormat:@"%@",chargeDic[@"preapidFlag"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"chargeUnit"]]) {
            chargeM.chargeUnit   = [NSString stringWithFormat:@"%@",chargeDic[@"chargeUnit"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeCycle"]]) {
            chargeM.consumeCycle = [NSString stringWithFormat:@"%@",chargeDic[@"consumeCycle"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"dateCreated"]]) {
            chargeM.dateUpdated  = [NSString stringWithFormat:@"%@",chargeDic[@"dateCreated"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId      = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"saleAmount"]]) {
            chargeM.saleAmount   = [NSString stringWithFormat:@"%@",chargeDic[@"saleAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"sdmStatus"]]) {
            chargeM.sdmStatus    = [NSString stringWithFormat:@"%@",chargeDic[@"sdmStatus"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }

        
        if (![NSString isEmptyOrNull:chargeDic[@"sdmType"]]) {
            chargeM.sdmType      = [NSString stringWithFormat:@"%@",chargeDic[@"sdmType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"userNumber"]]) {
            chargeM.userNumber   = [NSString stringWithFormat:@"%@",chargeDic[@"userNumber"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"customerName"]]) {
            chargeM.name         = [NSString stringWithFormat:@"%@",chargeDic[@"customerName"]];
        }
       
        if (![NSString isEmptyOrNull:chargeDic[@"userAddress"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"userAddress"]];
        }
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}

-(NSArray *)decodeChargeDetailW:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"W";
        
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"chargeUnit"]]) {
            chargeM.chargeUnit   = [NSString stringWithFormat:@"%@",chargeDic[@"chargeUnit"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeCycle"]]) {
            chargeM.consumeCycle = [NSString stringWithFormat:@"%@",chargeDic[@"consumeCycle"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeType"]]) {
            chargeM.consumeType  = [NSString stringWithFormat:@"%@",chargeDic[@"consumeType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"dateUpdated"]]) {
            chargeM.dateUpdated  = [NSString stringWithFormat:@"%@",chargeDic[@"dateUpdated"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId      = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"saleAmount"]]) {
            chargeM.saleAmount   = [NSString stringWithFormat:@"%@",chargeDic[@"saleAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"dateCreated"]]) {
            chargeM.dateCreated  = [NSString stringWithFormat:@"%@",chargeDic[@"dateCreated"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"name"]]) {
            chargeM.name         = [NSString stringWithFormat:@"%@",chargeDic[@"name"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"status"]]) {
            chargeM.sdmStatus    = [NSString stringWithFormat:@"%@",chargeDic[@"status"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }

        
        if (![NSString isEmptyOrNull:chargeDic[@"address"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"address"]];
        }
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}

-(NSArray *)decodeChargeDetailT:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"T";
        
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"status"]]) {
            chargeM.sdmStatus   = [NSString stringWithFormat:@"%@",chargeDic[@"status"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }

        
        if (![NSString isEmptyOrNull:chargeDic[@"chargeUnit"]]) {
            chargeM.chargeUnit  = [NSString stringWithFormat:@"%@",chargeDic[@"chargeUnit"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeCycle"]]) {
            chargeM.consumeCycle= [NSString stringWithFormat:@"%@",chargeDic[@"consumeCycle"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"consumeType"]]) {
            chargeM.consumeType = [NSString stringWithFormat:@"%@",chargeDic[@"consumeType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"dateCreated"]]) {
            chargeM.dateCreated = [NSString stringWithFormat:@"%@",chargeDic[@"dateCreated"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"licenseNumber"]]) {
            chargeM.licenseNumber = [NSString stringWithFormat:@"%@",chargeDic[@"licenseNumber"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId     = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"parkingType"]]) {
            chargeM.parkingType = [NSString stringWithFormat:@"%@",chargeDic[@"parkingType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"saleAmount"]]) {
            chargeM.saleAmount  = [NSString stringWithFormat:@"%@",chargeDic[@"saleAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"name"]]) {
            chargeM.name        = [NSString stringWithFormat:@"%@",chargeDic[@"name"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"payMonths"]]) {
            chargeM.payMonths   = [NSString stringWithFormat:@"%@",chargeDic[@"payMonths"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"address"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"address"]];
        }
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}
-(NSArray *)decodeChargeDetailH:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"H";
        
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"ctype"]]) {
            chargeM.ctype =[NSString stringWithFormat:@"%@",chargeDic[@"ctype"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"createTime"]]) {
            chargeM.createTime = [NSString stringWithFormat:@"%@",chargeDic[@"createTime"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId   = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"payAmount"]]) {
            chargeM.payAmount = [NSString stringWithFormat:@"%@",chargeDic[@"payAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"saleAmount"]]) {
            chargeM.saleAmount= [NSString stringWithFormat:@"%@",chargeDic[@"saleAmount"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"status"]]) {
            chargeM.sdmStatus = [NSString stringWithFormat:@"%@",chargeDic[@"status"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }

        
        if (![NSString isEmptyOrNull:chargeDic[@"usernumber"]]) {
            chargeM.usernumber= [NSString stringWithFormat:@"%@",chargeDic[@"usernumber"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"address"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"address"]];
        }
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}
-(NSArray *)decodeChargeDetailJ:(NSArray *)chargeArr {
    NSMutableArray *returnArr = [NSMutableArray array];
    [chargeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *chargeDic = obj;
        PaycostModel *chargeM = [PaycostModel new];
        chargeM.type         = @"J";
        
        if (![NSString isEmptyOrNull:chargeDic[@"refund"]])
        {
            chargeM.refund = [NSString stringWithFormat:@"%@",chargeDic[@"refund"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"money"]])
        {
            chargeM.money = [NSString stringWithFormat:@"%@",chargeDic[@"money"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"updateTime"]])
        {
            chargeM.updateTime = [NSString stringWithFormat:@"%@",chargeDic[@"updateTime"]];
        }
        if (![NSString isEmptyOrNull:chargeDic[@"createTime"]]) {
            chargeM.createTime = [NSString stringWithFormat:@"%@",chargeDic[@"createTime"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"carType"]]) {
            chargeM.carType = [NSString stringWithFormat:@"%@",chargeDic[@"carType"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"carnumber"]]) {
            chargeM.carnumber = [NSString stringWithFormat:@"%@",chargeDic[@"carnumber"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"count"]]) {
            chargeM.count     = [NSString stringWithFormat:@"%@",chargeDic[@"count"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"orderId"]]) {
            chargeM.orderId   = [NSString stringWithFormat:@"%@",chargeDic[@"orderId"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"status"]]) {
            chargeM.sdmStatus = [NSString stringWithFormat:@"%@",chargeDic[@"status"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"statusCN"]])
        {
            chargeM.statusCN     = [NSString stringWithFormat:@"%@",chargeDic[@"statusCN"]];
        }

        if (![NSString isEmptyOrNull:chargeDic[@"name"]]) {
            chargeM.name      = [NSString stringWithFormat:@"%@",chargeDic[@"name"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"address"]]) {
            chargeM.address       = [NSString stringWithFormat:@"%@",chargeDic[@"address"]];
        }
        
        if (![NSString isEmptyOrNull:chargeDic[@"poundage"]])
        {
            chargeM.poundage   = [NSString stringWithFormat:@"%@",chargeDic[@"poundage"]];
        }
        
        [returnArr addObject:chargeM];
    }];
    return returnArr;
}



@end
