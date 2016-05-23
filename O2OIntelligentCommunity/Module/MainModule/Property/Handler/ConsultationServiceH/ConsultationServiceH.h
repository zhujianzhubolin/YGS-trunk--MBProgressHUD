//
//  ConsultationServiceH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShengShiJiaH.h"

@interface ConsultationServiceH : ShengShiJiaH
@property (nonatomic, copy) NSString *legalPNumber;
@property (nonatomic, copy) NSString *legalPCount;
@property (nonatomic, strong) NSMutableArray *legalArr;
@property (nonatomic, assign) BOOL isLegalNeedUpdate;

@property (nonatomic, copy) NSString *taxPNumber;
@property (nonatomic, copy) NSString *taxPCount;
@property (nonatomic, strong) NSMutableArray *taxArr;
@property (nonatomic, assign) BOOL isTaxNeedUpdate;

@property (nonatomic, copy) NSString *financialPNumber;
@property (nonatomic, copy) NSString *financialPCount;
@property (nonatomic, strong) NSMutableArray *financialArr;
@property (nonatomic, assign) BOOL isFinancialNeedUpdate;

//获取法务咨询列表
-(void)requestForLegalServiceWithModel:(ShengSJDataE *)shengSJE
                               success:(SuccessBlock)success
                                failed:(FailedBlock)failed
                              isHeader:(BOOL)isheader;

//获取税务咨询列表
-(void)requestForTaxServiceWithModel:(ShengSJDataE *)shengSJE
                             success:(SuccessBlock)success
                              failed:(FailedBlock)failed
                            isHeader:(BOOL)isheader;

//获取财务咨询数据列表
-(void)requestForFinancialServiceWithModel:(ShengSJDataE *)shengSJE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader;

@end
