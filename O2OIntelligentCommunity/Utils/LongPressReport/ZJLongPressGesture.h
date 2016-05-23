//
//  ZJLongPressGesture.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/26.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

typedef void (^LongPressBlock)();
#import <UIKit/UIKit.h>
#import "ReportBtn.h" 

@interface ZJLongPressGesture : UILongPressGestureRecognizer
@property (nonatomic,strong) LongPressBlock pressBlock;

- (id)initWithTarget:(id)target
              action:(SEL)action
              toView:(UIView *)toView;
@end
