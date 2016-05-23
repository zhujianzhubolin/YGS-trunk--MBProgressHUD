//
//  AroundMerchantsCell.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeCircleE.h"
#import "LifeCircleVC.h"

@interface LifeCircleStoresCell : UITableViewCell
@property (nonatomic, assign) LifeCircleType circleType;

- (void)reloadAroundMerchangtsWithModel:(LifeCircleE *)circleE;
- (void)reloadPublicServiceWithModel:(LifeCircleE *)circleE;

@end
