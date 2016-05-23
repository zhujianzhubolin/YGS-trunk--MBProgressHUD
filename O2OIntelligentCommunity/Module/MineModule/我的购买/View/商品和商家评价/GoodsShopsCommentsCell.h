//
//  GoodsShopsCommentsCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyShiGoodM.h"


@interface GoodsShopsCommentsCell : UITableViewCell
-(void)setGoodsinfo:(MineBuyShiGoodM *)goodM ifTgOrSc:(NSString *)str;
- (NSString *)getCommentContent;
- (CGFloat)getCommentRating;
@end
