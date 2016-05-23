//
//  SellerCellGoods.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "SellerCellGoods.h"
#import "ShoppingCarDataSocure.h"
#import <UIImageView+AFNetworking.h>

@implementation SellerCellGoods

{
    
    __weak IBOutlet UIButton *addShopCar_light;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UIImageView *headimage;
    __weak IBOutlet UILabel *price;
    NSMutableDictionary * dataDict;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setGoodsData:(id)mydata{
    
    NSLog(@"Cell数据%@",mydata);
    
    [addShopCar_light setImage:[UIImage imageNamed:@"shopcar"] forState:UIControlStateNormal];
    addShopCar_light.enabled = YES;
    
    if ([mydata[@"stock"] isEqualToString:@"0"]) {
        [addShopCar_light setImage:[UIImage imageNamed:@"shopCar_lighi"] forState:UIControlStateNormal];
    }
    
    [headimage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",mydata[@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    dataDict = (NSMutableDictionary *)mydata;
    name.text = mydata[@"name"];
    price.text = [NSString stringWithFormat:@"%@元",mydata[@"price"]];
}

//添加到购物车
- (IBAction)addToShopCar:(UIButton *)sender {
    NSString * goodsID = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
    //库存的数量
    NSString * kucun = [NSString stringWithFormat:@"%@",dataDict[@"stock"]];
    
    NSMutableDictionary * dictEntiy = [NSMutableDictionary dictionary];
    [dictEntiy setObject:dataDict forKey:@"entity"];
    
    NSMutableDictionary * addDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:dictEntiy,@"goodslist",dataDict[@"storeId"],@"storeId",dataDict[@"name"],@"name",dataDict[@"id"],@"id",@"1",@"addNumber", nil];
    NSLog(@"添加的数据>>>>>%@",addDict);
    //购物车里面的该商品数量
    if ([kucun intValue] == 0) {//没有库存的时候
        [AppUtils showAlertMessage:@"该商品暂无库存"];
        return;
    }else{//有库存的时候判断购物车是否为空
        NSMutableArray * shopCarData = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData];
        if (shopCarData.count > 0) {
            int shopCarNum = 0;
            BOOL isExist = NO;
            for (NSMutableDictionary * shop in shopCarData) {//遍历购物车里面的商家
                for (NSMutableDictionary * goods in shop[@"goodsList"]) {//遍历商家里面的商品
                    if ([goodsID isEqualToString:goods[@"id"]]) {//该商品存在
                        shopCarNum = [goods[@"addNumber"] intValue];
                        isExist = YES;
                        break;
                        break;
                    }
                }
            }
            if (isExist) {
                if (shopCarNum < [kucun intValue]) {
                    [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:addDict addnumber:@"1"];
                    if (_numdel && [_numdel respondsToSelector:@selector(setCarNum)]) {

                        [_numdel setCarNum];
                    }
                    if (self.cellClickBlock) {
                        self.cellClickBlock(sender.center);
                    }
                }else{
//                    [AppUtils showAlertMessage:[NSString stringWithFormat:@"库存%@件,已达到库存上限",kucun]];
                    [AppUtils showAlertMessage:@"购买数已到当前库存最大数"];
                    //超过最多大的就修改数量为库存数量
                    if (_numdel && [_numdel respondsToSelector:@selector(setCarNum)]) {
                        
                        [_numdel setCarNum];
                    }
                }
            }
            else {
                [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:addDict addnumber:@"1"];
                if (_numdel && [_numdel respondsToSelector:@selector(setCarNum)]) {
                    
                    [_numdel setCarNum];
                }
                if (self.cellClickBlock) {
                    self.cellClickBlock(sender.center);
                }
            }
        }else{//购物车为空
            [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:addDict addnumber:@"1"];
            if (_numdel && [_numdel respondsToSelector:@selector(setCarNum)]) {
                
                [_numdel setCarNum];
            }
            if (self.cellClickBlock) {
                self.cellClickBlock(sender.center);
            }
        }
    }
}


@end
