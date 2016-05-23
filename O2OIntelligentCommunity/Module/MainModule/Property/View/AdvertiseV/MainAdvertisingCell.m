//
//  AdvertisingCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//


#import "MainAdvertisingCell.h"
#import "AdCollectionCell.h"
#import "ADEntity.h"
#import <UIImageView+AFNetworking.h>

@implementation MainAdvertisingCell

- (void)awakeFromNib {
    self.dataSource = [NSArray array];
    self.adCollectionV.dataSource = self;
    self.adCollectionV.delegate = self;
    // Initialization code
}

- (void)reloadMainAdCellWithModel:(NSArray *)list {
    self.dataSource = [list copy];
    [self.adCollectionV reloadData];
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    AdCollectionCell * adCell = (AdCollectionCell *)cell;
    ADEntity *adE = self.dataSource[indexPath.row];
    [adCell.imgV setImageWithURL:[NSURL URLWithString:adE.imageAddres] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
}

#pragma mark - UICollectionViewDataSource &&
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width - 3 * cellInterval) / 2, (self.frame.size.width - 3 * cellInterval) / 2 / 1.75);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *collectionCellID = SYSTEM_CELL_Col_ID;
    AdCollectionCell * cell = (AdCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID
                                                                                              forIndexPath:indexPath];
    if ([AppUtils systemVersion] < 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppUtils systemVersion] >= 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.aCellClick) {
        self.aCellClick(indexPath.row);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
