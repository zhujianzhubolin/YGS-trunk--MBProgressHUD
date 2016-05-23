//
//  NoticeTBH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NoticeTBH.h"

@implementation NoticeTBH

- (id)init {
    self = [super init];
    if (self) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
        self.noticeInfoArr = [NSMutableArray array];
        self.isNoticeNeedUpdate = YES;
    }
    return self;
}

- (void)executeNoticeContentTaskWithUser:(NoticeEntity *)noticeE success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isHeader {

    if (isHeader) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
    }
    else {
        if (self.currentPage.integerValue > self.pageCount.integerValue) {
            success(self.noticeInfoArr);
            return;
        }
        self.currentPage = [NSString stringWithFormat:@"%d",self.currentPage.integerValue + 1];
    }
    
    noticeE.pageNumber  = self.currentPage;
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             noticeE.pageNumber,@"pageNumber",
                             noticeE.pageSize,@"pageSize",
                             noticeE.queryMap,@"queryMap",
                             noticeE.orderBy,@"orderBy",
                             noticeE.orderType,@"orderType",
                             nil];
    NSLog(@"NoticeContentparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_NOTICE] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"NoticeContentdic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NoticeEntity *noticeE = [self decodeNoticeContentJson:dic_json];
            self.pageCount = noticeE.pageCount;
            
            NSMutableArray *recvArr = [noticeE.list mutableCopy];
            if (isHeader) {
                self.noticeInfoArr = [recvArr mutableCopy];
            }
            else {
                [recvArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.noticeInfoArr addObject:obj];
                }];
            }
            success(self.noticeInfoArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

- (NoticeEntity *)decodeNoticeContentJson:(NSDictionary *)dicJson {
    NoticeEntity *noticeE = [NoticeEntity new];
    
    noticeE.totalCount = dicJson[@"totalCount"];
    noticeE.pageCount = dicJson[@"pageCount"];
    noticeE.pageNumber = dicJson[@"pageNumber"];
    noticeE.pageSize = dicJson[@"pageSize"];
    if ([NSArray isArrEmptyOrNull:dicJson[@"list"]]) {
        return noticeE;
    }
    
    NSArray *jsonArr = dicJson[@"list"];
    NSMutableArray *listArr = [NSMutableArray array];
    [jsonArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *jsonDic = (NSDictionary *)obj;
        NoticeEntity *noticeLE = [NoticeEntity new];
        noticeLE.createTimeStr  = jsonDic[@"createTimeStr"];
        noticeLE.noticeTitle    = jsonDic[@"noticeTitle"];
        noticeLE.noticeContent  = jsonDic[@"noticeContent"];
        noticeLE.createdBy      = jsonDic[@"createdBy"];
        noticeLE.idID           = jsonDic[@"id"];
        noticeLE.imgPath        = jsonDic[@"imgPath"];
        noticeLE.noticeType     = jsonDic[@"noticeType"];
        noticeLE.noticeStatus   = jsonDic[@"noticeStatus"];
        noticeLE.type           = jsonDic[@"type"];
        [listArr addObject:noticeLE];
    }];
    noticeE.list = [listArr copy];
    return noticeE;
}

@end
