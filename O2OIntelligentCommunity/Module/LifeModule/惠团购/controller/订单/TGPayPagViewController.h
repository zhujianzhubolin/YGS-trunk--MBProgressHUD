//
//  TGPayPagViewController.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PayMethod) {
    WXPayMethod,
    QianBaoMethod
};

#import "O2OBaseViewController.h"



@interface TGPayPagViewController : O2OBaseViewController

@property(nonatomic,assign) PayMethod method;

@property(nonatomic,strong) NSDictionary * orderinformation;

@property(nonatomic,copy) NSString * totalFee;

@end
