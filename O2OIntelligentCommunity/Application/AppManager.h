//
//  AppManager.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/4/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"
#import "AppModel.h"

@interface AppManager : NSObject <UIAlertViewDelegate>

+ (instancetype)shareManager;
- (void)getSystemVersionInfo;
@end
