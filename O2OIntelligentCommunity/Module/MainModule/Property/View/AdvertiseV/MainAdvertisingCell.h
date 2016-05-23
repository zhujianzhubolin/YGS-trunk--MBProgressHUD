//
//  AdvertisingCell.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#define cellInterval 10

#import <UIKit/UIKit.h>
typedef void (^AdCellClickBlock)(NSUInteger index);

@interface MainAdvertisingCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *adCollectionV;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) AdCellClickBlock aCellClick;

- (void)reloadMainAdCellWithModel:(NSArray *)list;

@end
