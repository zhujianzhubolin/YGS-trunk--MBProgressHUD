//
//  CommodityNumberCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyGoodM.h"
#import "MineBuyShiGoodM.h"
#import "MineBuyXuniGoodM.h"

@interface CommodityNumberCell : UITableViewCell

@property (strong,nonatomic)UIImageView *headImg;
@property (strong,nonatomic)UILabel     *miaoshuLab;
@property (strong,nonatomic)UILabel     *priceLabe;
@property (strong,nonatomic)UILabel     *numberLabe;


-(void)getShitiBuyM:(MineBuyGoodM *)buyshi;
-(void)getXuliBuyM:(MineBuyGoodM *)xunibuy;

@end
