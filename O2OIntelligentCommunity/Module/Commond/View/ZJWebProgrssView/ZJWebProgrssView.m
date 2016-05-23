//
//  ZJWebProgrssView.m
//  testWebProgress
//
//  Created by user on 15/11/17.
//  Copyright © 2015年 user. All rights reserved.
//

static NSString * const kNoDataContent = @"暂无内容，点击刷新";
static NSString * const kDefaultContent = @"暂无内容，点击刷新";
static NSString * const kErrorContent = @"暂无内容，请稍后再试";
static NSString * const kLoadingContent = @"正在加载中,请稍候";

#define ZJWEB_REFRESH_IMG @"ZJ_web_noData"
#define ZJWEB_ERROR_IMG   @"ZJ_web_error"

typedef NS_ENUM(NSInteger,StopAnimationType) {
    StopAnimationTypeDismiss,
    StopAnimationTypeNoData,
    StopAnimationTypeError
};

#import "ZJWebProgrssView.h"
#import "NetworkRequest.h"

@implementation ZJWebProgrssView
{
    UIButton *defaultBtn;
    UILabel *loadingL;
    UIImageView *loadingImgV;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
        defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat  narrowWidth = MIN(frame.size.width, frame.size.height);
        CGFloat btnHeight = narrowWidth / 5;
        if (btnHeight < 40) {
            btnHeight = 40;
        }
        
        CGFloat btnWidth  = btnHeight /187 *218;
        defaultBtn.frame = CGRectMake((frame.size.width - btnWidth) /2,
                                      (frame.size.height - btnHeight) /2,
                                      btnWidth,
                                      btnHeight);
        [defaultBtn setBackgroundImage:[UIImage imageNamed:ZJWEB_REFRESH_IMG]
                              forState:UIControlStateNormal];
        [defaultBtn addTarget:self
                       action:@selector(startAnimationAndClick)
             forControlEvents:UIControlEventTouchDown];
        
        loadingL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                             defaultBtn.frame.size.height + defaultBtn.frame.origin.y,
                                                             self.frame.size.width,
                                                             30)];
        loadingL.text = kDefaultContent;
        loadingL.adjustsFontSizeToFitWidth = YES;
        loadingL.textAlignment = NSTextAlignmentCenter;
        loadingL.textColor = [UIColor darkGrayColor];
        
        [self addSubview:defaultBtn];
        [self addSubview:loadingL];
        
        loadingImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        loadingImgV.frame = CGRectMake((frame.size.width - btnHeight) /2,
                                       (frame.size.height - btnHeight) /2,
                                       btnHeight,
                                       btnHeight);
        loadingImgV.hidden = YES;
        [self addSubview:loadingImgV];
        self.hidden = YES;
    }
    return self;
}

- (void)startImgVAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [loadingImgV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopImgVAnimation {
    [loadingImgV.layer removeAllAnimations];
}

- (void)stopAnimationWithType:(StopAnimationType)stopType {
     [self stopImgVAnimation];
     loadingImgV.hidden = YES;

    switch (stopType) {
        case StopAnimationTypeDismiss: {
            self.hidden = YES;
            defaultBtn.hidden = NO;
            [defaultBtn setBackgroundImage:[UIImage imageNamed:ZJWEB_REFRESH_IMG] forState:UIControlStateNormal];
            if ([NetworkRequest defaultRequest].isConnectionReachable) {
                loadingL.text = kDefaultContent;
            }
            else {
                loadingL.text = W_ALL_NO_NETWORK;
            }
        }
            break;
        case StopAnimationTypeError: {
            self.hidden = NO;
            defaultBtn.hidden = NO;
            [defaultBtn setBackgroundImage:[UIImage imageNamed:ZJWEB_ERROR_IMG] forState:UIControlStateNormal];
            
            if ([NetworkRequest defaultRequest].isConnectionReachable) {
                loadingL.text = kErrorContent;
            }
            else {
                loadingL.text = W_ALL_NO_NETWORK;
            }
        }
            break;
        case StopAnimationTypeNoData: {
            self.hidden = NO;
            defaultBtn.hidden = NO;
            [defaultBtn setBackgroundImage:[UIImage imageNamed:ZJWEB_REFRESH_IMG] forState:UIControlStateNormal];
            if ([NetworkRequest defaultRequest].isConnectionReachable) {
                loadingL.text = kNoDataContent;
            }
            else {
                loadingL.text = W_ALL_NO_NETWORK;
            }
        }
            break;
        default:
            break;
    }
}

- (void)stopAnimationNormalIsNoData:(BOOL)isNoData {
    if (isNoData) {
        [self stopAnimationWithType:StopAnimationTypeNoData];
    }
    else {
        if (self.superview) {
            [self.superview bringSubviewToFront:self];
        }
        [self stopAnimationWithType:StopAnimationTypeDismiss];
    }
}

- (void)stopAnimationFailIsNoData:(BOOL)isNoData {
    if (isNoData) {
        [self stopAnimationWithType:StopAnimationTypeError];
    }
    else {
        [self stopAnimationWithType:StopAnimationTypeDismiss];
    }
}

- (void)startAnimationAndClick {
    [self startAnimation];
    if (self.loadBlock) {
        self.loadBlock();
    }
}

- (void)startAnimation {
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    
    self.hidden = NO;
    loadingL.text = kLoadingContent;
    defaultBtn.hidden = YES;
    loadingImgV.hidden = NO;
    [self startImgVAnimation];
}

@end
