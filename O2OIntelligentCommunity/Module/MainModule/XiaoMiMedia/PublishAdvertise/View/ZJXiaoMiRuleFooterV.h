//
//  ZJXiaoMiRuleFooterV.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ZJXiaoMiRuleFooterV : UIView

@property (nonatomic,assign) NSUInteger ruleDays; //相差的天数
@property (nonatomic,assign) CGFloat ruleCount; //规则金额

- (NSString *)getStartDateStr;
- (NSString *)getEndDateStr;
- (void)updateDataForXiaoMiJiQiNum:(NSInteger)jiqiNum;
- (NSString *)getTotalCount;

@end
