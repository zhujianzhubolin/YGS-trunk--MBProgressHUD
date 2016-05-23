//
//  GoodsPingJiaCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/22.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerBrowserViewController.h"


@interface GoodsPingJiaCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

- (void)GoodsPingJIa:(NSDictionary *)data;

@end
