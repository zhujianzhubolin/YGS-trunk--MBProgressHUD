//
//  shangjiaCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/9.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "shangjiaCell.h"
#import <UIImageView+AFNetworking.h>
#import "RatingBar.h"

@implementation shangjiaCell

{
    __weak IBOutlet UILabel *servertime;
    __weak IBOutlet RatingBar *socreStar;
    __weak IBOutlet UILabel *shopName;
    __weak IBOutlet UIImageView *headImage;
//    __weak IBOutlet UIView *renzhengBackView;
//    __weak IBOutlet UILabel *renzhenglable;
    
    
    __weak IBOutlet UILabel *zhuyingYewu;

    __weak IBOutlet UIImageView *rzStateImage;
}

- (void)awakeFromNib {

    headImage.clipsToBounds = YES;
    
    [socreStar setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    socreStar.isIndicator = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCellData:(id)myData rzState:(BOOL)rzState{

    NSLog(@"商家>>>%@",myData);
    
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",myData[@"entity"][@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    shopName.text = [NSString stringWithFormat: @"%@",myData[@"entity"][@"name"]];
    
    NSString * startTime = nil;
    NSString * endTime = nil;
    
    if ([myData[@"entity"][@"storeStartDate"] isEqual:[NSNull null]]) {
        startTime = @"00:00";
    }else{
        startTime = [NSString stringWithFormat:@"%@",myData[@"entity"][@"storeStartDate"]];
    }
    
    if ([myData[@"entity"][@"storeEndDate"] isEqual:[NSNull null]]) {
        endTime = @"24:00";
    }else{
        endTime = [NSString stringWithFormat:@"%@",myData[@"entity"][@"storeEndDate"]];
    }
    
    servertime.text = [NSString stringWithFormat:@"营业时间:%@~%@",startTime,endTime];
    
    zhuyingYewu.text = [NSString stringWithFormat:@"主营业务:%@",myData[@"entity"][@"bizArea"]];
    
    
    if (rzState) {
        
        rzStateImage.hidden = NO;
        
        if ([myData[@"entity"][@"score"] isEqual:[NSNull null]] || [myData[@"entity"][@"score"] floatValue] <= 0) {
            socreStar.hidden = YES;
            CGRect frameY = servertime.frame;
            frameY.origin.y -= 6;
            servertime.frame = frameY;
            
        }else{
            socreStar.hidden = NO;
            [socreStar displayRating:[myData[@"entity"][@"score"] intValue]];
        }
        
    }else{
        rzStateImage.hidden = YES;
        socreStar.hidden = YES;
        
        CGRect frame = shopName.frame;
        frame.size.width = self.frame.size.width -78;
        shopName.frame = frame;
    }

}

@end
