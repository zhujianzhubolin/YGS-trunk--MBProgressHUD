//
//  UINavigationItem+custom.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/5/5.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef void(^ClickEvent)(void);

@interface UINavigationItem (custom)

@property (nonatomic,strong) ClickEvent itemLeftAction;
@property (nonatomic,strong) ClickEvent itemRightAction;

- (void)addLeftItemWithImgName:(NSString *)imgName
                        action:(ClickEvent)action;

- (void)addRightItemWithImgName:(NSString *)imgName
                         action:(ClickEvent)action;
@end
