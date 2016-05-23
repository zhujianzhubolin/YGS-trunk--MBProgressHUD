//
//  ShoppingCarDataSocure.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCarDataSocure : NSObject

+(ShoppingCarDataSocure *)sharedShoppingCar;

//购物车数量
- (NSInteger)getShoppingCarNum;

//清空购物车
- (void)deleAllGoods;

//添加到购物车
- (void)addGoodsToShopCar:(NSMutableDictionary *)dict addnumber:(NSString *)addNumber;

//获取购物车数据
- (NSMutableArray *)getShoppingCarData;

//购物车数量加
- (void)addShoppingCarNum:(NSString *)storeid goodsID:(NSString *)goodsID number:(NSString *)number;

//购物车数量减
- (void)JianShoppingCarNum:(NSString *)storeid goodsID:(NSString *)goodsID number:(NSString *)number;

//直接删除购物车数据
- (void)DeleGoodsFromShoppingCar:(NSString *)storeID goodsID:(NSString *)goodsID;

@end
