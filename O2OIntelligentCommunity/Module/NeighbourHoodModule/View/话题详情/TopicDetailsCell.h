//
//  TopicDetailsCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryCommentModel.h"

@interface TopicDetailsCell : UITableViewCell

@property (strong,nonatomic)UIImageView *headImg;
@property (strong,nonatomic)UILabel     *nameLabe;
@property (strong,nonatomic)UILabel     *timeLabe;
@property (strong,nonatomic)UILabel     *contentLabe;
@property (strong,nonatomic)UIButton    *deleteBut;
@property (strong,nonatomic)UILabel     *floorLabe;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;

-(void)setCellData:(QueryCommentModel *)CommentM;

@end
