//
//  NeighbourHoodHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NeighbourHoodHandler.h"
#import "NetworkRequest.h"
#import "APIConfig.h"

@implementation NeighbourHoodHandler
//获取话题分类
- (void)getTopicClass:(ClassHuaTiModel *)topClass
              success:(SuccessBlock)success
               failed:(FailedBlock)failed

{
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:topClass.wyId  ,@"wyId", nil];
    
    
    NSLog(@"dic >> %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:TopicClass] requestType:ZJHttpRequestGet parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success)
            {
                ClassHuaTiModel *huatiM =[self huatiTypeJson:dic];
                success(huatiM.list);
                return;
            }
            
            NSLog(@"yes");
            
        }
        
        //NSLog(@"response dic = %@",dic);
        failed(nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

-(ClassHuaTiModel *)huatiTypeJson:(NSDictionary *)dic
{
    ClassHuaTiModel *huatiM =[ClassHuaTiModel new];
    huatiM.wyId  =dic[@"wyId"];
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dict =(NSDictionary *)obj;
            
            ClassHuaTiModel *huatiM =[ClassHuaTiModel new];
            huatiM.ID =  dict[@"id"];
            huatiM.wyId =dict[@"wyId"];
            huatiM.typeName =dict[@"typeName"];
            huatiM.author   =dict[@"author"];
            huatiM.remark   =dict[@"remark"];
            huatiM.code     =dict[@"code"];
            [arr addObject:huatiM];
        }];
        
        huatiM.list =[arr mutableCopy];
    }
    return huatiM;
    
}

//新建话题（ 我要发帖）
-(void)NewHuaTi:(NewHuaTiModel *)NewHT
        success:(SuccessBlock)success
         failed:(FailedBlock)failed
{
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           NewHT.memberid,@"memberid",
                           NewHT.wyNo,@"wyNo",
                           NewHT.xqNo,@"xqNo",
                           NewHT.activityType,@"activityType",
                           NewHT.title,@"title",
                           NewHT.activityContent,@"activityContent",
                           NewHT.fileId,@"fileId",
                           NewHT.complaintType,@"complaintType",
                           NewHT.type,@"type",
                           NewHT.status,@"status",
                           nil];
    
    
    NSLog(@"dic >> %@",Dict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:NeighbourHoodNewHuaTi] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            if (success) {
                success(dic);
                return;
            }
            
            NSLog(@"yes");
            
        }
        
        //NSLog(@"response dic = %@",dic);
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
        
    }];

}

@end
