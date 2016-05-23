//
//  GoodsShopsCommentsVC.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/10/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TgorSc){
    ScClass = 0,
    TgClass
};


#import "O2OBaseViewController.h"
#import "MineBuyorderM.h"
#import "MineBuyGoodM.h"
#import "MineBuyShopsM.h"
typedef void(^CommentSuccessBlock)();

@interface GoodsShopsCommentsVC : O2OBaseViewController

@property (nonatomic)TgorSc ifTgorSc;
@property (atomic,strong)MineBuyorderM *orderM;
@property (strong,nonatomic)MineBuyShopsM *mineshopsM;

@property (nonatomic,strong)CommentSuccessBlock commentSuccessBlock;
@end
