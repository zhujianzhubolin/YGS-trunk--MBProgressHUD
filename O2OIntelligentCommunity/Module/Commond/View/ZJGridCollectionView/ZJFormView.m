//
//  ZJFormView.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/2/17.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define IMG_MAX_COUNT 9
#define POST_IMG_NAME @"postImg"

#import "ZJFormView.h"
#import "AppUtils.h"
#import <UIImageView+AFNetworking.h>
#import "GetImgFromSystem.h"

@implementation ZJFormView
{
    CGFloat itemWidth;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.formType = ZJFormTypeAllShowImg;
        self.showImgArr = [NSMutableArray new];
        self.imgMaxCount = IMG_MAX_COUNT;
        self.postImgName = POST_IMG_NAME;
        [GetImgFromSystem getImgInstance].delegate = self;
        [self addSubview:self.formCollView];
    }
    return self;
}

- (void)setFormType:(ZJFormType)formType {
    _formType = formType;
    if (_formType == ZJFormTypeLastImgPost) {
        self.showImgArr = [@[[UIImage imageNamed:self.postImgName]] mutableCopy];
    }
}

- (void)setShowImgArr:(NSMutableArray *)showImgArr {
    _showImgArr = showImgArr;
    
    itemWidth = [ZJFormView itemWidthForFormWdith:self.formCollView.frame.size.width
                                  forItemInterval:self.itemInterval
                                  forEachRowCount:self.eachRowCount];
    
    CGFloat myHeight = [ZJFormView cellHeightForImgCount:_showImgArr.count
                                         forItemInterval:self.itemInterval
                                         forEachRowCount:self.eachRowCount
                                               formWidth:self.frame.size.width];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect formRect = self.frame;
        formRect.size.height = myHeight;
        self.frame = formRect;
        self.formCollView.frame = self.bounds;
    });
}

+ (NSUInteger)imgRowsForImgCount:(NSUInteger)imgCount
                 forEachRowCount:(NSUInteger)eachRowCount {
    if (eachRowCount <= 0) {
        return 0;
    }
    
    NSUInteger rows = imgCount /eachRowCount;
    if (imgCount % eachRowCount > 0) {
        rows++;
    }
    return rows;
}

+ (int)itemWidthForFormWdith:(CGFloat)width
             forItemInterval:(NSUInteger)itemInterval
             forEachRowCount:(NSUInteger)eachrowCount {
    if (eachrowCount <= 0) {
        return 0;
    }

    CGFloat itemWidth = (width - itemInterval *((eachrowCount + 1))) /eachrowCount;
    return (int)itemWidth;
}

+ (CGFloat)cellHeightForImgCount:(NSUInteger)imgCount //图片的总个数
                 forItemInterval:(CGFloat)itemInterval //图片的间距
                 forEachRowCount:(NSUInteger)rowCount //每行图片的个数
                       formWidth:(CGFloat)width; //控件展示的总宽度
{
    CGFloat itemWidth = [ZJFormView itemWidthForFormWdith:width
                                          forItemInterval:itemInterval
                                          forEachRowCount:rowCount];
    NSUInteger rows = [ZJFormView imgRowsForImgCount:imgCount
                                     forEachRowCount:rowCount];
    return rows *itemWidth + itemInterval *(rows + 1);
}

- (UICollectionView *)formCollView {
    if (!_formCollView) {
        UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
//        flowLayout.minimumLineSpacing = 5;//行间距(最小值);
//        flowLayout.minimumInteritemSpacing = 50;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

        _formCollView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];

        [_formCollView registerClass:[ZJFormCollectionCell class] forCellWithReuseIdentifier:@"systemColCellID"];
        _formCollView.dataSource = self;
        _formCollView.delegate = self;
        _formCollView.scrollEnabled = NO;
        _formCollView.backgroundColor = [UIColor clearColor];
    }
    return _formCollView;
}

- (void)reloadData {
    [self.formCollView reloadData];
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    ZJFormCollectionCell *imgCell = (ZJFormCollectionCell *)cell;
    if ([self.showImgArr[indexPath.row] isKindOfClass:[UIImage class]]) {
        imgCell.showImgView.image = self.showImgArr[indexPath.row];
    }
    else {
        [imgCell.showImgView setImageWithURL:[NSURL URLWithString:self.showImgArr[indexPath.row]]
                            placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showImgArr.count;
}

//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(self.itemInterval, self.itemInterval, self.itemInterval, self.itemInterval);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJFormCollectionCell *formCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"systemColCellID" forIndexPath:indexPath];
    if (SYSTEMVERYION < 8) {
        [self refreshCollectionViewForCell:formCell forIndexPath:indexPath];
    }
    return formCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (SYSTEMVERYION >= 8) {
        [self refreshCollectionViewForCell:cell forIndexPath:indexPath];
    }
}

//设置单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(itemWidth,itemWidth);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath");
    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
    
    if (self.formType == ZJFormTypeLastImgPost) {
        if (indexPath.row == self.showImgArr.count - 1 &&
            [self.showImgArr.lastObject isEqual:[UIImage imageNamed:self.postImgName]]) {
            int MaxImage = self.imgMaxCount + 1;
            [GetImgFromSystem getImgInstance].maxCount = MaxImage - self.showImgArr.count;
            [[GetImgFromSystem getImgInstance] getImgFromVC:[AppUtils viewControllerForView:self]];
            return;
        }
    }
 
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.dataSource = self;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [pickerBrowser showPickerVc:[AppUtils viewControllerForView:self]];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    if (self.formType == ZJFormTypeLastImgPost) {
        if ([self.showImgArr.lastObject isEqual:[UIImage imageNamed:self.postImgName]]) {
            return self.showImgArr.count - 1;
        }
        return self.showImgArr.count;
    }
    return self.showImgArr.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [self.showImgArr objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源

    ZJFormCollectionCell *cell = (ZJFormCollectionCell *)[self.formCollView cellForItemAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    
    photo.toView = cell.showImgView;
    return photo;
}

#pragma mark - GetImgFromSystemDelegate
- (void)getFromImg:(NSArray *)imgArr {
    [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.showImgArr insertObject:obj atIndex:0];
    }];
    
    if (self.showImgArr.count > self.imgMaxCount) {
        [self.showImgArr removeLastObject];
    }
    
    if (self.getImgBlock) {
        self.getImgBlock([self.showImgArr copy]);
    }
}

@end
