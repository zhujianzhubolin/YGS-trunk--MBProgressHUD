//
//  CicleVuew.m
//  StartMoving
//
//  Created by app on 16/2/29.
//  Copyright © 2016年 kuroneko. All rights reserved.
//

#import "CicleVuew.h"

@implementation CicleVuew

{
    UIActivityIndicatorView * activity;

}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame:frame]) {
        
        activity = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];//指定进度轮的大小
        activity.layer.cornerRadius = 5;
        
        activity.backgroundColor = [UIColor clearColor];
        [activity setCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)];//指定进度轮中心点
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [self addSubview:activity];
    }
    return self;
}

- (void)startMoving{
    
    [activity startAnimating];

}

- (void)stopMoving{

    [activity stopAnimating];
}

@end
