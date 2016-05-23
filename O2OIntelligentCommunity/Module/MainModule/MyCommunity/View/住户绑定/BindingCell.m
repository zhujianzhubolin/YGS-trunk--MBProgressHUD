//
//  BindingCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BindingCell.h"

@implementation BindingCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor =[UIColor whiteColor];
        _nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 40)];
        _nameLabe.textAlignment = NSTextAlignmentLeft;
        _nameLabe.font =[UIFont systemFontOfSize:14];
        _nameLabe.textColor =[UIColor blackColor];
        
        [self addSubview:_nameLabe];
        
        
//        _textField = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, self.frame.size.width-65, 40)];
//        _textField.placeholder=@"必填";
//        [self addSubview:_textField];
        

    }
    return self;
}

-(void)setname:(NSString *)name;
{
    _nameLabe.text=name;
}


@end
