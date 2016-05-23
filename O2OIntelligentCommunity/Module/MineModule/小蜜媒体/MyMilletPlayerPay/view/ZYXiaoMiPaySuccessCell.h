//
//  ZYXiaoMiPaySuccessCell.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/6.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYXiaoMiPaySuccessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *StateLab;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;

-(void)celltext:(NSString *)str;

@end
