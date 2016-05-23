//
//  SetCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell : UITableViewCell

@property(strong,nonatomic)UIImageView *iconImage;
@property(strong,nonatomic)UILabel     *nameLabele;
@property(strong,nonatomic)UILabel     *dataLabe;

-(void)setIcon:(UIImage *)image;
-(void)setNameLabe:(NSString *)name;
-(void)setDataStringLabe:(NSString *)string;

@end
