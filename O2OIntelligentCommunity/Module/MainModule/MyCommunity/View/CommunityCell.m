//
//  CommunityCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CommunityCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"
#import "NSString+wrapper.h"

@implementation CommunityCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat interval = 10;
        _cellImg = [[UIImageView alloc]initWithFrame:CGRectMake(interval, interval, self.frame.size.width - interval*2, self.frame.size.height - interval *3)];
        _cellImg.clipsToBounds = YES;
        _cellImg.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_cellImg];
        
        _deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBut.frame =CGRectMake(self.frame.size.width - 25, 0, 25, 25);
        _deleteBut.backgroundColor =[UIColor blackColor];
        [_deleteBut setTitle:@"*" forState:UIControlStateNormal];
        [_deleteBut.layer setMasksToBounds:YES];
        [_deleteBut.layer setCornerRadius:8];
        [_deleteBut setHidden:YES];
        [self.contentView addSubview:_deleteBut];
        
        _bangdingimg = [[UIImageView alloc]init];

        _bangdingimg.frame=CGRectMake(self.frame.size.width *24 /168-interval, -self.frame.size.width *26 /168+interval, self.frame.size.width, self.frame.size.height);
        _bangdingimg.hidden = YES;
        [self.contentView addSubview:_bangdingimg];
        
        _textLabe = [[UILabel alloc]initWithFrame:CGRectMake(0, _cellImg.frame.size.height + _cellImg.frame.origin.y,frame.size.width, 20)];
        _textLabe.textColor =[UIColor blackColor];
        _textLabe.textAlignment = NSTextAlignmentCenter;
        _textLabe.numberOfLines = 2;
        _textLabe.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textLabe];
        
        self.defaultXqImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height /4)];
        self.defaultXqImgV.image = [UIImage imageNamed:@"defaaultCommunity"];
        self.defaultXqImgV.hidden = YES;

        [self.contentView addSubview:self.defaultXqImgV];
    }
    return self;
}

-(void)reloadCellData:(BingingXQModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _textLabe.text = model.xqName;
    });
    
    if (![NSArray isArrEmptyOrNull:model.imgPath]) {
        if ([model.imgPath[0] isKindOfClass:[UIImage class]]) {
            _cellImg.image = model.imgPath[0];
        }
        else {
            [_cellImg setImageWithURL:[NSURL URLWithString:model.imgPath[0]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        }
    }
    else {
        _cellImg.image = [UIImage imageNamed:@"defaultImg"];
    }
    
    switch (model.isCheckPassType) {
        case XQRenZhengTypeSuccess: {
            dispatch_async(dispatch_get_main_queue(), ^{
                _bangdingimg.image=[UIImage imageNamed:@"bindingAlready"];
            });
            _bangdingimg.hidden=NO;
        }
            break;
        case XQRenZhengTypeWaitCheck: {
            dispatch_async(dispatch_get_main_queue(), ^{
                _bangdingimg.image=[UIImage imageNamed:@"bangdingimg"];
            });
            _bangdingimg.hidden=NO;
        }
            break;
        case XQRenZhengTypeFailCheck: {
            dispatch_async(dispatch_get_main_queue(), ^{
                _bangdingimg.image=[UIImage imageNamed:@"bindingFail"];
            });
            _bangdingimg.hidden=NO;
        }
            break;
        case XQRenZhengTypeNone: {
            _bangdingimg.hidden=YES;
        }
            break;
        default:
            _bangdingimg.hidden=YES;
            break;
    }
}

@end
