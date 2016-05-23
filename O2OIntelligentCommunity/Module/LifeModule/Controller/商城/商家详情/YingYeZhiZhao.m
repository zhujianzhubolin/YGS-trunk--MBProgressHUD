//
//  YingYeZhiZhao.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/11/10.
//  Copyright © 2015年 yiGongShe. All rights reserved.
//

#import "YingYeZhiZhao.h"
#import <UIImageView+AFNetworking.h>


@interface YingYeZhiZhao ()<UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIScrollView *_scrollview;
}
@end

@implementation YingYeZhiZhao

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.imageUrl);
    
    self.title = @"营业执照";
    
    _scrollview=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollview];
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.delegate=self;
    _scrollview.maximumZoomScale=3.0;
    _scrollview.minimumZoomScale=1.0;
    
    
    imageView = [[UIImageView alloc] initWithFrame:_scrollview.bounds];
    [_scrollview addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [imageView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
    
}

 //告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
@end
