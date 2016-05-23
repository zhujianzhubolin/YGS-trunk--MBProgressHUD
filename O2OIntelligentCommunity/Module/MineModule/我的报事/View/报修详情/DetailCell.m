//
//  DetailCell.m
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.NameLabe =[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 75, 30)];
        //self.NameLabe.text =@"报修日期:";
        self.NameLabe.font=[UIFont systemFontOfSize:15];
        self.NameLabe.textColor=[UIColor grayColor];
        [self addSubview:self.NameLabe];
        
        self.DataLabe = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, IPHONE_WIDTH-95, 30)];
        //self.DataLabe.text =@"2015=04-20 12：30";
        self.DataLabe.font=[UIFont systemFontOfSize:15];
        self.DataLabe.textColor=[UIColor grayColor];
        
        
        [self addSubview:self.DataLabe];
        
    }
    return self;
}

-(void)setName:(NSString *)Name
{
    _NameLabe.text=Name;
}

@end
