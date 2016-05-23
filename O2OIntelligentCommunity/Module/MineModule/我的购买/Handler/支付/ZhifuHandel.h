//
//  ZhifuHandel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ZhifuModel.h"

@interface ZhifuHandel : BaseHandler

//重新选择支付下单
-(void)AgainXiaDanZhiFu:(ZhifuModel *)zhifu success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
