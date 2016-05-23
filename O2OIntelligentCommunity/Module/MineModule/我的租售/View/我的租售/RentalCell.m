//
//  RentalCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentalCell.h"
#import "CollectionViewImgCell.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import "NSArray+wrapper.h"
#import <UIImageView+AFNetworking.h>
#import "NSString+wrapper.h"
#import "ZLPhotoPickerBrowserViewController.h"


@interface RentalCell ()<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@end

@implementation RentalCell
{
    //UIImageView *lineimgV;
    UIImageView *inimageV;
    UILabel     *monthLab;
    UILabel     *dayLab;
    UILabel     *dayLab2;
    UIImageView *stateimgV;
    UILabel     *titleLab;
    UILabel     *contentLab;
    UILabel     *priceL;
    UICollectionView *collectionV;
    
    NSMutableArray *imgarr;
    MultiShowing *multShow;
    
    CGFloat itemWidth;
    NSUInteger singleRowNum;
    CGFloat interval;
    CGFloat inimageVHigth;
    
    UIView *backgroundV;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        singleRowNum = 3;
        interval = 10;
        itemWidth = (IPHONE_WIDTH - interval * (singleRowNum + 2)) / (singleRowNum + 1);
        
        inimageVHigth=80;
        
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    NSLog(@"self.frame.size.height==%f",self.frame.size.height);

    inimageV =[[UIImageView alloc]init];
    
//    inimageV.image=[UIImage imageNamed:@"red"];
    
    [self.contentView addSubview:inimageV];
    
    monthLab =[[UILabel alloc]init];
    monthLab.frame=CGRectMake(25, 20, 40, 20);
    monthLab.textColor=[UIColor whiteColor];
    monthLab.font=[UIFont systemFontOfSize:12];
//    monthLab.text=@"12月";
    [inimageV addSubview:monthLab];
    
    dayLab =[[UILabel alloc]init];
    dayLab.frame=CGRectMake(28, 35, 25, 30);
    dayLab.textColor=[UIColor whiteColor];
    dayLab.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
//    dayLab.text=@"12";
    [inimageV addSubview:dayLab];
    
    dayLab2 =[[UILabel alloc]init];
    dayLab2.frame=CGRectMake(48, 40, 25, 20);
    dayLab2.font=[UIFont systemFontOfSize:12];
//    dayLab2.text=@"日";
    dayLab2.textColor=[UIColor whiteColor];
    [inimageV addSubview:dayLab2];
    
    stateimgV=[[UIImageView alloc]init];
    stateimgV.frame=CGRectMake(100, interval, 0, 20);
    [self.contentView addSubview:stateimgV];
    
    CGFloat priceLwidth = 60;
    priceL = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - priceLwidth - interval, stateimgV.frame.origin.y, priceLwidth, 30)];
    priceL.textColor = [UIColor redColor];
    priceL.font = [UIFont systemFontOfSize:14];
    priceL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceL];
    
    titleLab =[[UILabel alloc]init];
    titleLab.frame=CGRectMake(CGRectGetMaxX(stateimgV.frame),
                              interval / 2,
                              IPHONE_WIDTH - CGRectGetMaxX(stateimgV.frame) - priceL.frame.size.width,
                              30);
    titleLab.text=@"标题";
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLab];
    
    contentLab =[[UILabel alloc]init];
    contentLab.frame=CGRectMake(stateimgV.frame.origin.x, CGRectGetMaxY(titleLab.frame) + interval / 2, IPHONE_WIDTH - stateimgV.frame.origin.x - interval, 30);
    contentLab.font=[UIFont systemFontOfSize:13];
    contentLab.textColor = [UIColor grayColor];
    contentLab.numberOfLines=5;
    [self.contentView addSubview:contentLab];
    
    //初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(stateimgV.frame.origin.x, CGRectGetMaxY(contentLab.frame) + interval / 2, itemWidth*singleRowNum +interval*1, 0) collectionViewLayout:flowLayout];
    collectionV.backgroundColor=[UIColor redColor];
    [collectionV registerClass:[CollectionViewImgCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    collectionV.scrollEnabled = NO;
    collectionV.userInteractionEnabled = YES;
    collectionV.dataSource = self;
    collectionV.delegate = self;
    collectionV.backgroundColor =[UIColor blueColor];
    [self.contentView addSubview:collectionV];
    
    backgroundV =[[UIView alloc]init];
    backgroundV.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [self.contentView addSubview:backgroundV];

}

-(void)setRentalData:(ShengSJDataE *)rentalD imgIndex:(NSUInteger)imgIndex
{
    switch (imgIndex) {
        case 0: {
            inimageV.image=[UIImage imageNamed:@"blue"];
        }
            break;
        case 1: {
            inimageV.image=[UIImage imageNamed:@"red"];
        }
            break;
        case 2: {
            inimageV.image=[UIImage imageNamed:@"coffee"];
        }
            break;
        default:
            break;
    }
    
    if (rentalD.updateTimeStr.length >= 19) {
        monthLab.text = [NSString stringWithFormat:@"%@ 月",[rentalD.updateTimeStr substringWithRange:NSMakeRange(5, 2)]];
        dayLab.text = [rentalD.updateTimeStr substringWithRange:NSMakeRange(8, 2)];
        dayLab2.text = @"日";
    }
    if ([rentalD.price isEqualToString:@"0"]) {
        priceL.text = @"面议";
    }
    else {
        priceL.text = [NSString stringWithFormat:@"%@元",rentalD.price];
    }
    
    CGSize priceLSize = [AppUtils sizeWithString:priceL.text font:priceL.font size:CGSizeMake(200, IPHONE_HEIGHT)];
    priceL.frame = CGRectMake(IPHONE_WIDTH - priceLSize.width - interval, priceL.frame.origin.y, priceLSize.width, priceLSize.height);
    
    monthLab.text=[NSString stringWithFormat:@"%@月",[rentalD.createTimeStr substringWithRange:NSMakeRange(5,2)]];
    dayLab.text=[NSString stringWithFormat:@"%@",[rentalD.createTimeStr substringWithRange:NSMakeRange(8,2)]];
    titleLab.text=rentalD.title;
    
    contentLab.text=rentalD.activityContent;

    CGSize contentSize= [AppUtils sizeWithString:contentLab.text
                                            font:contentLab.font
                                            size:CGSizeMake(IPHONE_WIDTH - stateimgV.frame.origin.x - interval, 100)];
    CGRect contentR =CGRectMake(stateimgV.frame.origin.x,
                                contentLab.frame.origin.y,
                                IPHONE_WIDTH - stateimgV.frame.origin.x - interval,
                                contentSize.height);
    dispatch_async(dispatch_get_main_queue(), ^{
         contentLab.frame = contentR;
    });
    
    if (![NSString isEmptyOrNull:rentalD.fleaMarketType] || ![NSString isEmptyOrNull:rentalD.transactionType]) {
        stateimgV.frame=CGRectMake(stateimgV.frame.origin.x,
                                   stateimgV.frame.origin.y,
                                   stateimgV.frame.size.height, stateimgV.frame.size.height);
        titleLab.frame=CGRectMake(CGRectGetMaxX(stateimgV.frame) + interval / 2,
                                  titleLab.frame.origin.y,
                                  IPHONE_WIDTH - CGRectGetMaxX(stateimgV.frame) - priceLSize.width - interval / 2 *3,
                                  titleLab.frame.size.height);

        if ([rentalD.fleaMarketType isEqualToString:@"1"]) {
            stateimgV.image=[UIImage imageNamed:@"chu"];
        }
        else if ([rentalD.fleaMarketType isEqualToString:@"2"]) {
            stateimgV.image=[UIImage imageNamed:@"qiu"];
        }
        else if ([rentalD.transactionType isEqualToString:@"1"] || [rentalD.transactionType isEqualToString:@"2"]) {
            stateimgV.image=[UIImage imageNamed:@"chu"];
        }
        else if ([rentalD.transactionType isEqualToString:@"3"]) {
            stateimgV.image=[UIImage imageNamed:@"qiu"];
        }
    }
    
    if ([NSArray isArrEmptyOrNull:rentalD.imgPath])
    {
        [imgarr removeAllObjects];
        [collectionV removeFromSuperview];

        CGFloat cellHeight =CGRectGetMaxY(titleLab.frame)+contentSize.height +interval;
        inimageV.frame=CGRectMake(interval,0, 80, 80);
        backgroundV.frame=CGRectMake(0, 0, IPHONE_WIDTH, cellHeight);
        [self.contentView bringSubviewToFront:backgroundV];

        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                cellHeight > inimageV.frame.size.height+ interval *2 ? cellHeight : inimageV.frame.size.height+ interval);
        CGFloat higth =cellHeight > inimageV.frame.size.height+ interval *2 ? cellHeight : inimageV.frame.size.height+ interval;
        inimageV.frame=CGRectMake(0, (higth-80)/2, 80, 80);
    }
    else
    {
        [self.contentView addSubview:collectionV];
        imgarr =[rentalD.imgPath mutableCopy];
        [collectionV reloadData];
        NSInteger rows = (imgarr.count % singleRowNum > 0 ? (imgarr.count / singleRowNum +1) : (imgarr.count / singleRowNum));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            collectionV.frame =CGRectMake(contentLab.frame.origin.x, CGRectGetMaxY(contentR) + interval / 2, collectionV.frame.size.width , rows * itemWidth);
            collectionV.backgroundColor=[UIColor whiteColor];
        });
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width-inimageV.frame.size.width, CGRectGetMaxY(contentR) +interval / 1.5 + rows * (itemWidth+interval));
        inimageV.frame=CGRectMake(interval, self.frame.size.height/2-40, 80, 80);
        backgroundV.frame=CGRectMake(0, 0, IPHONE_WIDTH, self.frame.size.height);

        NSLog(@"self.contentView.center.y = %f",self.contentView.center.y);
        //inimageV.center = CGPointMake(inimageV.center.x, self.contentView.center.y);
        CGFloat higth =CGRectGetMaxY(contentR) +interval / 1.5 + rows * (itemWidth+interval);
        inimageV.frame=CGRectMake(0, (higth-80)/2, 80, 80);
        [self.contentView bringSubviewToFront:backgroundV];
    }
    if ([rentalD.status isEqualToString:@"1"])
    {
        backgroundV.hidden=NO;
        UIImageView *disabledImg=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundV.frame.size.width/2-40, backgroundV.frame.size.height/2-40, 80, 80)];
        disabledImg.image=[UIImage imageNamed:@"ZYdisabled"];
        [backgroundV addSubview:disabledImg];
    }
    else
    {
        backgroundV.hidden=YES;
        
    }
    
}

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
    UIEdgeInsets top ={0 ,0,0 ,0};
    return top;
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewImgCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    [cell.img setImageWithURL:[NSURL URLWithString:[imgarr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    //cell.img.image=[UIImage imageNamed:@"defaultImg"];
    
    return cell;
}

//设置单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(itemWidth-5,itemWidth-5);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"23");
//    multShow =[[MultiShowing alloc]init];
//    
//    NSMutableArray *imgArr = [NSMutableArray array];
//    [imgarr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        WebImage *webImg = [WebImage new];
//        webImg.url = obj;
//        [imgArr addObject:webImg];
//    }];
//    
//    [multShow ShowImageGalleryFromView:collectionV ImageList:imgArr ImgType:ImgTypeFromWeb Scale:2.0];
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.dataSource = self;
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:[self viewController]];

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




@end
