//
//  DaiJinQunHandel.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/3/1.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "DaiJinQunHandel.h"
#import "NSArray+wrapper.h"

@implementation DaiJinQunHandel
- (id)init {
    self = [super init];
    if (self) {
        self.voucherPNumber = @"1";
        self.voucherPCount =  @"1";
        self.voucherArr = [NSMutableArray array];
    }
    return self;
}

//根据商家ID及用户ID查询商家券使用情况
- (void)getStoreQuan:(DaiJinQuanModel*)model success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader {

    if (isheader) {
        self.voucherPNumber = @"1";
        self.voucherPCount =  @"1";
    }
    else {
        if (self.voucherPNumber.integerValue > self.voucherPCount.integerValue) {
            success(self.voucherArr);
            return;
        }
        self.voucherPNumber = [NSString stringWithFormat:@"%ld",self.voucherPNumber.integerValue + 1];
    }
    
    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    
    [upLoadDict setObject:model.memberId forKey:@"memberId"];
    [upLoadDict setObject:model.storeId forKey:@"storeId"];
    [upLoadDict setObject:self.voucherPNumber forKey:@"pageNumber"];
    [upLoadDict setObject:model.pageSize forKey:@"pageSize"];
    [upLoadDict setObject:model.status forKey:@"status"];
  
    NSLog(@"查看商家代金券>>>>%@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerGetMima];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:QUANLIST] requestType:ZJHttpRequestGet parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([NSJSONSerialization isValidJSONObject:dic] && success) {
            NSMutableArray *recvArr =[self jsonToModel:dic];
            self.voucherPCount = dic[@"pageCount"];
            
            if (isheader) {
                self.voucherArr = recvArr;
            }
            else {
                [recvArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.voucherArr addObject:obj];
                }];
            }
            success(self.voucherArr);
            return;
        }
        
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
}


//下单时候查询商家券的情况
- (void)getStoreAvailbleQuan:(DaiJinQuanModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed{

    NSMutableDictionary * upLoadDict = [NSMutableDictionary dictionary];
    
    [upLoadDict setObject:model.memberId forKey:@"memberId"];
    [upLoadDict setObject:model.storeId forKey:@"storeId"];
    [upLoadDict setObject:model.status forKey:@"status"];
    
    NSLog(@"查看下单商家代金券>>>>%@",upLoadDict);
    
    [[NetworkRequest defaultRequest] requestSerializerGetMima];
    
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_PDM WithPort:A_PORT_PDM WithPath:ORDERLIST] requestType:ZJHttpRequestGet parameters:upLoadDict prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        success([self shopQuan:dict]);
//        success([self shopQuan:dataArray]);
        NSLog(@"下单查看商家代金券>>>>>>%@",dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"%@",error);
        
    }];
    

}

//下单的时候商家代金券模型
-(NSMutableArray *)shopQuan:(NSDictionary *)dataSoucre{
    
    NSMutableArray * shopArray = [NSMutableArray array];
    NSLog(@"dataSoucre = %@",dataSoucre);
    
    NSArray *shopArr = dataSoucre[@"list"];
    if (![NSArray isArrEmptyOrNull:shopArr]) {
        for (NSDictionary * shopDic in shopArr) {
            NSMutableArray * quanListArray = [NSMutableArray array];
            
            NSArray *quanArr = shopDic[@"couponList"];
            if (![NSArray isArrEmptyOrNull:quanArr]) {
                for (NSDictionary * quaDict in quanArr) {
                    [quanListArray addObject:[self getModelFromQuanDic:quaDict]];
                }
            }
            [shopArray addObject:quanListArray];
        }
    }
    
    return shopArray;
}

- (DaiJinQuanModel *)getModelFromQuanDic:(NSDictionary *)quaDict {
    DaiJinQuanModel * model = [DaiJinQuanModel new];
    model.bound = [NSString stringWithFormat:@"%@",quaDict[@"bound"]];
    model.channelId = [NSString stringWithFormat:@"%@",quaDict[@"channelId"]];
    model.chargeDate = [NSString stringWithFormat:@"%@",quaDict[@"chargeDate"]];
    model.code = [NSString stringWithFormat:@"%@",quaDict[@"code"]];
    model.couponNo = [NSString stringWithFormat:@"%@",quaDict[@"couponNo"]];
    model.couponObjoctType = [NSString stringWithFormat:@"%@",quaDict[@"couponObjoctType"]];
    model.couponTemplateId = [NSString stringWithFormat:@"%@",quaDict[@"couponTemplateId"]];
    model.couponTemplateName = [NSString stringWithFormat:@"%@",quaDict[@"couponTemplateName"]];
    model.createdBy = [NSString stringWithFormat:@"%@",quaDict[@"createdBy"]];
    model.dateCreated = [NSString stringWithFormat:@"%@",quaDict[@"dateCreated"]];
    model.dateUpdated = [NSString stringWithFormat:@"%@",quaDict[@"dateUpdated"]];
    model.deleted = [NSString stringWithFormat:@"%@",quaDict[@"deleted"]];
    model.deliverDate = [NSString stringWithFormat:@"%@",quaDict[@"deliverDate"]];
    
    if (![quaDict[@"description"] isEqual:[NSNull null]]) {
        model.mydescription = [NSString stringWithFormat:@"%@",quaDict[@"description"]];
    }else{
        model.mydescription = @"未知";
    }
    
    model.displayCoupon = [NSString stringWithFormat:@"%@",quaDict[@"displayCoupon"]];
    model.endDate = [NSString stringWithFormat:@"%@",quaDict[@"endDate"]];
    model.field1 = [NSString stringWithFormat:@"%@",quaDict[@"field1"]];
    model.field2 = [NSString stringWithFormat:@"%@",quaDict[@"field2"]];
    model.field3 = [NSString stringWithFormat:@"%@",quaDict[@"field3"]];
    model.id1 = [NSString stringWithFormat:@"%@",quaDict[@"id"]];
    model.memberId = [NSString stringWithFormat:@"%@",quaDict[@"memberId"]];
    model.memo = [NSString stringWithFormat:@"%@",quaDict[@"memo"]];
    model.merchantId = [NSString stringWithFormat:@"%@",quaDict[@"merchantId"]];
    model.merchantName = [NSString stringWithFormat:@"%@",quaDict[@"merchantName"]];
    model.name = [NSString stringWithFormat:@"%@",quaDict[@"name"]];
    model.optCounter = [NSString stringWithFormat:@"%@",quaDict[@"optCounter"]];
    model.orderId = [NSString stringWithFormat:@"%@",quaDict[@"orderId"]];
    model.parValue = [NSString stringWithFormat:@"%@",quaDict[@"parValue"]];
    model.password = [NSString stringWithFormat:@"%@",quaDict[@"password"]];
    model.promotionId = [NSString stringWithFormat:@"%@",quaDict[@"promotionId"]];
    model.sourceId = [NSString stringWithFormat:@"%@",quaDict[@"sourceId"]];
    model.sourceType = [NSString stringWithFormat:@"%@",quaDict[@"sourceType"]];
    model.startDate = [NSString stringWithFormat:@"%@",quaDict[@"startDate"]];
    model.status = [NSString stringWithFormat:@"%@",quaDict[@"status"]];
    model.statusCn = [NSString stringWithFormat:@"%@",quaDict[@"statusCn"]];
    model.storeId = [NSString stringWithFormat:@"%@",quaDict[@"storeId"]];
    model.updatedBy = [NSString stringWithFormat:@"%@",quaDict[@"updatedBy"]];
    model.usedAmount = [NSString stringWithFormat:@"%@",quaDict[@"usedAmount"]];
    model.usedDate = [NSString stringWithFormat:@"%@",quaDict[@"usedDate"]];
    return model;
}

//商家代金券Json To Model
- (NSMutableArray *)jsonToModel:(NSDictionary *)dict{
    
    NSMutableArray * modelsArray;
    if (![dict[@"list"] isEqual:[NSNull null]]) {
        
        modelsArray = [NSMutableArray array];

        
        for (NSDictionary * quaDict in dict[@"list"]) {
            
            DaiJinQuanModel * model = [DaiJinQuanModel new];
            model.bound = [NSString stringWithFormat:@"%@",quaDict[@"bound"]];
            model.channelId = [NSString stringWithFormat:@"%@",quaDict[@"channelId"]];
            model.chargeDate = [NSString stringWithFormat:@"%@",quaDict[@"chargeDate"]];
            model.code = [NSString stringWithFormat:@"%@",quaDict[@"code"]];
            model.couponNo = [NSString stringWithFormat:@"%@",quaDict[@"couponNo"]];
            model.couponObjoctType = [NSString stringWithFormat:@"%@",quaDict[@"couponObjoctType"]];
            model.couponTemplateId = [NSString stringWithFormat:@"%@",quaDict[@"couponTemplateId"]];
            model.couponTemplateName = [NSString stringWithFormat:@"%@",quaDict[@"couponTemplateName"]];
            model.createdBy = [NSString stringWithFormat:@"%@",quaDict[@"createdBy"]];
            model.dateCreated = [NSString stringWithFormat:@"%@",quaDict[@"dateCreated"]];
            model.dateUpdated = [NSString stringWithFormat:@"%@",quaDict[@"dateUpdated"]];
            model.deleted = [NSString stringWithFormat:@"%@",quaDict[@"deleted"]];
            model.deliverDate = [NSString stringWithFormat:@"%@",quaDict[@"deliverDate"]];
            
            if (![quaDict[@"description"] isEqual:[NSNull null]]) {
                model.mydescription = [NSString stringWithFormat:@"%@",quaDict[@"description"]];
            }else{
                model.mydescription = @"未知";
            }
            
            
            
            model.displayCoupon = [NSString stringWithFormat:@"%@",quaDict[@"displayCoupon"]];
            model.endDate = [NSString stringWithFormat:@"%@",quaDict[@"endDate"]];
            model.field1 = [NSString stringWithFormat:@"%@",quaDict[@"field1"]];
            model.field2 = [NSString stringWithFormat:@"%@",quaDict[@"field2"]];
            model.field3 = [NSString stringWithFormat:@"%@",quaDict[@"field3"]];
            model.id1 = [NSString stringWithFormat:@"%@",quaDict[@"id"]];
            model.memberId = [NSString stringWithFormat:@"%@",quaDict[@"memberId"]];
            model.memo = [NSString stringWithFormat:@"%@",quaDict[@"memo"]];
            model.merchantId = [NSString stringWithFormat:@"%@",quaDict[@"merchantId"]];
            model.merchantName = [NSString stringWithFormat:@"%@",quaDict[@"merchantName"]];
            model.name = [NSString stringWithFormat:@"%@",quaDict[@"name"]];
            model.optCounter = [NSString stringWithFormat:@"%@",quaDict[@"optCounter"]];
            model.orderId = [NSString stringWithFormat:@"%@",quaDict[@"orderId"]];
            model.parValue = [NSString stringWithFormat:@"%@",quaDict[@"parValue"]];
            model.password = [NSString stringWithFormat:@"%@",quaDict[@"password"]];
            model.promotionId = [NSString stringWithFormat:@"%@",quaDict[@"promotionId"]];
            model.sourceId = [NSString stringWithFormat:@"%@",quaDict[@"sourceId"]];
            model.sourceType = [NSString stringWithFormat:@"%@",quaDict[@"sourceType"]];
            model.startDate = [NSString stringWithFormat:@"%@",quaDict[@"startDate"]];
            model.status = [NSString stringWithFormat:@"%@",quaDict[@"status"]];
            model.statusCn = [NSString stringWithFormat:@"%@",quaDict[@"statusCn"]];
            model.storeId = [NSString stringWithFormat:@"%@",quaDict[@"storeId"]];
            model.updatedBy = [NSString stringWithFormat:@"%@",quaDict[@"updatedBy"]];
            model.usedAmount = [NSString stringWithFormat:@"%@",quaDict[@"usedAmount"]];
            model.usedDate = [NSString stringWithFormat:@"%@",quaDict[@"usedDate"]];
            
            [modelsArray addObject:model];
        }
        
    }
    
    return modelsArray;
}

@end
