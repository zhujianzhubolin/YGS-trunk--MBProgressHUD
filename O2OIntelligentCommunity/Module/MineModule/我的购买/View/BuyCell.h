//
//  BuyCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyShiGoodM.h"
#import "MineBuyXuniGoodM.h"
#import "MineBuyGoodM.h"

@interface BuyCell : UITableViewCell

@property (strong,nonatomic)UIImageView *commodityimg;
@property (strong,nonatomic)UILabel     *describeLabe;
@property (strong,nonatomic)UILabel     *UnitpriceLabe;
@property (strong,nonatomic)UILabel     *numberLabe;


-(void)getShitiBuyM:(MineBuyGoodM *)buyshi;
-(void)getXuliBuyM:(MineBuyGoodM *)xunibuy;

-(void)taunGouM:(MineBuyGoodM *)tuangou number:(NSUInteger)number;
@end
