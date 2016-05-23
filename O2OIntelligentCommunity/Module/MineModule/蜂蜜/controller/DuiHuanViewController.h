//
//  DuiHuanViewController.h
//  BeeTest
//
//  Created by app on 15/11/17.
//  Copyright © 2015年 kuroneko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "O2OBaseViewController.h"

typedef void (^duiHuanSuccessBLOCK)();

@interface DuiHuanViewController : O2OBaseViewController

@property (nonatomic,strong)duiHuanSuccessBLOCK duihuanblock;

@end
