//
//  PayViewController.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/13.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"

typedef NS_ENUM(NSUInteger, PayMethod) {
    WXPayMethod,
    QianBaoMethod
};


@interface PayViewController : O2OBaseViewController

@property(nonatomic,copy) NSString * orderNum;

@property(nonatomic,assign) PayMethod method;

@property(nonatomic,copy) NSString * allMoney;

@property(nonatomic,copy) NSArray * orderlistArray;


@property(nonatomic,assign) BOOL isMine;


@end
