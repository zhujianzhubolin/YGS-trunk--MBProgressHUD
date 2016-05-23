//
//  RepairsCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RepairsCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"

@implementation RepairsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 80, 80)];
        self.img.image=[UIImage imageNamed:@"defaultImg"];
        _img.clipsToBounds=YES;
        _img.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:self.img];
        
        _statusLabe =[[UILabel alloc]init];
        _statusLabe.frame=CGRectMake(0, 55, 80, 25);
        _statusLabe.textColor=[UIColor whiteColor];
        _statusLabe.font=[UIFont systemFontOfSize:14];
        _statusLabe.textAlignment=NSTextAlignmentCenter;
        _statusLabe.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.img addSubview:_statusLabe];
        
        
        
        _textLabe = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, IPHONE_WIDTH - 110, 30)];
        [self addSubview:_textLabe];
        
        
        
        self.timeLabe = [[UILabel alloc]initWithFrame:CGRectMake(100, 55, IPHONE_WIDTH - CGRectGetMaxX(_img.frame) - 80, 25)];
        self.timeLabe.textColor=[UIColor blackColor];
        self.timeLabe.font=[UIFont systemFontOfSize:14];
        self.timeLabe.text=@"00-00-00 00:00:00";
        [self addSubview:self.timeLabe];
        
        self.evaluateBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.evaluateBut.frame = CGRectMake(IPHONE_WIDTH - 50 - 10, self.timeLabe.frame.origin.y, 50, 30);
        //self.evaluateBut.backgroundColor=[UIColor redColor];
        [self.evaluateBut setTitle:@"评论" forState:UIControlStateNormal];
        self.evaluateBut.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.evaluateBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:self.evaluateBut];
        self.evaluateBut.hidden=YES;
    }
    return self;
}

-(void)getDataByDictionary:(BaoXiuTouSuModel *)dicM
{
    NSArray *array  =[dicM.imgPath copy];
    [_img setImageWithURL:[NSURL URLWithString:[array objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    _textLabe.text=dicM.complaintContent;
//    NSString *str1;
//    NSString *str2;
//    if ([dicM.type isEqualToString:@"1"])
//    {
//        str1=@"[投诉]";
//    }
//    else if ([dicM.type isEqualToString:@"2"])
//    {
//        str1=@"[报修]";
//    }
//    str2=dicM.complaintContent;
//    
//    NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
//    [str addAttribute:NSForegroundColorAttributeName value:[AppUtils colorWithHexString:@"fa6900"] range:NSMakeRange(0, str1.length)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(str1.length, str2.length)];
//    _textLabe.attributedText=str;
    

//    _textLabe.attributedText=str;
//    _textLabe.numberOfLines = 0;
//    _textLabe.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize size = [_textLabe sizeThatFits:CGSizeMake(_textLabe.frame.size.width, MAXFLOAT)];
//    _textLabe.frame =CGRectMake(100, 5, self.frame.size.width-110, size.height);
//    _textLabe.font = [UIFont systemFontOfSize:14];
    _timeLabe.text=dicM.createTimeStr;
    
    
    
    NSString *statusStr = dicM.complaintStatus;
    NSLog(@"statusStr==%@",statusStr);
    if ([statusStr isEqualToString:@"0"])
    {
        _statusLabe.text=@"等待处理";
    }
    else if ([statusStr isEqualToString:@"1"])
    {
        _statusLabe.text=@"处理中";
    }
    else if ([statusStr isEqualToString:@"2"])
    {
        _statusLabe.text=@"处理完毕";
        self.evaluateBut.hidden=NO;
        
    }
    
}


-(void)getDataByDictionaryJianYi:(ShengSJDataE *)dicM
{
    NSString *statusStr = dicM.opinionStatus;
    NSLog(@"statusStr==%@",statusStr);
    if ([statusStr isEqualToString:@"1"])
    {
        _statusLabe.text=@"已回复";
    }
    else
    {
        _statusLabe.text=@"已查看";
    }
    if ([NSArray isArrEmptyOrNull:dicM.imgPath])
    {
        _img.image =[UIImage imageNamed:@"defaultImg"];
    }
    else
    {
        [_img setImageWithURL:[NSURL URLWithString:[dicM.imgPath objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }

    _textLabe.text=dicM.activityContent;
    _timeLabe.text=dicM.createTimeStr;
}
@end
