//
//  NeightbourHoodCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuaTiListModel.h"
#import "ZLPhotoPickerBrowserViewController.h"

//typedef void(^CellHeightInfoBLock)(CGFloat height);
//@protocol didSelectBuutonImg <NSObject>
//
//-(void)didbuttonimg:(NSArray *)arr;
//
//@end


@interface NeightbourHoodCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property (strong,nonatomic)UIImageView *headimg;
@property (strong,nonatomic)UILabel     *nameLabe;
@property (strong,nonatomic)UILabel     *classifyLabe;
@property (strong,nonatomic)UILabel     *biaotiLabe;
@property (strong,nonatomic)UILabel     *timeLabe;
@property (strong,nonatomic)UILabel     *contentLabe;
@property (strong,nonatomic)NSString    *cellType;

@property (strong,nonatomic)NSMutableArray *cellHigthArr;
-(void)sethuatidic:(HuaTiListModel *)huatim
         isShowAll:(BOOL)isShowAll;
+ (CGFloat)cellHigth:(HuaTiListModel *)huatiM
           isShowAll:(BOOL)isShowAll;
@end
