//
//  TopicCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuaTiListModel.h"

@interface TopicCell : UITableViewCell

@property (strong,nonatomic)UIImageView *headimg;
@property (strong,nonatomic)UILabel     *contentLabe;

@property (strong,nonatomic)UILabel     *timeLabe;
@property (strong,nonatomic)UIButton    *songhuaBut;
@property (strong,nonatomic)UIButton    *pinglunBut;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;


-(void)setCellData:(HuaTiListModel *)huatiM;

@end
