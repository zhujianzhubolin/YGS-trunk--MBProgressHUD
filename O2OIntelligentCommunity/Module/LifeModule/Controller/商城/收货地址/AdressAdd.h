//
//  AdressAdd.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"

@interface AdressAdd : O2OBaseViewController

@property(nonatomic,strong) NSDictionary * adressDict;

@property(nonatomic,assign) BOOL isEmpty;
@property(nonatomic,copy)NSString *EditingAddStr;

@end
