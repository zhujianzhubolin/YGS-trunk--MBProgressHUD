//
//  TableViewCellThree.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/6.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "TableViewCellThree.h"
#import <UIImageView+AFNetworking.h>

@implementation TableViewCellThree
{
    
    __weak IBOutlet UIImageView *image1;
    
    __weak IBOutlet UIImageView *image2;
    
    __weak IBOutlet UIImageView *image3;
    NSMutableArray * dataArray;
    
}

- (void)awakeFromNib {
    
}

- (void)setTuaData:(id)data{
    
    dataArray = (NSMutableArray *)data;
    
    if ([data count] == 0) {
        return;
        
    }else if ([data count] == 1){
        [image1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[0][@"imageAddres"]]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
    }else if ([data count] == 2){
        [image1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[0][@"imageAddres"]]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
        [image2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[1][@"imageAddres"]]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
    }else{
        [image1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[0][@"imageAddres"]]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
        [image2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[1][@"imageAddres"]]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
        [image3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[2][@"imageAddres"]]] placeholderImage:[UIImage imageNamed:@"defaultImg_w"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)huituangou:(UIButton *)sender {
    
    NSLog(@"按钮的tag>>>>>%ld",(long)sender.tag);
    NSLog(@"数据源数组>>>>%@",dataArray);
    
    if (dataArray.count <= 0) {
        [AppUtils showAlertMessage:@"暂无团购广告"];
    }else if (dataArray.count == 1){
        if (sender.tag == 1000) {
            if (_delegate && [_delegate respondsToSelector:@selector(cellClick:)]) {
                [_delegate cellClick:dataArray[0]];//传过去的
            }
        }else if (sender.tag == 1001){
            [AppUtils showAlertMessage:@"暂无该团购信息"];
            return;
        }else{
            [AppUtils showAlertMessage:@"暂无该团购信息"];
            return;
        }
        
    }else if (dataArray.count == 2){
        if (sender.tag == 1000) {
            if (_delegate && [_delegate respondsToSelector:@selector(cellClick:)]) {
                [_delegate cellClick:dataArray[0]];//传过去的
            }
        }else if (sender.tag == 1001){
            if (_delegate && [_delegate respondsToSelector:@selector(cellClick:)]) {
                [_delegate cellClick:dataArray[1]];//传过去的
            }
        }else{
            [AppUtils showAlertMessage:@"暂无该团购信息"];
            return;
        }
    }else{
        if (sender.tag == 1000) {
            if (_delegate && [_delegate respondsToSelector:@selector(cellClick:)]) {
                [_delegate cellClick:dataArray[0]];//传过去的
            }
        }else if (sender.tag == 1001){
            if (_delegate && [_delegate respondsToSelector:@selector(cellClick:)]) {
                [_delegate cellClick:dataArray[1]];//传过去的
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(cellClick:)]) {
                [_delegate cellClick:dataArray[2]];//传过去的
            }
        }
    }

}
- (IBAction)MoreTuanGou:(UIButton *)sender {
    
    if (_goudelegate && [_goudelegate respondsToSelector:@selector(clickMore)]) {
        
        [_goudelegate clickMore];
    }
    
}


@end
