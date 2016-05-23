//
//  HuiTuanCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/20.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "HuiTuanCell.h"
#import <UIImageView+AFNetworking.h>
#import<CoreText/CoreText.h>

@implementation HuiTuanCell

{
    __weak IBOutlet UIButton *buyBtn;
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *oldPrice;
    
    
    TGGoodsModel * goods;
}

- (void)awakeFromNib {
    
    buyBtn.layer.cornerRadius = 5;
    //设置头像圆角
    headImage.contentMode = UIViewContentModeCenter;
    headImage.clipsToBounds = YES;
    
}

- (void)setData:(id)mydata distance:(NSString *)distance{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)TGGoodsCellData:(TGGoodsModel *)model{

    goods = model;
    
    
    //还未开始
    if ([model.serverTime  compare:model.groupStartDate] == NSOrderedAscending) {
        buyBtn.selected = YES;
        [buyBtn setTitle:@"即将开售" forState:UIControlStateNormal];

    }else if ([model.serverTime compare:model.groupEndDate] == NSOrderedDescending){//已经结束
        buyBtn.selected = YES;
        [buyBtn setTitle:@"已结束" forState:UIControlStateNormal];
    }else{
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        buyBtn.selected = NO;
    }
    
    
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.img]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    name.text = [NSString stringWithFormat:@"%@",model.name];
    price.text = [NSString stringWithFormat:@"%@元%@",model.price,model.standard];
    oldPrice.text = [NSString stringWithFormat:@"%@元",model.market_price];
//    oldPrice.backgroundColor = [UIColor redColor];
//    CGSize oldPriceSize = [AppUtils sizeWithString:oldPrice.text font:oldPrice.font size:CGSizeMake(IPHONE_WIDTH, oldPrice.frame.size.height)];
//    CGSize lineW = [AppUtils sizeWithString:[NSString stringWithFormat:@"%@元",model.market_price] font:[UIFont systemFontOfSize:13] size:CGSizeMake(IPHONE_WIDTH -price.frame.origin.x - price.frame.size.width - buyBtn.frame.origin.x - 9, price.frame.size.height)];
    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, price.frame.size.height/2, oldPrice.frame.size.width,1)];
//    view.backgroundColor = [AppUtils colorWithHexString:@"787878"];
//    [oldPrice addSubview:view];
}


//团购搜索专用
- (void)TGGoodsCellData:(TGGoodsModel *)model withKeyWords:(NSString *)keyWords{

    
    NSLog(@"搜索关键字>>>>%@",keyWords);

    goods = model;
    
    //还未开始
    if ([model.serverTime  compare:model.groupStartDate] == NSOrderedAscending) {
        buyBtn.selected = YES;
        [buyBtn setTitle:@"即将开售" forState:UIControlStateNormal];
        
    }else if ([model.serverTime compare:model.groupEndDate] == NSOrderedDescending){//已经结束
        buyBtn.selected = YES;
        [buyBtn setTitle:@"已结束" forState:UIControlStateNormal];
    }else{
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        buyBtn.selected = NO;
    }
    
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.img]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    NSString * nameStr = model.name;
    NSRange range;
    range = [nameStr rangeOfString:keyWords];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",nameStr]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range.location,range.length)];
    name.attributedText = str1;
    
    price.text = [NSString stringWithFormat:@"%@元%@",model.price,model.standard];
    oldPrice.text = [NSString stringWithFormat:@"%@",model.market_price];

    CGSize lineW = [AppUtils sizeWithString:[NSString stringWithFormat:@"%@元",model.market_price] font:[UIFont systemFontOfSize:13] size:CGSizeMake(IPHONE_WIDTH -price.frame.origin.x - price.frame.size.width - buyBtn.frame.origin.x, price.frame.size.height)];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, price.frame.size.height/2, lineW.width-15,1)];
    view.backgroundColor = [AppUtils colorWithHexString:@"787878"];
    [oldPrice addSubview:view];
}


//立即购买
- (IBAction)buyNow:(UIButton *)sender {
    
    NSLog(@"服务器时间%@开始时间%@结束时间%@",goods.serverTime,goods.groupStartDate,goods.groupEndDate);
    
    //还未开始
    if ([goods.serverTime  compare:goods.groupStartDate] == NSOrderedAscending) {
        
        [AppUtils showAlertMessageTimerClose:[NSString stringWithFormat:@"%@开售,详见团购详情",goods.groupStartDate]];
        return;
        
    }else if ([goods.serverTime  compare:goods.groupEndDate] == NSOrderedDescending || [goods.serverTime  compare:goods.groupEndDate] == NSOrderedSame) {//已经结束
        [AppUtils showAlertMessageTimerClose:@"团购已经结束"];
        return;
    }else{//正在进行
        if ([goods.stock intValue] <= 0) {
            [AppUtils showAlertMessageTimerClose:@"库存不足!"];
        }else{
            if (self.buyNow) {
                self.buyNow(goods);
            }
        }
    }
}



@end
