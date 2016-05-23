//
//  TableViewCellFour.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TableViewCellFour.h"
#import <UIImageView+AFNetworking.h>

@implementation TableViewCellFour

{
    __weak IBOutlet UIView *lineView;
    __weak IBOutlet UIImageView *distanImage;
    __weak IBOutlet UIButton *morebutton;
    __weak IBOutlet UILabel *distain;
    __weak IBOutlet UILabel *jingxuanLable;
    __weak IBOutlet UILabel *adressshangjia;
    __weak IBOutlet UIImageView *imageshangjia;
    __weak IBOutlet UILabel *telephone;
    __weak IBOutlet UILabel *nameshangjia;
    
    NSString * shopID;
}

- (void)awakeFromNib {
}

- (void)setCellData:(id)mydata isHideLable:(BOOL)isHide{
//    NSLog(@"精选商家传入Cell数据>>>>%@",mydata[@"distance"]);
    [imageshangjia setImageWithURL:[NSURL URLWithString:mydata[@"img"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    shopID = [NSString stringWithFormat:@"%@",mydata[@"id"]];
    nameshangjia.text = [NSString stringWithFormat:@"%@",[mydata objectForKey:@"name"]];
    adressshangjia.text = [NSString stringWithFormat:@"%@",[mydata objectForKey:@"storeAddress"]];
    telephone.text = [NSString stringWithFormat:@"%@",[mydata objectForKey:@"phone"]];
    distain.text = [NSString stringWithFormat:@"%@米",mydata[@"distance"]];
    
    if (isHide) {
        jingxuanLable.hidden = YES;
        morebutton.hidden = YES;
        lineView.hidden = YES;

    }else{
        jingxuanLable.hidden = NO;
        morebutton.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
