//
//  ManagerialReportH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/9.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ManagerialReportH.h"

@implementation ManagerialReportH
- (id)init {
    self = [super init];
    if (self) {
        self.propertyPNumber = @"1";
        self.propertyPCount =  @"1";
        self.propertyArr = [NSMutableArray array];
        self.isPropertyNeedUpdate= YES;
        
        self.expendituresPNumber= @"1";
        self.propertyPCount = @"1";
        self.expendituresArr = [NSMutableArray array];
        self.isExpendituresNeedUpdate = YES;
    }
    return self;
}

//获取管理报告数据列表
-(void)requestForPropertyReportWithModel:(ShengSJDataE *)shengSJE
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed
                                isHeader:(BOOL)isheader {
    if (isheader) {
        self.propertyPNumber = @"1";
        self.propertyPCount =  @"1";
    }
    else {
        if (self.propertyPNumber.integerValue > self.propertyPCount.integerValue) {
            success(self.propertyArr);
            return;
        }
        self.propertyPNumber = [NSString stringWithFormat:@"%d",self.propertyPNumber.integerValue + 1];
    }
    
    shengSJE.pageNumber = self.propertyPNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.propertyPCount =reportM.pageCount;
            
            if (isheader) {
                [self.propertyArr removeAllObjects];
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.propertyArr addObject:obj];
                    }
                }];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.propertyArr addObject:obj];
                    }
                }];
            }
            
            success(self.propertyArr);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(obj);
    }];
}

//获取财政报告
-(void)requestForExpendituresReportWithModel:(ShengSJDataE *)shengSJE
                                     success:(SuccessBlock)success
                                      failed:(FailedBlock)failed
                                    isHeader:(BOOL)isheader {
    if (isheader) {
        self.expendituresPNumber = @"1";
        self.expendituresPCount =  @"1";
    }
    else {
        if (self.expendituresPNumber.integerValue > self.expendituresPCount.integerValue) {
            success(self.expendituresArr);
            return;
        }
        self.expendituresPNumber = [NSString stringWithFormat:@"%d",self.expendituresPNumber.integerValue + 1];
    }
    
    shengSJE.pageNumber = self.expendituresPNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.expendituresPCount =reportM.pageCount;
            
            if (isheader) {
                [self.expendituresArr removeAllObjects];
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.expendituresArr addObject:obj];
                    }
                }];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.expendituresArr addObject:obj];
                    }
                }];
            }
            
            success(self.expendituresArr);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(obj);
    }];
}

@end
