//
//  ZJXiaoMiSubmmitSecFooter.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/28.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChickActionDelegate <NSObject>

-(void)submitAction;

@end

@interface ZJXiaoMiSubmmitSecFooter : UIView

@property (nonatomic,assign)id<ChickActionDelegate> delegate;

@end
