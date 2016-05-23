//
//  DelectRentalBadyHandler.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 15/12/15.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ShengSJDataE.h"

@interface DelectRentalBadyHandler : BaseHandler

//删除我的宝贝和我租售
-(void)delectRentalBady:(ShengSJDataE *)delectRB success:(SuccessBlock)success
                 failed:(FailedBlock)failed;

@end
