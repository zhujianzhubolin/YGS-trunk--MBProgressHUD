//
//  ZJLongPressGesture.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/26.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "ZJLongPressGesture.h"
#import "UIView+wrapper.h"
#import "ReportVC.h"
  

@implementation ZJLongPressGesture
{
    UIView *_toView;
}

- (id)initWithTarget:(id)target
              action:(SEL)action
              toView:(UIView *)toView {
    self = [super initWithTarget:self action:@selector(handleLongPress:)];
    if (self) {
        _toView = toView;
    }
    return self;
};

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [[ReportBtn btnInstance] removeReportBtn];
        CGFloat btnWidth = [ReportBtn btnInstance].frame.size.width;
        CGFloat btnHeight = [ReportBtn btnInstance].frame.size.height;
        
        CGRect gestureVRect = [gestureRecognizer.view.superview convertRect:gestureRecognizer.view.frame toView:[UIApplication sharedApplication].keyWindow];
        CGPoint pressVCenter = gestureRecognizer.view.center;
        
        if (gestureVRect.origin.y > 64 + btnHeight + 5) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ReportBtn btnInstance].frame = CGRectMake(pressVCenter.x - btnWidth/2, gestureVRect.origin.y - 5 - btnHeight, btnWidth, btnHeight);
            });
            [[ReportBtn btnInstance] switchImgdirection:SwitchDirectionDown];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ReportBtn btnInstance].frame = CGRectMake(pressVCenter.x - btnWidth/2, gestureVRect.origin.y + gestureVRect.size.height + 5, btnWidth, btnHeight);
            });
            [[ReportBtn btnInstance] switchImgdirection:SwitchDirectionUp];
        }
        
        [[ReportBtn btnInstance] showRepoerBtn];
        [[ReportBtn btnInstance] animateFadeIn:0.8];
        
        [ReportBtn btnInstance].clickBlock = ^(UIButton *sender) {
            if (self.pressBlock) {
                self.pressBlock();
            }
        };
    }
}


@end
