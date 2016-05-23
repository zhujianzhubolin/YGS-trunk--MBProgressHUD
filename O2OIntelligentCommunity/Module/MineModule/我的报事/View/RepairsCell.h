//
//  RepairsCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoXiuTouSuModel.h"
#import "ShengSJDataE.h"


@interface RepairsCell : UITableViewCell

@property (strong,nonatomic)UIImageView *img;
@property (strong,nonatomic)UILabel     *statusLabe;
@property (strong,nonatomic)UILabel     *textLabe;
@property (strong,nonatomic)UILabel     *timeLabe;
@property (strong,nonatomic)UIButton    *evaluateBut;

-(void)getDataByDictionary:(BaoXiuTouSuModel *)dicM;
-(void)getDataByDictionaryJianYi:(ShengSJDataE *)dicM;

@end
