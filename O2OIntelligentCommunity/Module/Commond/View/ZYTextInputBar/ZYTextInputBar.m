//
//  ZYToolBar.m
//  Demo
//
//  Created by zhaoyang on 15/12/8.
//  Copyright © 2015年 zhaoyang. All rights reserved.
//

#import "ZYTextInputBar.h"

@interface ZYTextInputBar ()
{
    UIBarButtonItem *rigthBtn;
    UIBarButtonItem *SpaceBtn;
}

@end

@implementation ZYTextInputBar

+(id)shareInstance
{
    static ZYTextInputBar *zyBar = nil;
    if (zyBar == nil){
        zyBar = [[ZYTextInputBar alloc]init];
    }
    return zyBar;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setBarStyle:UIBarStyleDefault];
        self.frame=CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, 35);
        rigthBtn =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        SpaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSArray *buttonArray =[NSArray arrayWithObjects:SpaceBtn,rigthBtn, nil];
        [self setItems:buttonArray];
        
    }
    return self;
}

-(void)dismissKeyBoard
{
    if (self.inputBarBlock)
    {
        self.inputBarBlock();
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
