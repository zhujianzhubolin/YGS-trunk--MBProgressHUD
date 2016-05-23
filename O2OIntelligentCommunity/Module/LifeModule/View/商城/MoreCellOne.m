//
//  MoreCellOne.m
//  O2OIntelligentCommunity
//
//  Created by app on 15/7/8.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "MoreCellOne.h"
#import "ChangePostionButton.h"
@implementation MoreCellOne

{
    __weak IBOutlet ChangePostionButton *oneBtn;
    __weak IBOutlet ChangePostionButton *twoBtn;
    __weak IBOutlet ChangePostionButton *threeBtn;
    __weak IBOutlet ChangePostionButton *fourBtn;
}

- (void)awakeFromNib {
    
#ifdef SmartComJYZX
    
#elif SmartComYGS
    [oneBtn setTitle:@"通行证" forState:UIControlStateNormal];
    [oneBtn setImage:[UIImage imageNamed:@"mtongxingzheng"] forState:UIControlStateNormal];
    
    [twoBtn setTitle:@"外卖" forState:UIControlStateNormal];
    [twoBtn setImage:[UIImage imageNamed:@"module_takeOut"] forState:UIControlStateNormal];
    
    [threeBtn setTitle:@"爱大厨" forState:UIControlStateNormal];
    [threeBtn setImage:[UIImage imageNamed:@"module_loveChef"] forState:UIControlStateNormal];
    
    [fourBtn setTitle:@"" forState:UIControlStateNormal];
    [fourBtn setImage:nil forState:UIControlStateNormal];
#else
    
#endif
    
    
    for (ChangePostionButton *button in self.contentView.subviews) {
        [button setInternalPositionType:ButtonInternalLabelPositionButtom spacing:6];
        
    }
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
