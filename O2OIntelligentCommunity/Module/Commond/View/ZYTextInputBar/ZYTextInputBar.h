//
//  ZYToolBar.h
//  Demo
//
//  Created by zhaoyang on 15/12/8.
//  Copyright © 2015年 zhaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputBarBLOCK)();

@interface ZYTextInputBar : UIToolbar

@property (nonatomic,strong)InputBarBLOCK inputBarBlock;

+ (id)shareInstance;



@end
