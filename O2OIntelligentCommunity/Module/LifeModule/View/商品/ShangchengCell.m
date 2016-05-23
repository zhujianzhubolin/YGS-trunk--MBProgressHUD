//
//  ShangchengCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "ShangchengCell.h"
#import "ShoppingCarDataSocure.h"
#import <UIImageView+AFNetworking.h>

@implementation ShangchengCell

{
    NSDictionary * dataDict;
    
    __weak IBOutlet UIView *lineL;
    __weak IBOutlet UIButton *addbtn;
    __weak IBOutlet UILabel *oldPrice;
    __weak IBOutlet UILabel *newPrice;
    __weak IBOutlet UILabel *goodsname;
    __weak IBOutlet UIImageView *cellImage;
    
}

- (void)awakeFromNib {
//    cellImage.contentMode = UIViewContentModeCenter;
//    cellImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)getDataFromeController:(id)object{
    
    NSLog(@"cell data >>>>%@",object);
    [addbtn setImage:[UIImage imageNamed:@"shopcar"] forState:UIControlStateNormal];
    addbtn.enabled = YES;
    
    //库存为零禁止加入购物车
    if ([object[@"stock"] isEqualToString:@"0"]) {
        [addbtn setImage:[UIImage imageNamed:@"shopCar_lighi"] forState:UIControlStateNormal];
//        addbtn.enabled = NO;
    }
    
    dataDict = (NSDictionary *)object;
    [cellImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object[@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    newPrice.text = [NSString stringWithFormat:@"%@元", object[@"price"]];
    oldPrice.text = [NSString stringWithFormat:@"%@元",object[@"market_price"]];
    CGSize lineSize = [AppUtils sizeWithString:oldPrice.text font:oldPrice.font size:oldPrice.frame.size];
    dispatch_async(dispatch_get_main_queue(), ^{
        lineL.frame = CGRectMake(oldPrice.frame.origin.x + lineSize.width / 2 - lineSize.width /2, oldPrice.center.y, lineSize.width, lineL.frame.size.height);
    });
    
    goodsname.text = object[@"name"];
}

//添加到购物车
- (IBAction)addToShoppingCar:(UIButton *)sender {
    
//    NSLog(@"购物车里面的数据>>>>%@",[[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData]);
    NSString * storeID = [NSString stringWithFormat:@"%@",dataDict[@"storeId"]];
    NSString * storeName = [NSString stringWithFormat:@"%@",dataDict[@"name"]];
    NSString * goodsID = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
    
    
    NSMutableDictionary * dictEntiy = [NSMutableDictionary dictionary];
    [dictEntiy setObject:dataDict forKey:@"entity"];
    NSMutableDictionary * adddict = [NSMutableDictionary dictionaryWithObjectsAndKeys:storeID,@"storeId",storeName,@"name",dictEntiy,@"goodslist",goodsID,@"id", nil];
    
    
    //库存的数量
    NSString * kucun = [NSString stringWithFormat:@"%@",dataDict[@"stock"]];
    NSMutableArray * shopCarData = [[ShoppingCarDataSocure sharedShoppingCar] getShoppingCarData];
    //购物车里面的该商品数量
    if ([kucun intValue] == 0) {//没有库存的时候
        [AppUtils showAlertMessage:@"该商品暂无库存"];
        return;
    }else{//有库存的时候判断购物车是否为空
        if (shopCarData.count > 0) {//有库存，但是购物车为空
            
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
                    [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:adddict addnumber:@"1"];
                    
                    
                    if (self.cellClickBlock) {
                        self.cellClickBlock(sender.center);
                    }
                    if (_numDele && [_numDele respondsToSelector:@selector(setNewNum)]) {
                        [_numDele setNewNum];
                    }
                }else{
//                    [AppUtils showAlertMessage:[NSString stringWithFormat:@"库存%@件,已达到库存上限",kucun]];
                    [AppUtils showAlertMessage:@"购买数已到当前库存最大数"];
                    //超过最多大的就修改数量为库存数量
                    if (_numDele && [_numDele respondsToSelector:@selector(setNewNum)]) {
                        [_numDele setNewNum];
                    }
                }
            }
            else {
                [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:adddict addnumber:@"1"];
                if (self.cellClickBlock) {
                    self.cellClickBlock(sender.center);
                }
                
                if (_numDele && [_numDele respondsToSelector:@selector(setNewNum)]) {
                    [_numDele setNewNum];
                }
            }
        }else{
            [[ShoppingCarDataSocure sharedShoppingCar] addGoodsToShopCar:adddict addnumber:@"1"];
            
            if (self.cellClickBlock) {
                self.cellClickBlock(sender.center);
            }
            
            if (_numDele && [_numDele respondsToSelector:@selector(setNewNum)]) {
                [_numDele setNewNum];
            }
        }
    }

}

@end
