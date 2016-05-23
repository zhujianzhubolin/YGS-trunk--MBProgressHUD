//
//  BaoXiuTouShuHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "BaoXiuTouSuModel.h"
#import "BXTSCommentsModel.h"
#import "ShengSJDataE.h"
#import "ShengShiJiaH.h"

@interface BaoXiuTouShuHandler : ShengShiJiaH
@property (nonatomic, copy) NSString *bxcurrentPage;
@property (nonatomic, copy) NSString *bxpageCount;
@property (nonatomic, strong) NSMutableArray *bxArray;

@property (nonatomic, copy) NSString *tscurrentPage;
@property (nonatomic, copy) NSString *tspageCount;
@property (nonatomic, strong) NSMutableArray *tsArray;

@property (nonatomic, copy) NSString *advicePNumber;
@property (nonatomic, copy) NSString *advicePCount;
@property (nonatomic, strong) NSMutableArray *adviceArray;



//获取报修信息列表
-(void)BaoXiuList:(BaoXiuTouSuModel *)MineBX success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;
//获取投诉信息列表
-(void)TousuList:(BaoXiuTouSuModel *)MineTS success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;


//获取报修或者投诉详情的评论列表
-(void)BXTSCommentsList:(BXTSCommentsModel *)MineBXTSComment success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取投诉和建议
-(void)queryAdviceData:(ShengSJDataE *)shengSJE
               success:(SuccessBlock)success
                failed:(FailedBlock)failed
              isHeader:(BOOL)isheader;

@end
