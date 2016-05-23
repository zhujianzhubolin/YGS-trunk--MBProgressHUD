//
//  HotSearchModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/12/8.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface HotSearchModel : BaseEntity

@property(nonatomic,copy) NSString * pageNumber;

@property(nonatomic,copy) NSString * pageSize;

@property(nonatomic,copy) NSString * code;

@property(nonatomic,copy) NSString * name;


@end
