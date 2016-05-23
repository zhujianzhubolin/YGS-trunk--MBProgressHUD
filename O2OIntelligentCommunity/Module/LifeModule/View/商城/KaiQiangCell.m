//
//  KaiQiangCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "KaiQiangCell.h"

@implementation KaiQiangCell

{
    NSTimer * timer2;
    
    __weak IBOutlet UILabel *hour;
    
    __weak IBOutlet UILabel *miniute;
    
    __weak IBOutlet UILabel *second;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)morekaiqiang:(UIButton *)sender {
    
    if (_qianggouDelegate && [_qianggouDelegate respondsToSelector:@selector(getMoreQiangGou)]) {
        
        [_qianggouDelegate getMoreQiangGou];
    }
    
}

- (void)SetEndTime:(NSString *)endTime{

//    NSString * time = [endTime substringWithRange:NSMakeRange(endTime.length - 8, 8)];
//    NSLog(@"Cell 结束时间>>>>>>%@",time);
    
    //在调用该方法之前，一定要判断为同一年同一月同一日//返回时间与本地时间的对比
    timer2 = [NSTimer scheduledTimerWithTimeInterval:START_NET_TIME target:self selector:@selector(getLeftTime) userInfo:@"hell" repeats:YES];
    
}

- (NSString *)getSystemTime{

    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"H:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}


- (void)getLeftTime{

    
    NSString * lastTime = @"24:00:00";
    int endHour = [[lastTime substringWithRange:NSMakeRange(0, 2)] intValue];
    int endminiute = [[lastTime substringWithRange:NSMakeRange(3, 2)] intValue];
    int endsendecond = [[lastTime substringWithRange:NSMakeRange(6, 2)] intValue];
    int endallSecond = endsendecond + endminiute * 60 + 3600 * endHour;
    
    
    NSString * systemStr = [self getSystemTime];
    int currentHour = [[systemStr substringWithRange:NSMakeRange(0, 2)] intValue];
    int currentminiute = [[systemStr substringWithRange:NSMakeRange(3, 2)] intValue];
    int currentsecond = [[systemStr substringWithRange:NSMakeRange(6, systemStr.length - 6)] intValue];
    int currentAllSecond = currentsecond + currentminiute * 60 + 3600 * currentHour;
    
    
    int leftMiniute = endallSecond - currentAllSecond;
    
    int lefth = leftMiniute/3600;
    
    if (lefth < 10) {
        hour.text = [NSString stringWithFormat:@"0%d",lefth];
        
    }else{
        hour.text = [NSString stringWithFormat:@"%d",lefth];
    }
    
    int leftm = leftMiniute%3600/60;
    
    if (leftm < 10) {
        miniute.text = [NSString stringWithFormat:@"0%d",leftm];

    }else{
        miniute.text = [NSString stringWithFormat:@"%d",leftm];
    }
    
    int lefts = leftMiniute%3600%60;
    
    if (lefts < 10) {
        second.text = [NSString stringWithFormat:@"0%d",lefts];
    }else{
        second.text = [NSString stringWithFormat:@"%d",lefts];
    }
    
}

@end
