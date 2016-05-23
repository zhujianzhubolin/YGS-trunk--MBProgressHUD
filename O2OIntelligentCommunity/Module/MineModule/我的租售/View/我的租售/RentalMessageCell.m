//
//  RentalMessageCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/12.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentalMessageCell.h"
#import <UIImageView+AFNetworking.h>


@implementation RentalMessageCell
{
    UIImageView *headImgV;
    UILabel     *nameLab;
    UILabel     *timeLab;
    UILabel     *contentLab;
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat imgWidth = 60;
        CGFloat interval = 10;
        headImgV =[[UIImageView alloc]init];
        headImgV.frame=CGRectMake(interval,
                                  interval,
                                  imgWidth,
                                  imgWidth);
        headImgV.layer.masksToBounds=YES;
        headImgV.contentMode = UIViewContentModeScaleAspectFill;
        headImgV.layer.cornerRadius = headImgV.frame.size.width / 2;
        [self.contentView addSubview:headImgV];
        
        CGFloat timeWidth = 140;
        CGFloat timeHeight = 30;
        timeLab =[[UILabel alloc]init];
        timeLab.frame=CGRectMake(IPHONE_WIDTH - timeWidth - interval,
                                 interval,
                                 timeWidth,
                                 timeHeight);
        timeLab.text=@"00:00:00";
        timeLab.textAlignment=NSTextAlignmentRight;
        timeLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeLab];
        
        nameLab =[[UILabel alloc]init];
        nameLab.frame=CGRectMake(CGRectGetMaxX(headImgV.frame) + interval,
                                 timeLab.frame.origin.y,
                                 IPHONE_WIDTH - (CGRectGetMaxX(headImgV.frame) + interval) - (timeLab.frame.size.width + interval),
                                 timeLab.frame.size.height);
        nameLab.text=@"姓名";
        [self.contentView addSubview:nameLab];
        
        contentLab  =[[UILabel alloc]init];
        contentLab.frame=CGRectMake(nameLab.frame.origin.x, CGRectGetMaxY(nameLab.frame) + interval / 2, IPHONE_WIDTH - nameLab.frame.origin.x - interval, timeHeight);
        contentLab.textColor=[UIColor grayColor];
        contentLab.text=@"一句话就可以去，真的这么容易吗，还不如去上刀山，让我门一起跳舞那";
        contentLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:contentLab];
    }
    return self;
}

-(void)setcellData:(QueryCommentModel *)queryM
{
    NSLog(@"photourl==%@",queryM.nickName);
    
    [headImgV setImageWithURL:[NSURL URLWithString:queryM.photourl] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    nameLab.text=queryM.nickName;
    timeLab.text=queryM.createTimeStr;
    contentLab.text=queryM.content;
}

@end
