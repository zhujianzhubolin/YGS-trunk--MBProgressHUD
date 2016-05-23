//
//  CollectionViewImgCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CollectionViewImgCell.h"

@implementation CollectionViewImgCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        _img =[[UIImageView alloc]initWithFrame:self.bounds];
        _img.clipsToBounds=YES;
        _img.contentMode = UIViewContentModeScaleAspectFill;
        //_img.image =[UIImage imageNamed:@"headIcon.png"];
        [self addSubview:_img];
        
    }
    return self;
}


@end
