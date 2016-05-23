//
//  BaoXiuTouShuHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaoXiuTouShuHandler.h"

@implementation BaoXiuTouShuHandler

-(id)init
{
    self = [super init];
    if (self) {
        self.bxcurrentPage = @"1";
        self.bxpageCount =  @"1";
        self.bxArray = [NSMutableArray array];
        
        self.tscurrentPage =@"1";
        self.tspageCount   =@"1";
        self.tsArray=[NSMutableArray array];
        
        self.advicePNumber = @"1";
        self.advicePCount = @"1";
        self.adviceArray = [NSMutableArray array];
    }
    return self;
}

//获取报修信息列表
-(void)BaoXiuList:(BaoXiuTouSuModel *)MineBX success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    
    if (isheader)
    {
        self.bxcurrentPage =@"1";
        self.bxpageCount   =@"1";
    }
    else
    {
        if (self.bxcurrentPage.intValue > self.bxpageCount.intValue)
        {
            success(self.bxArray);
            return;
        }
        self.bxcurrentPage = [NSString stringWithFormat:@"%d",self.bxcurrentPage.intValue+1];
    }
    
    MineBX.pageNumber =self.bxcurrentPage;

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           MineBX.pageNumber,@"pageNumber",
                           MineBX.pageSize,@"pageSize" ,
                           MineBX.queryMap, @"queryMap",
                           MineBX.orderBy,@"orderBy",
                           MineBX.orderType,@"orderType",
                           nil];
    
    NSLog(@"Dic ==%@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:BaoxiuTousu] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            BaoXiuTouSuModel *bxtsM =[self BXTSJson:dic];
            self.bxpageCount=bxtsM.pageCount;
            if (isheader)
            {
                self.bxArray =[bxtsM.list mutableCopy];
            }
            else
            {
                [bxtsM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.bxArray addObject:obj];
                }];
            }
            success(self.bxArray);
            return ;
            
        }
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    
}

//获取投诉信息列表
-(void)TousuList:(BaoXiuTouSuModel *)MineTS success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.tscurrentPage =@"1";
        self.tspageCount   =@"1";
    }
    else
    {
        if (self.tscurrentPage.intValue > self.tspageCount.intValue)
        {
            success(self.tsArray);
            return;
        }
        self.tscurrentPage = [NSString stringWithFormat:@"%d",self.tscurrentPage.intValue+1];
    }
    
    MineTS.pageNumber =self.tscurrentPage;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           MineTS.pageNumber,@"pageNumber",
                           MineTS.pageSize,@"pageSize" ,
                           MineTS.queryMap, @"queryMap",
                           MineTS.orderBy,@"orderBy",
                           MineTS.orderType,@"orderType",
                           nil];
    
    NSLog(@"Dic ==%@",dict);
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:BaoxiuTousu] requestType:ZJHttpRequestPost parameters:dict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            BaoXiuTouSuModel *bxtsM =[self BXTSJson:dic];
            self.tspageCount=bxtsM.pageCount;
            if (isheader)
            {
                self.tsArray =[bxtsM.list mutableCopy];
            }
            else
            {
                [bxtsM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.tsArray addObject:obj];
                }];
            }
            success(self.tsArray);
            return ;
            
        }
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];

}

-(BaoXiuTouSuModel *)BXTSJson:(NSDictionary *)dicJson
{
    BaoXiuTouSuModel *bxtsM =[BaoXiuTouSuModel new];
    bxtsM.pageNumber      =dicJson[@"pageNumber"];
    bxtsM.pageSize        =dicJson[@"pageSize"];
    bxtsM.pageCount       =dicJson[@"pageCount"];
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            NSDictionary *propcommunityhouseDic =recvDic[@"propCommunityhouse"];
            
            BaoXiuTouSuModel *bxtsM =[BaoXiuTouSuModel new];
            bxtsM.ID                    =recvDic[@"id"];
            bxtsM.memberId              =[NSString stringWithFormat:@"%@",recvDic[@"memberId"]];
            bxtsM.wyNo                  =[NSString stringWithFormat:@"%@",recvDic[@"wyNo"]];
            bxtsM.xqNo                  =[NSString stringWithFormat:@"%@",recvDic[@"xqNo"]];
            bxtsM.type                  =[NSString stringWithFormat:@"%@",recvDic[@"type"]];
            bxtsM.complaintTitle        =[NSString stringWithFormat:@"%@",recvDic[@"complaintTitle"]];
            bxtsM.complaintContent      =[NSString stringWithFormat:@"%@",recvDic[@"complaintContent"]];
            bxtsM.complaintStatus       =[NSString stringWithFormat:@"%@",recvDic[@"complaintStatus"]];
            bxtsM.contactPerson         =[NSString stringWithFormat:@"%@",recvDic[@"contactPerson"]];
            bxtsM.contactPhone          =[NSString stringWithFormat:@"%@",recvDic[@"contactPhone"]];
            bxtsM.createTimeStr         =[NSString stringWithFormat:@"%@",recvDic[@"createTimeStr"]];
            bxtsM.contactAddress        =[NSString stringWithFormat:@"%@",recvDic[@"contactAddress"]];
            bxtsM.complaintType         =[NSString stringWithFormat:@"%@",recvDic[@"complaintType"]];
            bxtsM.communityName         =[NSString stringWithFormat:@"%@",propcommunityhouseDic[@"communityName"]];

            if (![NSArray isArrEmptyOrNull:recvDic[@"imgPath"]]) {
                 bxtsM.imgPath               =recvDic[@"imgPath"];
            }
           
            [arr addObject:bxtsM];
        }];
        bxtsM.list =[arr mutableCopy];
    }
    return bxtsM;

}



//获取报修或者投诉详情的评论列表
-(void)BXTSCommentsList:(BXTSCommentsModel *)MineBXTSComment success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *queDic =[NSDictionary dictionaryWithObjectsAndKeys:
                           MineBXTSComment.memberId,@"memberId",
                           MineBXTSComment.complaintId,@"complaintId",
                           MineBXTSComment.complaintType,@"complaintType",
                           nil];
    
    NSDictionary *commenDic=[NSDictionary dictionaryWithObjectsAndKeys:
                             MineBXTSComment.pageNumber,@"pageNumber",
                             MineBXTSComment.pageSize,@"pageSize",
                             queDic,@"queryMap",
                             MineBXTSComment.orderBy,@"orderBy",
                             MineBXTSComment.orderType,@"orderType",
                             nil];
    
    NSLog(@"commenDic==%@",commenDic);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:MineBXTSComments] requestType:ZJHttpRequestPost parameters:commenDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"response dic = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success)
        {
            
            BXTSCommentsModel *bxtsMM =[self CommentsJson:dic];
            success(bxtsMM.list);
            return;
            
        }
        
        //NSLog(@"response dic = %@",dic);
        failed(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
    }];
    
}

-(BXTSCommentsModel *)CommentsJson:(NSDictionary *)dicJson
{
    BXTSCommentsModel *bxtsM =[BXTSCommentsModel new];
    bxtsM.pageNumber      =dicJson[@"pageNumber"];
    bxtsM.pageSize        =dicJson[@"pageSize"];
    bxtsM.memberId        =dicJson[@"memberId"];
    bxtsM.complaintId     =dicJson[@"complaintId"];
    bxtsM.orderBy         =dicJson[@"orderBy"];
    bxtsM.orderType       =dicJson[@"orderType"];
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]])
    {
        NSMutableArray *arr =[NSMutableArray array];
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *recvDic =(NSDictionary *)obj;
            
            BXTSCommentsModel *bxtsMM =[BXTSCommentsModel new];
            bxtsMM.complaintId       =recvDic[@"complaintId"];
            bxtsMM.complaintType     =recvDic[@"complaintType"];
            bxtsMM.title             =recvDic[@"title"];
            bxtsMM.content           =recvDic[@"content"];
            bxtsMM.status            =recvDic[@"status"];
            bxtsMM.createTimeStr     =recvDic[@"createTimeStr"];
            bxtsMM.imgPath           =recvDic[@"imgPath"];
            bxtsMM.mbMember          =recvDic[@"mbMember"];
            bxtsMM.nickName          =recvDic[@"nickName"];
            [arr addObject:bxtsMM];
        }];
        bxtsM.list =[arr mutableCopy];
    }
    
    return bxtsM;
    
}

-(void)queryAdviceData:(ShengSJDataE *)shengSJE
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
              isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.advicePNumber=@"1";
        self.advicePCount=@"1";
    }
    else
    {
        if (self.advicePNumber.integerValue >= self.advicePCount.integerValue)
        {
            success(self.adviceArray);
            return;
        }
        self.advicePNumber =[NSString stringWithFormat:@"%ld",self.advicePNumber.integerValue +1];
    }
    shengSJE.pageNumber =self.advicePNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            NSLog(@"queryAdviceData = %@",obj);
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.advicePCount =reportM.pageCount;
            
            if (isheader) {
                self.adviceArray =[reportM.list mutableCopy];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.adviceArray addObject:obj];
                }];
            }
            
            success(self.adviceArray);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(nil);
    }];
}

@end
