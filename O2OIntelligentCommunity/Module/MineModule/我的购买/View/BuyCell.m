//
//  BuyCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BuyCell.h"
#import <UIImageView+AFNetworking.h>

@implementation BuyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat interval = 10;
        CGFloat imgWidth =70;
        self.commodityimg = [[UIImageView alloc]initWithFrame:CGRectMake(interval, interval, imgWidth, imgWidth)];
        self.commodityimg.image =[UIImage imageNamed:@"defaultImg"];
//        self.commodityimg.contentMode = UIViewContentModeCenter;
//        self.commodityimg.clipsToBounds = YES;
        [self addSubview:self.commodityimg];
        
        self.describeLabe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.commodityimg.frame) + interval,
                                                                     interval,
                                                                     IPHONE_WIDTH - CGRectGetMaxY(self.commodityimg.frame) - interval - interval -self.UnitpriceLabe.frame.size.width,
                                                                     40)];
        self.describeLabe.text=@"商品描述";
        self.describeLabe.numberOfLines=2;
        self.describeLabe.font=[UIFont systemFontOfSize:15];
        //self.describeLabe.backgroundColor =[UIColor blueColor];
        [self addSubview:self.describeLabe];

        
        self.UnitpriceLabe = [[UILabel alloc]init];
        //self.UnitpriceLabe.backgroundColor=[UIColor blueColor];
        
        CGFloat unitPriceW = 100;
        self.UnitpriceLabe.frame=CGRectMake(IPHONE_WIDTH - interval - unitPriceW, interval, unitPriceW, 30);
        self.UnitpriceLabe.textAlignment=NSTextAlignmentRight;
        self.UnitpriceLabe.font=  [UIFont systemFontOfSize:17];
        self.UnitpriceLabe.text = @"00.00元";
        
        CGFloat numberLWidth = 60;
        self.numberLabe = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH - interval - numberLWidth-3, CGRectGetMaxY(self.UnitpriceLabe.frame), numberLWidth,25)];
        self.numberLabe.textAlignment=NSTextAlignmentRight;
        self.numberLabe.font=  [UIFont systemFontOfSize:13];
        self.numberLabe.text = @"x 1";
        
               
        [self addSubview:self.UnitpriceLabe];
        [self addSubview:self.numberLabe];
    }
    return self;
}

//实体商品
-(void)getShitiBuyM:(MineBuyGoodM *)buyshi
{
    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)buyshi;
    [_commodityimg setImageWithURL:[NSURL URLWithString:shitiM.imgPath] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    _UnitpriceLabe.text=[NSString stringWithFormat:@"%@ 元",shitiM.unitDeductedPrice];
    CGSize priceSize = [AppUtils sizeWithString:_UnitpriceLabe.text font:_UnitpriceLabe.font size:CGSizeMake(200, _UnitpriceLabe.frame.size.height)];
    CGFloat interval = 10;
    dispatch_async(dispatch_get_main_queue(), ^{
        _UnitpriceLabe.frame = CGRectMake(IPHONE_WIDTH - interval - priceSize.width, _UnitpriceLabe.frame.origin.y, priceSize.width, _UnitpriceLabe.frame.size.height);
    });
    
    _numberLabe.text=[NSString stringWithFormat:@"x %@",shitiM.saleNum];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _describeLabe.frame = CGRectMake(_describeLabe.frame.origin.x, _describeLabe.frame.origin.y, IPHONE_WIDTH - CGRectGetMaxX(_commodityimg.frame) - interval * 2 - priceSize.width, _describeLabe.frame.size.height);
    });
    
    _describeLabe.text=shitiM.commodityName;
    
    
//    CGSize contentSize = [AppUtils sizeWithString:_describeLabe.text font:_describeLabe.font size:CGSizeMake(IPHONE_WIDTH-CGRectGetMaxX(_commodityimg.frame)-_UnitpriceLabe.frame.size.width, MAXFLOAT)];
//    
//    _describeLabe.frame=CGRectMake(_describeLabe.frame.origin.x, _describeLabe.frame.origin.y,_describeLabe.frame.size.width, contentSize.height);
}
//虚拟商品
-(void)getXuliBuyM:(MineBuyGoodM *)xunibuy
{
     MineBuyXuniGoodM *xuniM = (MineBuyXuniGoodM *)xunibuy;
    _describeLabe.text=xuniM.productName;
    _UnitpriceLabe.text=[NSString stringWithFormat:@"%@ 元",xuniM.unitPrice];
    _numberLabe.text=[NSString stringWithFormat:@"x %@",xuniM.saleNum];

}

//团购
-(void)taunGouM:(MineBuyGoodM *)tuangou number:(NSUInteger)number
{
    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)tuangou;
    NSLog(@"shitiM.imgPath==%@",shitiM.imgPath);
    [_commodityimg setImageWithURL:[NSURL URLWithString:shitiM.imgPath] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    _UnitpriceLabe.text=[NSString stringWithFormat:@"%0.2f 元",[shitiM.unitDeductedPrice floatValue]];
    CGSize priceSize = [AppUtils sizeWithString:_UnitpriceLabe.text font:_UnitpriceLabe.font size:CGSizeMake(200, _UnitpriceLabe.frame.size.height)];
    CGFloat interval = 10;
    dispatch_async(dispatch_get_main_queue(), ^{
        _UnitpriceLabe.frame = CGRectMake(IPHONE_WIDTH - interval - priceSize.width, _UnitpriceLabe.frame.origin.y, priceSize.width, _UnitpriceLabe.frame.size.height);
    });
    
    _numberLabe.text=[NSString stringWithFormat:@"x %lu",(unsigned long)number];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _describeLabe.frame = CGRectMake(_describeLabe.frame.origin.x, _describeLabe.frame.origin.y, IPHONE_WIDTH - CGRectGetMaxX(_commodityimg.frame) - interval * 2 - priceSize.width, _describeLabe.frame.size.height);
    });
    
    _describeLabe.text=shitiM.productName;
}


// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-CGRectGetMaxX(_commodityimg.frame)-_UnitpriceLabe.frame.size.width, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}


@end
