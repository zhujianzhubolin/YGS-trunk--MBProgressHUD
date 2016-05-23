//
//  SwitchVCAnimation.h
//  KEAPP
//
//  Created by apple on 15-1-21.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

typedef NS_ENUM(NSUInteger,AnimationType) {
    AnimationTypeFade,
    AnimationTypeMoveIn,
    AnimationTypePush,
    AnimationTypeReveal
};

typedef NS_ENUM(NSUInteger,AnimationDirection) {
    AnimationDirectionRight,
    AnimationDirectionLeft,
    AnimationDirectionTop,
    AnimationDirectionBottom
};

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SwitchVCAnimation : NSObject

+ (id)shareInstance;
- (CATransition *)getTransitionAnimation;
- (void)replaceAnimationType:(AnimationType)type;
- (void)replaceAnimationDirection:(AnimationDirection)directionType;
- (void)replaceAnimationDuration:(CGFloat)duration;

@end
