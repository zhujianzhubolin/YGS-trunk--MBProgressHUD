//
//  HouseAndGoods.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "AddNewInforModel.h"

@interface HouseAndGoods : BaseHandler

//发布一则新的消息----房屋租售
- (void)AddNewHouseInfor:(AddNewInforModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;


//发布一则新的消息----跳蚤市场
- (void)AddNewGoodsInfor:(AddNewInforModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
