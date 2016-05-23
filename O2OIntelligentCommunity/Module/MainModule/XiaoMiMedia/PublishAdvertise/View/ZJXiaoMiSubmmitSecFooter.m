//
//  ZJXiaoMiSubmmitSecFooter.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/28.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJXiaoMiSubmmitSecFooter.h"

@implementation ZJXiaoMiSubmmitSecFooter
{
    __weak IBOutlet UIButton *submmitBtn;
    __weak IBOutlet UIButton *agreeBtn;
    __weak IBOutlet UIButton *protocalBtn;
    
}

- (void)awakeFromNib {
    agreeBtn.selected = YES;
    submmitBtn.layer.cornerRadius = 5;
}

- (IBAction)clickBtnForIsAgree:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)clickBtnForProtocal:(id)sender {
    
}

- (IBAction)clickBtnForSubmmit:(id)sender {
    if (![self isValidSubmmit]) {
        [AppUtils showAlertMessageTimerClose:@"小蜜协议未同意，无法提交审核喔！"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitAction)]) {
        [self.delegate submitAction];
    }
}

- (BOOL)isValidSubmmit {
    return agreeBtn.selected;
}

@end
