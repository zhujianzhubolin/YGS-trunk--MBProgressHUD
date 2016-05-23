//
//  MessageModel.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface MessageModel : BaseEntity

@property (nonatomic, copy) NSString *smsType; //业务类型      RetPwd:找回密码            BinDingUser:绑定业主
@property (nonatomic, copy) NSString *mobile; //
@property (nonatomic, copy) NSString *code; //验证码
@property (nonatomic, copy) NSString *reference; //来源   盛世嘉：  shengshijia  移公社：yigongshe

//注册时的参数，注册独立
@property (nonatomic, copy) NSString *businessType; //register 注册
@property (nonatomic, copy) NSString *mobilePhone; //注册时的手机号码
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *roomId;//房号ID
@end
