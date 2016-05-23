//
//  StayPaymentAddressCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "StayPaymentAddressCell.h"
#import <UIImageView+AFNetworking.h>
#import "UserManager.h"

@implementation StayPaymentAddressCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat intervalWidth = 10;
        CGFloat intervalHeight = 5;
        CGFloat configuFont = 14;
        
        _phoneLabe = [[UILabel alloc]init];
        _phoneLabe.frame = CGRectMake(IPHONE_WIDTH-100, intervalHeight, 100, 20);
        _phoneLabe.textColor =[UIColor grayColor];
        _phoneLabe.text=@"13800138000";
        _phoneLabe.font =[UIFont systemFontOfSize:configuFont];
        [self addSubview:_phoneLabe];
        
        _nameLabe =[[UILabel alloc]initWithFrame:CGRectMake(intervalWidth, _phoneLabe.frame.origin.y, IPHONE_WIDTH - intervalWidth * 3 - _phoneLabe.frame.size.width, _phoneLabe.frame.size.height)];
        _nameLabe.text=@"收货人:";
        _nameLabe.textColor =[UIColor grayColor];
        _nameLabe.font=[UIFont systemFontOfSize:configuFont];
        [self addSubview:_nameLabe];
        
        _addressLabe = [[UILabel alloc]initWithFrame:CGRectMake(intervalWidth, CGRectGetMaxY(_nameLabe.frame), IPHONE_WIDTH - intervalWidth * 2, 45)];
        _addressLabe.numberOfLines = 3;
        _addressLabe.textColor =[UIColor grayColor];
        _addressLabe.font=[UIFont systemFontOfSize:12];
        _addressLabe.text=@"收货地址:";
        
        [self addSubview:_addressLabe];
    }
    return self;
}

-(void)setuserinfo:(MineBuyorderM *)orderM
{
//    [_headimg setImageWithURL:[NSURL URLWithString:[UserManager shareManager].userModel.photoUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    _nameLabe.text=[NSString stringWithFormat:@"收货人：%@",orderM.userName];
    _phoneLabe.text=[NSString stringWithFormat:@"%@",orderM.mobPhoneNum];
    _addressLabe.text=[NSString stringWithFormat:@"收货地址：%@",orderM.addressDetail];
    
}

@end
