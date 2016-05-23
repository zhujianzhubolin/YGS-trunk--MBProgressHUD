//
//  MyCollectionHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "CollectionModel.h"
#import "ShangjiaModel.h"

@interface MyCollectionHandler : BaseHandler
@property (nonatomic, copy) NSString *sjCurrentPage;
@property (nonatomic, copy) NSString *sjPageCount;
@property (nonatomic, assign) BOOL isSJUpdate;
@property (nonatomic, copy) NSMutableArray *SJArray;

@property (nonatomic, copy) NSString *spCurrentPage;
@property (nonatomic, copy) NSString *spPageCount;
@property (nonatomic, assign) BOOL isSPUpdate;
@property (nonatomic, copy) NSMutableArray *SPArray;;




//获取我的收藏商品列表
-(void)PostSPList:(CollectionModel *)SPList success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;

//获取我的收藏商家列表
-(void)PostSJList:(ShangjiaModel *)SJList success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;

//删除收藏的商家
-(void)DeleteSJ:(ShangjiaModel *)sjM success:(SuccessBlock)success failed:(FailedBlock)failed;

//删除收藏的商品
-(void)DeleteSP:(CollectionModel *)spM success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
