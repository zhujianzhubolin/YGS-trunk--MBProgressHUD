//
//  MoneyBagInfoModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface MoneyBagInfoModel : BaseEntity

@property(nonatomic,copy)NSString *memberId;

@property(nonatomic,copy)NSString *amount;//账户余额
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *idNumber;//身份证号
@property(nonatomic,copy)NSString *cardNo;// 卡号
@property(nonatomic,copy)NSString *vipNo; //系统卡号
@property(nonatomic,copy)NSString *isDelete;//删除标记
@property(nonatomic,copy)NSString *dateCreated;//创建时间
@property(nonatomic,copy)NSString *updateBy;//修改人
@property(nonatomic,copy)NSString *dateUpdated;//修改时间
@property(nonatomic)BOOL isFreeze;//是否冻结
@property(nonatomic,copy)NSString *isActivate;// 是否激活
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *code;

@end
