//
//  MenuCell.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/7.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//


#import "MainMenuCell.h"
#import "ChangePostionButton.h" 

@implementation MainMenuCell
{
    __weak IBOutlet ChangePostionButton *idleMarketBtn;
    __weak IBOutlet ChangePostionButton *houseOrMediaBtn;
    __weak IBOutlet ChangePostionButton *reportOrPassBtn;
    __weak IBOutlet ChangePostionButton *comAffirsOrNoticeBtn;
    __weak IBOutlet ChangePostionButton *consultOrExpressageBtn;
    __weak IBOutlet UIView *buttomV;
    __weak IBOutlet ChangePostionButton *purchaseOrOnlineBtn;
}

- (void)awakeFromNib {
#ifdef SmartComJYZX

#elif SmartComYGS
    [idleMarketBtn setTitle:@"闲置交易" forState:UIControlStateNormal];
    
    [houseOrMediaBtn setTitle:@"小蜜媒体" forState:UIControlStateNormal];
    [houseOrMediaBtn setImage:[UIImage imageNamed:@"mudule_media"] forState:UIControlStateNormal];
    
    [reportOrPassBtn setTitle:@"惠团购" forState:UIControlStateNormal];
    [reportOrPassBtn setImage:[UIImage imageNamed:@"module_tuangou"] forState:UIControlStateNormal];
    
    [comAffirsOrNoticeBtn setTitle:@"通知通告" forState:UIControlStateNormal];
    [comAffirsOrNoticeBtn setImage:[UIImage imageNamed:@"module_notice"] forState:UIControlStateNormal];
    
    [consultOrExpressageBtn setTitle:@"快递易" forState:UIControlStateNormal];
    [consultOrExpressageBtn setImage:[UIImage imageNamed:@"module_expressage"] forState:UIControlStateNormal];
    [purchaseOrOnlineBtn setTitle:@"网上商城" forState:UIControlStateNormal];
#else
    
#endif
    
    buttomV.layer.cornerRadius = 10;
    buttomV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    buttomV.layer.borderWidth = 1.0;
    for (ChangePostionButton *button in buttomV.subviews) {
        if (button.tag == 6) { //房屋租售
            [button setInternalPositionType:ButtonInternalLabelPositionRight spacing:20];
        }
        else {
            [button setInternalPositionType:ButtonInternalLabelPositionButtom spacing:3];
        }
    }
    // Initialization code
}

- (IBAction)menuButtonClick:(UIButton *)sender {
    if (self.aCellClick) {
        self.aCellClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
