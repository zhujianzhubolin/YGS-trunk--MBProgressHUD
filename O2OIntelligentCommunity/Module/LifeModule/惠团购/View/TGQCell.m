//
//  TGQCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/20.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "TGQCell.h"
#import "DES3EncryptUtil.h"

@implementation TGQCell
{
    __weak IBOutlet UILabel *timelable;
    __weak IBOutlet UITextView *orderTxt;
}

- (void)awakeFromNib {

    
}

- (void)tgOrder:(NSDictionary *)dict{
    
    timelable.text = [NSString stringWithFormat:@"%@",dict[@"validityDate"]];
    orderTxt.text = [NSString stringWithFormat:@"%@",[DES3EncryptUtil decrypt:[dict objectForKey:@"checkCode"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

@end
