//
//  ZYMilletDetailsCell.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYXiaoMiPlayerModel.h"


@interface ZYMilletDetailsCell : UITableViewCell



-(void)detailsData:(NSString *)nameStr;

-(void)detailsContent:(NSString *)content content2:(NSString *)content2 index:(NSUInteger)index;


@end
