//
//  CommunityAffairsH.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CommunityAffairsH.h"

@implementation CommunityAffairsH

- (id)init {
    self = [super init];
    if (self) {
        self.affairsPNumber = @"1";
        self.affairsPCount =  @"1";
        self.affairsArr = [NSMutableArray array];
        self.isAffairsNeedUpdate = YES;
    }
    return self;
}

//获取社区政务列表
-(void)requestForCommunityAffairsWithModel:(ShengSJDataE *)shengSJE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader {
    if (isheader) {
        self.affairsPNumber = @"1";
        self.affairsPCount =  @"1";
    }
    else {
        if (self.affairsPNumber.integerValue > self.affairsPCount.integerValue) {
            success(self.affairsArr);
            return;
        }
        self.affairsPNumber = [NSString stringWithFormat:@"%d",self.affairsPNumber.integerValue + 1];
    }
    
    shengSJE.pageNumber = self.affairsPNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.affairsPCount =reportM.pageCount;
            
            if (isheader) {
                [self.affairsArr removeAllObjects];
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.affairsArr addObject:obj];
                    }
                }];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    ShengSJDataE *singleReportM = obj;
                    if (![NSString isEmptyOrNull:singleReportM.status] && [singleReportM.status isEqualToString:@"3"]) { //已发布
                        [self.affairsArr addObject:obj];
                    }
                }];
            }
            
            success(self.affairsArr);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(obj);
    }];
}

@end
