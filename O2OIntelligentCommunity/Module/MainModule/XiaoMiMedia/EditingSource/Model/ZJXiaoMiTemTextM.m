//
//  ZJXiaoMiTemTextM.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/29.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJXiaoMiTemTextM.h"

@implementation ZJXiaoMiTemTextM

- (void)setTemplateTextXy:(NSString *)templateTextXy {
    _templateTextXy = templateTextXy;
    NSArray *temArr = [_templateTextXy componentsSeparatedByString:@","];
    
    if (temArr.count > 0) {
        self.leftTopX = [[temArr[0] substringFromIndex:1] floatValue];
    }
    
    if (temArr.count > 1) {
        self.leftTopY = [[temArr[1] substringToIndex:([temArr[1] length] - 1)] floatValue];
    }
    
    if (temArr.count > 2) {
        self.rightBottmX = [[temArr[2] substringFromIndex:1] floatValue];
    }
    
    if (temArr.count > 3) {
        self.rightBottmY = [[temArr[3] substringToIndex:([temArr[3] length] - 1)] floatValue];
    }
    NSLog(@"self.leftTopX = %f,self.leftTopY = %f,rightBottmX = %f,rightBottmY = %f",self.leftTopX,self.leftTopY,self.rightBottmX,self.rightBottmY);
}

@end
