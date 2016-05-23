//
//  YesIsNOCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyShopsM.h"

@interface YesIsNOCell : UITableViewCell

@property (strong ,nonatomic)UIButton *button1;
@property (strong ,nonatomic)UIButton *button2;
@property (strong ,nonatomic)UIButton *button3;

-(void)setButton:(MineBuyShopsM *)shopM;

@end
