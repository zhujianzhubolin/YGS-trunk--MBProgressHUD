//
//  MorePinLunCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//rating  评分字段

#import "MorePinLunCell.h"
#import "RatingBar.h"
#import <UIImageView+AFNetworking.h>
#import "CollectionViewImgCell.h"
#import "MultiShowing.h"
#import "WebImage.h"

@implementation MorePinLunCell

{
    __weak IBOutlet RatingBar *rate;
    __weak IBOutlet UIImageView *headimage;
    __weak IBOutlet UILabel *content;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *time;
    UICollectionView *myCollectionView;
    MultiShowing *multShow;
    NSMutableArray * imageArray;
}


- (void)awakeFromNib{

    [rate setImageDeselected:@"xingxing_n" halfSelected:@"banxing" fullSelected:@"xingxing" andDelegate:nil];
    rate.isIndicator = YES;
    
    headimage.layer.cornerRadius = 30;
    headimage.contentMode = UIViewContentModeScaleAspectFill;
    headimage.clipsToBounds = YES;
    
    imageArray = [NSMutableArray array];
    
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

- (void)cellData:(NSDictionary *)data isCollectionHide:(BOOL)isHide{
    NSLog(@"cell里面的数据>>>>>%@",data);
    
    //时间处理
    NSString * timStr = [NSString stringWithFormat:@"%@",data[@"dateCreated"]];

    if (![data[@"memberUrl"] isEqual:[NSNull null]]) {
        [headimage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"memberUrl"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }
    
    CGSize contentSize;
    
    if (![data[@"content"] isEqual:[NSNull null]]) {
        
        content.text = (NSString *)data[@"content"];
        contentSize = [AppUtils sizeWithString:data[@"content"] font:content.font size:CGSizeMake(IPHONE_WIDTH - 81, 2000)];
        CGRect frame = content.frame;
        frame.size.height = contentSize.height;
        content.frame = frame;
        
        NSLog(@"Y坐标>>>>>>%f,height  =  %f,size = %@",content.frame.origin.y,content.frame.size.height,NSStringFromCGSize(contentSize));
        
        
        NSLog(@"屏幕宽度>>>>%f",self.frame.size.width);
    }
    
    
    name.text = (NSString *)data[@"memberName"];
    time.text = timStr;
    
    if (![data[@"rating"] isEqual:[NSNull null]]) {
        [rate displayRating:[data[@"rating"] floatValue]];
    }else{
        [rate displayRating:0];
    }
    
    
    if (isHide) {
        
    }else{
        if (![data[@"file"] isEqual:[NSNull null]]) {
            
            [imageArray removeAllObjects];
            
            if ([data[@"file"] count] > 0) {

                [self.contentView addSubview:myCollectionView];
                
                for (NSDictionary * dict in data[@"file"]) {
                    
                    if ([dict[@"url"] isEqual:[NSNull null]]) {
                    }else{
                        [imageArray addObject:dict[@"url"]];
                    }
                        
            }
                
                [myCollectionView reloadData];
                
            }else{
                [myCollectionView removeFromSuperview];
            }
        }else{
            [myCollectionView removeFromSuperview];
        }
        NSLog(@"Cell里面的图片数组>>>>%@",imageArray);
    }

    
    if (imageArray.count > 0) {//重置UICollectionframe
        myCollectionView.frame = CGRectMake(76, content.frame.origin.y + contentSize.height + 10, IPHONE_WIDTH - 76 -10, 70);
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
    UIEdgeInsets top ={0 ,0,0 ,5};
    return top;
}

//每个分区上的元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewImgCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:SYSTEM_CELL_Col_ID forIndexPath:indexPath];
    [cell.img setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    return cell;
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


@end
