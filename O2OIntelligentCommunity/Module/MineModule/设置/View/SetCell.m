//
//  SetCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat levelInterval = 15;
        CGFloat verticalInterval = 5;
        CGFloat nameWidth =130;
        _iconImage  = [[UIImageView alloc]initWithFrame:CGRectMake(levelInterval, verticalInterval, 44 - verticalInterval *2, 44 - verticalInterval *2)];
        [self addSubview:_iconImage];
        
        _nameLabele =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame) + levelInterval, _iconImage.frame.origin.y, nameWidth, _iconImage.frame.size.height)];
        _nameLabele.textColor =[UIColor grayColor];
        _nameLabele.font=[UIFont systemFontOfSize:15];
        [self addSubview:_nameLabele];
        
        _dataLabe = [[UILabel alloc]init];
        _dataLabe.frame=CGRectMake(levelInterval + 44 - verticalInterval *2 + nameWidth, _nameLabele.frame.origin.y, IPHONE_WIDTH - CGRectGetMaxX(_nameLabele.frame) - 25, _nameLabele.frame.size.height);
        _dataLabe.font = [UIFont systemFontOfSize:14];
        _dataLabe.textColor =[UIColor grayColor];
        _dataLabe.textAlignment=NSTextAlignmentRight;
        [self addSubview:_dataLabe];
    }
    return self;
}

-(void)setIcon:(UIImage *)image
{
    _iconImage.image =image;
}
-(void)setNameLabe:(NSString *)name
{
    _nameLabele.text=name;
}
-(void)setDataStringLabe:(NSString *)string
{
    _dataLabe.text=string;
}

@end
