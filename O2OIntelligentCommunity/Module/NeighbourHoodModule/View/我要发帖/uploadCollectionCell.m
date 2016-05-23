//
//  uploadCollectionCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "uploadCollectionCell.h"

@implementation uploadCollectionCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.backgroundColor = [UIColor redColor];
        _imageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.frame=self.bounds;
        //[_imageBtn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
        [_imageBtn addTarget:self action:@selector(imageBtnArr:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageBtn];
        
    }
    return self; 
}

-(void)imageBtnArr:(UIButton *)btn
{
    if (_didimgbtnDeletget && [_didimgbtnDeletget respondsToSelector:@selector(didimgBtn:)])
    {
        [_didimgbtnDeletget didimgBtn:btn.tag];
        return;
    }
    
    if (_didimgbtnDeletget && [_didimgbtnDeletget respondsToSelector:@selector(didimgBtnIndex:cellIndex:)])
    {
        [_didimgbtnDeletget didimgBtnIndex:btn.tag-TAG_BEGIN_CELL cellIndex:self.cellIndex];
    }
    
}



@end
