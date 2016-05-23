//
//  bindingHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "BingingXQModel.h"

@interface bindingHandler : BaseHandler

//获取小区的数据
- (void)requsetForGetCommunityDataForModel:(BingingXQModel *)bindingXq
                                   success:(SuccessBlock)success
                                    failed:(FailedBlock)failed;

//绑定小区
- (void)bangdingxiaoqu:(BingingXQModel *)MineXq
               success:(SuccessBlock)success
                failed:(FailedBlock)failed;

    
@end
