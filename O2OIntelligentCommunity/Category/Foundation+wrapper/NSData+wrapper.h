//
//  NSData+wrapper.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData(wrapper)

//将图片转化为二进制
+ (NSData *)dataTransformFromImg:(UIImage *)img;


//将图片转化为二进制,并计算图片的大小，将超过1M的图片转化到1M左右，没超过的不做处理
+ (NSData *)dataTransformUnder1MFromImg:(UIImage *)img;

//替换非utf8字符
+ (NSData *)replaceNoUtf8:(NSData *)data;
@end
