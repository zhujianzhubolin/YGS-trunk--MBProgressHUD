//
//  ConsultationServiceH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ConsultationServiceH.h"

@implementation ConsultationServiceH
- (id)init {
    self = [super init];
    if (self) {
        self.legalPNumber = @"1";
        self.legalPCount =  @"1";
        self.legalArr = [NSMutableArray array];
        self.isLegalNeedUpdate = YES;
        
        self.taxPNumber= @"1";
        self.taxPCount = @"1";
        self.taxArr = [NSMutableArray array];
        self.isTaxNeedUpdate = YES;
        
        self.financialPNumber= @"1";
        self.financialPCount = @"1";
        self.financialArr = [NSMutableArray array];
        self.isFinancialNeedUpdate = YES;
    }
    return self;
}

//获取法务咨询列表
-(void)requestForLegalServiceWithModel:(ShengSJDataE *)shengSJE
                               success:(SuccessBlock)success
                                failed:(FailedBlock)failed
                              isHeader:(BOOL)isheader {
    if (isheader) {
        self.legalPNumber = @"1";
        self.legalPCount =  @"1";
    }
    else {
        if (self.legalPNumber.integerValue > self.legalPCount.integerValue) {
            success(self.legalArr);
            return;
        }
        self.legalPNumber = [NSString stringWithFormat:@"%d",self.legalPNumber.integerValue + 1];
    }
    
    shengSJE.pageNumber = self.legalPNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.legalPCount =reportM.pageCount;
            
            if (isheader) {
                [self.legalArr removeAllObjects];
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.legalArr addObject:obj];
                    }
                }];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.legalArr addObject:obj];
                    }
                }];
            }
            
            success(self.legalArr);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(obj);
    }];
}

//获取税务咨询列表
-(void)requestForTaxServiceWithModel:(ShengSJDataE *)shengSJE
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed
                            isHeader:(BOOL)isheader {
    if (isheader) {
        self.taxPNumber = @"1";
        self.taxPCount =  @"1";
    }
    else {
        if (self.taxPNumber.integerValue > self.taxPCount.integerValue) {
            success(self.taxArr);
            return;
        }
        self.taxPNumber = [NSString stringWithFormat:@"%d",self.taxPNumber.integerValue + 1];
    }
    
    shengSJE.pageNumber = self.taxPNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.taxPCount =reportM.pageCount;
            
            if (isheader) {
                [self.taxArr removeAllObjects];
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.taxArr addObject:obj];
                    }
                }];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.taxArr addObject:obj];
                    }
                }];
            }
            
            success(self.taxArr);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(obj);
    }];
}

//获取财务咨询数据列表
-(void)requestForFinancialServiceWithModel:(ShengSJDataE *)shengSJE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader {
    if (isheader) {
        self.financialPNumber = @"1";
        self.financialPCount =  @"1";
    }
    else {
        if (self.financialPNumber.integerValue > self.financialPCount.integerValue) {
            success(self.financialArr);
            return;
        }
        self.financialPNumber = [NSString stringWithFormat:@"%d",self.financialPNumber.integerValue + 1];
    }
    
    shengSJE.pageNumber = self.financialPNumber;

    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.financialPNumber =reportM.pageCount;
            
            if (isheader) {
                [self.financialArr removeAllObjects];
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.financialArr addObject:obj];
                    }
                }];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.financialArr addObject:obj];
                    }
                }];
            }
            
            success(self.financialArr);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(obj);
    }];
}
@end
