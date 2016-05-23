//
//  TGPingJianCell.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerBrowserViewController.h"


@interface TGPingJianCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

- (void)setPingJiaCellData:(NSDictionary *)data isGoods:(BOOL)isgoods;


@end
