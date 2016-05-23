//
//  SystemCellEntity.h
//  Search
//
//  Created by user on 15/7/4.
//  Copyright (c) 2015年 hei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseSearchCellEntity : NSObject

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *searchTitle;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, strong) UIView *accessoryView;
@end
