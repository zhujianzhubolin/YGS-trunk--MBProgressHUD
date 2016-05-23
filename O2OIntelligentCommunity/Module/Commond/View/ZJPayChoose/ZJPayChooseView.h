//
//  ZJPayChooseView.h
//  testZHIFU
//
//  Created by user on 16/3/9.
//  Copyright © 2016年 ygs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPayModel.h"

typedef NS_ENUM(NSUInteger,PayMethod) {
    PayMethodQianbao = 1,
    PayMethodWeiXin
};

@interface ZJPayChooseView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) PayMethod paymethod;
- (void)reloadData;

@end
