//
//  HuaTiListHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "HuaTiListModel.h"


@interface HuaTiListHandler : BaseHandler
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, assign) BOOL isHuaTiNeedUpdate;
@property (nonatomic, strong)NSMutableArray *htArray;

@property (nonatomic, copy) NSString *myHtPNumber;
@property (nonatomic, copy) NSString *myHtPCount;
@property (nonatomic, assign) BOOL isMyHtNeedUpdate;
@property (nonatomic, strong)NSMutableArray *myHtArr;

//获取所有话题列表
-(void)PostHuatiList:(HuaTiListModel *)huati success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;

//查询我自己的话题
-(void)postUserHuaTiList:(HuaTiListModel *)huati success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;

//查询话题详情
-(void)queryHuaTiDetails111:(NSDictionary *)Dic success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
