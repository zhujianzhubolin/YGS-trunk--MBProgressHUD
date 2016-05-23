//
//  ZJWebProgrssView.h
//  testWebProgress
//
//  Created by user on 15/11/17.
//  Copyright © 2015年 user. All rights reserved.
//


typedef void (^LoadingBlock)();

#import <UIKit/UIKit.h>

@interface ZJWebProgrssView : UIView
@property (nonatomic, strong) LoadingBlock loadBlock;

- (void)startAnimation;
- (void)stopAnimationNormalIsNoData:(BOOL)isNoData;
- (void)stopAnimationFailIsNoData:(BOOL)isNoData;
@end
