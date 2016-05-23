//
//  ReportBtn.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/26.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//
typedef NS_ENUM(NSUInteger,SwitchDirection) {
    SwitchDirectionUp,
    SwitchDirectionDown
};


typedef void (^ReportBtnClickBlock)(UIButton *reportBtn);
#import <UIKit/UIKit.h>

@interface ReportBtn : UIButton
+ (instancetype)btnInstance;

@property (nonatomic,strong) ReportBtnClickBlock clickBlock;

- (void)switchImgdirection:(SwitchDirection)direction;
- (void)removeReportBtn;
- (void)showRepoerBtn;

@end
