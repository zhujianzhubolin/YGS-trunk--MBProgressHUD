//
//  DescCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/10/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "DescCell.h"
#import <UIImageView+AFNetworking.h>

@implementation DescCell {
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *title;
    __weak IBOutlet UILabel *detailDesc;
    __weak IBOutlet UILabel *fromTime;
    __weak IBOutlet UILabel *laiyuan;
    __weak IBOutlet UIImageView *headImage;
    NSString * telePhoneNum;
}

- (void)awakeFromNib {
    headImage.layer.cornerRadius = 25;
    headImage.clipsToBounds = YES;
    
    
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(id)data{
    
    NSLog(@"Cell数据>>>>%@",data);
    
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"mbMember"][@"photourl"]]] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    laiyuan.text = [NSString stringWithFormat:@"%@",data[@"mbMember"][@"nickName"]];
    telePhoneNum = [NSString stringWithFormat:@"%@",data[@"phone"]];
    title.text = [NSString stringWithFormat:@"%@",data[@"title"]];
    
    NSString * unit = @"元";
    
    if ([data[@"type"] isEqualToString:@"2"]) {//房屋租售
        
        if ([data[@"transactionType"] isEqualToString:@"1"]) {//1 出租 2 出售 3 求租
            unit = @"元/月";
        }else if ([data[@"transactionType"] isEqualToString:@"2"]){
            unit = @"万/套";
        }else{
            unit = @"元/月";
        }
        
    }else{//跳蚤市场
        unit = @"元";
    }
    price.text = [NSString stringWithFormat:@"%@%@",data[@"price"],unit];
    detailDesc.text = [NSString stringWithFormat:@"%@",data[@"activityContent"]];
    fromTime.text = [NSString stringWithFormat:@"%@",data[@"createDateStr"]];
    
    CGRect frame = detailDesc.frame;
    CGFloat height = [self heightForString:detailDesc.text fontSize:15 andWidth:frame.size.width];
    frame.size.height = height;
    detailDesc.frame = frame;
    
    if (75 + frame.size.height < 150) {
        self.height = 80 + frame.size.height + 30 + 15;
    }else{
        self.height = 80 + frame.size.height + 15;
    }
    
}





- (IBAction)dadianhua:(UIButton *)sender {

    [AppUtils callPhone:telePhoneNum];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"23");
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

@end
