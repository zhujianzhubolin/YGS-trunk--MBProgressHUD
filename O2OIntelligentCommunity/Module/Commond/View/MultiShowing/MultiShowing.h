//
//  MultiShowing.h
//  CantonTower
//
//  Created by dlrc on 22/12/13.
//  Copyright (c) 2013年 dlrc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LinkType) {
    LinkTypeVideo,
    LinkTypeOneBigImage,
    LinkTypeImageGallery
};
typedef NS_ENUM(NSUInteger, ShowImgType) {
    ImgTypeFromWeb,
    ImgTypeFromImgName,
    ImgTypeFromImg
};

@interface MultiShowing : NSObject<UIScrollViewDelegate>
{
    CGRect oldframe;
    CGRect screenframe;
    UIImageView *currentimageView;
    UILabel * LabelPageIndex;
    UIScrollView *MainscrollView;
    NSMutableArray *ImageList;
    int ImageIndex;
}
@property UIViewController *superViewController;
@property LinkType linktype;
@property bool is_Showing;

- (void) ShowImageGalleryFromView:(UIView*) view ImageList:(NSMutableArray*) imagelist ImgType:(ShowImgType)imgType Scale:(float) scale;
@end
