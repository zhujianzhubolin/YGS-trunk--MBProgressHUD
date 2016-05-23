//
//  GoodsPingJiaCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/22.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "GoodsPingJiaCell.h"
#import "RatingBar.h"
#import "CollectionViewImgCell.h"
#import <UIImageView+AFNetworking.h>

@implementation GoodsPingJiaCell

{
    
    __weak IBOutlet UILabel *content;
    __weak IBOutlet RatingBar *rating;
    __weak IBOutlet UILabel *userName;
    
    UICollectionView *myCollectionView;
    NSMutableArray * imageArray;
}

- (void)awakeFromNib {
    
    imageArray = [NSMutableArray array];

    
    [rating setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    rating.isIndicator = YES;
    
    
    //初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    myCollectionView.showsHorizontalScrollIndicator = NO;
    [myCollectionView registerClass:[CollectionViewImgCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    myCollectionView.scrollEnabled = YES;
    myCollectionView.userInteractionEnabled = YES;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    myCollectionView.backgroundColor =[UIColor whiteColor];
//    [self addSubview:myCollectionView];
}

- (void)GoodsPingJIa:(NSDictionary *)data{

    NSLog(@"cell数据>>>>%@",data);
    
    userName.text = [NSString stringWithFormat:@"%@",data[@"memberName"]];
    
    if (![data[@"content"] isEqual:[NSNull null]]) {
        content.text = [NSString stringWithFormat:@"%@",data[@"content"]];
    }else{
        content.text = [NSString stringWithFormat:@""];
    }
    
    if (![data[@"rating"] isEqual:[NSNull null]]) {
        [rating displayRating:[data[@"rating"] floatValue]];
    }else{
        [rating displayRating:0];
    }
    
    
    
    if (![data[@"file"] isEqual:[NSNull null]]) {
        
        [imageArray removeAllObjects];
        
        if ([data[@"file"] count] <=0 ) {
            [myCollectionView removeFromSuperview];
        }else{
            [self.contentView addSubview:myCollectionView];
            for (NSDictionary * imageDict in data[@"file"]) {
                if (![imageDict[@"url"] isEqual:[NSNull null]]) {
                    [imageArray addObject:imageDict[@"url"]];
                }
            }

        }
        
        
    }else{
        [myCollectionView removeFromSuperview];
    }
    
    CGSize contentH = [AppUtils sizeWithString:[NSString stringWithFormat:@"%@",data[@"content"]] font:[UIFont systemFontOfSize:14] size:CGSizeMake(IPHONE_WIDTH - 16, CGFLOAT_MAX)];
    
    if (imageArray.count > 0) {//重置UICollectionframe
        myCollectionView.frame = CGRectMake(10, content.frame.origin.y + contentH.height + 10, IPHONE_WIDTH - 20, 70);
        [myCollectionView reloadData];
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
    return imageArray.count;
    
}

//设置元素的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top ={5 ,0,10 ,10};
    return top;
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewImgCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    
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

//设置单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(60,60);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    return imageArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [imageArray objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    CollectionViewImgCell * cell = (CollectionViewImgCell *)[myCollectionView cellForItemAtIndexPath:indexPath];
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.img;
    return photo;
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewImgCell *imgCell = (CollectionViewImgCell *)cell;
    [imgCell.img setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
