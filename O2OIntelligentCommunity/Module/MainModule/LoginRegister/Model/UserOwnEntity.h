//
//  UserOwnEntity.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface UserOwnEntity : BaseEntity

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *telphone; //物业电话
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *photoUrl; //头像
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *realName; //姓名
@property (nonatomic, copy) NSString *isCardActivate; //用户的钱包是否开通
@property (nonatomic, copy) NSString *integral; //蜂蜜
@property (nonatomic, copy) NSString *tradeMenoy; //钱包数额
@property (nonatomic, copy) NSString *optCounter; //可用代金券个数

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message; 
@end
