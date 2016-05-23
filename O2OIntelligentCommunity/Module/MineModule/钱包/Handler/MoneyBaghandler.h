//
//  MoneyBaghandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#include "MoneybagModel.h"

@interface MoneyBaghandler : BaseHandler
@property (nonatomic, copy) NSString *moneyBagcurrentPage;
@property (nonatomic, copy) NSString *moneyBagpageCount;
@property (nonatomic, strong) NSMutableArray *moneyBagArray;
@property (nonatomic, strong) NSMutableArray *recvArr;

//获取钱包支付信息记录
-(void)postjiaoyixinxi:(MoneybagModel *)moneyinfo success:(SuccessBlock)success failed:(FailedBlock)failed isHeader:(BOOL)isheader;

- (void)resetData;
@end
