//
//  TuanGouStaeCell.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyShopsM.h"

@interface TuanGouStaeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *stateLabe;
@property (weak, nonatomic) IBOutlet UILabel *detailsLab;


@property (strong,nonatomic)MineBuyShopsM  *mineshopsM;


-(void)setStateData:(MineBuyShopsM *)stateM;
@end
