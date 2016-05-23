//
//  SubmitRepairCell.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "GetImgFromSystem.h"
#import "RepairTableViewController.h"
#import "ZLPhotoPickerBrowserViewController.h"

typedef void(^ShowImgBlock)(NSMutableArray *imgArr,NSUInteger selectedIndex);
@interface SubmitRepairCell : UITableViewCell <UITextViewDelegate,
NIDropDownDelegate,
UITextFieldDelegate,
GetImgFromSystemDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate,
ZLPhotoPickerBrowserViewControllerDataSource>
@property (nonatomic, strong) RepairTableViewController *getImgVC;
@property (nonatomic, copy) ShowImgBlock showImg;
@property (nonatomic, assign) VCType type;

- (void)setType:(VCType)type;

@end
