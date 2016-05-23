//
//  DetaimgCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "DetaimgCell.h"
#import "NSArray+wrapper.h"
#import <UIImageView+AFNetworking.h>
#import "CollectionViewImgCell.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import "ZLPhotoPickerBrowserViewController.h"


@interface DetaimgCell ()<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>
{
    NSMutableArray *imgarr;
    CGFloat itemWidth;
    NSUInteger singleRowNum;
    CGFloat interval;
    MultiShowing *multShow;
    
    UICollectionView *collectionV;
}

@end
@implementation DetaimgCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        imgarr =[NSMutableArray array];
        singleRowNum = 3;
        interval = 10;
        itemWidth = (IPHONE_WIDTH - interval * singleRowNum-interval) / (singleRowNum + 1);
        
        self.textLabe = [[UILabel alloc]initWithFrame:CGRectMake(interval, interval, IPHONE_WIDTH-interval*2, 35)];
        self.textLabe.numberOfLines = 0;
        //self.textLabe.backgroundColor=[UIColor redColor];
         _textLabe.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.textLabe];
        
        //初始化layout
        UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(interval, CGRectGetMaxY(_textLabe.frame), itemWidth * singleRowNum + interval * 3, 0) collectionViewLayout:flowLayout];
        
        [collectionV registerClass:[CollectionViewImgCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
        collectionV.scrollEnabled = NO;
        collectionV.userInteractionEnabled = YES;
        collectionV.backgroundColor = [UIColor whiteColor];
        collectionV.dataSource = self;
        collectionV.delegate = self;
        [self addSubview:collectionV];


        
    }
    return  self;
}

-(void)settextComment:(NSString *)text
{
    _textLabe.text=text;
}
-(void)setcellData:(BaoXiuTouSuModel *)bxts
{
    
    self.textLabe.text = bxts.complaintContent;
    //CGFloat contentWidth = IPHONE_WIDTH-interval*2;
    CGSize contentSize = [AppUtils sizeWithString:self.textLabe.text font:self.textLabe.font size:CGSizeMake(IPHONE_WIDTH-interval*2, MAXFLOAT)];
    self.textLabe.frame= CGRectMake(interval, interval, IPHONE_WIDTH-interval*2, contentSize.height);
    
    if ([NSArray isArrEmptyOrNull:bxts.imgPath])
    {
        [imgarr removeAllObjects];
        [collectionV removeFromSuperview];
        
         self.frame =CGRectMake(interval, interval, IPHONE_WIDTH-interval*2,contentSize.height +interval*2);
    }
    else
    {
        [self addSubview:collectionV];
        imgarr =[bxts.imgPath mutableCopy];
        [collectionV reloadData];
       NSUInteger rows = (imgarr.count % singleRowNum > 0 ? (imgarr.count / singleRowNum + 1) : (imgarr.count / singleRowNum));
        dispatch_async(dispatch_get_main_queue(), ^{
            collectionV.frame = CGRectMake(_textLabe.frame.origin.x,
                                              CGRectGetMaxY(_textLabe.frame) + interval,
                                              collectionV.frame.size.width,
                                              rows * (interval + itemWidth));
        });
        self.frame =CGRectMake(interval, self.frame.origin.y, IPHONE_WIDTH-interval*2, CGRectGetMaxY(_textLabe.frame) +interval+rows *(interval + itemWidth)+interval);
    }
}

-(void)setAdviceData:(ShengSJDataE *)shengSJM
{
    UIView *contentView =[[UIView alloc]init];
    self.textLabe.text = shengSJM.activityContent;
    CGSize contentSize = [AppUtils sizeWithString:self.textLabe.text font:self.textLabe.font size:CGSizeMake(IPHONE_WIDTH - interval *4,MAXFLOAT)];
    
    self.textLabe.frame = CGRectMake(interval, interval, IPHONE_WIDTH-interval*4, contentSize.height);
    [contentView addSubview:self.textLabe];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds=YES;
    contentView.layer.cornerRadius=5;
    if ([NSArray isArrEmptyOrNull:shengSJM.imgPath])
    {
        [imgarr removeAllObjects];
        [collectionV removeFromSuperview];
        CGFloat cellHeight = contentSize.height+interval;
        contentView.frame=CGRectMake(interval, 0, IPHONE_WIDTH-20, cellHeight+interval);
    }
    else
    {
        [contentView addSubview:collectionV];
        imgarr =[shengSJM.imgPath mutableCopy];
        [collectionV reloadData];
        NSUInteger rows = (imgarr.count % singleRowNum > 0 ? (imgarr.count / singleRowNum + 1) : (imgarr.count / singleRowNum));
        dispatch_async(dispatch_get_main_queue(), ^{
            collectionV.frame = CGRectMake(_textLabe.frame.origin.x,
                                           CGRectGetMaxY(_textLabe.frame) + interval,
                                           collectionV.frame.size.width,
                                           rows * (interval + itemWidth));
        });
            
        contentView.frame=CGRectMake(interval, self.frame.origin.y, IPHONE_WIDTH-20, CGRectGetMaxY(_textLabe.frame) +interval+rows *(interval + itemWidth)+interval);
        
    }
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds=YES;
    contentView.layer.cornerRadius=5;
    
    [self.contentView addSubview:contentView];
    self.backgroundColor=[AppUtils colorWithHexString:@"EBEBF1"];
    _height=CGRectGetMaxY(contentView.frame);

}




//-(void)imgTap
//{
//    if (_deletedidImg &&[_deletedidImg respondsToSelector:@selector(didimg)])
//    {
//        [_deletedidImg didimg];
//    }
//}

#pragma mark - UICollectionView 代理方法
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return imgarr.count;
}


//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(interval, 0, 0, 0);
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewImgCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    [cell.img setImageWithURL:[NSURL URLWithString:[imgarr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    return cell;
}

//设置单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(itemWidth,itemWidth);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    multShow =[[MultiShowing alloc]init];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    [imgarr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WebImage *webImg = [WebImage new];
        webImg.url = obj;
        [imgArr addObject:webImg];
    }];
    

    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.dataSource = self;
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:[self viewController]];


}

//得到此view 所在的viewController
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}




//2、图片放大控件更换，需要设置代理；
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return imgarr.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [imgarr objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    CollectionViewImgCell * cell = (CollectionViewImgCell *)[collectionV cellForItemAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.img;
    return photo;
}


@end
