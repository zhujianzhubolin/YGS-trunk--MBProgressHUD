//
//  SwitchVCAnimation.m
//  KEAPP
//
//  Created by apple on 15-1-21.
//  Copyright (c) 2015年 huawei. All rights reserved.
//

#import "SwitchVCAnimation.h"

@implementation SwitchVCAnimation
{
    CATransition *globalAnimation;
}

+ (id)shareInstance {
    static SwitchVCAnimation *transitionSimple = nil;
    if (transitionSimple == nil) {
        transitionSimple = [[SwitchVCAnimation alloc] init];
    }
    return transitionSimple;
}

- (id)init {
    self = [super init];
    if (self) {
        globalAnimation = [CATransition animation];
        globalAnimation.duration = 0.5f;
        globalAnimation.type = kCATransitionFade;
        globalAnimation.subtype = kCATransitionFromLeft;
    }
    return self;
}

- (CATransition *)getTransitionAnimation {
    return globalAnimation;
}

- (void)replaceAnimationType:(AnimationType)type {
    switch (type) {
        case AnimationTypeFade:
            globalAnimation.type = kCATransitionFade;
            break;
        case AnimationTypeMoveIn:
            globalAnimation.type = kCATransitionMoveIn;
            break;
        case AnimationTypePush:
            globalAnimation.type = kCATransitionPush;
            break;
        default:
            globalAnimation.type = kCATransitionReveal;
            break;
    }
}

- (void)replaceAnimationDirection:(AnimationDirection)directionType {
    switch (directionType) {
        case AnimationDirectionRight: //0 从右边开始
            globalAnimation.subtype = kCATransitionFromRight;
            break;
        case AnimationDirectionLeft:  //1 从左边开始
            globalAnimation.subtype = kCATransitionFromLeft;
            break;
        case AnimationDirectionTop:   //2 从上边开始
            globalAnimation.subtype = kCATransitionFromTop;
            break;
        default:                  //3 从下边开始
            globalAnimation.subtype = kCATransitionFromBottom;
            break;
    }
}

- (void)replaceAnimationDuration:(CGFloat)duration {
    globalAnimation.duration = duration;
}

@end
