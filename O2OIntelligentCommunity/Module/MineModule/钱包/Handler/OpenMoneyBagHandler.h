//
//  OpenMoneyBagHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "OpenMoneyBagModel.h"

@interface OpenMoneyBagHandler : BaseHandler

//开通钱包
-(void)openmoneybag:(OpenMoneyBagModel *)openm success:(SuccessBlock)success failed:(FailedBlock)failed;

//忘记支付密码，
-(void)forgetzhifupassword:(OpenMoneyBagModel *)forgetpassword success:(SuccessBlock)success failed:(FailedBlock)failed;
@end
