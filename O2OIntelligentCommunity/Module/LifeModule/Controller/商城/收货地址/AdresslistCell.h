//
//  AdresslistCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdresslistCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *isSelectGou;

- (void)setCellData:(id)data;

@end
