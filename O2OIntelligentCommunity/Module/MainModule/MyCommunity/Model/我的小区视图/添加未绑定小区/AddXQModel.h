//
//  AddXQModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface AddXQModel : BaseEntity

@property (nonatomic,strong)NSArray *lsit;          //对象集合
@property (nonatomic,copy)NSNumber *xqNo;           //小区ID
@property (nonatomic,copy)NSString *memberId;       //会员ID

@property (nonatomic,copy)NSString *messages;        //消息
@property (nonatomic,copy)NSString *code;            //返回结果


@end
