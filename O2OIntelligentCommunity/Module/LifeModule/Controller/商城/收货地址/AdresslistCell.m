//
//  AdresslistCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/9/1.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AdresslistCell.h"

@implementation AdresslistCell

{
    __weak IBOutlet UILabel *adress;
    __weak IBOutlet UILabel *phone;
    __weak IBOutlet UILabel *name;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setCellData:(id)data{
    NSLog(@"地址cell>>>%@",data);
    
    //NSString * cityAdr = [NSString stringWithFormat:@"%@",data[@"ssq_Address"]];
    NSString * detailAdr = [NSString stringWithFormat:@"%@",data[@"addressName"]];

    adress.text = [NSString stringWithFormat:@"%@",detailAdr];
    phone.text = [NSString stringWithFormat:@"%@",data[@"mobile"]];
    name.text = [NSString stringWithFormat:@"%@",data[@"consignee"]];
}


@end
