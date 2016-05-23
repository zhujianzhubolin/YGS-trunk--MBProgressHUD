//
//  LegalDetailHeaderV.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "LegalDetailHeaderV.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"

@implementation LegalDetailHeaderV
{
    __weak IBOutlet UIImageView *userImgV;
    __weak IBOutlet UILabel *userNameL;
    __weak IBOutlet UILabel *specialityL;
}

- (CGFloat)reloadDataWithModel:(ShengSJDataE *)detailE {
    if (![NSArray isArrEmptyOrNull:detailE.imgPath]) {
        [userImgV setImageWithURL:[NSURL URLWithString:detailE.imgPath[0]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }
    else {
        userImgV.image = [UIImage imageNamed:@"touxiang"];
    }
    
    userNameL.text = detailE.title;
    NSString *specialityStr = [NSString stringWithFormat:@"擅长领域:%@",detailE.specialty];
    specialityL.text = specialityStr;
    specialityL.textAlignment = NSTextAlignmentLeft;
    CGSize specialitySize = [AppUtils sizeWithString:specialityStr
                                                font:specialityL.font
                                                size:CGSizeMake(IPHONE_WIDTH - 16, MAXFLOAT)];
    dispatch_async(dispatch_get_main_queue(), ^{
        specialityL.frame = CGRectMake(specialityL.frame.origin.x, specialityL.frame.origin.y, specialityL.frame.size.width, specialitySize.height +10);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, specialityL.frame.origin.y + specialitySize.height + 10);
    });
    
    return specialityL.frame.origin.y + specialitySize.height + 10;
}

@end
