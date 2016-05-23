//
//  MorePinLunCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerBrowserViewController.h"

@interface MorePinLunCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,ZLPhotoPickerBrowserViewControllerDataSource>

- (void)cellData:(NSDictionary *)data isCollectionHide:(BOOL)isHide;

@end
