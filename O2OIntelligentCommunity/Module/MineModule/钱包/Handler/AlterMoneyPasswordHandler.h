//
//  AlterMoneyPasswordHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "AlterMoneyPasswordModel.h"

@interface AlterMoneyPasswordHandler : BaseHandler
//修改支付密码
-(void)altermoneypassword:(AlterMoneyPasswordModel *)password success:(SuccessBlock)success failed:(FailedBlock)failed;

//检查身份通过后设置交易密码
-(void)confirmIdsetPassword:(AlterMoneyPasswordModel *)confirmid success:(SuccessBlock)success failed:(FailedBlock)failed;


@end
