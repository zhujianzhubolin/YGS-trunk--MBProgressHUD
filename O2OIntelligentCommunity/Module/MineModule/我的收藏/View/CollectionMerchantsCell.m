//
//  CollectionMerchantsCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CollectionMerchantsCell.h"
#import <UIImageView+AFNetworking.h>
#import "RatingBar.h"

@implementation CollectionMerchantsCell
{
    UIImageView *logoimage;
    UILabel     *nameLabe;
    UILabel     *numberLabe;
    UILabel     *addressLabe;
    RatingBar *rating;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat interval = 10;
        CGFloat ratingHeight = 16;
        logoimage = [[UIImageView alloc]initWithFrame:CGRectMake(interval, interval, 70, 70)];
//        logoimage.image =[UIImage imageNamed:@"goodHead.png"];
//        logoimage.contentMode = UIViewContentModeCenter;
//        logoimage.clipsToBounds = YES;

        [self addSubview:logoimage];
        
        nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoimage.frame)+interval, logoimage.frame.origin.y, IPHONE_WIDTH-CGRectGetMaxX(logoimage.frame)-interval*2, (70-ratingHeight)/2)];
        nameLabe.text = @"正章干洗";
        nameLabe.font = [UIFont systemFontOfSize:16];
        [self addSubview:nameLabe];
        
        rating =[[RatingBar alloc]init];
        rating.frame =CGRectMake(nameLabe.frame.origin.x, CGRectGetMaxY(nameLabe.frame), ratingHeight * 5, ratingHeight);
        [self addSubview:rating];
        [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
        rating.isIndicator = YES;
        
        addressLabe =[[UILabel alloc]initWithFrame:CGRectMake(rating.frame.origin.x, CGRectGetMaxY(rating.frame), IPHONE_WIDTH-CGRectGetMaxX(logoimage.frame)-interval*2, (70-ratingHeight)/2)];
        addressLabe.text=@"23";
        addressLabe.textColor=[UIColor lightGrayColor];
        addressLabe.font=[UIFont systemFontOfSize:12];
        [self addSubview:addressLabe];
  
    }
    
    return self;
}

-(void)setdata:(ShangjiaModel *)dicM {
    [logoimage setImageWithURL:[NSURL URLWithString:dicM.img] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    nameLabe.text=dicM.name;
    addressLabe.text=dicM.storeAddress;
    if ([dicM.score intValue] ==0 || dicM.score.length==0)
    {
        rating.hidden=YES;
    }
    else{
        rating.hidden=NO;
        [rating displayRating:[dicM.score floatValue]];
    }
    //numberLabe.text=[NSString stringWithFormat:@"%@人评价",@"10"];
    
}

@end
