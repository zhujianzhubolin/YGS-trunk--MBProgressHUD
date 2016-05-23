//
//  BuyViewController.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ShangChengPerhapsTaunGou){
    ShopClass = 0,
    taunGouClass
};

typedef NS_ENUM(NSUInteger, ShopType) {
    ShopTypeAll = 0,
    ShopTypeWaitPay,
    ShopTypeWaitShouhuo,
    ShopTypeWaitPingjia
};

#import "O2OBaseViewController.h"

@interface BuyViewController : O2OBaseViewController

@property (nonatomic)ShopType currentType;
@property (nonatomic)ShangChengPerhapsTaunGou ifShopOrTuanGou;


@end
