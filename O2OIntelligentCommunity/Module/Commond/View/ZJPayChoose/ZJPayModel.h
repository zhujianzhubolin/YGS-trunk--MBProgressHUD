//
//  ZJPayModel.h
//  testZHIFU
//
//  Created by user on 16/3/4.
//  Copyright © 2016年 ygs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJPayModel : NSObject
@property (nonatomic, copy) NSString *payImgStr;
@property (nonatomic, copy) NSString *payName;
@property (nonatomic, copy) NSString *selectedImgStr;
@property (nonatomic, copy) NSString *unselectedImgStr;
@property (nonatomic, assign) BOOL isSelected;
@end
