//
//  StayPaymentAddressCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBuyorderM.h"
@interface StayPaymentAddressCell : UITableViewCell

@property (strong,nonatomic)UIImageView *headimg;//头像
@property (strong,nonatomic)UILabel     *consigneeLabe;//收货人
@property (strong,nonatomic)UILabel     *nameLabe;//姓名
@property (strong,nonatomic)UILabel     *phoneLabe;//电话
@property (strong,nonatomic)UILabel     *addressLabe;//详细地址


-(void)setuserinfo:(MineBuyorderM *)orderM;

@end
