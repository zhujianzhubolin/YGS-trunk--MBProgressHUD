//
//  AroundMerchantsCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "LifeCircleStoresCell.h"
#import <UIImageView+AFNetworking.h>
#import "RatingBar.h"
#import "NSString+wrapper.h"
#import "ChangePostionButton.h"

@implementation LifeCircleStoresCell
{
    __weak IBOutlet UIImageView *shopImgV;
    __weak IBOutlet UILabel *shopNameL;
    __weak IBOutlet UILabel *shopTypeL;
    __weak IBOutlet RatingBar *ratingBar;
    __weak IBOutlet ChangePostionButton *distanceBtn;
    __weak IBOutlet UIButton *phoneBtn;
    LifeCircleE *currentE;
}
- (IBAction)phoneClick:(id)sender {
    if (self.circleType == LifeCircleTypeAround && ![NSString isEmptyOrNull:currentE.phone]) {
        [AppUtils callPhone:currentE.phone];
    }
}

- (void)reloadPublicServiceWithModel:(LifeCircleE *)circleE {
    currentE = circleE;
    
    [phoneBtn setImage:[UIImage imageNamed:@"mydianhua"] forState:UIControlStateNormal];
    phoneBtn.hidden = NO;
    [phoneBtn.superview bringSubviewToFront:phoneBtn];
    
    ratingBar.hidden = YES;
    [shopImgV setImageWithURL:[NSURL URLWithString:circleE.img] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    if ([NSString isEmptyOrNull:circleE.name]) {
        shopNameL.text = @"未知";
    }
    else {
        shopNameL.text = circleE.name;
    }
    
    if ([NSString isEmptyOrNull:circleE.storeAddress]) {
        shopTypeL.text = @"未知";
    }
    else {
        shopTypeL.text = circleE.storeAddress;
    }
    
    if ([NSString isEmptyOrNull:circleE.distance]) {
        [distanceBtn setTitle:@"0m" forState:UIControlStateNormal];
    }
    else if (circleE.distance.floatValue < 1000) {
        [distanceBtn setTitle:[NSString stringWithFormat:@"%@m",circleE.distance] forState:UIControlStateNormal];
    }
    else {
        [distanceBtn setTitle:[NSString stringWithFormat:@"%.1fkm",circleE.distance.floatValue /1000] forState:UIControlStateNormal];
    }
}

- (void)reloadAroundMerchangtsWithModel:(LifeCircleE *)circleE {
    [ratingBar setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    ratingBar.isIndicator = YES;
    
    [shopImgV setImageWithURL:[NSURL URLWithString:circleE.img] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    if ([NSString isEmptyOrNull:circleE.name]) {
        shopNameL.text = @"未知";
    }
    else {
        shopNameL.text = circleE.name;
    }
    shopTypeL.text=circleE.bizArea;
    //shopTypeL.text = [LocalUtils merchantsCategoryForCategoryID:circleE.optionCode.integerValue];
    
    if ([NSString isEmptyOrNull:circleE.distance]) {
        [distanceBtn setTitle:@"0m" forState:UIControlStateNormal];
    }
    else if (circleE.distance.floatValue < 1000) {
        [distanceBtn setTitle:[NSString stringWithFormat:@"%@m",circleE.distance] forState:UIControlStateNormal];
    }
    else {
        [distanceBtn setTitle:[NSString stringWithFormat:@"%.1fkm",circleE.distance.floatValue /1000] forState:UIControlStateNormal];
    }
    
    if (![NSString isEmptyOrNull:circleE.rzStatus] && [circleE.rzStatus isEqualToString:@"已认证"]) {
        [phoneBtn setImage:[UIImage imageNamed:@"yirenzhenglog"] forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            phoneBtn.hidden = NO;
        });
        
        ratingBar.hidden = NO;
        if (circleE.score.floatValue == 0) {
            ratingBar.hidden = YES;
        }
        else {
            [ratingBar displayRating:circleE.score.floatValue];
        }
    }
    else {
        phoneBtn.hidden = YES;
        ratingBar.hidden = YES;
    }
}

- (void)awakeFromNib {
    [distanceBtn setInternalPositionType:ButtonInternalLabelPositionRight spacing:5];
    shopImgV.contentMode = UIViewContentModeScaleAspectFill;
    shopImgV.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
