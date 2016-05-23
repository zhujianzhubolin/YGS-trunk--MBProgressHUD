//
//  SongXianHuaHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "SongXianHuaModel.h"

@interface SongXianHuaHandler : BaseHandler

//送鲜花
-(void)SongHua:(SongXianHuaModel *)songhuaM success:(SuccessBlock)success
        failed:(FailedBlock)failed;

@end
