//
//  ZJFormView.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/2/17.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

typedef  NS_ENUM(NSUInteger,ZJFormType) {
    ZJFormTypeAllShowImg, //图片只放大
    ZJFormTypeLastImgPost //点击最后一张图片可以获取图片，且到图片最大数量后会隐藏，只放大
};

#import <UIKit/UIKit.h>
#import "ZJFormCollectionCell.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import "GetImgFromSystem.h"

typedef void(^ImgClickBlock)(NSInteger selectedRow);
typedef void(^GetImgFormSystemBlock)(NSArray *imgArr);

@interface ZJFormView : UIView <UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout,
                                ZLPhotoPickerBrowserViewControllerDataSource,
                                GetImgFromSystemDelegate>

@property (nonatomic,strong) UICollectionView *formCollView;

@property (nonatomic,assign) NSUInteger eachRowCount; //每行图片的个数
@property (nonatomic,assign) CGFloat itemInterval; //图片的间距
@property (nonatomic,strong) NSMutableArray *showImgArr; //所有的图片

@property (nonatomic,assign) int imgMaxCount; //需要展示图片个数总个数
@property (nonatomic,strong) NSString *postImgName; //点击图片上传的图片名称

@property (nonatomic,assign) ZJFormType formType; //表格类型  (默认为ZJFormTypeAllShowImg)
@property (nonatomic,strong) ImgClickBlock clickBlock; //点击回调事件
@property (nonatomic,strong) GetImgFormSystemBlock getImgBlock; //获取图片后的回调事件

- (void)reloadData;

//如果需要获取高度。必须设置eachRowCount、itemInterval、showImgArr的值，且和下面的值同步
+ (CGFloat)cellHeightForImgCount:(NSUInteger)imgCount //图片的总个数
                 forItemInterval:(CGFloat)itemInterval //图片的间距
                 forEachRowCount:(NSUInteger)rowCount //每行图片的个数
                       formWidth:(CGFloat)width; //控件展示的总宽度

@end
