//
//  EasyCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "EasyShoppingCell.h"
#import "RatingBar.h"
#import <UIImageView+AFNetworking.h>

@implementation EasyShoppingCell

{
    __weak IBOutlet UILabel *type;
    __weak IBOutlet UILabel *name;
    
    __weak IBOutlet UILabel *disTanceLable;
    __weak IBOutlet RatingBar *rating;
    __weak IBOutlet UIImageView *headimage;
    
    NSString * telePhoneNum;
}

- (void)awakeFromNib {

    [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    rating.isIndicator = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)telephone:(UIButton *)sender {
    [_phoneDele telePhoneNum:telePhoneNum];
}

- (void)getData:(id)mydata{
    
    
    [headimage setImageWithURL:[NSURL URLWithString:mydata[@"img"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    telePhoneNum = mydata[@"phone"];
    name.text = mydata[@"name"];
    NSMutableArray * typeArray = [NSMutableArray array];
    
    if (mydata[@"tmdmService"]) {
        for (NSDictionary * dict in mydata[@"tmdmService"]) {
            [typeArray addObject:[dict objectForKey:@"name"]];
        }
        NSString * str = @"";
        for (NSString * mystr in typeArray) {
//            NSLog(@">>>>%@",mystr);
            str = [NSString stringWithFormat:@"%@ %@",str,mystr];
        }
            type.text = str;
    }
//    NSLog(@"距离>>%@",mydata);
    
    disTanceLable.text = [NSString stringWithFormat:@"距离小区%@米",mydata[@"distance"]];
    
    if ([mydata[@"score"] isEqual:[NSNull null]]) {
        [rating displayRating:0];
    }else{
        [rating displayRating:[mydata[@"score"] intValue]];
    }
    
}
@end
