//
//  RentCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentCell.h"
#import "CollectionViewImgCell.h"
#import <UIImageView+AFNetworking.h>
#import "MultiShowing.h"
#import "WebImage.h"

@implementation RentCell

{
    UILabel *timelable;
    __weak IBOutlet UILabel *tiaozaoTitle;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *title;
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UILabel *description;
    __weak IBOutlet UILabel *cityLable;
    UICollectionView *myCollectionView;
    CGFloat currentY;
    NSMutableArray * imageArray;
    
}

- (void)awakeFromNib {
    
    //设置头像圆角
    headImage.layer.cornerRadius = 25;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
    
    imageArray = [NSMutableArray array];
    
    //初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    
    [myCollectionView registerClass:[CollectionViewImgCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    myCollectionView.scrollEnabled = NO;
    myCollectionView.userInteractionEnabled = YES;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    myCollectionView.backgroundColor =[UIColor whiteColor];
    [self addSubview:myCollectionView];
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCellInformation:(id)data{
    
//    NSLog(@"Cell data >>>>%@",data);
    
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"mbMember"][@"photourl"]]]
              placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    //城市ID 深圳：77 、 东莞：79、惠州：82
    NSString * cityID = [NSString stringWithFormat:@"%@",data[@"cityId"]];
    
    //房屋出售还是跳蚤市场 2房屋租售  6 跳蚤市场
    NSString * kindOftiaozao = [NSString stringWithFormat:@"%@",data[@"type"]];
    
    //跳蚤市场交易类型 1：出售 2：求购
    
    //房屋交易类型 1:出租 2：出售 3：求租
    NSString * houseKind = [NSString stringWithFormat:@"%@",data[@"transactionType"]];
    if ([kindOftiaozao isEqualToString:@"2"]) {//房屋

        NSString * cityName;
        
        if ([cityID isEqualToString:@"77"]) {//深圳
            cityName = [NSString stringWithFormat:@"【%@】",@"深圳"];
        }else if ([cityID isEqualToString:@"80"]){//东莞
            cityName = [NSString stringWithFormat:@"【%@】",@"佛山"];
        }else{//惠州
            cityName = [NSString stringWithFormat:@"【%@】",@"中山"];
        }
//        [stateButton setTitle:cityName forState:UIControlStateNormal];
        cityLable.text = cityName;
        
        if ([houseKind isEqualToString:@"1"]) {//出租
            
            if ([data[@"price"] intValue] == 0) {
                price.text = [NSString stringWithFormat:@"面议"];
                
            }else{
                price.text = [NSString stringWithFormat:@"%@元/月",data[@"price"]];

            }
            
        }else if ([houseKind isEqualToString:@"2"]){//出售
            if ([data[@"price"] intValue] == 0) {
                price.text = [NSString stringWithFormat:@"面议"];
            }else{
                price.text = [NSString stringWithFormat:@"%@万/套",data[@"price"]];

            }
        }else{//求租
            
            if ([data[@"price"] intValue] == 0) {
                price.text = [NSString stringWithFormat:@"面议"];
            }else{
                price.text = [NSString stringWithFormat:@"%@元/月",data[@"price"]];
            }
        }
        //先移除再创建
        [timelable removeFromSuperview];
        timelable = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 18)];
        [self addSubview:timelable];
        timelable.textAlignment = NSTextAlignmentCenter;
        timelable.font = [UIFont systemFontOfSize:13];
        timelable.text = [NSString stringWithFormat:@"%@",data[@"createDateStr"]];
        timelable.textColor = [AppUtils colorWithHexString:@"787878"];
        title.text = [NSString stringWithFormat:@"%@",data[@"title"]];
        tiaozaoTitle.hidden = YES;
        
    }else{//跳蚤  tiaozaochushou tiaozaoqiugou
        
        cityLable.hidden = YES;
        
        //先移除再创建
        [timelable removeFromSuperview];
        
        timelable = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 18)];
        [self addSubview:timelable];
        timelable.textAlignment = NSTextAlignmentCenter;
        timelable.font = [UIFont systemFontOfSize:13];
        timelable.textColor = [AppUtils colorWithHexString:@"787878"];
        tiaozaoTitle.hidden = NO;
        title.hidden = YES;

        price.text = [NSString stringWithFormat:@"%@元",data[@"price"]];

        tiaozaoTitle.text = [NSString stringWithFormat:@"%@",data[@"title"]];
        timelable.text = [NSString stringWithFormat:@"%@",data[@"createDateStr"]];
    }
    
    description.text = [NSString stringWithFormat:@"%@",data[@"activityContent"]];
    name.text = [NSString stringWithFormat:@"%@",data[@"mbMember"][@"nickName"]];
    
    if (![data[@"imgPath"] isEqual:[NSNull null]]) {
        if ([data[@"imgPath"] count] <= 0) {
            [myCollectionView removeFromSuperview];
        }else if ([data[@"imgPath"] count] > 0 && [data[@"imgPath"] count] <= 3) {
            imageArray = [data[@"imgPath"] mutableCopy];
            [self addSubview:myCollectionView];
        }else{
            [imageArray removeAllObjects];
            
            for (int i = 0; i < 3; i++) {
                [imageArray addObject:data[@"imgPath"][i]];
            }
            [self addSubview:myCollectionView];

        }
    }
    //以下动态计算Cell高度
    CGRect frame = description.frame;
//    CGFloat height = [self heightForString:description.text fontSize:14 andWidth:frame.size.width - 86];
    CGSize  lablesize = [AppUtils sizeWithString:description.text font:[UIFont systemFontOfSize:13] size:CGSizeMake(IPHONE_WIDTH - 79, 2000)];
    if (lablesize.height > 80) {
        description.numberOfLines = 5;
        frame.size.height = 80;
    }else{
        frame.size.height = lablesize.height;
    }
    description.frame = frame;
    currentY = title.frame.origin.y + title.frame.size.height + 3 + frame.size.height;
    CGFloat cellHeight = 0;
    
    if (imageArray.count > 0) {
        myCollectionView.frame = CGRectMake(71, currentY, 70 * imageArray.count, 70);
        cellHeight = currentY + 60;
        if (cellHeight < 120) {
            cellHeight =120;
        }
        [myCollectionView reloadData];
    }else{
        cellHeight = currentY + 30;
        if (cellHeight < 120) {
            cellHeight = 120;
        }else{
            cellHeight = currentY + 20;
        }
    }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, cellHeight + 10);
}


- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    CollectionViewImgCell *imgCell = (CollectionViewImgCell *)cell;
    [imgCell.img setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
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
