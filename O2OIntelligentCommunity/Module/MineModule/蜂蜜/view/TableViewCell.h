//
//  TableViewCell.h
//  BeeTest
//
//  Created by app on 15/11/17.
//  Copyright © 2015年 kuroneko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoneyTradeInfoModel.h"

@interface TableViewCell : UITableViewCell

- (void)setCellData:(HoneyTradeInfoModel *)data;

@end
