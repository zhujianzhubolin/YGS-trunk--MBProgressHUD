//
//  MultiShowing.m
//  CantonTower
//
//  Created by dlrc on 22/12/13.
//  Copyright (c) 2013年 dlrc. All rights reserved.
//
#define DATAULTIMG @"enLargeImg"

#import "MultiShowing.h"
#import "NSString+wrapper.h"
#import "WebImage.h"
#import <UIImageView+AFNetworking.h>

@implementation MultiShowing
{
//    UIButton *shareButton;
}
@synthesize superViewController,is_Showing;

- (void) ShowImageGalleryFromView:(UIView*) view ImageList:(NSMutableArray*) imagelist ImgType:(ShowImgType)imgType Scale:(float) scale
{
    if (imagelist ==nil || [imagelist count] ==0) {
        return;
    }
    is_Showing =YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    screenframe = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:screenframe];
    
    oldframe=[view convertRect:view.bounds toView:window];
    
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0.0;
    
     MainscrollView = [[UIScrollView alloc] initWithFrame:screenframe];
     MainscrollView.tag =0;
    [MainscrollView setBackgroundColor:[UIColor blackColor]];
    [MainscrollView setScrollEnabled:YES];
    [MainscrollView setShowsHorizontalScrollIndicator:NO];
    [MainscrollView setShowsVerticalScrollIndicator:NO];
    
     MainscrollView.delegate = self;
    [MainscrollView setPagingEnabled:YES];
     MainscrollView.contentSize = CGSizeMake(screenframe.size.width*imagelist.count, screenframe.size.height);
    
    switch (imgType) {
        case ImgTypeFromWeb:
            [self AddWebImageWithList:imagelist Scale:scale];
            break;
        case ImgTypeFromImgName:
            [self AddNativeImageNameWithList:imagelist Scale:scale];
            break;
        case ImgTypeFromImg:
            [self AddNativeImageWithList:imagelist Scale:scale];
            break;
        default:
            return;
    }
    
    [backgroundView addSubview:MainscrollView];
    [window addSubview:backgroundView];
    
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    CGAffineTransform at =CGAffineTransformConcat(
                                                  CGAffineTransformMakeScale(oldframe.size.width/screenframe.size.width, oldframe.size.height/screenframe.size.height),
                                                  CGAffineTransformMakeTranslation(-screenframe.size.width/2+oldframe.origin.x+oldframe.size.width/2, -screenframe.size.height/2+oldframe.origin.y+oldframe.size.height/2));
    
    backgroundView.transform = at;
    [UIView animateWithDuration:0.3 animations:^{
        
        CGAffineTransform at = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 1.0),
                                                       CGAffineTransformMakeTranslation(0, 0));
        backgroundView.transform = at;
        backgroundView.alpha=1;
    } completion:^(BOOL finished)
     {
         if(imagelist.count>1)
         {
         LabelPageIndex = [[UILabel alloc] initWithFrame:CGRectMake((screenframe.size.width-100)/2, screenframe.size.height-40, 100, 30)];
         LabelPageIndex.font = [UIFont boldSystemFontOfSize:18];
         LabelPageIndex.text = [NSString stringWithFormat:@"%d / %lu",1,(unsigned long)imagelist.count];
         [LabelPageIndex setTextAlignment:NSTextAlignmentCenter];
         LabelPageIndex.textColor = [UIColor whiteColor];
         [window addSubview:LabelPageIndex];
         }
     }];
}


-(void) AddWebImageWithList:(NSMutableArray*) imageUrlList Scale:(float) scale
{
    float offset=0;
    int index=0;
    ImageList = [[NSMutableArray alloc] init];
    for (WebImage* webimage in imageUrlList) {

        NSURL *url = [NSURL URLWithString:webimage.url ];
        UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:screenframe];
             UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:DATAULTIMG]];
            [imageview setContentMode:UIViewContentModeCenter];
            imageview.bounds = screenframe;
            imageview.center = CGPointMake(screenframe.size.width/2, screenframe.size.height/2);
            
            
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
        
            __block __typeof(imageview)weakImgView = imageview;
        
            [imageview setImageWithURLRequest:requestURL
                             placeholderImage:[UIImage imageNamed:DATAULTIMG]
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *aImage) {
                NSLog(@"responseData success");
                                          
                if(aImage!=nil)
                {
                    weakImgView.image =aImage;
                    [weakImgView setContentMode:UIViewContentModeScaleAspectFit];
                    float image_w,image_h;
                    if( (aImage.size.width/screenframe.size.width)>=(aImage.size.height/screenframe.size.height) )
                    {
                        image_w = screenframe.size.width;
                        image_h = image_w*aImage.size.height/aImage.size.width;
                    }
                    else
                    {
                        image_h = screenframe.size.height;
                        image_w = image_h*aImage.size.width/aImage.size.height;
                    }
                    weakImgView.bounds = CGRectMake(0, 0, image_w, image_h);
                    weakImgView.center = CGPointMake(screenframe.size.width/2, screenframe.size.height/2);
                    UIScrollView* scrollviewSub =  (UIScrollView*) weakImgView.superview;
                    [scrollviewSub setMaximumZoomScale:scale];
                }
                else
                {
                    weakImgView.image =[UIImage imageNamed:DATAULTIMG];
                    [weakImgView setContentMode:UIViewContentModeCenter];
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                weakImgView.image =[UIImage imageNamed:DATAULTIMG];
                [weakImgView setContentMode:UIViewContentModeCenter];
            }];
        
        innerScrollView.tag = index+1;
        [innerScrollView addSubview:imageview];
        
        
        innerScrollView.center = CGPointMake(offset+screenframe.size.width/2, screenframe.size.height/2);
        [innerScrollView setShowsHorizontalScrollIndicator:NO];
        [innerScrollView setShowsVerticalScrollIndicator:NO];
        
        innerScrollView.delegate =self;
        [MainscrollView addSubview:innerScrollView];
        
        index++;
        if(index == 1)
        {
            currentimageView = imageview;
        }
        if (index == imageUrlList.count) {
            
            [MainscrollView addConstraint:[NSLayoutConstraint constraintWithItem:innerScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:MainscrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        }
        [ImageList addObject:imageview];
        
        offset =offset + screenframe.size.width;
    }
}

-(void) AddNativeImageNameWithList:(NSMutableArray*) imagePathList Scale:(float) scale
{
    NSMutableArray *imgArr = [NSMutableArray array];
    [imagePathList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *imgName = (NSString *)obj;
        if (![NSString isEmptyOrNull:imgName]) {
            [imgArr addObject:[UIImage imageNamed:obj]];
        }
    }];
    [self AddNativeImageWithList:imgArr Scale:scale];
}

- (void) AddNativeImageWithList:(NSMutableArray*) imagePathList Scale:(float) scale {
    float offset=0;
    int index=0;
    ImageList = [[NSMutableArray alloc] init];
    for (UIImage* image in imagePathList) {
        if (![image isKindOfClass:[UIImage class]]) {
            continue;
        }
//        UIImage * image = [UIImage imageNamed:imagepath];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        float image_w,image_h;
        if( (image.size.width/screenframe.size.width)>=(image.size.height/screenframe.size.height) )
        {
            image_w = screenframe.size.width;
            image_h = image_w*image.size.height/image.size.width;
        }
        else
        {
            image_h = screenframe.size.height;
            image_w = image_h*image.size.width/image.size.height;
        }
        
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
        
        imageview.bounds = CGRectMake(0, 0, image_w, image_h);
        
        
        imageview.center = CGPointMake(screenframe.size.width/2, screenframe.size.height/2);
        
        //
        UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:screenframe];
        innerScrollView.tag = index+1;
        [innerScrollView addSubview:imageview];
        
        
        innerScrollView.center = CGPointMake(offset+screenframe.size.width/2, screenframe.size.height/2);
        [innerScrollView setShowsHorizontalScrollIndicator:NO];
        [innerScrollView setShowsVerticalScrollIndicator:NO];
        [innerScrollView setMaximumZoomScale:scale];
        innerScrollView.delegate =self;
        [MainscrollView addSubview:innerScrollView];
        
        index++;
        if(index == 1)
        {
            currentimageView = imageview;
        }
        if (index == imagePathList.count) {
            
            [MainscrollView addConstraint:[NSLayoutConstraint constraintWithItem:innerScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:MainscrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        }
        [ImageList addObject:imageview];
        
        offset =offset + screenframe.size.width;
        
    }
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollViewSub
{
    return currentimageView;
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollViewSub
{
    CGFloat offsetX = (scrollViewSub.bounds.size.width > scrollViewSub.contentSize.width)?(scrollViewSub.bounds.size.width - scrollViewSub.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollViewSub.bounds.size.height > scrollViewSub.contentSize.height)?(scrollViewSub.bounds.size.height - scrollViewSub.contentSize.height)/2 : 0.0;
    currentimageView.center = CGPointMake(scrollViewSub.contentSize.width/2 + offsetX,scrollViewSub.contentSize.height/2 + offsetY);
    
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollViewMain
{
    if (scrollViewMain.tag ==0) {
        int index = fabs(scrollViewMain.contentOffset.x)/scrollViewMain.frame.size.width;
        
        if (ImageIndex != index) {

            currentimageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            currentimageView.center = CGPointMake(screenframe.size.width/2, screenframe.size.height/2);
            UIScrollView* scrollviewSub =  (UIScrollView*) currentimageView.superview;
            scrollviewSub.contentSize  = CGSizeMake(screenframe.size.width, screenframe.size.height);
            ImageIndex = index;
            
            currentimageView = [ImageList objectAtIndex:ImageIndex];
            if (LabelPageIndex) {
                LabelPageIndex.text = [NSString stringWithFormat:@"%d / %lu",ImageIndex+1,(unsigned long)ImageList.count];
            }
            
            
        }
        
        
    }
    
}




-(void)hideImage:(UITapGestureRecognizer*)tap{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    if (LabelPageIndex)
    [LabelPageIndex removeFromSuperview];
    
    UIView *backgroundView=tap.view;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        CGAffineTransform at =CGAffineTransformConcat(
                                                      CGAffineTransformMakeScale(oldframe.size.width/screenframe.size.width, oldframe.size.height/screenframe.size.height),
                                                      CGAffineTransformMakeTranslation(-screenframe.size.width/2+oldframe.origin.x+oldframe.size.width/2, -screenframe.size.height/2+oldframe.origin.y+oldframe.size.height/2));        backgroundView.transform = at;
        backgroundView.alpha=0;
    } completion:^(BOOL finished)
     {
         [backgroundView removeFromSuperview];
         [ImageList removeAllObjects];
         is_Showing =NO;
     }];
    
    
}

@end
