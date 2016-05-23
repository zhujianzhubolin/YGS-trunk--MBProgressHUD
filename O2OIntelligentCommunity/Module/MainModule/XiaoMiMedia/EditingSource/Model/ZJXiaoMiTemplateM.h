//
//  ZJXiaoMiTemplateM.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/29.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJXiaoMiTemTextM.h"

@interface ZJXiaoMiTemplateM : NSObject

@property (nonatomic, copy) NSString *pageNumber; //当前页
@property (nonatomic, copy) NSString *pageSize; //每页显示条数
@property (nonatomic, copy) NSString *wyNo;
@property (nonatomic, copy) NSString *xqNo;

@property (nonatomic, strong) NSArray *list; //模板列表
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *pageCount; //总页数
@property (nonatomic, copy) NSString *templatename; //模版名称
@property (nonatomic, copy) NSString *templateImgSrc; //广告图片路径。
@property (nonatomic, copy) NSString *templateImgSrcSlt; //广告图片缩略图路径。
@property (nonatomic, copy) NSString *filePathDisk; //图片上传成功后的路径

@property (nonatomic, copy) NSString *templateSizePx; //图片的像素
@property (nonatomic, assign) CGFloat templateSizePxW; //图片的宽度总像素
@property (nonatomic, assign) CGFloat templateSizePxH; //图片的高度总像素
@property (nonatomic, copy) UIImage *photoImg; //从相册获取的图片

@property (nonatomic, strong) ZJXiaoMiTemTextM *textModel1;
@property (nonatomic, strong) ZJXiaoMiTemTextM *textModel2;
@property (nonatomic, strong) ZJXiaoMiTemTextM *textModel3;

@end
