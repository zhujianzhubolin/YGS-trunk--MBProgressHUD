//
//  NoticeDHeaderView.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NoticeDHeaderV.h"
#import "NSString+wrapper.h"
#import "NSArray+wrapper.h"
#import <UIImageView+AFNetworking.h>

@implementation NoticeDHeaderV
{
    __weak IBOutlet UILabel *noticeTitleL;
    __weak IBOutlet UILabel *dateL;
    __weak IBOutlet UILabel *detailL;
    __weak IBOutlet UILabel *commentNumL;
    __weak IBOutlet UIView *buttomV;
    __weak IBOutlet UIImageView *noticeImgV;
}

- (void)awakeFromNib {
    noticeImgV.clipsToBounds = YES;
    noticeImgV.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)reloadHeaderVDataWithModel:(NoticeEntity *)noticeE {
    noticeTitleL.text = noticeE.noticeTitle;
    
    if (![NSString isEmptyOrNull:noticeE.createTimeStr]) {
        dateL.text = noticeE.createTimeStr;
    }
    else {
        dateL.text = nil;
    }
    
    if (![NSArray isArrEmptyOrNull:noticeE.imgPath]) {
        [noticeImgV setImageWithURL:[NSURL URLWithString:noticeE.imgPath[0]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
    }
    else {
        noticeImgV.image = [UIImage imageNamed:@"defaultImg_w"];
    }
    
    detailL.text = noticeE.noticeContent;
    
    CGSize contentSize = [AppUtils sizeWithString:noticeE.noticeContent font:detailL.font size:CGSizeMake(IPHONE_WIDTH - 16, MAXFLOAT)];
    CGFloat interval = 10;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect detailRect = detailL.frame;
        detailRect.size.height = contentSize.height + interval;
        detailL.frame = detailRect;
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect buttomVRect = buttomV.frame;
        buttomVRect.origin.y = detailL.frame.origin.y + contentSize.height + interval;
        buttomV.frame = buttomVRect;
    });
    
    self.contentHeight = detailL.frame.origin.y + contentSize.height + interval + buttomV.frame.size.height;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect selfRect = self.frame;
        selfRect.size.height = self.contentHeight;
        self.frame = selfRect;
    });
}

- (void)refreshCommentNum:(NSUInteger)commentNum {
    commentNumL.text = [NSString stringWithFormat:@"评论(%lu)",commentNum];
}

- (IBAction)commentClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(commentClickNextVC)]) {
        [_delegate commentClickNextVC];
    }
}

@end
