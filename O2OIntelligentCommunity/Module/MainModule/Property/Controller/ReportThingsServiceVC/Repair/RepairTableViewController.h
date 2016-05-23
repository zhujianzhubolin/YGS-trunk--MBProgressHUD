//
//  RepairTableViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM (NSUInteger, VCType) {
    VCTypeRepair,
    VCTypeComplain
};

#import "BaseTableViewController.h"

@interface RepairTableViewController : BaseTableViewController
@property (nonatomic, assign) VCType type;
@end
