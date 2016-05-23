//
//  ZYStarLevelView.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/31.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ZYStarLevelView.h"

@implementation ZYStarLevelView
{
    CGFloat interval;//间距
    CGFloat itemWidth;//button的宽
    CGFloat itemHeight;//button的高
    
}

-(id)initWithFrame:(CGRect)frame defaultcolorImg:(UIImage *)defaultcolorImg imgAarray:(NSMutableArray *)imgArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.backgroundColor=[UIColor redColor];
        
        interval = 1;
        itemHeight=frame.size.height;
        itemWidth = (frame.size.width -interval*(imgArray.count-1))/ imgArray.count;
        
        for (int i = 0 ; i < imgArray.count; i++)
        {
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame= CGRectMake(i * (interval + itemWidth), 0, itemWidth, itemHeight);
            button.tag = i+1000;
            button.selected=YES;
            [button setImage:defaultcolorImg forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
//            if (i==0)
//            {
//                button.selected=YES;
//            }
        }
        
        
    }
    return self;
}

-(void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    for (UIButton * star in self.subviews)
    {
        if (star.tag <= button.tag) {
            star.selected = YES;
        }
        else
        {
            star.selected = NO;
        }
    }
}


-(NSUInteger)starLevelVSelectNumber
{
    NSUInteger selectNum=0;
    for (UIView * subV in self.subviews)
    {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subV;
            if (btn.selected) {
                selectNum++;
            }
        }
    }
    NSLog(@"selectNum==%lu",(unsigned long)selectNum);
    return selectNum;
}


@end
