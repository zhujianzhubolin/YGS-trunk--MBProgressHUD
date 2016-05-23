//
//  ZYMilletPlayerCell.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYXiaoMiPlayerModel.h"

@interface ZYMilletPlayerCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

-(void)milletData:(ZYXiaoMiPlayerModel *)millerM;

+(NSString *)stateBackStr:(NSString *)str;
@end
