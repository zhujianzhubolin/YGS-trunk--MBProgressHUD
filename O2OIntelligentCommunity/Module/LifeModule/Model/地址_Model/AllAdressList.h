//
//  AllAdressList.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"


//删除一个收货地址的Model公用
@interface AllAdressList : BaseEntity

@property(nonatomic,copy) NSString * memberId;

@property(nonatomic,copy) NSString * addressId;

@end
