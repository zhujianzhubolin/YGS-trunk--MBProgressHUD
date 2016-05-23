//
//  YGSDaiJinCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/15.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiJinQuanModel.h"

@interface YGSDaiJinCell : UITableViewCell

@property (nonatomic,assign) BOOL isHasShopUse;
@property (nonatomic,assign) BOOL isMeetCondition;

- (void)setQuanModel:(DaiJinQuanModel *)model;
//没有选中的时候
- (void)setQuanModel:(DaiJinQuanModel *)model
              bounds:(NSString *)bounds;

//前面有选中
- (void)hasSelect:(DaiJinQuanModel *)model
           quanID:(NSMutableArray *)quanModelArray
           shopId:(NSString *)shopId
           bounds:(NSString *)bounds;

@end
