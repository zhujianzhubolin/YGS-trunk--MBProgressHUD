//
//  ZYMilletPlayerHandler.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/22.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZYXiaoMiPlayerHandler.h"
#import "NSArray+wrapper.h"

@implementation ZYXiaoMiPlayerHandler

-(id)init
{
    self = [super init];
    if (self)
    {
        [self milletResetData];
    }
    return self;
}

-(void)milletResetData{
    self.milletPage = @"1";
    self.millerCount = @"1";
    self.millerArray = [NSMutableArray array];
    self.recvArr = [NSMutableArray array];
}

-(void)queryMillerList:(ZYXiaoMiPlayerModel *)milletM
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
              isHeader:(BOOL)isheader;
{
    NSLog(@"queryMillerList");
    if (isheader){
        self.milletPage = @"1";
        self.millerCount = @"1";
    }
    else{
        if (self.milletPage.integerValue > self.millerCount.integerValue) {
            success(self.millerArray);
            return;
        }
        self.milletPage = [NSString stringWithFormat:@"%ld",self.milletPage.integerValue +1];
    }
    milletM.pageNumber = self.milletPage;
    
    NSDictionary *milletDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               milletM.pageNumber,@"pageNumber",
                               milletM.pageSize,@"pageSize",
                               milletM.memberId,@"memberId" ,nil];
    NSLog(@"millerDic = %@",milletDic);
    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_XiaoMI_Mine_PlayerList] requestType:ZJHttpRequestGet parameters:milletDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"millet json = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            
            ZYXiaoMiPlayerModel * milletM =[self milletJson:dic isHeader:isheader];
            NSLog(@"milletM.list=%@",milletM.list);
            self.millerCount = milletM.pageCount;
            self.millerArray = [milletM.list mutableCopy];
            success(self.millerArray);
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);

    }];
    
}


-(ZYXiaoMiPlayerModel *)milletJson:(NSDictionary *)dicJson isHeader:(BOOL)isheader
{
    ZYXiaoMiPlayerModel *millerM =[ZYXiaoMiPlayerModel new];
    millerM.pageNumber = dicJson[@"pageNumber"];
    millerM.pageSize   = dicJson[@"pageSize"];
    millerM.pageCount  = dicJson[@"pageCount"];
    
    if (![NSArray isArrEmptyOrNull:dicJson[@"list"]]) {
        if (isheader)
        {
            [self.recvArr removeAllObjects];
        }
        [dicJson[@"list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *recvDic = (NSDictionary *)obj;
            NSLog(@"ggTitle==%@",recvDic[@"ggTitle"]);
            ZYXiaoMiPlayerModel * milletMM = [ZYXiaoMiPlayerModel new];
            milletMM.ID = [NSString stringWithFormat:@"%@",recvDic[@"id"]];
            if ([NSString isEmptyOrNull:recvDic[@"ggTitle"]])
            {
                milletMM.ggTitle=@"未知";
            }
            else
            {
                milletMM.ggTitle = [NSString stringWithFormat:@"%@",recvDic[@"ggTitle"]];
            }
            
            if ([NSString isEmptyOrNull:recvDic[@"chargeConfigName"]])
            {
                milletMM.chargeConfigName=@"未知";
            }
            else
            {
                milletMM.chargeConfigName = [NSString stringWithFormat:@"%@",recvDic[@"chargeConfigName"]];
            }
            
            
            milletMM.status = [NSString stringWithFormat:@"%@",recvDic[@"status"]];
            
            if ([NSString isEmptyOrNull:recvDic[@"ggServiceDateStart"]])
            {
                milletMM.ggServiceDateStart=@"未知";
            }
            else
            {
                NSString *str = recvDic[@"ggServiceDateStart"];
                milletMM.ggServiceDateStart = [str substringWithRange:NSMakeRange(0,10)];
            }
            
            if ([NSString isEmptyOrNull:recvDic[@"ggServiceDateEnd"]])
            {
                milletMM.ggServiceDateEnd=@"未知";
            }
            else
            {
                NSString *str = recvDic[@"ggServiceDateEnd"];
                milletMM.ggServiceDateEnd = [str substringWithRange:NSMakeRange(0,10)];
            }

           
            milletMM.ggImgSrc = [NSString stringWithFormat:@"%@",recvDic[@"ggImgSrc"]];
            milletMM.ggImgSrcSlt = [NSString stringWithFormat:@"%@",recvDic[@"ggImgSrcSlt"]];
            
            if([NSString isEmptyOrNull:recvDic[@"dateCreated"]])
            {
                milletMM.dateCreated=@"未知";
            }
            else
            {
                milletMM.dateCreated = [NSString stringWithFormat:@"%@",recvDic[@"dateCreated"]];
            }
           
            if ([NSString isEmptyOrNull:recvDic[@"payAmount"]])
            {
                milletMM.saleAmount=@"未知";
            }
            else
            {
                milletMM.saleAmount = [NSString stringWithFormat:@"%@",recvDic[@"payAmount"]];
            }
            
            if ([NSString isEmptyOrNull:recvDic[@"linkmanName"]])
            {
                milletMM.linkmanName=@"未知";
            }
            else
            {
                milletMM.linkmanName = [NSString stringWithFormat:@"%@",recvDic[@"linkmanName"]];
            }
            
            if ([NSString isEmptyOrNull:recvDic[@"linkmanPhone"]])
            {
                milletMM.linkmanPhone=@"未知";
            }
            else
            {
                milletMM.linkmanPhone = [NSString stringWithFormat:@"%@",recvDic[@"linkmanPhone"]];
            }
            
            if([NSString isEmptyOrNull:recvDic[@"remarkUser"]])
            {
                 milletMM.remarkUser=@"未留言";
            }
            else
            {
                milletMM.remarkUser  = [NSString stringWithFormat:@"%@",recvDic[@"remarkUser"]];
            }
            
            if([NSString isEmptyOrNull:recvDic[@"ggText1"]])
            {
                 milletMM.ggText1 = @"未知";
            }
            else
            {
                 milletMM.ggText1 = [NSString stringWithFormat:@"%@",recvDic[@"ggText1"]];
            }
            milletMM.orderIdPay = [NSString stringWithFormat:@"%@",recvDic[@"orderIdPay"]];
           
            milletMM.ggText2 = [NSString stringWithFormat:@"%@",recvDic[@"ggText2"]];
            milletMM.ggText3 = [NSString stringWithFormat:@"%@",recvDic[@"ggText3"]];
            [self.recvArr addObject:milletMM];
        }];
    }
    millerM.list = [self milletInfo:self.recvArr];
    return millerM;
}

- (NSArray *)milletInfo:(NSArray *)milletList {
    NSMutableArray *list = [NSMutableArray array];
    NSLog(@"paylist.count = %d",milletList.count);
    [milletList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZYXiaoMiPlayerModel *xiaomiM1 = obj;
        if (idx == 0) {
            NSMutableArray *listOne = [NSMutableArray array];
            [listOne addObject:xiaomiM1];
            [list addObject:listOne];
        }
        
        if (idx == milletList.count - 1) {
            return;
        }
        
        NSString *detailDate1 = nil;
        NSUInteger interceptionLenth = 7;
        if (xiaomiM1.dateCreated.length > interceptionLenth) {
            detailDate1 = [xiaomiM1.dateCreated substringToIndex:interceptionLenth];
            NSLog(@"detailDate1 = %@",detailDate1);
        }
        
        ZYXiaoMiPlayerModel *xiaomiM2 = milletList[idx + 1];
        NSString *detailDate2 = nil;
        if (xiaomiM2.dateCreated.length > interceptionLenth) {
            detailDate2 = [xiaomiM2.dateCreated substringToIndex:interceptionLenth];
        }
        
        if (![NSString isEmptyOrNull:detailDate2] && [detailDate2 isEqualToString:detailDate1]) {
            NSMutableArray *lastList = list[list.count - 1];
            [lastList addObject:milletList[idx + 1]];
        }
        else {
            NSMutableArray *listOther = [NSMutableArray array];
            [listOther addObject:milletList[idx + 1]];
            [list addObject:listOther];
        }
    }];
    NSLog(@"list = %@",list);
    return  [list copy];
}

//查询我的媒体详情
-(void)queryMeiTiDetailed:(NSDictionary *)detailedM
                  success:(SuccessBlock)success
                   failed:(FailedBlock)failed
{
    
    NSDictionary *Dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              detailedM[@"memberId"],@"memberId",
                                    detailedM[@"id"],@"id",
                        detailedM[@"pageNumber"],@"pageNumber",
                            detailedM[@"pageSize"],@"pageSize"
                         ,nil];
    
    NSString *title = [NSString jsonStringWithDictionary:Dic];
    
    NSLog(@"Dic==%@",title);

    
    [[NetworkRequest defaultRequest]requestSerializerJson];
    [[NetworkRequest defaultRequest]requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:A_XiaoMI_Mine_PlayerList] requestType:ZJHttpRequestGet parameters:Dic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"millet json = %@",dic);
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            
            ZYXiaoMiPlayerModel * milletM =[self DetailedJson:dic];
            success(milletM);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(W_ALL_FAIL_GET_DATA);
        NSLog(@"%@",error);
    }];
}

-(ZYXiaoMiPlayerModel *)DetailedJson:(NSDictionary *)dicJson
{
     ZYXiaoMiPlayerModel * milletMM = [ZYXiaoMiPlayerModel new];
    [dicJson[@"list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *recvDic=(NSDictionary *)obj;
        
        milletMM.ID = [NSString stringWithFormat:@"%@",recvDic[@"id"]];
        if ([NSString isEmptyOrNull:recvDic[@"ggTitle"]])
        {
            milletMM.ggTitle=@"未知";
        }
        else
        {
            milletMM.ggTitle = [NSString stringWithFormat:@"%@",recvDic[@"ggTitle"]];
        }
        
        if ([NSString isEmptyOrNull:recvDic[@"chargeConfigName"]])
        {
            milletMM.chargeConfigName=@"未知";
        }
        else
        {
            milletMM.chargeConfigName = [NSString stringWithFormat:@"%@",recvDic[@"chargeConfigName"]];
        }
        
        
        milletMM.status = [NSString stringWithFormat:@"%@",recvDic[@"status"]];
        
        if ([NSString isEmptyOrNull:recvDic[@"ggServiceDateStart"]])
        {
            milletMM.ggServiceDateStart=@"未知";
        }
        else
        {
            NSString *str = recvDic[@"ggServiceDateStart"];
            milletMM.ggServiceDateStart = [str substringWithRange:NSMakeRange(0,10)];
        }
        
        if ([NSString isEmptyOrNull:recvDic[@"ggServiceDateEnd"]])
        {
            milletMM.ggServiceDateEnd=@"未知";
        }
        else
        {
            NSString *str = recvDic[@"ggServiceDateEnd"];
            milletMM.ggServiceDateEnd = [str substringWithRange:NSMakeRange(0,10)];
        }
        
        
        milletMM.ggImgSrc = [NSString stringWithFormat:@"%@",recvDic[@"ggImgSrc"]];
        milletMM.ggImgSrcSlt = [NSString stringWithFormat:@"%@",recvDic[@"ggImgSrcSlt"]];
        
        if([NSString isEmptyOrNull:recvDic[@"dateCreated"]])
        {
            milletMM.dateCreated=@"未知";
        }
        else
        {
            milletMM.dateCreated = [NSString stringWithFormat:@"%@",recvDic[@"dateCreated"]];
        }
        
        if ([NSString isEmptyOrNull:recvDic[@"payAmount"]])
        {
            milletMM.saleAmount=@"未知";
        }
        else
        {
            milletMM.saleAmount = [NSString stringWithFormat:@"%@",recvDic[@"payAmount"]];
        }
        
        if ([NSString isEmptyOrNull:recvDic[@"linkmanName"]])
        {
            milletMM.linkmanName=@"未知";
        }
        else
        {
            milletMM.linkmanName = [NSString stringWithFormat:@"%@",recvDic[@"linkmanName"]];
        }
        
        if ([NSString isEmptyOrNull:recvDic[@"linkmanPhone"]])
        {
            milletMM.linkmanPhone=@"未知";
        }
        else
        {
            milletMM.linkmanPhone = [NSString stringWithFormat:@"%@",recvDic[@"linkmanPhone"]];
        }
        milletMM.remarkUser  = [NSString stringWithFormat:@"%@",recvDic[@"remarkUser"]];

        if([NSString isEmptyOrNull:recvDic[@"ggText1"]])
        {
            milletMM.ggText1 = @"未知";
        }
        else
        {
            milletMM.ggText1 = [NSString stringWithFormat:@"%@",recvDic[@"ggText1"]];
        }
        milletMM.orderIdPay = [NSString stringWithFormat:@"%@",recvDic[@"orderIdPay"]];
        
        milletMM.ggText2 = [NSString stringWithFormat:@"%@",recvDic[@"ggText2"]];
        milletMM.ggText3 = [NSString stringWithFormat:@"%@",recvDic[@"ggText3"]];
    }];
    return milletMM;
}
@end
