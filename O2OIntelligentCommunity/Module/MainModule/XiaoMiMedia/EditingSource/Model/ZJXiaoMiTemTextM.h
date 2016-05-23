//
//  ZJXiaoMiTemTextM.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/29.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJXiaoMiTemTextM : NSObject

@property (nonatomic,assign) CGFloat leftTopX;
@property (nonatomic,assign) CGFloat leftTopY;
@property (nonatomic,assign) CGFloat rightBottmX;
@property (nonatomic,assign) CGFloat rightBottmY;
@property (nonatomic, copy) NSString *templateText; //默认提示
@property (nonatomic, copy) NSString *templateTextXy; //图片上的文本1位置坐标:格式(x,y),(x,y)。
@property (nonatomic, copy) NSString *templateTextZt; //图片上的文本1的字体：st：宋体。
@property (nonatomic, assign) CGFloat templateTextFontsize; //图片上的文本1的字号大小：20到80之间的整数
@property (nonatomic, assign) NSUInteger templateTextFontcount; //字体个数限制

@end
