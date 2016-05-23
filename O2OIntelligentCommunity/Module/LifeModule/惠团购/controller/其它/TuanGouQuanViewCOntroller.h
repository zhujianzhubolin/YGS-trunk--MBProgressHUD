//
//  TuanGouQuanViewCOntroller.h
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/15.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "DaiJinQuanModel.h"

typedef NS_ENUM(NSInteger,PayStyle) {
    StoreType,
    TuanGouType
};

//惠团购的，因为只有一个商家，所以不需要确定Index;
@protocol SendQuanModel <NSObject>

- (void)quanModel:(DaiJinQuanModel *)model;

@end

//网上商城，涉及到多商家，要指定刷新某一行
@protocol StoreQuan <NSObject>

- (void)shangCheng:(DaiJinQuanModel *)model index:(NSInteger )section;

@end

@interface TuanGouQuanViewCOntroller : O2OBaseViewController

@property(nonatomic,assign) PayStyle mystyle;

//商城选择代金券，用于刷选择行
@property(nonatomic,assign) NSInteger section;

@property(nonatomic,strong) NSString * shopId;

//满足最低使用条件
@property(nonatomic,strong) NSString * bounds;

//已经选择了的券
@property(nonatomic,strong) NSMutableArray * selectArray;

//团购代理
@property(nonatomic,weak) id <SendQuanModel> quanDelegate;
//商城传券代理
@property(nonatomic,weak) id <StoreQuan> shangchengquanDelegate;


@end
