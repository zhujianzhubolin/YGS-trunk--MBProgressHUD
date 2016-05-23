//
//  ChangePersonalInfoModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ChangePersonalInfoModel : BaseEntity

@property (nonatomic,copy)NSString *memberId;//会员id
@property (nonatomic,copy)NSString *realName;//真实姓名
@property (nonatomic,copy)NSString *nickName;//昵称
@property (nonatomic,assign)long   fileId;//图像Id


@end
