//
//  CommentCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryCommentModel.h"

@interface CommentCell : UITableViewCell

@property (strong,nonatomic)UIImageView *headImg;
@property (strong,nonatomic)UILabel     *contentLabe;
@property (strong,nonatomic)UILabel     *numberLabe;
@property (strong,nonatomic)UILabel     *timeLabe;

@property (nonatomic ,assign) CGFloat height;

-(void)setCellData:(QueryCommentModel *)queryM;

@end
