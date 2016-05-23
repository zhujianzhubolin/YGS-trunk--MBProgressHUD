//
//  BindingVerificationCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingVerificationCell : UITableViewCell <UITextFieldDelegate>

@property (strong ,nonatomic)UILabel *nameLabe;
@property (strong ,nonatomic)UIImageView *img;
@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton    *TestingBut;

-(void)setname:(NSString *)name;
@end
