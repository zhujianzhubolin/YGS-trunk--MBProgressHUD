//
//  GetImgFromSystem.h
//  图片上传
//
//  Created by user on 15/7/7.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GetImgFromSystemDelegate <NSObject>

- (void)getFromImg:(NSArray *)imgArr;

@end
@interface GetImgFromSystem : NSObject <UIActionSheetDelegate>
@property (nonatomic,weak) id<GetImgFromSystemDelegate>delegate;
@property (nonatomic,assign) NSInteger maxCount;
+ (instancetype)getImgInstance;
- (void)getImgFromVC:(UIViewController *)viewController;
@end
