//
//  CollectionShangpinCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CollectionShangpinCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSString+wrapper.h"

@implementation CollectionShangpinCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat interval = 10;
        CGFloat descHeight = 18;
        CGFloat imgWidth = 70;
        CGFloat priceWidth = (IPHONE_WIDTH - imgWidth *2 - interval *3) /2;
        _goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(interval, interval, 70, 70)];
        _goodsImg.image = [UIImage imageNamed:@"goodHead.png"];
//        _goodsImg.contentMode = UIViewContentModeCenter;
//        _goodsImg.clipsToBounds = YES;
       
        [self addSubview:_goodsImg];
        
        _nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImg.frame) + interval, _goodsImg.frame.origin.y, IPHONE_WIDTH-CGRectGetMaxX(_goodsImg.frame)-(interval*2), (_goodsImg.frame.size.height-descHeight) / 2)];
        _nameLabe.font=[UIFont systemFontOfSize:16];
        _nameLabe.text = @"韩熙真气垫BB霜";
        [self addSubview:_nameLabe];
        
        _miaosuLabe  = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabe.frame.origin.x, CGRectGetMaxY(_nameLabe.frame),_nameLabe.frame.size.width , descHeight)];
        _miaosuLabe.text = @"无暇矿物质气垫BB霜，买一送一";
        _miaosuLabe.textColor=[UIColor grayColor];
        _miaosuLabe.font=[UIFont systemFontOfSize:13];
        [self addSubview:_miaosuLabe];
        
        _spTypeLabe  = [[UILabel alloc]initWithFrame:CGRectMake(_miaosuLabe.frame.origin.x, CGRectGetMaxY(_miaosuLabe.frame), 100, _nameLabe.frame.size.height)];
        _spTypeLabe.text = @"类型";
        _spTypeLabe.adjustsFontSizeToFitWidth=YES;
        _spTypeLabe.font = [UIFont systemFontOfSize:14];
        _spTypeLabe.textColor = [UIColor redColor];
        [self addSubview:_spTypeLabe];
        
        //        _spPriceLale  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_spTypeLabe.frame), _spTypeLabe.frame.origin.y, _spTypeLabe.frame.size.width, _spTypeLabe.frame.size.height)];
        //        _spPriceLale.text = @"0元";
        //        _spPriceLale.textAlignment=NSTextAlignmentLeft;
        //        _spPriceLale.textColor =[UIColor grayColor];
        //        _spPriceLale.font = _spTypeLabe.font;
        //        [self addSubview:_spPriceLale];
        
        //        _xianimg = [[UIImageView alloc]initWithFrame:CGRectMake(_spPriceLale.frame.origin.x, _spPriceLale.center.y, _spPriceLale.frame.size.width, 1)];
        //        _xianimg.backgroundColor = [UIColor grayColor];
        //        [self addSubview:_xianimg];
        
        _immediatelyBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatelyBut.frame = CGRectMake(IPHONE_WIDTH - interval-imgWidth, _spPriceLale.frame.origin.y, imgWidth, _spPriceLale.frame.size.height);
        [_immediatelyBut setTitle:@"立即购买" forState:UIControlStateNormal];
        [_immediatelyBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _immediatelyBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_immediatelyBut.layer setMasksToBounds:YES];
        [_immediatelyBut.layer setCornerRadius:5];
        [self addSubview:_immediatelyBut];
    }
    return self;
}

-(void)setcellDic:(CollectionModel *)dicM
{
    [_goodsImg setImageWithURL:[NSURL URLWithString:dicM.img] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    if([NSString isEmptyOrNull:dicM.name])
    {
        _nameLabe.text=@"未知";
    }
    else
    {
        _nameLabe.text=[NSString stringWithFormat:@"%@",dicM.name];
    }
    
    if(![dicM.isMarket isEqualToString:@"ON_MARKET"])
    {
        _immediatelyBut.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        _immediatelyBut.enabled = NO;
    }
    else
    {
        _immediatelyBut.backgroundColor = [AppUtils colorWithHexString:@"fa6900"];
        _immediatelyBut.enabled = YES;
        
    }
    
    if ([dicM.stock intValue]==0)
    {
        _immediatelyBut.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _immediatelyBut.enabled = NO;
        
    }
    else
    {
        _immediatelyBut.backgroundColor = [AppUtils colorWithHexString:@"fa6900"];
        _immediatelyBut.enabled = YES;
    }
    
    
    if ([NSString isEmptyOrNull:dicM.desc])
    {
        _miaosuLabe.text=@"";
    }
    else
    {
        _miaosuLabe.text=[NSString stringWithFormat:@"%@",dicM.desc];
    }
    
    
    if ([dicM.productType isEqualToString:@"Quickly"])
    {
        _spTypeLabe.text=[NSString stringWithFormat:@"[快送] %@元",dicM.price];
    }
    else if ([dicM.productType isEqualToString:@"Group"])
    {
        _spTypeLabe.text=[NSString stringWithFormat:@"[团购] %@元",dicM.price];
    }
    else{
        
        _spTypeLabe.text=[NSString stringWithFormat:@"[商城] %@元",dicM.price];
    }
    //   _spPriceLale.text=[NSString stringWithFormat:@"%@元",dicM.price];
    //    CGSize lineSize = [AppUtils sizeWithString:_originalpriceLale.text font:_originalpriceLale.font size:_originalpriceLale.frame.size];
    //    _xianimg.frame = CGRectMake(_xianimg.frame.origin.x, _xianimg.frame.origin.y, lineSize.width, _xianimg.frame.size.height);
}


@end
