//
//  TableViewCell.m
//  BeeTest
//
//  Created by app on 15/11/17.
//  Copyright © 2015年 kuroneko. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

{
    __weak IBOutlet UILabel *num;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *method;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setCellData:(HoneyTradeInfoModel *)data{
    
    NSLog(@"data.point%@",data.point);
    time.text = [data.changTime substringToIndex:10];
    method.text = data.changeDesc;
    
    if( [data.changeType isEqualToString:@"integralToMoney"] || [data.changeType isEqualToString:@"delTopic"] ){
        num.text = [NSString stringWithFormat:@"-%@滴",data.point];
        num.textColor=[UIColor blackColor];
        
    }else{
        num.text = [NSString stringWithFormat:@"+%@滴",data.point];
        num.textColor=[AppUtils colorWithHexString:@"fa6900"];
    }

    //num.text = data.point;
}

@end
