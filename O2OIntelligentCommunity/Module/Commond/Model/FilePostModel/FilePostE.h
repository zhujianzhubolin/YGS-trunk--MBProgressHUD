//
//  ImgPostE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface FilePostE : BaseEntity

@property (nonatomic, copy) NSString *dataD; //文件字节流
@property (nonatomic, copy) NSString *fileName; //文件名
@property (nonatomic, copy) NSString *entityType; //业务类型

@property (nonatomic, copy) NSString *messages; //返回提示
@property (nonatomic, copy) NSString *code; //返回结果
@property (nonatomic, copy) NSString *idID; //文件ID
@end
