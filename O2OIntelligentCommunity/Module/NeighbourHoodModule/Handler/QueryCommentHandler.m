//
//  QueryCommentHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "QueryCommentHandler.h"

@implementation QueryCommentHandler

- (id)init {
    self = [super init];
    if (self) {
        self.currentPage = @"1";
        self.pageCount =  @"1";
        self.isUserCommentUpdate = YES;
        self.huatipinglunArr = [NSMutableArray array];
        
        self.topicCurrentPage =@"1";
        self.topicPageCount   =@"1";
        self.topicArr =[NSMutableArray array];
        
        self.myRentalPage =@"1";
        self.myRentalCount=@"1";
        self.ismyRentalCommentUpdate = YES;
        self.myRentalDataArr = [NSMutableArray array];
        
        self.myBadyPage = @"1";
        self.myBadyCount = @"1";
        self.ismyBadyCommentUpdate = YES;
        self.myBadyDataArr = [NSMutableArray array];
        
    }
    return self;
}

//查询我的宝贝评论
-(void)queryBadyComment:(QueryCommentModel *)queryM
                success:(SuccessBlock)success
                 failed:(FailedBlock)failed
               isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.myBadyPage = @"1";
        self.myBadyCount   = @"1";
    }
    else
    {
        if (self.myBadyPage.intValue > self.myBadyPage.intValue) {
            success(self.myBadyDataArr);
            return;
        }
        
        self.myBadyPage =[NSString stringWithFormat:@"%d",self.myBadyPage.intValue +1];
    }
    queryM.pageNumber = self.myBadyPage;
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         queryM.pageNumber,@"pageNumber",
                         queryM.pageSize,@"pageSize",
                         queryM.queryMap,@"queryMap",
                         queryM.orderBy,@"orderBy",
                         queryM.orderType,@"orderType",
                         nil];
    
    NSLog(@"%@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBXTSComments] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            QueryCommentModel *queryM =[self QueryCommentJson:dic];
            
            self.myBadyCount =queryM.pageCount;
            if (isheader)
            {
                self.myBadyDataArr = [queryM.list mutableCopy];
            }
            else
            {
                [queryM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.myBadyDataArr addObject:obj];
                }];
            }
            success(self.myBadyDataArr);
            return ;
            
        }
        
        failed([NSString stringFromat:dic[@"message"]]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}

//查询租售信息的评论
-(void)queryRentalComment:(QueryCommentModel *)queryM
                      success:(SuccessBlock)success
                       failed:(FailedBlock)failed
                     isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.myRentalPage = @"1";
        self.myRentalCount   = @"1";
    }
    else
    {
        if (self.myRentalPage.intValue > self.myRentalPage.intValue) {
            success(self.myRentalDataArr);
            return;
        }
        
        self.myRentalPage =[NSString stringWithFormat:@"%d",self.myRentalPage.intValue +1];
    }
    queryM.pageNumber = self.myRentalPage;
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         queryM.pageNumber,@"pageNumber",
                         queryM.pageSize,@"pageSize",
                         queryM.queryMap,@"queryMap",
                         queryM.orderBy,@"orderBy",
                         queryM.orderType,@"orderType",
                         nil];
    
    NSLog(@"%@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBXTSComments] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            QueryCommentModel *queryM =[self QueryCommentJson:dic];
            
            self.myRentalCount =queryM.pageCount;
            if (isheader) {
                self.myRentalDataArr = [queryM.list mutableCopy];
            }
            else {
                [queryM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.myRentalDataArr addObject:obj];
                }];
            }
            success(self.myRentalDataArr);
            return ;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];

}


//查询我的评论
-(void)queryComment:(QueryCommentModel *)queryM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.currentPage = @"1";
        self.pageCount   = @"1";
    }
    else
    {
        if (self.currentPage.intValue > self.pageCount.intValue) {
            success(self.huatipinglunArr);
            return;
        }

        self.currentPage =[NSString stringWithFormat:@"%d",self.currentPage.intValue +1];
    }
    queryM.pageNumber = self.currentPage;
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         queryM.pageNumber,@"pageNumber",
                         queryM.pageSize,@"pageSize",
                         queryM.queryMap,@"queryMap",
                         queryM.orderBy,@"orderBy",
                         queryM.orderType,@"orderType",
                          nil];
    
    NSLog(@"%@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBXTSComments] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            QueryCommentModel *queryM =[self QueryCommentJson:dic];
            
            self.pageCount =queryM.pageCount;
            if (isheader)
            {
                self.huatipinglunArr = [queryM.list mutableCopy];
            }
            else
            {
                [queryM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.huatipinglunArr addObject:obj];
                }];
            }
            success(self.huatipinglunArr);
            return ;
            
        }
        
        failed(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
}

//查询话题评论
-(void)queryTopicComment:(QueryCommentModel *)queryM success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.topicCurrentPage = @"1";
        self.topicPageCount   = @"1";
    }
    else
    {
        if (self.topicCurrentPage.intValue > self.topicPageCount.intValue)
        {
            success(self.topicArr);
            return;
        }
        self.topicCurrentPage =[NSString stringWithFormat:@"%d",self.topicCurrentPage.intValue +1];
    }
    queryM.pageNumber = self.topicCurrentPage;
    
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         queryM.pageNumber,@"pageNumber",
                         queryM.pageSize,@"pageSize",
                         queryM.queryMap,@"queryMap",
                         queryM.orderBy,@"orderBy",
                         queryM.orderType,@"orderType",
                         nil];
    
    NSLog(@"%@",dict);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBXTSComments] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            QueryCommentModel *queryM =[self QueryCommentJson:dic];
            self.topicPageCount =queryM.pageCount;
            if (isheader)
            {
                self.topicArr =[queryM.list mutableCopy];
            }
            else
            {
                [queryM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.topicArr addObject:obj];
                }];
            }
            success(self.topicArr);
            return ;
            
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];

}

//查询建议回复
-(void)queryAdvicecomment:(QueryCommentModel *)queryM success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:
                         queryM.queryMap,@"queryMap",
                         nil];
    NSLog(@"建议回复 %@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBXTSComments] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"建议回复 dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            success(dic[@"message"]);
            NSArray *dicArr=dic[@"list"];
            NSDictionary *huifuDic = dicArr[0];

            success(huifuDic[@"content"]);
            return;
        }
        failed([NSString stringFromat:dic[@"message"]]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
        
    }];
    
}

-(QueryCommentModel *)QueryCommentJson:(NSDictionary *)dic
{
    QueryCommentModel *queryM =[QueryCommentModel new];
    queryM.pageNumber   =dic[@"pageNumber"];
    queryM.pageSize     =dic[@"pageSize"];
    queryM.pageCount    =dic[@"pageCount"];
    if (![NSArray isArrEmptyOrNull:dic[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dic[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            NSDictionary *mbMemberDic =recvDic[@"mbMember"];
            NSDictionary *memberProfileDic =mbMemberDic[@"memberProfile"];
            NSLog(@"mbMemberDic==%@",mbMemberDic[@"nickName"]);
            
            QueryCommentModel *queryM =[QueryCommentModel new];
            queryM.ID              =[NSString stringWithFormat:@"%@",recvDic[@"id"]];
            queryM.createTimeStr   =[NSString stringWithFormat:@"%@",recvDic[@"createTimeStr"]];
            queryM.content         =[NSString stringWithFormat:@"%@",recvDic[@"content"]];
            queryM.complaintId     = [NSString stringWithFormat:@"%@",recvDic[@"complaintId"]];

            queryM.photourl        =[NSString stringWithFormat:@"%@",mbMemberDic[@"photourl"]];
            queryM.nickName        =[NSString stringWithFormat:@"%@",mbMemberDic[@"nickName"]];
            queryM.dateTimeStr     =[NSString stringWithFormat:@"%@",recvDic[@"dateTimeStr"]];
            queryM.memberId        =[NSString stringWithFormat:@"%@",memberProfileDic[@"memberId"]];
            queryM.dateCreateStr   =[NSString stringWithFormat:@"%@",recvDic[@"dateCreateStr"]];
            queryM.imgPath         =recvDic[@"imgPath"];
            
            [arr addObject:queryM];
        }];
        queryM.list=[arr copy];
    }
    return queryM;
}



@end
