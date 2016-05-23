//
//  ZJXiaoMiPublishHeaderTBV.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJXiaoMiRuleHeaderV.h"
#import "UserManager.h"
#import "MultiShowing.h"
#import "WebImage.h"
#import <UIImageView+AFNetworking.h>
#import "ZJNoDeviceCell.h"

@interface ZJXiaoMiRuleHeaderV () 

@property (nonatomic,strong) MultiShowing *multiShow;
@property (nonatomic,strong) ZJNoDeviceCell *xqInfoCell;

@end

@implementation ZJXiaoMiRuleHeaderV
{
    __weak IBOutlet UIImageView *imgV;
    __weak IBOutlet UIView *xqInfoButtomV;
}

- (ZJNoDeviceCell *)xqInfoCell {
    if (_xqInfoCell == nil) {
        _xqInfoCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZJNoDeviceCell class]) owner:self options:nil] lastObject];
    }
    return _xqInfoCell;
}

- (MultiShowing *)multiShow {
    if (_multiShow == nil) {
        _multiShow = [MultiShowing new];
    }
    return _multiShow;
}

- (void)updateUIForComInfo:(BingingXQModel *)comM {
    [self.xqInfoCell updateUIForComInfo:comM];
}

- (void)updateUIForXiaoMiJiQiNum:(NSUInteger)jiqiNum {
    [self.xqInfoCell updateUIForXiaoMiJiQiNum:jiqiNum];
}

- (void)setTmpM:(ZJXiaoMiTemplateM *)tmpM {
    _tmpM = tmpM;
    [imgV setImageWithURL:[NSURL URLWithString:self.tmpM.templateImgSrcSlt] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
}

- (void)awakeFromNib {
    [xqInfoButtomV addSubview:self.xqInfoCell];
    [self updateUIForComInfo:[UserManager shareManager].comModel];
    
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds = YES;
    imgV.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVChickAction)];
    [imgV addGestureRecognizer:singleTap];
}

-(void)imgVChickAction
{
    NSMutableArray *imgArr = [NSMutableArray array];
    WebImage *webImg = [WebImage new];
    webImg.url = self.tmpM.templateImgSrc;
    [imgArr addObject:webImg];

    [self.multiShow ShowImageGalleryFromView:self ImageList:imgArr ImgType:ImgTypeFromWeb Scale:2.0];
}

@end
