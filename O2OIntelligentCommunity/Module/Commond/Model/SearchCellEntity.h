//
//  SystemCellEntity.h
//  Search
//
//  Created by user on 15/7/4.
//  Copyright (c) 2015年 hei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchCellEntity : NSObject

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, copy) NSString *searchString; //搜索的内容
@property (nonatomic, strong) UIView *accessoryView;

@property (nonatomic, strong) id dataSource;
@end
