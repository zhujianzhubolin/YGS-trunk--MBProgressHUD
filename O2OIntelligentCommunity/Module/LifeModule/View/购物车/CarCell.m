//
//  CarCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/16.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CarCell.h"
#import "ShoppingCarDataSocure.h"
#import <UIImageView+AFNetworking.h>
@implementation CarCell

{
    
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UIButton *DeleteBtn;
    __weak IBOutlet UILabel *number;
    __weak IBOutlet UILabel *goodsname;
    __weak IBOutlet UILabel *goodsPrice;
    
    NSMutableDictionary * cellDict;
    NSIndexPath * myIndex;
    NSString * isSelect;
}

- (void)awakeFromNib {
    DeleteBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//商品数量减
- (IBAction)numbermis:(UIButton *)sender {
    //增加购物车数量主要是通过修改数据源中的addNumber字段来操作数据源
    [[ShoppingCarDataSocure sharedShoppingCar] JianShoppingCarNum:cellDict[@"storeId"] goodsID:cellDict[@"id"] number:@"1"];
    
    if (_numdele && [_numdele respondsToSelector:@selector(senderGoodsNum:)]) {
        
        [_numdele senderGoodsNum:myIndex];
        
    }
}

//商品数量加
- (IBAction)numberPlus:(UIButton *)sender {
    
    NSLog(@"商品的字典>>>>%@",cellDict);
    
    NSInteger goodsNum = [cellDict[@"addNumber"] intValue];
    NSInteger kucun = [cellDict[@"goodslist"][@"entity"][@"stock"] intValue];
    if (goodsNum >= kucun) {
        
//        [AppUtils showAlertMessage:[NSString stringWithFormat:@"已达库存%ld件上限",(long)kucun]];
        [AppUtils showAlertMessage:@"购买数已到当前库存最大数"];
        return;
        
    }else{
        //增加购物车数量主要是通过修改数据源中的addNumber字段来操作数据源
        [[ShoppingCarDataSocure sharedShoppingCar] addShoppingCarNum:cellDict[@"storeId"] goodsID:cellDict[@"id"] number:@"1"];
        if (_numdele && [_numdele respondsToSelector:@selector(senderGoodsNum:)]) {
            [_numdele senderGoodsNum:myIndex];
        }
    }
}

////删除商品
//- (IBAction)deleGoods:(UIButton *)sender {
//    if (self.selectOrNot) {
//        
//        [[ShoppingCarDataSocure sharedShoppingCar] DeleGoodsFromShoppingCar:cellDict[@"storeId"] goodsID:cellDict[@"id"]];
//        
//        if (_numdele && [_numdele respondsToSelector:@selector(senderGoodsNum:)]) {
//            
//            [_numdele senderGoodsNum:myIndex];
//            
//        }
//        
//    }else{
//        
//        NSLog(@"未勾选，不做任何事");
//        sender.userInteractionEnabled = NO;
//
//    }
//}

//前面的圆圈勾选
- (IBAction)gouxuan:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        cellDict[@"isSelect"] = @"YES";
    }else{
        cellDict[@"isSelect"] = @"NO";
    }
    if (_gouSelect && [_gouSelect respondsToSelector:@selector(finishGou:)]) {
        [_gouSelect finishGou:myIndex];
    }
}


//传到Cell里面的数据
- (void)setCellData:(NSMutableDictionary *)myData isShow:(BOOL)isShow index:(NSIndexPath *)index{
    
    NSLog(@"Cell 数据源>>>%@",myData);
    
    myIndex = index;
    if (isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            DeleteBtn.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            DeleteBtn.hidden = YES;
        }];
    }
    
    NSLog(@"CellData>>>>>%@",myData);
    cellDict = myData;
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",myData[@"goodslist"][@"entity"][@"img"]]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    goodsname.text = [NSString stringWithFormat:@"%@",myData[@"goodslist"][@"entity"][@"name"]];
    goodsPrice.text = [NSString stringWithFormat:@"%@元",myData[@"goodslist"][@"entity"][@"price"]];
    number.text = [NSString stringWithFormat:@"%@",myData[@"addNumber"]];
    isSelect = [NSString stringWithFormat:@"%@",myData[@"isSelect"]];
    
    if ([isSelect isEqualToString:@"YES"]) {
        self.selectOrNot.selected = YES;
    }else{
        self.selectOrNot.selected = NO;
    }
}

@end
