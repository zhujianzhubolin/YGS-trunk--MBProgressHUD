//
//  ManagerialReportH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/9.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShengShiJiaH.h"
#import "ShengSJDataE.h"

@interface ManagerialReportH : ShengShiJiaH

@property (nonatomic, copy) NSString *propertyPNumber;
@property (nonatomic, copy) NSString *propertyPCount;
@property (nonatomic, strong) NSMutableArray *propertyArr;
@property (nonatomic, assign) BOOL isPropertyNeedUpdate;

@property (nonatomic, copy) NSString *expendituresPNumber;
@property (nonatomic, copy) NSString *expendituresPCount;
@property (nonatomic, strong) NSMutableArray *expendituresArr;
@property (nonatomic, assign) BOOL isExpendituresNeedUpdate;

//获取管理报告
-(void)requestForPropertyReportWithModel:(ShengSJDataE *)shengSJE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader;

//获取财政报告
-(void)requestForExpendituresReportWithModel:(ShengSJDataE *)shengSJE
                                     success:(SuccessBlock)success
                                      failed:(FailedBlock)failed
                                    isHeader:(BOOL)isheader;


@end
