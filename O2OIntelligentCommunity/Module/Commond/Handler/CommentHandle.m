//
//  DiscussH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CommentHandle.h"
#import "NSArray+wrapper.h"

@implementation CommentHandle
- (id)init {
    self = [super init];
    if (self) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
        self.commentArr = [NSMutableArray array];
        self.isNeedRefresh = YES;
    }
    return self;
}

- (void)executeCommentTaskWithUser:(CommentEntity *)commentE
                           success:(SuccessBlock)success
                            failed:(FailedBlock)failed
                          isHeader:(BOOL)isHeader {
    
    if (isHeader) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
    }
    else {
        if (self.currentPage.integerValue > self.pageCount.integerValue) {
            success(self.commentArr);
            return;
        }
        self.currentPage = [NSString stringWithFormat:@"%ld",self.currentPage.integerValue + 1];
    }
    
    commentE.pageNumber = self.currentPage;
    
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:commentE.pageNumber,@"pageNumber",
                             commentE.pageSize,@"pageSize",
                             commentE.queryMap,@"queryMap",
                             commentE.orderBy,@"orderBy"
                             ,commentE.orderType,@"orderType",
                             nil];
    NSLog(@"paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_COMMENT] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            NSLog(@"dic_json = %@",dic_json);
            
            CommentEntity *commentE = [self decodeCommentJson:dic_json];
            if ([NSArray isArrEmptyOrNull:commentE.list]) {
                self.currentPage = commentE.pageNumber;
            }
            
            self.pageCount = commentE.pageCount;
            if (isHeader) {
                [self.commentArr removeAllObjects];
                [commentE.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.commentArr addObject:obj];
                }];
            }
            else {
                [commentE.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.commentArr addObject:obj];
                }];
            }

            success(self.commentArr);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

- (CommentEntity *)decodeCommentJson:(NSDictionary *)dicJson {
    CommentEntity *commentE = [CommentEntity new];
    
    commentE.totalCount = dicJson[@"totalCount"];
    commentE.pageCount = dicJson[@"pageCount"];
    commentE.pageNumber = dicJson[@"pageNumber"];
    commentE.pageSize = dicJson[@"pageSize"];
    
    if (![dicJson[@"list"] isKindOfClass:[NSArray class]] || [NSArray isArrEmptyOrNull:dicJson[@"list"]]) {
        return commentE;
    }
    
    NSArray *jsonArr = dicJson[@"list"];
    NSMutableArray *listArr = [NSMutableArray array];
    [jsonArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *jsonDic = (NSDictionary *)obj;
        CommentEntity *commentDetailE = [CommentEntity new];
        commentDetailE.createTimeStr = jsonDic[@"createTimeStr"];
        commentDetailE.nickName = jsonDic[@"mbMember"][@"nickName"];
        commentDetailE.idID = jsonDic[@"id"];
        commentDetailE.dateCreateStr = jsonDic[@"dateCreateStr"];
        commentDetailE.createTimeStr = jsonDic[@"createTimeStr"];
        commentDetailE.content = jsonDic[@"content"];
        commentDetailE.status = jsonDic[@"status"];
        commentDetailE.memberId = jsonDic[@"memberId"];
        [listArr addObject:commentDetailE];
    }];
    commentE.list = listArr;
    return commentE;
}


- (void)executeDeleteCommentTaskWithUser:(NSString *)idID
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed {
    NSLog(@"DeleteCommentTask id = %@",idID);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_DELETE_COMMENT] requestType:ZJHttpRequestGet parameters:[NSDictionary dictionaryWithObject:idID forKey:@"id"] prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            if (![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
                success(dic_json[@"message"]);
                return;
            }
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

- (void)executeSubmmitCommentTaskWithUser:(CommentEntity *)commentE
                                  success:(SuccessBlock)success
                                   failed:(FailedBlock)failed {
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:commentE.memberId,@"memberId",
                                                                       commentE.complaintId,@"complaintId",
                                                                       commentE.complaintType,@"complaintType",
                                                                       commentE.content,@"content",
                                                                       nil];
    NSLog(@"paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_PATH_PUBLISH_COMMENT] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            if (![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
                success(dic_json[@"message"]);
                return;
            }
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}

@end
