//
//  ZYMilletPlayerCell.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZYMilletPlayerCell.h"
#import <UIImageView+AFNetworking.h>

@implementation ZYMilletPlayerCell

- (void)awakeFromNib {
    // Initialization code
}

+(NSString *)stateBackStr:(NSString *)str
{
    NSString *string;
    if ([str isEqualToString:@"new"] || [str isEqualToString:@"place_success"] || [str isEqualToString:@"place_fail"] ||[str isEqualToString:@"pay_fail"])
    {
        string=@"待付款";
    }
    else if ([str isEqualToString:@"canceled_user"])
    {
        string=@"已取消";
    }
    else if ([str isEqualToString:@"canceled_auto"])
    {
        string=@"已失效";
    }
    else if ([str isEqualToString:@"pay_success"])
    {
        string=@"待审核";
    }
    else if ([str isEqualToString:@"pay_fail"])
    {
        string=@"待付款";
    }
    else if ([str isEqualToString:@"audit_success"])
    {
        string=@"审核通过";
    }
    else if ([str isEqualToString:@"audit_fail"])
    {
        string=@"审核驳回";
    }
    return string;
}


-(void)milletData:(ZYXiaoMiPlayerModel *)millerM
{
    [_headImg setImageWithURL:[NSURL URLWithString:millerM.ggImgSrcSlt] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    
    _stateLab.text=[ZYMilletPlayerCell stateBackStr:millerM.status];
    NSString *str=millerM.status;
    if ([str isEqualToString:@"new"] || [str isEqualToString:@"place_success"] || [str isEqualToString:@"place_fail"] ||[str isEqualToString:@"pay_fail"]||[str isEqualToString:@"pay_success"] || [str isEqualToString:@"audit_success"]||[str isEqualToString:@"audit_fail"])
    {
        _stateLab.textColor=[AppUtils colorWithHexString:@"fa6900"];
    }
    else if ([str isEqualToString:@"canceled_user"] || [str isEqualToString:@"canceled_auto"] || [str isEqualToString:@"payback_confirmed"])
    {
        _stateLab.textColor=[UIColor lightGrayColor];
    }


   
    
    _nameLab.numberOfLines=2;
    _nameLab.text =millerM.ggTitle;
    //_nameLab.text=@"看惊魂甫定和规范化就哦 i 就佛 i 感觉哦发 i 根据地哦";
    CGSize contentSize =[AppUtils sizeWithString:_nameLab.text font:_nameLab.font size:CGSizeMake(IPHONE_WIDTH-_headImg.frame.size.width - _stateLab.frame.size.width - G_INTERVAL*2, 40)];
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGRect rect = _nameLab.frame;
//        rect.origin.x =CGRectGetMaxX(_headImg.frame)+G_INTERVAL;
//        rect.size.width=IPHONE_WIDTH-_headImg.frame.size.width - _stateLab.frame.size.width - G_INTERVAL*2;
//        rect.size.height =contentSize.height;
//        _nameLab.frame=rect;
//        _nameLab.backgroundColor=[UIColor redColor];
        _nameLab.frame = CGRectMake(CGRectGetMaxX(_headImg.frame)+G_INTERVAL, G_INTERVAL, IPHONE_WIDTH-_headImg.frame.size.width - _stateLab.frame.size.width - G_INTERVAL*4, contentSize.height);
    });
    

    _timeLab.text = [millerM.dateCreated substringWithRange:NSMakeRange(5, 5)];
    if ([NSString isEmptyOrNull:millerM.saleAmount])
    {
        _moneyLab.text= [NSString stringWithFormat:@"%@",@"未知"];
    }
    else
    {
        _moneyLab.text= [NSString stringWithFormat:@"%@元",millerM.saleAmount];
    }
    
    _moneyLab.textAlignment=NSTextAlignmentRight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
