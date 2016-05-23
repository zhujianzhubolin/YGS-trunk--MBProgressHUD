//
//  MoneyBagPayHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/19.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "MoneyBagPayModel.h"

@interface MoneyBagPayHandler : BaseHandler
//钱包支付
-(void)moneybagpay:(MoneyBagPayModel *)payM success:(SuccessBlock)success failed:(FailedBlock)failed;
@end
