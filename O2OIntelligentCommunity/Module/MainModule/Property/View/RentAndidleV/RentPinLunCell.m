//
//  RentPinLunCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "RentPinLunCell.h"
#import <UIImageView+AFNetworking.h>
#import "UserManager.h"

@implementation RentPinLunCell

{
    __weak IBOutlet UIButton *delebutton;
    __weak IBOutlet UILabel *desc;
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *time;
    
    NSString * mypinluID;
}

- (void)awakeFromNib {
    
    headImage.layer.cornerRadius = 25;
    headImage.clipsToBounds = YES;
    
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
    
}

- (void)setCellData:(id)data{
    
    NSLog(@"Cell 里面的数据>>>>%@",data);
    
    mypinluID = [NSString stringWithFormat:@"%@",data[@"id"]];
    
    NSString * memID = [NSString stringWithFormat:@"%@",data[@"memberId"]];
    if ([[UserManager shareManager].userModel.memberId isEqualToString:memID]) {
        delebutton.hidden = NO;
    }else{
        delebutton.hidden = YES;
    }
    
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"mbMember"][@"photourl"]]] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    name.text = [NSString stringWithFormat:@"%@",data[@"mbMember"][@"nickName"]];
    
//    CGRect frameName = name.frame;
//    CGSize nameSize = [AppUtils sizeWithString:data[@"mbMember"][@"nickName"] font:[UIFont systemFontOfSize:13] size:CGSizeMake(CGFLOAT_MAX, 22)];
//    frameName.size.width = nameSize.width;
//    name.frame = frameName;
    
    
    
    desc.text = [NSString stringWithFormat:@"%@",data[@"content"]];
    time.text = [NSString stringWithFormat:@"%@",data[@"dateCreateStr"]];
    
    //以下动态计算Cell高度100
    CGRect frame = desc.frame;
    CGFloat height = [self heightForString:desc.text fontSize:14 andWidth:frame.size.width];
    frame.size.height = height;
    desc.frame = frame;
    
    if (height + 44 < 100) {
        self.height = 100;
    }else{
        self.height = height + 44;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)heightForString:(NSString *)string fontSize:(float)fontSize andWidth:(float)width
{
    if (string==nil) {
        return 0;
    }
    if ((NSNull *)string == [NSNull null]) {
        return 0;
    }
    if (string!=nil && string.length>1) {
        UIFont * tfont = [UIFont systemFontOfSize:fontSize];
        CGSize size = CGSizeMake(width,CGFLOAT_MAX);
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
        CGSize actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        return actualsize.height;
    }
    return 0;
}

- (IBAction)deletebtnclick:(id)sender {

    [_mydelete delteMyPinLun:mypinluID];
}


@end
