//
//  ConsultationServiceCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ConsultationServiceCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"

@implementation ConsultationServiceCell
{
    __weak IBOutlet UIImageView *userImgV;
    __weak IBOutlet UILabel *nameL;
    __weak IBOutlet UILabel *expertiseL;
    __weak IBOutlet UIView *buttomV;
}

- (void)awakeFromNib {
    buttomV.layer.borderWidth = 1;
    buttomV.layer.cornerRadius = 5;
    buttomV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userImgV.layer.cornerRadius = userImgV.frame.size.width / 2;
    userImgV.layer.masksToBounds = YES;
    // Initialization code
}

- (void)reloadDataWithModel:(ShengSJDataE *)dataE {
    if (![NSArray isArrEmptyOrNull:dataE.imgPath]) {
        [userImgV setImageWithURL:[NSURL URLWithString:dataE.imgPath[0]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }
    else {
        userImgV.image = [UIImage imageNamed:@"touxiang"];
    }
    nameL.text = dataE.title;
    expertiseL.text = dataE.specialty;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
