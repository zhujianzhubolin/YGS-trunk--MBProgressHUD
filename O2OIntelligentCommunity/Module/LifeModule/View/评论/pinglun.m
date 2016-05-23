//
//  pinglun.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/9.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "pinglun.h"
#import <UIImageView+AFNetworking.h>
#import "RatingBar.h"
@implementation pinglun

{
    __weak IBOutlet RatingBar *mystart;
    __weak IBOutlet UILabel *detail;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UIImageView *photoImage;
}

- (void)awakeFromNib {
    
    [mystart setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    mystart.isIndicator = YES;
    
    photoImage.layer.cornerRadius = 30;
    photoImage.clipsToBounds = YES;
}

- (void)setPingLunData:(id)data{
   
    NSLog(@"评论数据>>>%@",data);
    
    if ([data[@"rating"] isEqual:[NSNull null]]) {
        [mystart displayRating:0];
    }else{
        [mystart displayRating:[data[@"rating"] floatValue]];
    }
    
    //时间处理
    NSString * timStr = [NSString stringWithFormat:@"%@",data[@"dateCreated"]];
//    NSString * withOutSpace = [timStr stringByReplacingOccurrencesOfString:@" " withString:@"."];
//    NSString * withOutDian = [[withOutSpace stringByReplacingOccurrencesOfString:@"-" withString:@"."] substringWithRange:NSMakeRange(0, 16)];
    
    if ([data[@"content"] isEqual:[NSNull null]]) {
        detail.text = [NSString stringWithFormat:@""];
    }else
    {
        detail.text = [NSString stringWithFormat:@"%@",data[@"content"]];
    }
    time.text = [NSString stringWithFormat:@"%@",timStr];
    
    
    name.text = [NSString stringWithFormat:@"%@",data[@"memberName"]];
    [photoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"memberUrl"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
}

@end
