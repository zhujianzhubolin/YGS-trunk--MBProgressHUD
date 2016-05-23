//
//  NoticeCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NoticeCell.h"
#import "NSString+wrapper.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"

@implementation NoticeCell
{
    __weak IBOutlet UIImageView *noticeImgV;
    __weak IBOutlet UILabel *titleL;
    __weak IBOutlet UILabel *noticeDate;
    __weak IBOutlet UIImageView *noticeNatureImgV;
}

- (void)awakeFromNib {
//    noticeImgV.layer.cornerRadius = 5;
    noticeImgV.clipsToBounds = YES;
    noticeImgV.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadDataWithModel:(NoticeEntity *)entity {
    titleL.text = [NSString stringWithFormat:@"【%@】%@",entity.noticeType,entity.noticeTitle];

    if ([NSString isEmptyOrNull:entity.type]) {
        noticeNatureImgV.hidden = YES;
    }
    else if ([entity.type isEqualToString:@"1"]) { //重要且紧急
        noticeNatureImgV.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            noticeNatureImgV.image = [UIImage imageNamed:@"emergencyImportantNotice"];
        });
    }
    else if ([entity.type isEqualToString:@"2"]) { //紧急
        noticeNatureImgV.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            noticeNatureImgV.image = [UIImage imageNamed:@"emergencyNotice"];
        });
    }
    else if ([entity.type isEqualToString:@"3"]) { //重要
        noticeNatureImgV.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            noticeNatureImgV.image = [UIImage imageNamed:@"importantNotice"];
        });
    }
    else {
        noticeNatureImgV.hidden = YES;
    }
    
    if (![NSString isEmptyOrNull:entity.createTimeStr]) {
        noticeDate.text = [entity.createTimeStr substringWithRange:NSMakeRange(5, entity.createTimeStr.length - 8)] ;
    }
    else {
        noticeDate.text = nil;
    }
    
    if (![NSArray isArrEmptyOrNull:entity.imgPath]) {
        [noticeImgV setImageWithURL:[NSURL URLWithString:entity.imgPath[0]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
    }
    else {
        noticeImgV.image = [UIImage imageNamed:@"defaultImg_w"];
    }
}

@end
