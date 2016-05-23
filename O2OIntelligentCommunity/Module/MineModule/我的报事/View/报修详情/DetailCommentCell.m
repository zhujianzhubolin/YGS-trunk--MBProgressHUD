//
//  DetailCommentCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "DetailCommentCell.h"

@implementation DetailCommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.TextLab = [[UILabel alloc]init];
        self.TextLab.text=@"已经提交报修好几天了，怎么还没处理呢?";
        self.TextLab.numberOfLines=0;
        self.TextLab.font =[UIFont systemFontOfSize:14];
        [self addSubview:self.TextLab];
        
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-150, 35, 140, 25)];
        //self.timeLab.backgroundColor=[UIColor redColor];
        self.timeLab.text=@"04-23 12:14";
        self.timeLab.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.timeLab];
    }
    return self;
}

-(void)setcommentDic:(BXTSCommentsModel *)dicM
{
    _TextLab.text=dicM.content;
    CGSize commentSize =[AppUtils sizeWithString:_TextLab.text font:_TextLab.font size:CGSizeMake(IPHONE_WIDTH - 10 *2, MAXFLOAT)];
    CGFloat interval=10;
    _TextLab.frame = CGRectMake(interval, interval, IPHONE_WIDTH - interval*2, commentSize.height);
    
    _timeLab.text=dicM.createTimeStr;
    _timeLab.frame=CGRectMake(IPHONE_WIDTH-150, CGRectGetMaxY(_TextLab.frame), 140, 25);
     self.frame =CGRectMake(10, 10, IPHONE_WIDTH-10*2, commentSize.height + _timeLab.frame.size.height+interval*2);
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, commentSize.height + _timeLab.frame.size.height+interval*2, IPHONE_WIDTH, 1)];
    img.backgroundColor =[AppUtils colorWithHexString:@"EDEFEB"];
    [self addSubview:img];
}

@end
