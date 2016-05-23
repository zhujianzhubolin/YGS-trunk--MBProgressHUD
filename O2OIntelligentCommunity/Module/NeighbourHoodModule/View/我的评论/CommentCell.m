//
//  CommentCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CommentCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"

@implementation CommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headImg = [[UIImageView alloc]init];
        _headImg.clipsToBounds = YES;
        _headImg.layer.masksToBounds=YES;
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_headImg];
        
        _contentLabe = [[UILabel alloc]init];
        _contentLabe.numberOfLines=0;
        _contentLabe.font=[UIFont systemFontOfSize:14];
         [self addSubview:_contentLabe];

        _numberLabe = [[UILabel alloc]init];
        _numberLabe.font = [UIFont systemFontOfSize:14];
        _numberLabe.textColor=[UIColor grayColor];
        [self.contentView addSubview:_numberLabe];
        
        _timeLabe = [[UILabel alloc]init];
        _timeLabe.textColor =[UIColor grayColor];
        _timeLabe.textAlignment=NSTextAlignmentRight;
        _timeLabe.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabe];

    }
    return self;
    
}



-(void)setCellData:(QueryCommentModel *)queryM
{
    
    CGFloat headimgX =10,headimgY =10;
    CGFloat headimgWidth = 60;
    CGFloat interval =10;
    CGFloat labeHigth = 25,labeWidth = 140;
    CGFloat numberlabHigth = 25,numberlabWidth =100;
    CGRect  headimgR =CGRectMake(headimgX, headimgY, headimgWidth, headimgWidth);
    
    NSString *createTimeStr=queryM.dateCreateStr;
    
    
    
    if ([NSArray isArrEmptyOrNull:queryM.imgPath])
    {
        _headImg.image =[UIImage imageNamed:@"defaultImg"];

    }
    else
    {
        [_headImg setImageWithURL:[NSURL URLWithString:[queryM.imgPath objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }
    _headImg.frame=headimgR;
    
    
    _contentLabe.text=queryM.content;
    CGFloat contentlabeX =CGRectGetMaxX(_headImg.frame)+interval;
    CGSize  contentSize =[self sizeWithString:_contentLabe.text font:_contentLabe.font];
    _contentLabe.frame=CGRectMake(contentlabeX, headimgY, contentSize.width, contentSize.height);
    
    if (contentSize.height <33)
    {
        _numberLabe.text=[NSString stringWithFormat:@"共%d张",[queryM.imgPath count]];
        _numberLabe.frame=CGRectMake(CGRectGetMaxX(_headImg.frame)+interval, 50, numberlabWidth, labeHigth);
        
        _timeLabe.text=queryM.dateCreateStr;
        _timeLabe.frame =CGRectMake(IPHONE_WIDTH-labeWidth-interval, 50, labeWidth, labeHigth);
        
        _height=CGRectGetMaxY(_timeLabe.frame)+interval;
    }
    else
    {
        CGFloat numberlabX =CGRectGetMaxX(_headImg.frame)+interval;
        CGFloat numberlabY =CGRectGetMaxY(_contentLabe.frame);
        CGRect  numberR =CGRectMake(numberlabX, numberlabY, numberlabWidth, labeHigth);
        _numberLabe.text=[NSString stringWithFormat:@"共%d张",[queryM.imgPath count]];
        _numberLabe.frame=numberR;
        
        
        CGFloat timelabX =IPHONE_WIDTH-labeWidth-interval;
        CGRect  timelabR =CGRectMake(timelabX, numberlabY, labeWidth, labeHigth);
        _timeLabe.text=queryM.dateCreateStr;
        _timeLabe.frame =timelabR;
        
        _height=CGRectGetMaxY(_timeLabe.frame)+interval;

    }
    
   
   
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-90, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

@end
