//
//  CommodityNumberCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "CommodityNumberCell.h"
#import <UIImageView+AFNetworking.h>

@implementation CommodityNumberCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headImg  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        _headImg.image = [UIImage imageNamed:@"defaultImg"];
        [self addSubview:_headImg];
        
        _miaoshuLab = [[UILabel alloc]init];
        _miaoshuLab.numberOfLines = 0;
        _miaoshuLab.textColor =[UIColor grayColor];
        _miaoshuLab.font=[UIFont systemFontOfSize:14];
        _miaoshuLab.text=@"进口维嘉Vega全脂牛奶1L*6";
        CGSize size = [self sizeWithString:_miaoshuLab.text font:_miaoshuLab.font];
        _miaoshuLab.frame =CGRectMake(65, 20, size.width, size.height);
        [self addSubview:_miaoshuLab];
        
        _priceLabe = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 10, 100, 30)];
        _priceLabe.textColor =[UIColor grayColor];
        _priceLabe.textAlignment=NSTextAlignmentRight;
        _priceLabe.text=@"￥52.00";
        _priceLabe.font =[UIFont systemFontOfSize:14];
        [self addSubview:_priceLabe];
        
        _numberLabe = [[UILabel alloc]initWithFrame:CGRectMake(IPHONE_WIDTH-110, 40, 100, 30)];
        _numberLabe.textColor =[UIColor grayColor];
        _numberLabe.textAlignment = NSTextAlignmentRight;
        _numberLabe.text=@"x1";
        _numberLabe.font =[UIFont systemFontOfSize:14];
        [self addSubview:_numberLabe];
        
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, IPHONE_WIDTH, 1)];
//        img.backgroundColor=[AppUtils colorWithHexString:@"ECECEC"];
//        [self addSubview:img];

        

    }
    return self;
}


-(void)setShangPinInfo:(MineBuyGoodM *)goodM
{
    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)goodM;
    _miaoshuLab.text=shitiM.commodityName;
    _priceLabe.text=[NSString stringWithFormat:@"%@ 元",shitiM.unitDeductedPrice];
    _numberLabe.text=[NSString stringWithFormat:@"x %@",shitiM.saleNum];
}

//实体商品
-(void)getShitiBuyM:(MineBuyGoodM *)buyshi
{
    MineBuyShiGoodM *shitiM = (MineBuyShiGoodM *)buyshi;
    
    [_headImg setImageWithURL:[NSURL URLWithString:shitiM.imgPath] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    _priceLabe.text=[NSString stringWithFormat:@"%@ 元",shitiM.unitDeductedPrice];
    _numberLabe.text=[NSString stringWithFormat:@"x %@",shitiM.saleNum];
    
    _miaoshuLab.text=shitiM.commodityName;
    CGFloat contentlabeX =CGRectGetMaxX(_headImg.frame)+10;
    CGSize  contentSize =[self sizeWithString:_miaoshuLab.text font:_miaoshuLab.font];
    _miaoshuLab.frame=CGRectMake(contentlabeX, 15 , contentSize.width, contentSize.height);
    
}
//虚拟商品
-(void)getXuliBuyM:(MineBuyGoodM *)xunibuy
{
    MineBuyXuniGoodM *xuniM = (MineBuyXuniGoodM *)xunibuy;
    _miaoshuLab.text=xuniM.productName;
    _priceLabe.text=[NSString stringWithFormat:@"%@ 元",xuniM.unitPrice];
    _numberLabe.text=[NSString stringWithFormat:@"x %@",xuniM.saleNum];
    
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(IPHONE_WIDTH-CGRectGetMaxX(_headImg.frame)-_priceLabe.frame.size.width, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}





@end
