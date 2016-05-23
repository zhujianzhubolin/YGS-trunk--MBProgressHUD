//
//  TGFenLei.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/18.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TGFenLei : BaseEntity

@property(nonatomic,copy) NSString * catalogId;
@property(nonatomic,copy) NSString * parentCategoryId;
@property(nonatomic,copy) NSString * languageId;

//平音缩写
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * tgid;
@property(nonatomic,copy) NSString * name;



@end
