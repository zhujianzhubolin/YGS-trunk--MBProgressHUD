//
//  UINavigationItem+custom.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/5/5.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "UINavigationItem+custom.h"
#import <objc/runtime.h>

@implementation UINavigationItem (custom)

- (void)setItemLeftAction:(ClickEvent)itemLeftAction {
    objc_setAssociatedObject(self, @selector(itemLeftAction), itemLeftAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ClickEvent)itemLeftAction {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setItemRightAction:(ClickEvent)itemRightAction {
    objc_setAssociatedObject(self, @selector(itemRightAction), itemRightAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ClickEvent)itemRightAction {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)addLeftItemWithImgName:(NSString *)imgName
                        action:(ClickEvent)action {
    self.itemLeftAction = action;
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -8;
    
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 0, 21, 21);
    
    NSString *imgStr = @"backIcon";
    if (imgName.length > 0) {
        imgStr = imgName;
    }
    [backBtn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickForBtnLeftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.leftBarButtonItems=@[negativeSeperator,backItem];
}

- (void)addRightItemWithImgName:(NSString *)imgName
                         action:(ClickEvent)action {
    self.itemRightAction = action;

    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame =CGRectMake(0, 0, 21, 21);
    
    NSString *imgStr = @"jiantou";
    if (imgName.length > 0) {
        imgStr = imgName;
    }
    [rightBtn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickForBtnRightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.rightBarButtonItem = rightItem;
}

- (void)clickForBtnLeftItem {
    if (self.itemLeftAction) {
        self.itemLeftAction();
    }
}

- (void)clickForBtnRightItem {
    if (self.itemRightAction) {
        self.itemRightAction();
    }
}

@end
