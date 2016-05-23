//
//  DetailCommentCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTSCommentsModel.h"

@interface DetailCommentCell : UITableViewCell
@property (strong,nonatomic)UILabel *TextLab;
@property (strong,nonatomic)UILabel *timeLab;

-(void)setcommentDic:(BXTSCommentsModel *)dicM;


@end
