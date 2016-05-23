//
//  MoneyBaginfoHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "MoneyBagInfoModel.h"

@interface MoneyBaginfoHandler : BaseHandler
//钱包信息
-(void)moneybaginfo:(MoneyBagInfoModel *)info success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
