//
//  uploadCollectionCell.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#define TAG_BEGIN_CELL 100

#import <UIKit/UIKit.h>

@protocol didSelectImgBtn <NSObject>

-(void)didimgBtn:(NSInteger)tag;

-(void)didimgBtnIndex:(NSInteger)btnIndex cellIndex:(NSUInteger)cellIndex;
@end

@interface uploadCollectionCell : UICollectionViewCell
@property (nonatomic,assign)NSUInteger cellIndex;
@property (strong,nonatomic)UIButton *imageBtn;

@property(nonatomic,weak)id<didSelectImgBtn>didimgbtnDeletget;

@end
