//
//  PassFooterView.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef void (^PassButtonClickBlock)(NSUInteger btnTag);
#import <UIKit/UIKit.h>
#import "PassPermitEntity.h"

@interface PassFooterView : UIView
@property (nonatomic, strong) PassButtonClickBlock clickBlock;
- (void)reloadDataWithModel:(PassPermitEntity *)passE isGeneratePass:(BOOL)isGene;

@end
