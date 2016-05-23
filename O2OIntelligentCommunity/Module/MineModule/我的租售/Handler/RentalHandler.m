//
//  RentalHandler.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentalHandler.h"

@implementation RentalHandler

-(id)init
{
    self = [super init];
    if (self)
    {
        self.rentaPNumber =@"1";
        self.rentaPCount=@"1";
        self.rentaArray =[NSMutableArray array];
        
        self.idlePNumber =@"1";
        self.idlePCount=@"1";
        self.idleArray =[NSMutableArray array];
        
    }
    return self;
}

-(void)queryRentalData:(ShengSJDataE *)shengSJE success:(SuccessBlock)success
                failed:(FailedBlock)failed
              isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.rentaPNumber=@"1";
        self.rentaPCount=@"1";
    }
    else
    {
        if (self.rentaPNumber.integerValue >= self.rentaPCount.integerValue)
        {
            success(self.rentaArray);
            return;
        }
        self.rentaPNumber =[NSString stringWithFormat:@"%ld",self.rentaPNumber.integerValue +1];
    }
    shengSJE.pageNumber =self.rentaPNumber;
    
    
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.rentaPCount =reportM.pageCount;
            
            if (isheader) {
                self.rentaArray =[reportM.list mutableCopy];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.rentaArray addObject:obj];
                }];
            }
            
            success(self.rentaArray);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(nil);
    }];
}

-(void)queryIdleData:(ShengSJDataE *)shengSJE
             success:(SuccessBlock)success
              failed:(FailedBlock)failed
            isHeader:(BOOL)isheader
{
    if (isheader)
    {
        self.idlePNumber=@"1";
        self.idlePCount=@"1";
    }
    else
    {
        if (self.idlePNumber.integerValue >= self.idlePCount.integerValue)
        {
            success(self.idleArray);
            return;
        }
        self.idlePNumber =[NSString stringWithFormat:@"%ld",self.idlePNumber.integerValue +1];
    }
    shengSJE.pageNumber =self.idlePNumber;
    
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            self.idlePCount =reportM.pageCount;
            
            if (isheader) {
                self.idleArray =[reportM.list mutableCopy];
            }
            else {
                [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.idleArray addObject:obj];
                }];
            }
            success(self.idleArray);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(nil);
    }];
}

//查询我的租售和闲置的详情
-(void)queryXianZhiDetails:(ShengSJDataE *)shengSJE success:(SuccessBlock)success failed:(FailedBlock)failed
{
    [self requestForGetShengShiJiaData:shengSJE success:^(id obj) {
        if ([NSJSONSerialization isValidJSONObject:obj] && success) {
            ShengSJDataE *reportM =[self decodeShengSJDataJson:obj];
            [reportM.list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.idleArray addObject:obj];
            }];
            success(reportM);
            return;
        }
        failed(nil);
    } failed:^(id obj) {
        failed(nil);
    }];

}
@end
