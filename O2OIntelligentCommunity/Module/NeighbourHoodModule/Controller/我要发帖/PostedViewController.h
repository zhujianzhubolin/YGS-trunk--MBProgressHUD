//
//  PostedViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
typedef void (^PostingSuccessBlock)();

#import "O2OBaseViewController.h"
#import "NIDropDown.h"
#import "uploadCollectionCell.h"
#import "GetImgFromSystem.h"

@interface PostedViewController : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,NIDropDownDelegate,GetImgFromSystemDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>


@property (strong,nonatomic)UITableView *TableView;

@property (nonatomic, strong)PostingSuccessBlock postSucBlock;
@property(strong ,nonatomic)UICollectionView *CollectionView;



@end
