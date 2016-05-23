//
//  ComplainHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ComplaintHandler.h"
#import "ComplaintEntity.h"
#import "NSArray+wrapper.h"
#import "NSString+wrapper.h"

@implementation ComplaintHandler
- (void)executeSaveInfoTaskWithUser:(ComplaintSaveE *)complaint
                            success:(SuccessBlock)success
                             failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             complaint.memberid,@"memberid",
                             complaint.wyNo,@"wyNo",
                             complaint.xqNo,@"xqNo",
                             complaint.complaintType,@"complaintType",
                             complaint.complaintTitle,@"complaintTitle",
                             complaint.complaintContent,@"complaintContent",
                             complaint.complaintStatus,@"complaintStatus",
                             complaint.contactPerson,@"contactPerson",
                             complaint.contactPhone,@"contactPhone",
                             complaint.type,@"type",
                             complaint.contactAddress,@"contactAddress",
                             complaint.fileId,@"fileId",
                             complaint.source,@"source",
                             nil];
    NSLog(@"SaveInfoTasparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_COMPLAINT_SUBMIT] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"dic_json = %@",dic_json);
            ComplaintSaveE *saveE =[self decodeComplainSaveJson:dic_json];
            if (![NSString isEmptyOrNull:saveE.code] && [saveE.code isEqualToString:@"success"]) {
                success(saveE);
                return;
            }
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

- (ComplaintSaveE *)decodeComplainSaveJson:(NSDictionary *)dicJson {
    ComplaintSaveE *saveE = [ComplaintSaveE new];
    saveE.code = dicJson[@"code"];
    saveE.idID = dicJson[@"id"];
    saveE.message = dicJson[@"message"];
    NSLog(@"saveE.message = %@",saveE.message);
    return saveE;
}

- (void)executeGetTypeTaskWithUser:(ComplaintEntity *)complaint
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:complaint.type,@"type", nil];
    NSLog(@"paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_COMPLAINT_TYPE] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"dic_json = %@",dic_json);
            success([self decodeComplainJson:dic_json]);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }]; 
}

- (NSArray *)decodeComplainJson:(NSDictionary *)dicJson {
    NSMutableArray *complaintArr = [NSMutableArray array];
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]]) {
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *listDic = (NSDictionary *)obj;
            ComplaintEntity *complainE = [ComplaintEntity new];
            complainE.code = listDic[@"code"];
            complainE.enabled = listDic[@"enabled"];
            complainE.idID = listDic[@"id"];
            complainE.name = listDic[@"name"];
            complainE.optionGroupId = listDic[@"optionGroupId"];
            complainE.rank = listDic[@"rank"];
            [complaintArr addObject:complainE];
        }];
    }
    return [complaintArr copy];
}

- (void)excuteImgPostTask:(FilePostE *)imgPostE
                  success:(SuccessBlock)success
                   failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:imgPostE.dataD,@"data",imgPostE.fileName,@"fileName",imgPostE.entityType,@"entityType", nil];
//    NSLog(@"excuteImgPostTask paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_FILE_POST] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"excuteImgPostTaskdic_json = %@",dic_json);
            FilePostE *fileE = [self decodeImgPostJson:dic_json];
            if (![NSString isEmptyOrNull:fileE.code] && [fileE.code isEqualToString:@"success"]) {
                success(fileE);
                return;
            }
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

- (FilePostE *)decodeImgPostJson:(NSDictionary *)dicJson {
    FilePostE *fileE = [FilePostE new];
    fileE.code = dicJson[@"code"];
    fileE.idID = dicJson[@"id"];
    fileE.messages = dicJson[@"message"];
    return fileE;
}

@end
