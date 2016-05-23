//
//  NeightbourStatus.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NeightbourStatus.h"

@implementation NeightbourStatus

- (NeightbourStatus *)initWithDictionary:(NSDictionary *)dic{
    
    if (self  = [super init])
    {
        _headimgURLS = @"goodHead.png";
        _UserNameS = @"老笑";
        _classifyS = @"帮一帮";
        _baiotiS   = @"天气真好";
        _timeS     = @"2015-5-30 5:40";
        _huaNumberS= @"10";
        _pinglunNumberS=@"5";
        _contentS   = @"阳光明媚的日子，蓝蓝的天，让我们一起去黄山春游吧";
        _contentimgS=@"defaultImg";
        _imgArray = dic[@"imgArray"];
        
    
    }
    return self;
    
}


+(NeightbourStatus *)statusWithDictionary:(NSDictionary *)dic{
    
    NeightbourStatus * status = [[NeightbourStatus alloc]initWithDictionary:dic];
    
    return status;
    
}

-(NSString *)source{
    
    return [NSString stringWithFormat:@"来自 %@",_UserNameS];
}


@end
