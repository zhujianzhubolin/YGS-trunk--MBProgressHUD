//
//  TuanGouCell.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyGoodM.h"
#import "MineBuyShiGoodM.h"
#import "MineBuyXuniGoodM.h"

@interface TuanGouCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

-(void)setTaunGouCellDeta:(MineBuyGoodM *)tuangouM;
@end
