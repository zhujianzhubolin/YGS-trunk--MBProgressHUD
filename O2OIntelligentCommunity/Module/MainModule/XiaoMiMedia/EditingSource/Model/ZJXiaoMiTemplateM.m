//
//  ZJXiaoMiTemplateM.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/29.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJXiaoMiTemplateM.h"

@implementation ZJXiaoMiTemplateM

- (id)init {
    self = [super init];
    if (self) {
        self.list = [NSArray array];
        self.textModel1 = [ZJXiaoMiTemTextM new];
        self.textModel2 = [ZJXiaoMiTemTextM new];
        self.textModel3 = [ZJXiaoMiTemTextM new];
    }
    return self;
}

- (void)setTemplateSizePx:(NSString *)templateSizePx {
    _templateSizePx = templateSizePx;
    
    NSArray *temPxArr = [_templateSizePx componentsSeparatedByString:@"*"];
    
    if (temPxArr.count > 0) {
        self.templateSizePxW = [temPxArr[0] floatValue];
    }
    
    if (temPxArr.count > 1) {
        self.templateSizePxH = [temPxArr[1] floatValue];
    }
}

@end
