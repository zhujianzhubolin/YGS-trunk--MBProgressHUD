//
//  addXQHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "AddXQModel.h"

@interface addXQHandler : BaseHandler

//添加小区
-(void)addXQ:(AddXQModel *)addxq success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
