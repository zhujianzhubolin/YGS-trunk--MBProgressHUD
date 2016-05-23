//
//  CarCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SenderNumber <NSObject>

- (void)senderGoodsNum:(NSIndexPath *)index1;

@end

@protocol GouSelectOrNot <NSObject>

- (void)finishGou:(NSIndexPath *)indexPath2;

@end

@interface CarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectOrNot;

@property(nonatomic,weak) id<SenderNumber>numdele;

@property(nonatomic,weak) id<GouSelectOrNot>gouSelect;

- (void)setCellData:(NSMutableDictionary *)myData isShow:(BOOL)isShow index:(NSIndexPath *)index;

@end
