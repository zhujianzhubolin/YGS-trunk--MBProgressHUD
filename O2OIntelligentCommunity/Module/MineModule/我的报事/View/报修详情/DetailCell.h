//
//  DetailCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell

@property (strong ,nonatomic)UILabel *NameLabe;
@property (strong ,nonatomic)UILabel *DataLabe;

-(void)setName:(NSString *)Name;



@end
