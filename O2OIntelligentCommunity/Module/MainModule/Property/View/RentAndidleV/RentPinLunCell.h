//
//  RentPinLunCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DeleteDetailPinLun <NSObject>

- (void)delteMyPinLun:(NSString *)pinlunID;

@end

@interface RentPinLunCell : UITableViewCell

@property(nonatomic,assign) CGFloat height;

@property(nonatomic,weak) id <DeleteDetailPinLun> mydelete;

- (void)setCellData:(id)data;     

@end
