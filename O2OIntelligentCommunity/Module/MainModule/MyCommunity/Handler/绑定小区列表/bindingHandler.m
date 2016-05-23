//
//  bindingHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "bindingHandler.h"
#import "BingingXQModel.h"  
#import "UserManager.h"

@implementation bindingHandler

//绑定小区
- (void)bangdingxiaoqu:(BingingXQModel *)MineXq
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
{
    NSDictionary * uploaDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                MineXq.merberId,@"memberId",
                                MineXq.xqNo,@"xqNo",
                                MineXq.floorNumber,@"floorNumber",
                                MineXq.roomNumber,@"roomNumber",
                                MineXq.userName,@"userName",
                                MineXq.userPhone,@"userPhone",
                                MineXq.smstype,@"smstype",
                                MineXq.bindingId,@"id",
                                MineXq.code,@"code",
                                MineXq.identity,@"identity",
                                MineXq.unitNumber,@"unitNumber",
                                MineXq.roomId,@"roomId",
                                nil];
    
    
    NSLog(@"Upload >> %@",uploaDict);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBinding] requestType:ZJHttpRequestPost parameters:uploaDict prepareExecute:^{
    //[[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:@"192.168.1.98:8888" WithPort:@"/sup-rs" WithPath:MineBinding] requestType:ZJHttpRequestPost parameters:uploaDict prepareExecute:^{

        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"bangdingxiaoquresponse dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            if (![NSString isEmptyOrNull:dic[@"code"]] && [dic[@"code"] isEqualToString:@"success"])
            {
                success(dic[@"message"]);
                return;
            }
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}

//小区
- (void)requsetForGetCommunityDataForModel:(BingingXQModel *)bindingXq
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
//                        bindingXq.wyId,@"comapyanyId",
                        bindingXq.merberId,@"memberId",
                        bindingXq.isBinding,@"isBinding",
                        nil];
    
    NSDictionary * Dict = [NSDictionary dictionaryWithObjectsAndKeys:bindingXq.pageNumber,@"pageNumber",
                           bindingXq.pageSize,@"pageSize",
                           bindingXq.orderType,@"orderType",
                           bindingXq.orderBy,@"orderBy",
                           dic,@"queryMap",nil];

    NSLog(@"requsetForGetCommunityDataForModel Dict >> %@",[NSString jsonStringWithDictionary:Dict]);
    
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:bingingXQList] requestType:ZJHttpRequestPost parameters:Dict prepareExecute:^{
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic1] && success)
        {
            NSLog(@"bangdingxiaoquresponse dic = %@",dic1);
            BingingXQModel *bindM =[self bindXQJson:dic1];
            success(bindM.list);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

-(BingingXQModel *)bindXQJson:(NSDictionary *)dicJson
{
    BingingXQModel *bingM = [BingingXQModel new];
    bingM.pageNumber=dicJson[@"pageNumber"];
    bingM.pageSize=dicJson[@"pageSize"];
    bingM.merberId=dicJson[@"merberId"];
    

    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            [arr addObject:[self decodeXQDataDicJson:recvDic]];
        }];
        bingM.list = [arr copy];
    }
    
    return bingM;
}

- (BingingXQModel *)decodeXQDataDicJson:(NSDictionary *)recvDic {
    BingingXQModel *bingM = [BingingXQModel new];
    bingM.xqNo            =[NSString stringFromat:recvDic[@"xqNo"]];
    bingM.merberId        =[NSString stringFromat:recvDic[@"merberId"]];
    
    bingM.floorNumber     =[NSString stringFromat:recvDic[@"floorNumber"]];
    
    if (![NSString isEmptyOrNull:recvDic[@"unitNumber"]]) {
        bingM.unitNumber  =[NSString stringFromat:recvDic[@"unitNumber"]];
    }
    
    if (![NSString isEmptyOrNull:recvDic[@"unitName"]]) {
        bingM.unitName    =[NSString stringFromat:recvDic[@"unitName"]];
    }
    
    bingM.roomNumber      =[NSString stringFromat:recvDic[@"roomNumber"]];
    bingM.floorName       =[NSString stringFromat:recvDic[@"floorName"]];
    
    if ([NSString isEmptyOrNull:bingM.unitName]) {
        bingM.xqHouse         =[NSString stringWithFormat:@"%@%@",bingM.floorName,bingM.roomNumber];
    }
    else {
        bingM.xqHouse         =[NSString stringWithFormat:@"%@%@%@",bingM.floorName,bingM.unitName,bingM.roomNumber];
    }
    
    NSLog(@"bingM.xqHouse = %@",bingM.xqHouse);
    
    bingM.isBinding       =[NSString stringFromat:recvDic[@"isBinding"]];
    bingM.bindingId       =[NSString stringFromat:recvDic[@"id"]];
    bingM.isCheckPass     =[NSString stringFromat:recvDic[@"isCheckPass"]];

    NSDictionary *propCommunityhouseDic =recvDic[@"propCommunityhouse"];
    if (![NSDictionary isDicEmptyOrNull:propCommunityhouseDic]) {
        bingM.imgPath         =propCommunityhouseDic[@"imgPath"];
        
        bingM.cityid          =[NSString stringFromat:propCommunityhouseDic[@"cityId"]];
        bingM.xqAdress        =[NSString stringFromat:propCommunityhouseDic[@"communityAddress"]];
        bingM.wyId            =[NSString stringFromat:propCommunityhouseDic[@"comapyanyId"]];
        bingM.xqName          =[NSString stringFromat:propCommunityhouseDic[@"communityName"]];
        NSLog(@"bingM.xqName  = %@",bingM.xqName );
        //小区的部分权限
        bingM.propertyConst     =[NSString stringFromat:propCommunityhouseDic[@"propertyConst"]];
        bingM.parkingFees       =[NSString stringFromat:propCommunityhouseDic[@"parkingFees"]];
        bingM.pass              =[NSString stringFromat:propCommunityhouseDic[@"pass"]];
        bingM.complaints        =[NSString stringFromat:propCommunityhouseDic[@"complaints"]];
        bingM.repair            =[NSString stringFromat:propCommunityhouseDic[@"repair"]];
        bingM.opinion           =[NSString stringFromat:propCommunityhouseDic[@"opinion"]];
        bingM.longitude         =[NSString stringFromat:propCommunityhouseDic[@"longitudu"]];
        bingM.latitude          =[NSString stringFromat:propCommunityhouseDic[@"latitude"]];
        
        NSDictionary *propAreaDic =propCommunityhouseDic[@"propArea"];
        if (![NSDictionary isDicEmptyOrNull:propAreaDic]) {
            bingM.areaname = [NSString stringFromat:propAreaDic[@"areaname"]];
        }
        
        NSDictionary *propCityDic =propCommunityhouseDic[@"propCity"];
        if (![NSDictionary isDicEmptyOrNull:propCityDic]) {
            bingM.cityName = [NSString stringFromat:propCityDic[@"areaname"]];
        }
    }

    return bingM;
}

@end
