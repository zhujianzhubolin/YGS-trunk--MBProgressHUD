//
//  GoodsShopsCommentHandel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "GoodsShopsCommentModel.h"

@interface GoodsShopsCommentHandel : BaseHandler

//商品和商家评论
-(void)goodShopComment:(GoodsShopsCommentModel *)commentM success:(SuccessBlock)success failed:(FailedBlock)failed;


@end
