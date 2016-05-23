//
//  NeighbourHoodHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#include "ClassHuaTiModel.h"
#import "NewHuaTiModel.h"



@interface NeighbourHoodHandler : BaseHandler

//获取话题分类
- (void)getTopicClass:(ClassHuaTiModel *)topClass
               success:(SuccessBlock)success
                failed:(FailedBlock)failed;

//新建话题（ 我要发帖）
-(void)NewHuaTi:(NewHuaTiModel *)NewHT
        success:(SuccessBlock)success
         failed:(FailedBlock)failed;


@end
