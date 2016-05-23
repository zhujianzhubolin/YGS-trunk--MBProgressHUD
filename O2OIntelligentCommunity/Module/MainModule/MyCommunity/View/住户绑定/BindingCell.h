//
//  BindingCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingCell : UITableViewCell


@property (strong ,nonatomic)UILabel *nameLabe;
@property (strong ,nonatomic)UIImageView *img;
//@property (strong ,nonatomic)UITextField *textField;


-(void)setname:(NSString *)name;

@end
