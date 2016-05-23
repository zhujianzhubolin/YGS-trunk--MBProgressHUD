//
//  NSData+wrapper.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "NSData+wrapper.h"

@implementation NSData(wrapper)
+ (NSData *)dataTransformFromImg:(UIImage *)img {
    NSData *data;
    if (UIImagePNGRepresentation(img) == nil) {
        data = UIImageJPEGRepresentation(img, 1);
        
    } else {
        data = UIImagePNGRepresentation(img);
    }
    return data;
}

+ (NSData *)dataTransformUnder1MFromImg:(UIImage *)img {
    NSData *imgData = [NSData dataTransformFromImg:img];
    CGFloat scaleSize = imgData.length / 1024.00 /1024.00;
    if (scaleSize > 1.5 && scaleSize < 3.1) {
        imgData = UIImageJPEGRepresentation(img, 1);
    }
    else if (scaleSize >= 3.1){
        imgData = UIImageJPEGRepresentation(img, 0.99);
    }
    return imgData;
}

+ (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}
@end
