//
//  EasyFenLei.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface EasyFenLei : BaseEntity

//便利店分类查找商家---给服务器的
@property(nonatomic,copy) NSString * code;
//公共部分
@property (nonatomic,copy) NSNumber * pageNumber;
@property (nonatomic,copy) NSNumber * pageSize;

@end
