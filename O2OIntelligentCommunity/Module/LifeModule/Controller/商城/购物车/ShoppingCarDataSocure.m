//
//  ShoppingCarDataSocure.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShoppingCarDataSocure.h"

@implementation ShoppingCarDataSocure

{
    NSMutableArray * dataSocure;
}

+(ShoppingCarDataSocure *)sharedShoppingCar{
    
    static ShoppingCarDataSocure *shopCarData = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shopCarData = [[self alloc] init];
    });
    return shopCarData;
}

- (id)init
{
    @synchronized(self) {
        self =[super init];
        dataSocure = [NSMutableArray array];
        return self;
    }
}

//购物车数量
- (NSInteger)getShoppingCarNum{

    return [self temNum];
}

//清空购物车
- (void)deleAllGoods{
    
    [dataSocure removeAllObjects];
}

//添加到购物车
- (void)addGoodsToShopCar:(NSMutableDictionary *)dict addnumber:(NSString *)addNumber{
    
    NSMutableDictionary * adddict = dict;
    [adddict setObject:addNumber forKey:@"addNumber"];
    [adddict setObject:@"YES" forKey:@"isSelect"];
    
    NSLog(@"添加进来的数据>>>>>%@",adddict);

    if (dataSocure.count <=0) {
        
        NSMutableArray * goodslistArray = [NSMutableArray array];
        [goodslistArray addObject:adddict];
        NSDictionary *shopDic = [NSDictionary dictionaryWithObjectsAndKeys:goodslistArray,@"goodsList",adddict[@"storeId"],@"storeId",nil];
        [dataSocure addObject:shopDic];
//        NSLog(@"first %@,shopDic[goodsList] = %@",dataSocure,shopDic[@"goodsList"]);
    }else{
        
        if (([self temNum] + [addNumber intValue]) >= 200) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购物车总数量不可大于200" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        
        
        NSMutableArray *dataArr = [dataSocure mutableCopy];
        
        __block BOOL isShopExist = NO;
        [dataSocure enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx1, BOOL *stop1) {
            NSDictionary *shopDic = (NSDictionary *)obj1;
            NSLog(@"adddict[storeId] = %@,shopDic[storeId] = %@",adddict[@"storeId"],shopDic[@"storeId"]);
            
            NSString * str1 = [NSString stringWithFormat:@"%@",adddict[@"storeId"]];
            NSString * str2 = [NSString stringWithFormat:@"%@",shopDic[@"storeId"]];
            
            if ([str1 isEqualToString:str2]) {
                //商家存在
                isShopExist = YES;
                *stop1 = YES;
                
                NSArray *goodArr = shopDic[@"goodsList"];
                NSMutableArray *gaiGoodArr = [goodArr mutableCopy];
                __block BOOL isGoodExist = NO;
                
                [goodArr enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2) {
                    NSDictionary *goodDic = (NSDictionary *)obj2;
                    NSMutableDictionary *gaiGoodDic = [goodDic mutableCopy];
                    
                    
                    NSString * str3 = [NSString stringWithFormat:@"%@",adddict[@"id"]];
                    NSString * str4 = [NSString stringWithFormat:@"%@",goodDic[@"id"]];

                    if ([str3 isEqualToString:str4]) {
                        
                        //商家存在，商品也存在
                        isGoodExist = YES;
                        *stop2 = YES;
                        NSInteger num = [goodDic[@"addNumber"] intValue];
                        NSLog(@"num = %lu",num);
                        num += [adddict[@"addNumber"] intValue];
                        gaiGoodDic[@"addNumber"] = [NSString stringWithFormat:@"%ld",num];
                        [gaiGoodArr replaceObjectAtIndex:idx2 withObject:gaiGoodDic];
                        NSDictionary *shopDic = [NSDictionary dictionaryWithObjectsAndKeys:gaiGoodArr,@"goodsList",adddict[@"storeId"],@"storeId",nil];
                        [dataArr replaceObjectAtIndex:idx1 withObject:shopDic];
                    }
                }];
                
                if (!isGoodExist) {
                    //商家存在，商品不存在
                    [gaiGoodArr addObject:adddict];
                    NSDictionary *shopDic = [NSDictionary dictionaryWithObjectsAndKeys:gaiGoodArr,@"goodsList",adddict[@"storeId"],@"storeId",nil];
                    [dataArr replaceObjectAtIndex:idx1 withObject:shopDic];
                }
            }
        }];
        
        //商家不存在，商品也不会存在
        if (!isShopExist) {
            NSMutableArray * goodslistArray = [NSMutableArray array];
            [goodslistArray addObject:adddict];
            NSDictionary *goodDic = [NSDictionary dictionaryWithObjectsAndKeys:goodslistArray,@"goodsList",adddict[@"storeId"],@"storeId",nil];
            [dataArr addObject:goodDic];
        }
        dataSocure = [dataArr mutableCopy];
    }
    
}


//购物车临时数量
- (NSInteger)temNum{
    NSMutableArray * numberarray = [NSMutableArray array];
    for (NSDictionary * dict1 in dataSocure) {
        for (NSDictionary * dict2 in dict1[@"goodsList"]) {
            [numberarray addObject:dict2[@"addNumber"]];
        }
    }
    int sum = [[numberarray valueForKeyPath:@"@sum.floatValue"] intValue];
    return sum;
}

//获取购物车数据
- (NSMutableArray *)getShoppingCarData{
    
    return dataSocure;
}

//购物车数量加
- (void)addShoppingCarNum:(NSString *)storeid goodsID:(NSString *)goodsID number:(NSString *)number{

    NSLog(@"传过来的%@>>%@>>%@",storeid,goodsID,number);
    
    NSLog(@"修改前数据源>>>>>%@",dataSocure);
    
    if (([self temNum] + [number intValue]) >= 200) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购物车总数量不可大于200" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    for (NSMutableDictionary * dict in dataSocure) {
        
        NSLog(@"商品的数>>>>>%@",dict);
        
        for (NSMutableDictionary * dict1 in dict[@"goodsList"]) {
            
            if ([[dict1 allValues] containsObject:storeid] && [[dict1 allValues] containsObject:goodsID]) {
                
                NSLog(@"该商品包含");
                NSInteger dataSocureNum = [dict1[@"addNumber"] intValue];
                dataSocureNum += [number intValue];
                dict1[@"addNumber"] = [NSString stringWithFormat:@"%ld",dataSocureNum];
            }else{
                NSLog(@"修改不成功");
            }
            
        }
    }
    NSLog(@"修改后数据源>>>>>%@",dataSocure);
}
//购物车数量减
- (void)JianShoppingCarNum:(NSString *)storeid goodsID:(NSString *)goodsID number:(NSString *)number{

    NSLog(@"传过来的%@>>%@>>%@",storeid,goodsID,number);
    
    NSLog(@"修改前数据源>>>>>%@",dataSocure);

    NSMutableArray * temDataArray = [NSMutableArray arrayWithArray:dataSocure];
    for (NSMutableDictionary * shoDict in temDataArray) {
        
        NSMutableArray * tempArray =shoDict[@"goodsList"];
        
        for (NSMutableDictionary * goodsDict in tempArray) {
            
            if ([[goodsDict allValues] containsObject:storeid] && [[goodsDict allValues] containsObject:goodsID]) {
                NSLog(@"该商品包含");

                NSInteger dataSocureNum = [goodsDict[@"addNumber"] intValue];

                if (dataSocureNum == 1) {

                    [shoDict[@"goodsList"] removeObject:goodsDict];
                    
                    if (tempArray.count == 0) {
                        [dataSocure removeObject:shoDict];
                    }
                    
                    return;
                }else{
                    dataSocureNum -= [number intValue];
                    goodsDict[@"addNumber"] = [NSString stringWithFormat:@"%ld",(long)dataSocureNum];
                }
            }else{
                NSLog(@"修改不成功");
            }

        }
    }

    
    NSLog(@"修改后数据源>>>>>%@",dataSocure);

}

//直接删除购物车数据
- (void)DeleGoodsFromShoppingCar:(NSString *)storeID goodsID:(NSString *)goodsID{
    
    NSLog(@"传过来的%@>>%@",storeID,goodsID);
    //    NSLog(@"修改前数据源>>>>>%@",dataSocure);
    
    NSMutableArray * temDataArray = [NSMutableArray arrayWithArray:dataSocure];
    
    for (NSMutableDictionary * shoDict in temDataArray) {
        
        NSMutableArray * goodsArray = shoDict[@"goodsList"];
        
        NSMutableArray * tempArray =[NSMutableArray arrayWithArray:goodsArray];
        
        for (NSMutableDictionary * goodsDict in tempArray) {
            
            if ([[goodsDict allValues] containsObject:storeID] && [[goodsDict allValues] containsObject:goodsID]) {
                
                [goodsArray removeObject:goodsDict];
                
                if (goodsArray.count <= 0) {
                    
                    [dataSocure removeObject:shoDict];
                }
            }
        }
    }
    
    NSLog(@"修改后数据源>>>>>%@",dataSocure);
}


@end
