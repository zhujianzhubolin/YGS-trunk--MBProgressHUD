//
//  ZJAdvertisementModel.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/31.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ZJAdvertisementModel : BaseEntity


@property(nonatomic,strong) NSArray * list;
@property(nonatomic,copy) NSString * pageNumber;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * pageCount;
@property(nonatomic,copy) NSString * ID;
@property(nonatomic,copy) NSString * wyNo;          //物业id
@property(nonatomic,copy) NSString * xqNo;          //小区id
@property(nonatomic,copy) NSString * terminalNo;    //终端机编号
@property(nonatomic,copy) NSString * chargeType;    //收费类型
@property(nonatomic,copy) NSString * serviceRegular;//规则
@property(nonatomic,copy) NSString * chargeAmout;   //元
@property(nonatomic,assign) BOOL isSelected; //该规则是否选中，默认选中

@end
