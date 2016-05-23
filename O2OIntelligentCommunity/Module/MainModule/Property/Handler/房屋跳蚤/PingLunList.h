//
//  PingLunList.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/13.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "PinLunListModel.h"
#import "PinLunLieBiao.h"
@interface PingLunList : BaseHandler


//发布一条评论
- (void)AddPingLun:(PinLunListModel *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取评论列表
- (void)GetHousePingLUn:(PinLunLieBiao *)model success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
