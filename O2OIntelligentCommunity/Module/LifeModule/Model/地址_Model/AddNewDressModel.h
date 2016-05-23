//
//  AddNewDressModel.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface AddNewDressModel : BaseEntity

@property(nonatomic,copy)NSString * adressid;;
@property(nonatomic,copy)NSString * memberId;
@property(nonatomic,copy)NSString * default_Address;
@property(nonatomic,copy)NSString * consignee;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * province;
@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)NSString * district;
@property(nonatomic,copy)NSString * addressName;

@end
