//
//  NeightbourHoodCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define singleRowNum 3

#import "NeightbourHoodCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSArray+wrapper.h"
#import "NSString+wrapper.h"
#import "CollectionViewImgCell.h"
#import "MultiShowing.h"
#import "WebImage.h"

@implementation NeightbourHoodCell
{
    NSMutableArray *imgarr;
    UICollectionView *CollectionView;
    MultiShowing *multShow;
    CGFloat itemWidth;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        itemWidth = [NeightbourHoodCell  itemWidthImg];
        [self initUI];
    }
    return self;
}

+ (CGFloat)itemWidthImg {
    return (IPHONE_WIDTH - G_INTERVAL * (singleRowNum + 2)) / (singleRowNum + 1);
}

+ (CGFloat)headImgWidth {
    return [NeightbourHoodCell itemWidthImg] - G_INTERVAL*3;
}

+ (CGFloat)nameHeight {
    return [NeightbourHoodCell itemWidthImg] /3;
}

+ (CGFloat)timeLHeight {
    return G_INTERVAL - 5 + [NeightbourHoodCell nameHeight] *2;
}

#pragma mark 初始化视图
-(void)initUI
{
    _headimg = [[UIImageView alloc]initWithFrame:CGRectMake(G_INTERVAL, G_INTERVAL, [NeightbourHoodCell headImgWidth], [NeightbourHoodCell headImgWidth])];
    NSLog(@"itemWidth==%f",itemWidth);
    _headimg.layer.masksToBounds=YES;
    _headimg.layer.cornerRadius=(itemWidth-G_INTERVAL*3)/2;
    _headimg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headimg];
    
    //UIFont *kFontSize = [UIFont systemFontOfSize:13];
    CGFloat klabeHeight = [NeightbourHoodCell nameHeight];
    CGFloat nameG_INTERVAL = 2;
    _nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(nameG_INTERVAL,
                                                         CGRectGetMaxY(_headimg.frame),
                                                         CGRectGetMaxX(_headimg.frame) + G_INTERVAL - nameG_INTERVAL,
                                                         klabeHeight)];
    
    _nameLabe.textAlignment = NSTextAlignmentCenter;
    _nameLabe.font =[UIFont systemFontOfSize:13];
    _nameLabe.adjustsFontSizeToFitWidth = YES;
    _nameLabe.minimumScaleFactor = 9;
    [self addSubview:_nameLabe];
    
    CGFloat classLwidth = 60;
    _classifyLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headimg.frame) + G_INTERVAL,_headimg.frame.origin.y, classLwidth, klabeHeight)];
    _classifyLabe.textColor =[AppUtils colorWithHexString:@"fa6900"];
    _classifyLabe.textAlignment=NSTextAlignmentLeft;
    _classifyLabe.font=[UIFont systemFontOfSize:13];
    //_classifyLabe.backgroundColor=[UIColor redColor];
    [self addSubview:_classifyLabe];
    
    _biaotiLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_classifyLabe.frame),
                                                           _classifyLabe.frame.origin.y-5,
                                                           IPHONE_WIDTH - CGRectGetMaxX(_classifyLabe.frame) - G_INTERVAL,
                                                           klabeHeight)];
    _biaotiLabe.textAlignment=NSTextAlignmentLeft;
    _biaotiLabe.font = [UIFont systemFontOfSize:13];
    [self addSubview:_biaotiLabe];
    //_biaotiLabe.backgroundColor =[UIColor blueColor];

    _timeLabe = [[UILabel alloc]initWithFrame:CGRectMake(_classifyLabe.frame.origin.x,
                                                         CGRectGetMaxY(_biaotiLabe.frame),
                                                         IPHONE_WIDTH - CGRectGetMaxX(_headimg.frame) - G_INTERVAL,
                                                         klabeHeight)];
    _timeLabe.textColor=[UIColor grayColor];
    _timeLabe.textAlignment=NSTextAlignmentLeft;
    _timeLabe.font = [UIFont systemFontOfSize:12];
    [self addSubview:_timeLabe];
    
    _contentLabe = [[UILabel alloc]initWithFrame:CGRectMake(_timeLabe.frame.origin.x, CGRectGetMaxY(_timeLabe.frame), _timeLabe.frame.size.width, klabeHeight)];
    //_contentLabe.backgroundColor=[UIColor redColor];
    _contentLabe.textColor = [AppUtils colorWithHexString:@"787878"];
    _contentLabe.font = [UIFont systemFontOfSize:FONT_SIZE];
    _contentLabe.numberOfLines =0;
    
    [self addSubview:_contentLabe];
    
    //初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headimg.frame) + G_INTERVAL, CGRectGetMaxY(_contentLabe.frame), itemWidth * singleRowNum + G_INTERVAL * 2, 0) collectionViewLayout:flowLayout];
    
    [CollectionView registerClass:[CollectionViewImgCell class] forCellWithReuseIdentifier:SYSTEM_CELL_Col_ID];
    CollectionView.scrollEnabled = NO;
    CollectionView.userInteractionEnabled = YES;
    CollectionView.backgroundColor = [UIColor whiteColor];
    CollectionView.dataSource = self;
    CollectionView.delegate = self;
    [self addSubview:CollectionView];
}

//1）.对于单行文本数据的显示调用+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;方法来得到文本宽度和高度。
//2）.对于多行文本数据的显示调用- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context ;方法来得到文本宽度和高度；同时注意在此之前需要设置文本控件的numberOfLines属性为0。
#pragma mark  设置话题
-(void)sethuatidic:(HuaTiListModel *)huatim isShowAll:(BOOL)isShowAll
{
    //头像
    [_headimg setImageWithURL:[NSURL URLWithString:huatim.photourl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    _nameLabe.text=huatim.nickName;
    if (![huatim.activityType isEqual:[NSNull null]]) {
        _classifyLabe.text=[NSString stringWithFormat:@"[%@]",huatim.activityType];
        
        CGSize activityTypeSize = [_classifyLabe.text boundingRectWithSize:CGSizeMake(100, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_contentLabe.font} context:nil].size;
        _classifyLabe.frame=CGRectMake(CGRectGetMaxX(_headimg.frame) + G_INTERVAL,_headimg.frame.origin.y, activityTypeSize.width,_classifyLabe.frame.size.height );
        
    }
    _biaotiLabe.text=huatim.title;
    _biaotiLabe.frame=CGRectMake(CGRectGetMaxX(_classifyLabe.frame)+G_INTERVAL,_headimg.frame.origin.y ,IPHONE_WIDTH-CGRectGetMaxX(_classifyLabe.frame)-G_INTERVAL*2 , _biaotiLabe.frame.size.height);
    _timeLabe.text=huatim.createTimeStr;
    
    //话题内容
    if ([NSString isEmptyOrNull:huatim.activityContent])
    {
        _contentLabe.text=@"未知";
    }
    else
    {
        _contentLabe.text=huatim.activityContent;
    }
    
    CGFloat contentWidth  =IPHONE_WIDTH -(_headimg.frame.size.width+G_INTERVAL*3);
    CGFloat contentHeight = [NeightbourHoodCell cellContentHeightForContentStr:_contentLabe.text
                                                                     isShowAll:isShowAll];
    if (!isShowAll) {
        if (contentHeight > 90) {
            contentHeight = 90;
        }
        CGRect contentR =CGRectMake(_timeLabe.frame.origin.x, CGRectGetMaxY(_timeLabe.frame), contentWidth, contentHeight);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _contentLabe.frame = contentR;
        });
    }
    else {
        CGRect contentR =CGRectMake(_timeLabe.frame.origin.x, CGRectGetMaxY(_timeLabe.frame), contentWidth, contentHeight);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _contentLabe.frame = contentR;
        });
    }
    
    if ([NSArray isArrEmptyOrNull:huatim.imgPath]) {
        [imgarr removeAllObjects];
        [CollectionView removeFromSuperview];

        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                [NeightbourHoodCell cellHigth:huatim
                                                    isShowAll:isShowAll]);
    }
    else {
        [self addSubview:CollectionView];
        imgarr =[huatim.imgPath mutableCopy];
        [CollectionView reloadData];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            CollectionView.frame = CGRectMake(_contentLabe.frame.origin.x,
                                              CGRectGetMaxY(_timeLabe.frame) + contentHeight,
                                              CollectionView.frame.size.width,
                                              [NeightbourHoodCell cellCollectionViewHeightForImgCount:imgarr.count]);
        });

        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                [NeightbourHoodCell cellHigth:huatim
                                                    isShowAll:isShowAll]);
    }
}

+ (CGFloat)cellContentHeightForContentStr:(NSString *)text
                                isShowAll:(BOOL)isShowAll
{
    if ([NSString isEmptyOrNull:text]) {
        text = @"未知";
    }
    
    CGSize contentSize = [AppUtils sizeWithString:text
                                             font:[UIFont systemFontOfSize:FONT_SIZE]
                                             size:CGSizeMake(IPHONE_WIDTH -([NeightbourHoodCell headImgWidth]+G_INTERVAL*3),MAXFLOAT)];
    if (isShowAll) {
        return contentSize.height;
    }
   
    return MIN(contentSize.height, 90);
};

+ (CGFloat)cellCollectionViewHeightForImgCount:(NSUInteger)imgCount
{
    NSUInteger rows = (imgCount % singleRowNum > 0 ? (imgCount / singleRowNum + 1) : (imgCount / singleRowNum));
    return rows * (G_INTERVAL + [NeightbourHoodCell itemWidthImg]);
};

+ (CGFloat)cellHigth:(HuaTiListModel *)huatiM
           isShowAll:(BOOL)isShowAll{
    CGFloat contentHeight = [NeightbourHoodCell cellContentHeightForContentStr:huatiM.activityContent
                                                       isShowAll:isShowAll];
    CGFloat contentImgHeight = [NeightbourHoodCell cellCollectionViewHeightForImgCount:huatiM.imgPath.count];
    
    if (contentImgHeight == 0) {
        return [NeightbourHoodCell timeLHeight] *2 + contentHeight+ G_INTERVAL > G_INTERVAL *2 + [NeightbourHoodCell headImgWidth] + [NeightbourHoodCell nameHeight] ? [NeightbourHoodCell timeLHeight] + contentHeight+ G_INTERVAL : [NeightbourHoodCell timeLHeight];
    }
    return [NeightbourHoodCell timeLHeight] + contentHeight + contentImgHeight + G_INTERVAL;
}

- (void)refreshCollectionViewForCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    CollectionViewImgCell *imgCell = (CollectionViewImgCell *)cell;
    [imgCell.img setImageWithURL:[NSURL URLWithString:[imgarr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
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
    return  UIEdgeInsetsMake(G_INTERVAL, 0, 0, 0);
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
    return CGSizeMake(itemWidth,itemWidth);
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
    return imgarr.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [imgarr objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    CollectionViewImgCell * cell = (CollectionViewImgCell *)[CollectionView cellForItemAtIndexPath:indexPath];
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
