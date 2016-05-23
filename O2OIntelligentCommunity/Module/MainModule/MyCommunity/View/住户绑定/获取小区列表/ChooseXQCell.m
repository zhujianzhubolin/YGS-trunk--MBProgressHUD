//
//  ChooseXQCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ChooseXQCell.h"

@implementation ChooseXQCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _XQNameLabe =[[UILabel alloc]init];
        _XQNameLabe.frame=CGRectMake(20, 5,IPHONE_WIDTH-40, 30);
        _XQNameLabe.textColor=[UIColor blackColor];
        
        [self addSubview:_XQNameLabe];
        
        _XQAddressLabe =[[UILabel alloc]init];
        _XQAddressLabe.frame=CGRectMake(20, 30, IPHONE_WIDTH-40, 25);
        _XQAddressLabe.textColor = [UIColor lightGrayColor];
        _XQAddressLabe.font=[UIFont systemFontOfSize:13];
        [self addSubview:_XQAddressLabe];
    }
    return self;
}

-(void)getXQListDictionary:(BingingXQModel *)model
{
    _XQNameLabe.text=model.xqName;
    _XQAddressLabe.text=model.xqAdress;
}

@end
