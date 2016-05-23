//
//  ChooseXQCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingingXQModel.h"

@interface ChooseXQCell : UITableViewCell

@property (nonatomic,strong)UILabel *XQNameLabe;
@property (nonatomic,strong)UILabel *XQAddressLabe;


-(void)getXQListDictionary:(BingingXQModel *)model;
@end
