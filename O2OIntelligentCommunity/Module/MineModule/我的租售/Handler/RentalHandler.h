//
//  RentalHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShengShiJiaH.h"
#import "ShengSJDataE.h"

@interface RentalHandler : ShengShiJiaH

@property (nonatomic,copy)NSString *rentaPNumber;
@property (nonatomic,copy)NSString *rentaPCount;
@property (nonatomic, strong) NSMutableArray *rentaArray;

@property (nonatomic,copy)NSString *idlePNumber;
@property (nonatomic,copy)NSString *idlePCount;
@property (nonatomic, strong) NSMutableArray *idleArray;



//查询我的租售
-(void)queryRentalData:(ShengSJDataE *)shengSJE
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
              isHeader:(BOOL)isheader;

//查询我的闲置
-(void)queryIdleData:(ShengSJDataE *)shengSJE
             success:(SuccessBlock)success
              failed:(FailedBlock)failed
            isHeader:(BOOL)isheader;

//查询我的租售和闲置的详情
-(void)queryXianZhiDetails:(ShengSJDataE *)Dic
                   success:(SuccessBlock)success
                    failed:(FailedBlock)failed;

@end
