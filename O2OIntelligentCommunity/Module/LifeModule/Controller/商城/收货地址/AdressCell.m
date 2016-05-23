//
//  AdressCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AdressCell.h"

@implementation AdressCell
{
    __weak IBOutlet UILabel *address;
    __weak IBOutlet UILabel *phone;
    __weak IBOutlet UILabel *name;
}

- (void)awakeFromNib {
}

- (void)cellData:(id)data{

    //NSString * cityAdr = [NSString stringWithFormat:@"%@",data[@"ssq_Address"]];
    NSString * detailAdr = [NSString stringWithFormat:@"%@",data[@"addressName"]];
    
    name.text = [NSString stringWithFormat:@"%@",data[@"consignee"]];
    address.text = [NSString stringWithFormat:@"%@",detailAdr];
    phone.text = [NSString stringWithFormat:@"%@",data[@"mobile"]];

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
