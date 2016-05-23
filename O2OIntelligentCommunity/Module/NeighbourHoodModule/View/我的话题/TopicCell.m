//
//  TopicCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TopicCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"
#import "NSString+wrapper.h"

#define headImageWidth 60//头像宽


@implementation TopicCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headimg = [[UIImageView alloc]init];
        [self addSubview:_headimg];
        
        _contentLabe = [[UILabel alloc]init];
        _contentLabe.numberOfLines = 5;
        _contentLabe.font=[UIFont systemFontOfSize:14];
        [self addSubview:_contentLabe];
        
        _timeLabe = [[UILabel alloc]init];
        [self addSubview:_timeLabe];
        
        _songhuaBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_songhuaBut];
        
        _pinglunBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_pinglunBut];
    }
    return self;
}


-(void)setCellData:(HuaTiListModel *)huatiM
{
    CGFloat headImgX =15,headImgY=10;
    CGRect headImgRect =CGRectMake(headImgX, headImgY, headImageWidth, headImageWidth);
    if([NSArray isArrEmptyOrNull:huatiM.imgPath]){
        _headimg.image =[UIImage imageNamed:@"defaultImg.png"];
    }else{
        [_headimg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[huatiM.imgPath objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    }
    _headimg.frame=headImgRect;
    
    CGFloat contentX =CGRectGetMaxX(_headimg.frame)+10;
    CGFloat contentWidth =IPHONE_WIDTH - headImageWidth-30;
    CGSize contentSize =[huatiM.activityContent boundingRectWithSize:CGSizeMake(contentWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGRect contentRect=CGRectMake(contentX, 10, contentSize.width, contentSize.height);
    
    if ([NSString isEmptyOrNull:huatiM.activityContent]) {
        _contentLabe.text=@"未知";
    }else {
        _contentLabe.text=huatiM.activityContent;
    }
    
    _contentLabe.frame=contentRect;

    CGFloat timeLabX =CGRectGetMaxX(_headimg.frame)+10;
    CGFloat timeLabY =CGRectGetMaxY(_contentLabe.frame)+5;
    CGRect  timeRect;
    NSLog(@"timeLabY=%f",timeLabY);
    CGFloat timeHeight = 15;
    if (timeLabY <50){
         timeRect =CGRectMake(timeLabX, CGRectGetMaxY(_headimg.frame) - timeHeight, 120, timeHeight);
    }else{
        timeRect =CGRectMake(timeLabX, timeLabY, 120, timeHeight);
    }
    _timeLabe.text=huatiM.createTimeStr;
    //_timeLabe.backgroundColor = [UIColor blueColor];
    _timeLabe.textColor =[UIColor grayColor];
    _timeLabe.font = [UIFont systemFontOfSize:11];
    _timeLabe.frame=timeRect;
    
    
    
    
    if ([huatiM.commentNumber intValue] >100){
        [_pinglunBut setTitle:[NSString stringWithFormat:@" %@",@"99+"] forState:UIControlStateNormal];
    }else{
        [_pinglunBut setTitle:[NSString stringWithFormat:@" %@",huatiM.commentNumber] forState:UIControlStateNormal];
    }
    [_pinglunBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_pinglunBut setImage:[UIImage imageNamed:@"Pinglunnuber.png"] forState:UIControlStateNormal];
    //_pinglunBut.backgroundColor=[UIColor redColor];
    UIFont *pinglunHuaFont = [UIFont systemFontOfSize:13];
    _pinglunBut.titleLabel.font =pinglunHuaFont;
    
    CGSize pinglunButTypeSize =[AppUtils sizeWithString:_pinglunBut.titleLabel.text font:pinglunHuaFont size:CGSizeMake(200, _timeLabe.frame.size.height)];
    _pinglunBut.frame=CGRectMake(IPHONE_WIDTH-10*2-pinglunButTypeSize.width - _timeLabe.frame.size.height,
                                 _timeLabe.frame.origin.y,
                                 pinglunButTypeSize.width +10+ _timeLabe.frame.size.height,
                                 _timeLabe.frame.size.height);
    
    if ([huatiM.flowerCount intValue] >100){
        [_songhuaBut setTitle:[NSString stringWithFormat:@" %@",@"99+"] forState:UIControlStateNormal];
    }else{
        [_songhuaBut setTitle:[NSString stringWithFormat:@" %@",huatiM.flowerCount] forState:UIControlStateNormal];
    }
    [_songhuaBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_songhuaBut setImage:[UIImage imageNamed:@"hua.png"] forState:UIControlStateNormal];
   // _songhuaBut.backgroundColor=[UIColor redColor];
    UIFont *songHuaFont = [UIFont systemFontOfSize:13];
    _songhuaBut.titleLabel.font =songHuaFont;
    
    CGSize songhuaTypeSize =[AppUtils sizeWithString:_songhuaBut.titleLabel.text font:songHuaFont size:CGSizeMake(200, _timeLabe.frame.size.height)];
    _songhuaBut.frame=CGRectMake(IPHONE_WIDTH-10*3- pinglunButTypeSize.width - _timeLabe.frame.size.height * 2 - songhuaTypeSize.width,
                                 _timeLabe.frame.origin.y,
                                 songhuaTypeSize.width +10+ _timeLabe.frame.size.height,
                                 _timeLabe.frame.size.height);
    
    
    _height =CGRectGetMaxY(_songhuaBut.frame) + 10;
    
}
@end
