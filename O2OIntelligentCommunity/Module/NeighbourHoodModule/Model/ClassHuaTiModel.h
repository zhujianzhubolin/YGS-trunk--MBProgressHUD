//
//  ClassHuaTiModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ClassHuaTiModel : BaseEntity

@property(nonatomic,strong)NSArray *list;
@property(nonatomic,copy)NSString *wyId;

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *wyNo;     //物业ID
@property(nonatomic,copy)NSString *typeName; //类型名称
@property(nonatomic,copy)NSString *author;//作者
@property(nonatomic,copy)NSString *remark;//备注
@property(nonatomic,copy)NSString *code;



@end
