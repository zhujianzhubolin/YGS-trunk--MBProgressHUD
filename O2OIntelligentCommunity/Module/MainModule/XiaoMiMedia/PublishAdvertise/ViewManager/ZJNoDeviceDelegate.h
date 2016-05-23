//
//  ZJNoDeviceDelegate.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/7.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BingingXQModel.h"

@interface ZJNoDeviceDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *noDeviceTB;
- (void)updateUIForComInfo:(BingingXQModel *)comM;

- (void)updateUIForPromptInformation:(NSString *)prompt;
@end
