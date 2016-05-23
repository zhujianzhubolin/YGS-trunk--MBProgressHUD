//
//  YGSDaiJinCell.m
//  O2OIntelligentCommunity
//
//  Created by app on 16/1/15.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "YGSDaiJinCell.h"
#import "NSString+wrapper.h"

@implementation YGSDaiJinCell
{
    __weak IBOutlet UIImageView *bgImg;
    __weak IBOutlet UIButton *gouBtn;
    __weak IBOutlet UILabel *condiction;
    __weak IBOutlet UILabel *shopName;
    __weak IBOutlet UILabel *lastTime;
}

- (void)awakeFromNib {
    self.backgroundColor = [AppUtils colorWithHexString:COLOR_MAIN];
    self.isHasShopUse = NO;
    self.isMeetCondition = YES;
}

- (void)setQuanModel:(DaiJinQuanModel *)model {
    condiction.text = [NSString stringWithFormat:@"%@",model.couponTemplateName];
    shopName.text = [NSString stringWithFormat:@"%@",model.mydescription];
    NSArray * timeArray = [model.endDate componentsSeparatedByString:@" "];
    if (timeArray.count > 0) {
        lastTime.text = [NSString stringWithFormat:@"有效期至%@",timeArray[0]];
    }else{
        lastTime.text = @"";
    }
}

- (void)setQuanModel:(DaiJinQuanModel *)model
              bounds:(NSString *)bounds {
    [self setQuanModel:model];
    //该金券不满足使用条件
    if ([bounds floatValue] < [model.bound floatValue]) {
        bgImg.image = [UIImage imageNamed:@"quanBack_Gray"];
        gouBtn.selected = NO;
        gouBtn.hidden = YES;
        self.isMeetCondition = NO;
    }
    else {
        gouBtn.hidden = NO;
        self.isMeetCondition = YES;
    }
}

//前面有选中
- (void)hasSelect:(DaiJinQuanModel *)model
           quanID:(NSMutableArray *)quanModelArray
           shopId:(NSString *)shopId
           bounds:(NSString *)bounds {
    //已有选择的券
    for (DaiJinQuanModel * judgeModel in quanModelArray) {
        NSLog(@"judgeModel.shopId = %@,shopId = %@,model.id1 = %@,judgeModel.id1 = %@",judgeModel.shopId,shopId,model.id1,judgeModel.id1);
        if ([judgeModel.id1 isEqualToString:model.id1]) {
            //该行显示的代金券已经被传过来的商家选中
            if (![NSString isEmptyOrNull:judgeModel.shopId] &&
                [judgeModel.shopId isEqualToString:shopId]) {

                bgImg.image = [UIImage imageNamed:@"quanBack_S"];
                
                gouBtn.selected = YES;
                gouBtn.hidden = NO;
                self.isHasShopUse = NO;
            }
            else { //该代金券已经被其他商家选中
                bgImg.image = [UIImage imageNamed:@"quanBack_Gray"];
                
                gouBtn.selected = NO;
                gouBtn.hidden = YES;
                self.isHasShopUse = YES;
            }
        }
    }
    
    [self setQuanModel:model bounds:bounds];
}
@end
