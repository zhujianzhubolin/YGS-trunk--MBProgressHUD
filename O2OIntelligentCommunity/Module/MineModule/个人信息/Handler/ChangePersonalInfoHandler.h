//
//  ChangePersonalInfoHandler.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"
#import "ChangePersonalInfoModel.h"

@interface ChangePersonalInfoHandler : BaseHandler

//修改个人信息
-(void)ChangeInfo:(id)parameters
          success:(SuccessBlock)success
           failed:(FailedBlock)failed;


@end
