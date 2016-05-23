//
//  LifeCircleH.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "LifeCircleE.h" 

@interface LifeCircleH : BaseHandler
@property (nonatomic, copy) NSString *aroundPNumber;
@property (nonatomic, copy) NSString *aroundPCount;
@property (nonatomic, strong) NSMutableArray *aroundArr;
@property (nonatomic, assign) BOOL isAroundNeedUpdate;

@property (nonatomic, copy) NSString *publicPNumber;
@property (nonatomic, copy) NSString *publicPCount;
@property (nonatomic, strong) NSMutableArray *publicArr;
@property (nonatomic, assign) BOOL isPublicNeedUpdate;

//获取生活圈周边商家信息
- (void)requestForAroundMerchantsWithModel:(LifeCircleE *)circleE
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed
                                  isHeader:(BOOL)isheader;

//获取生活圈便民服务信息
- (void)requestForPublicServiceWithModel:(LifeCircleE *)circleE
                                 success:(SuccessBlock)success
                                  failed:(FailedBlock)failed
                                isHeader:(BOOL)isheader;

//搜索获取周边信息
- (void)requestForSearchWithModel:(LifeCircleE *)circleE
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed;

//获取生活圈商家分类
-(void)requestStoreCloseWithModel:(LifeCircleE *)circleE
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed;
@end
