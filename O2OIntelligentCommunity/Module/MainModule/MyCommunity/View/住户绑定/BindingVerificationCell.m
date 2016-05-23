//
//  BindingVerificationCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BindingVerificationCell.h"

@implementation BindingVerificationCell

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
        
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, IPHONE_WIDTH - 120 - 100 - 20, 40)];
        _textField.placeholder=@"验证码";
        _textField.delegate = self;
        [self addSubview:_textField];
        
        _TestingBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _TestingBut.frame=CGRectMake(IPHONE_WIDTH-120, 10, 100, 30);
        _TestingBut.backgroundColor = [AppUtils colorWithHexString:@"fa6900"];
        [_TestingBut setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_TestingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_TestingBut];
        

    }
    return self;
}

-(void)setname:(NSString *)name;
{
    _nameLabe.text=name;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    if (textField == self.textField) {
        return range.location < AUTH_CODE_INPUT_BITS;
    }
    return YES;
}

@end
