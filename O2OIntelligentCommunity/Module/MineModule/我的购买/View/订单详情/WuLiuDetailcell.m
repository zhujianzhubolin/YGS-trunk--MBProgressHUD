//
//  WuLiucell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "WuLiuDetailcell.h"

@implementation WuLiuDetailcell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        _headimg.image =[UIImage imageNamed:@"zylogistics"];
        [self addSubview:_headimg];
        
        _nameLabe =[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 30)];
        _nameLabe.text=@"物流信息";
        _nameLabe.textColor =[UIColor grayColor];
        _nameLabe.font=[UIFont systemFontOfSize:14];
        [self addSubview:_nameLabe];
        

        _addressLabe = [[UILabel alloc]init];
        _addressLabe.numberOfLines = 3;
        _addressLabe.textColor =[UIColor grayColor];
        _addressLabe.font=[UIFont systemFontOfSize:13];
        _addressLabe.text=@"广东省深圳市南山区朗山路11号同方信息港A栋10楼";
        CGSize size = [self sizeWithString:_addressLabe.text font:_addressLabe.font];
        _addressLabe.frame =CGRectMake(60, 35, size.width-60, size.height);
        [self addSubview:_addressLabe];

    }
    return self;
    
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}


@end
