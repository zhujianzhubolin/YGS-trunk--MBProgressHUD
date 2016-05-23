//
//  ZYXiaoMiPayVC.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/25.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "ZYXiaoMiPlayerModel.h"

typedef NS_ENUM(NSUInteger, DownOrderPerAginDownOrder){//直接下单还是重现下单
    DownOrder = 0,
    AginDownOrder
};

typedef NS_ENUM(NSUInteger, ArtworkPerTemplate){//原图还是模版
    Artwork = 0,
    Template
};



@interface ZYXiaoMiPayVC : O2OBaseViewController

@property (nonatomic,strong)ZYXiaoMiPlayerModel *milletM;
@property (nonatomic,strong)NSDictionary *downOrderDic;//下单字典
@property (nonatomic)DownOrderPerAginDownOrder downOrderType;
@property (nonatomic)ArtworkPerTemplate typeClose;
@property (nonatomic,copy)NSString *money;//原图的情况下需要传金额

@end
