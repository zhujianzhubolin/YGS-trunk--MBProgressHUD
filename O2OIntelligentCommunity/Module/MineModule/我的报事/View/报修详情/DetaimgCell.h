//
//  DetaimgCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoXiuTouSuModel.h"
#import "ShengSJDataE.h"


@interface DetaimgCell : UITableViewCell

@property (strong , nonatomic)UILabel *textLabe;
@property (strong , nonatomic)UIImageView *imgView;

//cell高度
@property (nonatomic ,assign) CGFloat height;


-(void)setcellData:(BaoXiuTouSuModel *)bxts;
//建议详情cell
-(void)setAdviceData:(ShengSJDataE *)shengSJM;

@end
