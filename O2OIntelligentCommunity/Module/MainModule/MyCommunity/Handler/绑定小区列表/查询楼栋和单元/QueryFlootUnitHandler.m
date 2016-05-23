//
//  QueryFlootUnitHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "QueryFlootUnitHandler.h"

@implementation QueryFlootUnitHandler

//根据小区查询楼栋或者单元
- (void)QueryFlootUnit:(QueryFlootUnitModel *)queryflootunit
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
{
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:queryflootunit.xqId,@"xqId",queryflootunit.type,@"type",queryflootunit.parentId,@"parentId",nil];

    NSLog(@"Dict >> %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:QueryFloorUnitinterface] requestType:ZJHttpRequestGet parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"response dic = %@",dic);
        if (success && [NSJSONSerialization isValidJSONObject:dic])
        {
            NSLog(@"response dic = %@",dic);
            QueryFlootUnitModel *bindM;
            bindM =[self queryFLootUnitJson:dic];
            if (![NSString isEmptyOrNull:dic[@"code"]] &&
                [dic[@"code"] isEqualToString:@"success"]) {
                success(bindM.list);
                return;
            }
        }

        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
        
    }];

}

-(QueryFlootUnitModel *)queryFLootUnitJson:(NSDictionary *)dicJson
{
    QueryFlootUnitModel *QueryM = [QueryFlootUnitModel new];
    QueryM.xqId = dicJson[@"xqId"];
    QueryM.type =dicJson[@"type"];
    QueryM.parentId=dicJson[@"parentId"];
    
    
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            NSDictionary *propCommunityhouseDic =recvDic[@"propCommunityhouse"];
           
            
            QueryFlootUnitModel *QueryM =[QueryFlootUnitModel new];
          
            if (![NSString isEmptyOrNull:recvDic[@"pId"]])
            {
                QueryM.pId   =recvDic[@"pId"];
            }
            
            if (![NSString isEmptyOrNull:recvDic[@"id"]])
            {
                  QueryM.ID    =recvDic[@"id"];
            }
            if (![NSString isEmptyOrNull:recvDic[@"houseName"]])
            {
                QueryM.houseName =recvDic[@"houseName"];
            }
            
            if (![NSString isEmptyOrNull:recvDic[@"hId"]])
            {
                QueryM.hId   = recvDic[@"hId"];
            }
            
            if (![NSString isEmptyOrNull:recvDic[@"type"]])
            {
                QueryM.type  =recvDic[@"type"];
            }
            if (![NSString isEmptyOrNull:propCommunityhouseDic[@"parentId"]])
            {
                  QueryM.parentId  =propCommunityhouseDic[@"parentId"];
            }
            if (![NSString isEmptyOrNull:recvDic[@"phone"]])
            {
                QueryM.phone =recvDic[@"phone"];
            }
            if (![NSString isEmptyOrNull:recvDic[@"room"]])
            {
                QueryM.room =recvDic[@"room"];
            }
            if (![NSString isEmptyOrNull:recvDic[@"roomId"]])
            {
                QueryM.roomId =recvDic[@"roomId"];
            }
            [arr addObject:QueryM];
        }];
        QueryM.list = [arr copy];
    }
    
    return QueryM;

}


@end
