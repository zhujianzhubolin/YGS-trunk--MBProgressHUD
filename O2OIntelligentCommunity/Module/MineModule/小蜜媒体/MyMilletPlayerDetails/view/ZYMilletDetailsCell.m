//
//  ZYMilletDetailsCell.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
#define LabelHeight 44-G_INTERVAL*2
#define M_TIME_SIZE  17

#import "ZYMilletDetailsCell.h"
#import "NSString+wrapper.h"
#import "ZYMilletPlayerCell.h"


@implementation ZYMilletDetailsCell
{
    UIButton *nameBtn;
    UILabel *contentLab;
    CGFloat nameWidth;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        nameBtn = [[UIButton alloc]initWithFrame:CGRectMake(G_INTERVAL, G_INTERVAL, 100, LabelHeight)];
        nameBtn.enabled=NO;
        [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nameBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [self.contentView addSubview:nameBtn];
        
        contentLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameBtn.frame), nameBtn.frame.origin.y, IPHONE_WIDTH-G_INTERVAL*2-CGRectGetMaxX(nameBtn.frame), nameBtn.frame.size.height)];
        contentLab.numberOfLines=0;
        [self.contentView addSubview:contentLab];
        
    }
    return self;
}

- (NSMutableAttributedString *)resetAttributedStr:(NSMutableAttributedString *)str
                                       textLength:(NSUInteger)textlength index:(NSUInteger)index{
    
    if (index==2)
    {
        NSRange numRange = NSMakeRange(0,str.length - (textlength + 1));
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:numRange];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:M_TIME_SIZE] range:numRange];
        
        NSRange strRange = NSMakeRange(str.length - textlength ,textlength);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:strRange];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:M_TIME_SIZE] range:strRange];

    }
    else
    {
        NSRange numRange = NSMakeRange(0,str.length - (textlength + 1));
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:numRange];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:M_TIME_SIZE] range:numRange];
        
        NSRange strRange = NSMakeRange(str.length - textlength ,textlength);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:strRange];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:M_TIME_SIZE] range:strRange];

    }
    return str;
}


- (CGSize)nameSize:(NSString *)nameStr {
     CGSize nameBtnSize = [AppUtils sizeWithString:nameBtn.titleLabel.text font:nameBtn.titleLabel.font size:CGSizeMake(100, LabelHeight)];
    return nameBtnSize;
}

-(void)detailsData:(NSString *)nameStr
{
    [nameBtn setTitle:nameStr forState:UIControlStateNormal];
   nameWidth = [self nameSize:nameStr].width;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = nameBtn.frame;
        rect.size.height = LabelHeight;
        rect.size.width = nameWidth;
        nameBtn.frame = rect;
        //nameBtn.backgroundColor=[UIColor redColor];
    });
}

-(void)detailsContent:(NSString *)content content2:(NSString *)content2 index:(NSUInteger)index
{
//    if (![NSString isEmptyOrNull:content2])
//    {
//        NSMutableAttributedString *allContentStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ (%@)",[ZYMilletPlayerCell stateBackStr:content],content2]];
//        
//        contentLab.attributedText=[self resetAttributedStr:allContentStr textLength:content2.length+2 index:index];
//    }
//    else
//    {
//        
//        
//    }
    if (index==2)
    {
        //contentLab.text = [ZYMilletPlayerCell stateBackStr:content];
        NSMutableAttributedString *allContentStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ (%@)",[ZYMilletPlayerCell stateBackStr:content],content2]];
        
        contentLab.attributedText = [self resetAttributedStr:allContentStr textLength:content2.length+2 index:index];
        
    }
    else
    {
        contentLab.text=content;
    }

    
    if (index==3) {
        contentLab.textColor=[UIColor orangeColor];
    }
    
    NSLog(@"nameWidth = %f",nameWidth);
    CGSize contentSize =[AppUtils sizeWithString:contentLab.text font:contentLab.font size:CGSizeMake(IPHONE_WIDTH-nameBtn.frame.origin.x - nameWidth - G_INTERVAL, 1000)];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = contentLab.frame;
        rect.origin.x =CGRectGetMaxX(nameBtn.frame);
        rect.size.width=contentSize.width;
        rect.size.height =contentSize.height;
        contentLab.frame=rect;
    });
    
//    if (index==2)
//    {
//        NSString *str=content;
//        if ([str isEqualToString:@"new"] || [str isEqualToString:@"place_success"] || [str isEqualToString:@"place_fail"] ||[str isEqualToString:@"pay_fail"]||[str isEqualToString:@"pay_success"] || [str isEqualToString:@"audit_success"]||[str isEqualToString:@"audit_fail"])
//        {
//            contentLab.textColor=[AppUtils colorWithHexString:@"fa6900"];
//        }
//        else if ([str isEqualToString:@"canceled_user"] || [str isEqualToString:@"canceled_auto"] || [str isEqualToString:@"payback_confirmed"])
//        {
//            contentLab.textColor=[UIColor lightGrayColor];
//        }
//
//    }
    
    CGRect  cellRect = self.frame;
    cellRect.size.height = G_INTERVAL *2 +contentSize.height;
    self.frame = cellRect;
    //contentLab.backgroundColor=[UIColor brownColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
