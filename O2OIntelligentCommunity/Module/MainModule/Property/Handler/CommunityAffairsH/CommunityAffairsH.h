//
//  CommunityAffairsH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShengShiJiaH.h"

@interface CommunityAffairsH : ShengShiJiaH

@property (nonatomic, copy) NSString *affairsPNumber;
@property (nonatomic, copy) NSString *affairsPCount;
@property (nonatomic, strong) NSMutableArray *affairsArr;
@property (nonatomic, assign) BOOL isAffairsNeedUpdate;

//获取社区政务列表
-(void)requestForCommunityAffairsWithModel:(ShengSJDataE *)shengSJE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader;

@end
