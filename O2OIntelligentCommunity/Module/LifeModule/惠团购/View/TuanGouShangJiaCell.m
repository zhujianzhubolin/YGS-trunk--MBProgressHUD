//
//  TuanGouShangJiaCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/15.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TuanGouShangJiaCell.h"
#import "RatingBar.h"
#import <UIImageView+AFNetworking.h>

@implementation TuanGouShangJiaCell

{
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UIImageView *rzState;
    __weak IBOutlet UILabel *adress;
    __weak IBOutlet UILabel *serverTime;
    __weak IBOutlet UILabel *shopName;
    __weak IBOutlet RatingBar *Score;
}

- (void)awakeFromNib {
    [Score setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    Score.isIndicator = YES;
    
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
}

- (void)setShopInfor:(NSDictionary *)dict{
    
    NSLog(@"商家详情>>>>%@",dict);
    
    if ([dict[@"code"] isEqualToString:@"success"] && ![dict[@"entity"] isEqual:[NSNull null]]) {
        
        [headImage setImageWithURL:[NSURL URLWithString:dict[@"entity"][@"img"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        
        shopName.text = dict[@"entity"][@"name"];
        
        
        
        NSString * serverStart = nil;
        
        NSString * serverEnd = nil;
        
        if ([dict[@"entity"][@"storeStartDate"] isEqual:[NSNull null]]) {
            serverStart = @"00:00";
        }else{
            serverStart = dict[@"entity"][@"storeStartDate"];
        }
        
        
        if ([dict[@"entity"][@"storeEndDate"] isEqual:[NSNull null]]) {
            serverEnd = @"24:00";
        }else{
            serverEnd = dict[@"entity"][@"storeEndDate"];
        }
        
        serverTime.text = [NSString stringWithFormat:@"营业时间:%@~%@",serverStart,serverEnd];
        
        
        adress.text = [NSString stringWithFormat:@"主营业务:%@",dict[@"entity"][@"bizArea"]];
        
        if ([dict[@"entity"][@"rzStatus"] isEqual:[NSNull null]]) {
            rzState.hidden = YES;
        }else{
            if ([dict[@"entity"][@"rzStatus"] isEqualToString:@"已认证"]) {
                rzState.hidden = NO;
            }else{
                rzState.hidden = YES;
            }
        }
        
        NSString * str = [NSString stringWithFormat:@"%@",dict[@"entity"][@"score"]];
        
        if ([str intValue] <= 0) {
            Score.hidden = YES;
        }else{
            [Score displayRating:[str floatValue]];
            Score.hidden = NO;
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
