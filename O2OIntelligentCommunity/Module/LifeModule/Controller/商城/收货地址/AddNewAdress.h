//
//  AddNewAdress.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"

@protocol SendArdessInfo <NSObject>

- (void)SenAdress:(id)info;

@end

@interface AddNewAdress : O2OBaseViewController

@property(nonatomic,weak) id<SendArdessInfo>adressdele;
@property (nonatomic)BOOL ismine;
@end
