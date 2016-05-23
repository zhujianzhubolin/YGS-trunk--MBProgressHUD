//
//  MoneyBaginfoHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoneyBaginfoHandler.h"

@implementation MoneyBaginfoHandler

//钱包信息
-(void)moneybaginfo:(MoneyBagInfoModel *)info success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        info.memberId,@"memberId",
                        nil];
    NSLog(@"ChangeInfo dic = %@",dic);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:MoneyBagInfo] requestType:ZJHttpRequestGet parameters:dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"moneybaginforesponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            MoneyBagInfoModel *moneyinfoM =[self moneybagInfoJson:dic];
            success(moneyinfoM);
            return;
            
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}

-(MoneyBagInfoModel *)moneybagInfoJson:(NSDictionary *)dicJson
{
    MoneyBagInfoModel *moneyM =[MoneyBagInfoModel new];
    if (![NSArray isArrEmptyOrNull:dicJson[@"mycardBean"]])
    {
        NSDictionary *dic=dicJson[@"mycardBean"];
        moneyM.amount=[NSString stringWithFormat:@"%@",dic[@"amount"]];
        moneyM.ID =[NSString stringWithFormat:@"%@",dic[@"id"]];
        moneyM.cardNo=[NSString stringWithFormat:@"%@",dic[@"cardNo"]];
        moneyM.vipNo=[NSString stringWithFormat:@"%@",dic[@"vipNo"]];
        moneyM.isDelete=[NSString stringWithFormat:@"%@",dic[@"isDelete"]];
        moneyM.dateCreated=[NSString stringWithFormat:@"%@",dic[@"dateCreated"]];
        moneyM.updateBy=[NSString stringWithFormat:@"%@",dic[@"updateBy"]];
        moneyM.dateUpdated=[NSString stringWithFormat:@"%@",dic[@"dateUpdated"]];
        moneyM.isFreeze=[dic[@"isFreeze"] boolValue];
        
        moneyM.isActivate=[NSString stringWithFormat:@"%@",dic[@"isActivate"]];
        moneyM.name =[NSString stringWithFormat:@"%@",dic[@"name"]];
        moneyM.idNumber =[NSString stringWithFormat:@"%@",dic[@"idNumber"]];
        moneyM.message=[NSString stringWithFormat:@"%@",dicJson[@"message"]];
        moneyM.code=[NSString stringWithFormat:@"%@",dicJson[@"code"]];
    }
    return moneyM;
}

@end
