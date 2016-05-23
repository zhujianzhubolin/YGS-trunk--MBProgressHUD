 //
//  TopicDetailsCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TopicDetailsCell.h"
#import <UIImageView+AFNetworking.h>
#define kheadImageWidth 50
#define kViewSpace 10//间距

@implementation TopicDetailsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    
        _headImg = [[UIImageView alloc]init];
        [self addSubview:_headImg];
        
        _nameLabe =[[UILabel alloc]init];
        _nameLabe.font =[UIFont systemFontOfSize:15];
        [self addSubview:_nameLabe];
        
        
        _timeLabe = [[UILabel alloc]init];
        _timeLabe.textColor=[UIColor grayColor];
        _timeLabe.font=[UIFont systemFontOfSize:12];
        [self addSubview:_timeLabe];
        
        //话题内容
        
        
        _contentLabe = [[UILabel alloc]init];
        _contentLabe.font=[UIFont systemFontOfSize:14];
        _contentLabe.numberOfLines=0;
        [self addSubview:_contentLabe];
        
        _deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBut.frame=CGRectMake(IPHONE_WIDTH-60, 5, 40, 30);
        _deleteBut.titleLabel.font=[UIFont systemFontOfSize:14];
        [_deleteBut setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBut setTitleColor:[AppUtils colorWithHexString:@"25A9DE"] forState:UIControlStateNormal];
        [self addSubview:_deleteBut];
        
        
        _floorLabe = [[UILabel alloc]init];
        _floorLabe.textColor=[UIColor grayColor];
        [self addSubview:_floorLabe];

    }
    return self;
}



-(void)setCellData:(QueryCommentModel *)CommentM
{
    NSLog(@"photourl==%@",CommentM.photourl);
    CGFloat headimgX =10,headimgY =10;
    _headImg.frame=CGRectMake(headimgX, headimgY, 50, 50);
    _headImg.layer.masksToBounds=YES;
    _headImg.layer.cornerRadius=25;
    [_headImg setImageWithURL:[NSURL URLWithString:CommentM.photourl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    CGFloat nameLabX = CGRectGetMaxX(_headImg.frame)+10;
    CGRect  nameLabR = CGRectMake(nameLabX, headimgY, 200, 25);
    _nameLabe.text=CommentM.nickName;
    _nameLabe.frame=nameLabR;
    
    CGFloat timeLabX = CGRectGetMaxX(_headImg.frame)+10;
    CGFloat timeLabY = CGRectGetMaxY(_nameLabe.frame);
    CGRect  timeLabR = CGRectMake(timeLabX, timeLabY, 150, 25);
    _timeLabe.text=CommentM.createTimeStr;
    _timeLabe.frame=timeLabR;
    
   
    _contentLabe.text=CommentM.content;
    CGFloat contentWidth =IPHONE_WIDTH-(_headImg.frame.size.width+10*3);

     CGSize  contentSize = [_contentLabe.text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGRect  contentRect = CGRectMake(_timeLabe.frame.origin.x, CGRectGetMaxY(_timeLabe.frame), contentSize.width, contentSize.height);
    
    _contentLabe.frame=contentRect;
    //_contentLabe.backgroundColor=[UIColor redColor];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _contentLabe.frame = contentRect;
    });
    
    CGFloat cellHeight = CGRectGetMaxY(_contentLabe.frame)+10;

    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            cellHeight);
    
    UIImageView *lineImgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, IPHONE_WIDTH, 1)];
    lineImgV.backgroundColor =[AppUtils colorWithHexString:COLOR_MAIN];
    [self.contentView addSubview:lineImgV];

}



@end
