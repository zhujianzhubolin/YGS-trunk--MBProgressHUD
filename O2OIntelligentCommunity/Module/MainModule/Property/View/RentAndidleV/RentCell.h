//
//  RentCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerBrowserViewController.h"

@interface RentCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,ZLPhotoPickerBrowserViewControllerDataSource>

- (void)setCellInformation:(id)data;

@end
