//
//  HuiTuanGouMuLuModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface HuiTuanGouMuLuModel : BaseEntity

@property (nonatomic,copy) NSNumber * catalogId;

@property (nonatomic,copy) NSNumber * parentCategoryId;

@property (nonatomic,copy) NSNumber * languageId;

@property(nonatomic,copy) NSString * longitude;

@property(nonatomic,copy) NSString * latitude;

@end
