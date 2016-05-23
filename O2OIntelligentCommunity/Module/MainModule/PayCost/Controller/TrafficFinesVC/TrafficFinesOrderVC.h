//
//  FinesOnlineViewController.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseTableViewController.h"

@interface TrafficFinesOrderVC : BaseTableViewController
@property (nonatomic, strong) NSArray *trafficArr;

@property (nonatomic, copy) NSString *carnumber; //车牌号
@property (nonatomic, copy) NSString *cardrivenumber; //车辆识别码
@property (nonatomic, copy) NSString *carcode; //发动机号码
@end
