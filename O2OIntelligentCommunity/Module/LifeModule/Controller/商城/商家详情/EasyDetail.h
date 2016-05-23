//
//  EasyDetail.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseTableViewController.h"

@interface EasyDetail : BaseTableViewController

@property(nonatomic,copy) NSNumber * shopID;
@property(nonatomic,copy) NSString * storeType;
@property(nonatomic,assign) BOOL isRz;
@property(nonatomic,copy) NSDictionary * shopData;

@end
