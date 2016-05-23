//
//  ZJNoDeviceCell.m
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/7.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJNoDeviceCell.h"
#import "UserManager.h"

@implementation ZJNoDeviceCell
{
    __weak IBOutlet UIButton *switchXQBtn;
    __weak IBOutlet UILabel *xqNameL;
    __weak IBOutlet UILabel *xiaoMiNumL;
    
}

- (void)awakeFromNib {
    CGRect rect = self.frame;
    rect.size.width = IPHONE_WIDTH;
    self.frame = rect;
    
    switchXQBtn.layer.cornerRadius = 5;
    switchXQBtn.layer.borderColor = switchXQBtn.titleLabel.textColor.CGColor;
    switchXQBtn.layer.borderWidth = 1;

    [self updateUIForComInfo:[UserManager shareManager].comModel];
    [self updateUIForXiaoMiJiQiNum:0];
    // Initialization code
}

- (void)updateUIForXiaoMiJiQiNum:(NSUInteger)jiqiNum {
    xiaoMiNumL.text=[NSString stringWithFormat:@"小蜜机器人%lu台" ,jiqiNum];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:xiaoMiNumL.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5, xiaoMiNumL.text.length - 6)];
    xiaoMiNumL.attributedText = str;
}

- (void)updateUIForComInfo:(BingingXQModel *)comM {
    xqNameL.text = comM.xqName;
}

- (IBAction)ClickBtnForSwitchXq:(id)sender {
    CommunityViewCotroller *communityVC = [CommunityViewCotroller new];
    communityVC.communityType = CommunityChooseTypeChooseAll;
    communityVC.comBlock = ^(BingingXQModel *comModel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:notiForComChange object:comModel];
    };
    
    [[SwitchVCAnimation shareInstance] replaceAnimationType:AnimationTypeFade];
    [[SwitchVCAnimation shareInstance] replaceAnimationDirection:AnimationDirectionTop];
    
    UINavigationController *nav = [AppUtils viewControllerForView:self].navigationController;
    [nav.view.layer addAnimation:[[SwitchVCAnimation shareInstance] getTransitionAnimation] forKey:nil];
    [nav pushViewController:communityVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
