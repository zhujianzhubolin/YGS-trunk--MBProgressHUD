//
//  ChangePasswordHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ChangePasswordModel.h"

@interface ChangePasswordHandler : BaseHandler
//修改密码
-(void)ChangePassword:(ChangePasswordModel *)changepassword success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
