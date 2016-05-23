//
//  ZJXiaoMiRuleManager.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
#define RuleCellRow 30

typedef NS_ENUM(NSUInteger,RuleShowType) {
    RuleShowTypeNone = 100,
    RuleShowTypeGetFail
};

#define Noti_ruleChange @"XiaoMiRuleChange"


typedef void(^GetRuleListBlock)();

#import <Foundation/Foundation.h>

@interface ZJXiaoMiRuleDelegate : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSMutableArray *ruleArr;
@property (nonatomic,strong) UITableView *infoTb;
@property (nonatomic,assign) RuleShowType ruleType;
@property (nonatomic,strong) GetRuleListBlock getRuleBlock;

- (NSString *)getRuleStr;

@end
