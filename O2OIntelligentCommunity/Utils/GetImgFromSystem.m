//
//  GetImgFromSystem.m
//  图片上传
//
//  Created by user on 15/7/7.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "GetImgFromSystem.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZLPhotoPickerViewController.h"
#import "ZLCameraViewController.h"
#import "ZLPhotoAssets.h"
#import "ZLCamera.h"

@implementation GetImgFromSystem
{
    UIViewController *sourceVC;
}

+ (instancetype)getImgInstance {
    static GetImgFromSystem *getImg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getImg = [[GetImgFromSystem alloc] init];
    });
    return getImg;
}

- (id)init {
    if (self) {
        self.maxCount = 9;
    }
    return self;
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self openCamera];
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}

- (void)openCamera{

    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVc.maxCount = self.maxCount;
    cameraVc.callback = ^(NSArray *cameras){
        NSMutableArray *imgArr = [NSMutableArray array];
        [cameras enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             ZLCamera *photoCamera = obj;
            [imgArr addObject:photoCamera.photoImage];
        }];
        if (_delegate && [_delegate respondsToSelector:@selector(getFromImg:)]) {
            [_delegate getFromImg:imgArr];
        }
    };
    [cameraVc showPickerVc:sourceVC];
}

- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = self.maxCount;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:sourceVC];
    
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *imgArr = [NSMutableArray array];
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZLPhotoAssets *photoAsset = obj;
            [imgArr addObject:photoAsset.originImage];
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(getFromImg:)]) {
            [_delegate getFromImg:imgArr];
        }
    };
}

- (void)getImgFromVC:(UIViewController *)viewController {
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
    
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    sourceVC = viewController;
}

@end
