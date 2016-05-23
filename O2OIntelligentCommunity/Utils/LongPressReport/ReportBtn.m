//
//  ReportBtn.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/26.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "ReportBtn.h"

@implementation ReportBtn
+ (instancetype)btnInstance {
    static ReportBtn *reportBtn = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat btnWidth = 60;
        CGFloat btnHeight = 50;
        reportBtn = [ReportBtn buttonWithType:UIButtonTypeCustom];
        reportBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
           });
    return reportBtn;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"举报" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showRepoerBtn {
    [[UIApplication sharedApplication].keyWindow addSubview:[ReportBtn btnInstance]];
}

- (void)removeReportBtn {
    if ([ReportBtn btnInstance].superview != nil) {
        [[ReportBtn btnInstance] removeFromSuperview];
    }
}

- (void)switchImgdirection:(SwitchDirection)direction {
    if (direction == SwitchDirectionUp) {
        [[ReportBtn btnInstance] setBackgroundImage:[UIImage imageNamed:@"c_report_up"] forState:UIControlStateNormal];
        [[ReportBtn btnInstance] setTitleEdgeInsets:UIEdgeInsetsMake([ReportBtn btnInstance].frame.size.height/3, 0, 0, 0)];
    }
    else {
        [[ReportBtn btnInstance] setBackgroundImage:[UIImage imageNamed:@"c_report_down"] forState:UIControlStateNormal];
        [[ReportBtn btnInstance] setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, [ReportBtn btnInstance].frame.size.height/3, 0)];
    }
}

- (void)reportClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
    [self removeReportBtn];
}

@end
