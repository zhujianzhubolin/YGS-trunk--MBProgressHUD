//
//  BuyGuiZongCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyShopsM.h"
#import "MineBuyorderM.h"

@interface BuyGuiZongCell : UITableViewCell

@property (strong ,nonatomic)UILabel *numberLab;
@property (strong ,nonatomic)UILabel *HowMuchLab;

@property (strong ,nonatomic)UIImageView *img;

@property (strong ,nonatomic)UIButton *button1;
@property (strong ,nonatomic)UIButton *button2;
@property (strong ,nonatomic)UIButton *button3;

-(void)setButton:(MineBuyShopsM *)buyM tuanGouOrShangcheng:(NSString *)str;

@end
