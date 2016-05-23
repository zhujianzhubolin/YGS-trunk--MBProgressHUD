//
//  UserAccoutInfoVC.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/1.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, NamePerNickname){
    NameEdit = 0,
    NicknameEdit
};


#import "O2OBaseViewController.h"

@interface UserAccoutInfoVC : O2OBaseViewController

@property (nonatomic)NamePerNickname nameOrNickname;

@end
