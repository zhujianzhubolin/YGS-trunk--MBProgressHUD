//
//  UpLoadNewRentInfor.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "O2OBaseViewController.h"
#import "IdleMarketVC.h"
#import "HouseRentingVC.h"

@protocol FreshTableView <NSObject>

- (void)freshWitchTable:(NSInteger)index;

@end

@interface UpLoadNewRentInfor : O2OBaseViewController
@property (nonatomic, assign) VCTypeRen vcType;
@property (nonatomic, assign) IdleMarketType idleType; //初始化选中哪个
@property (nonatomic, assign) RentType rentType;

@property(nonatomic,weak) id<FreshTableView>freshdele;

@end
