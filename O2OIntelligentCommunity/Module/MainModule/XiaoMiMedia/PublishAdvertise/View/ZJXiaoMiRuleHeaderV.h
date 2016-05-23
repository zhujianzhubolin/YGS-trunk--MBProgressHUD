//
//  ZJXiaoMiPublishHeaderTBV.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityViewCotroller.h"
#import "ZJXiaoMiTemplateM.h"

@interface ZJXiaoMiRuleHeaderV : UIView

@property (nonatomic,strong) ZJXiaoMiTemplateM *tmpM; //图片的链接

- (void)updateUIForComInfo:(BingingXQModel *)comM;
- (void)updateUIForXiaoMiJiQiNum:(NSUInteger)jiqiNum;

@end
