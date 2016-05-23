//
//  ShengShiJiaH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShengShiJiaH.h"

@implementation ShengShiJiaH


//物业的数据列表
-(void)requestForGetShengShiJiaData:(ShengSJDataE *)shengSJE success:(SuccessBlock)success failed:(FailedBlock)failed {
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         shengSJE.pageNumber,@"pageNumber",
                         shengSJE.pageSize,@"pageSize",
                         shengSJE.queryMap,@"queryMap",
                         shengSJE.orderBy,@"orderBy",
                         shengSJE.orderType,@"orderType",
                         nil];
    NSString *dicttitle = [NSString jsonStringWithDictionary:dict];
    NSLog(@"dicttitle==%@",dicttitle);
    NSLog(@"getShengShiJiaData %@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:HuatiList] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"getShengShiJiaData recvDic = %@",recvDic);
        
        if ([NSJSONSerialization isValidJSONObject:recvDic] && success)
        {
            success(recvDic);
            return ;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
    }];
}

-(ShengSJDataE *)decodeShengSJDataJson:(NSDictionary *)dic
{
    ShengSJDataE *shengSJE =[ShengSJDataE new];
    shengSJE.pageNumber    =dic[@"pageNumber"];
    shengSJE.pageSize      =dic[@"pageSize"];
    shengSJE.orderBy       =dic[@"orderBy"];
    shengSJE.orderType     =dic[@"orderType"];
    shengSJE.pageCount     =dic[@"pageCount"];
    
    NSMutableArray *recvArr =[NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSArray *jsonArr = dic[@"list"];
        [jsonArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            NSDictionary *mbMemberDic =recvDic[@"mbMember"];
            
            ShengSJDataE *eachE =[ShengSJDataE new];
            eachE.ID              =[NSString stringWithFormat:@"%@",recvDic[@"id"]];
            eachE.activityType    =[NSString stringWithFormat:@"%@",recvDic[@"activityType"]];
            eachE.title           =[NSString stringWithFormat:@"%@",recvDic[@"title"]];
            eachE.activityContent =[NSString stringWithFormat:@"%@",recvDic[@"activityContent"]];
            eachE.xqNo            =[NSString stringWithFormat:@"%@",recvDic[@"xqNo"]];
            eachE.wyNo            =[NSString stringWithFormat:@"%@",recvDic[@"wyNo"]];
            eachE.word            =[NSString stringWithFormat:@"%@",recvDic[@"word"]];
            eachE.activityTime    =[NSString stringWithFormat:@"%@",recvDic[@"activityTime"]];
            eachE.activityAddress =[NSString stringWithFormat:@"%@",recvDic[@"activityAddress"]];
            eachE.activityMoney   =[NSString stringWithFormat:@"%@",recvDic[@"activityMoney"]];
            eachE.prize           =[NSString stringWithFormat:@"%@",recvDic[@"prize"]];
            eachE.createTimeStr   =[NSString stringWithFormat:@"%@",recvDic[@"createTimeStr"]];
            eachE.status          =[NSString stringWithFormat:@"%@",recvDic[@"status"]];
            eachE.opinionStatus   =[NSString stringWithFormat:@"%@",recvDic[@"opinionStatus"]];
            eachE.fleaMarketType  =[NSString stringWithFormat:@"%@",recvDic[@"fleaMarketType"]];
            eachE.transactionType =[NSString stringWithFormat:@"%@",recvDic[@"transactionType"]];
            eachE.price           =[NSString stringWithFormat:@"%@",recvDic[@"price"]];
            
            eachE.updateTimeStr   =[NSString stringWithFormat:@"%@",recvDic[@"updateTimeStr"]];
            eachE.photourl        =[NSString stringWithFormat:@"%@",mbMemberDic[@"photourl"]];
            eachE.nickName        =[NSString stringWithFormat:@"%@",mbMemberDic[@"nickName"]];
            
            eachE.imgPath         =recvDic[@"imgPath"];
            eachE.commentNumber   =recvDic[@"commentNumber"];
            eachE.flowerCount     =recvDic[@"flowerCount"];
            eachE.haedimgurl      =[NSString stringWithFormat:@"%@",recvDic[@"haedimgurl"]];
            eachE.accountName     =[NSString stringWithFormat:@"%@",mbMemberDic[@"accountName"]];
            eachE.complaintType   =[NSString stringWithFormat:@"%@",recvDic[@"complaintType"]];
            eachE.specialty       =[NSString stringWithFormat:@"%@",recvDic[@"specialty"]];
            eachE.dateCreated     =[NSString stringWithFormat:@"%@",mbMemberDic[@"dateCreated"]];
            eachE.phone           =[NSString stringWithFormat:@"%@",recvDic[@"phone"]];
            eachE.dataDict        =obj;
            [recvArr addObject:eachE];
        }];
        shengSJE.list =[recvArr copy];
    }
    return shengSJE;
}

//新建建议和意见
-(void)requestForSubmmitShengShiJiaData:(ShengSJNewBuiltE *)newBuiltE
                                success:(SuccessBlock)success
                                 failed:(FailedBlock)failed
{
    NSDictionary * paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           newBuiltE.memberid,@"memberid",
                           newBuiltE.wyNo,@"wyNo",
                           newBuiltE.xqNo,@"xqNo",
                           newBuiltE.type,@"type",
                           newBuiltE.activityType,@"activityType",
                           newBuiltE.title,@"title",
                           newBuiltE.activityContent,@"activityContent",
                           newBuiltE.fileId,@"fileId",
                           newBuiltE.cityId,@"cityId",
                           nil];
    NSLog(@"requestForSubmmitShengShiJiaDataparaDic >> %@",paraDic);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:NeighbourHoodNewHuaTi] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"response dic = %@",dic);
        if ([NSJSONSerialization isValidJSONObject:dic] && success && ![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"]) {
            success(dic[@"message"]);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"error = %@",error);
    }];
}

@end
