//
//  GrayViewController.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/13.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PayMethod2) {
    WXPayMethod2,
    QianBaoMethod2
};

#import "O2OBaseViewController.h"

@interface GrayViewController : O2OBaseViewController

@property(nonatomic,assign) PayMethod2 method2;

@property(nonatomic,strong) NSDictionary * orderinformation;

@property(nonatomic,copy) NSString * totalFee;

@end
