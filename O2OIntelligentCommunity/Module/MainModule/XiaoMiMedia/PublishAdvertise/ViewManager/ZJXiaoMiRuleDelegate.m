//
//  ZJXiaoMiRuleManager.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#define BTN_START_TAG 1000
#define BTN_RULE_TAG 10000

#import "ZJXiaoMiRuleDelegate.h"
#import "ZJXiaoMiRuleHeaderV.h"
#import "ZJAdvertisementModel.h"

@interface ZJXiaoMiRuleDelegate ()

@property (nonatomic,strong) UIButton *noRuleBtn;
@end

@implementation ZJXiaoMiRuleDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ruleArr = [NSMutableArray array];
    }
    return self;
}

- (UIButton *)noRuleBtn {
    if (_noRuleBtn == nil) {
        _noRuleBtn = [UIButton addWithFrame:CGRectMake(G_INTERVAL *2, 0, IPHONE_WIDTH - G_INTERVAL *4, RuleCellRow)
                                           textColor:[UIColor blueColor]
                                            fontSize:FONT_SIZE
                                             imgName:nil
                                                text:@"规则"];
        [_noRuleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_noRuleBtn addTarget:self action:@selector(clickBtnForRequestRuleList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noRuleBtn;
}

- (void)setRuleType:(RuleShowType)ruleType {
    _ruleType = ruleType;
    if (ruleType == RuleShowTypeNone) {
        [self.noRuleBtn setTitle:@"未发现规则，点击重新获取" forState:UIControlStateNormal];
    }
    else if (ruleType == RuleShowTypeGetFail){
        [self.noRuleBtn setTitle:@"获取失败，点击重新获取" forState:UIControlStateNormal];
    }
    else {
        [self.noRuleBtn setTitle:@"" forState:UIControlStateNormal];
    }
};

- (void)setRuleArr:(NSMutableArray *)ruleArr {
    _ruleArr = ruleArr;
    
    if (ruleArr.count > 0) {
        ZJAdvertisementModel *advertisementM = self.ruleArr[0];
        advertisementM.isSelected = YES;
    }
    
    [self notiPostForRuleChange];
}

- (void)notiPostForRuleChange {
    __block CGFloat totalRuleCount = 0;
    [self.ruleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZJAdvertisementModel *advertisementM = [self.ruleArr objectAtIndex:idx];
        if (advertisementM.isSelected) {
            totalRuleCount = advertisementM.chargeAmout.floatValue;
            *stop = YES;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_ruleChange object:[NSNumber numberWithFloat:totalRuleCount]];
}

- (NSString *)getRuleStr {
    __block NSString *ruleStr;
    [self.ruleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZJAdvertisementModel *advertisementM = [_ruleArr objectAtIndex:idx];
        if (advertisementM.isSelected) {
            NSLog(@"ruleStr = %@",advertisementM.ID);
            ruleStr = advertisementM.ID;
            *stop = YES;
        }
    }];

    return ruleStr;
}

#pragma mark - event
- (void)clickBtnForRuleChoose:(UIButton *)btn {
    [self.ruleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *ruleBtn = (UIButton *)[self.infoTb viewWithTag:BTN_START_TAG + idx];
        ruleBtn.selected = NO;
        
        ZJAdvertisementModel *advertisementM = self.ruleArr[idx];
        advertisementM.isSelected = ruleBtn.selected;
        [self.ruleArr replaceObjectAtIndex:idx withObject:advertisementM];
    }];
    
    ZJAdvertisementModel *advertisementM = self.ruleArr[btn.tag - BTN_START_TAG];
    btn.selected = YES;
    advertisementM.isSelected = btn.selected;
    [self.ruleArr replaceObjectAtIndex:btn.tag - BTN_START_TAG withObject:advertisementM];
    [self notiPostForRuleChange];
}

- (void)clickBtnForRequestRuleList {
    if (self.getRuleBlock) {
        self.getRuleBlock();
    }
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
    headerV.backgroundColor = [UIColor whiteColor];
    
    UILabel *ruleTitleL = [[UILabel alloc] initWithFrame:CGRectMake(G_INTERVAL,0, headerV.frame.size.width - G_INTERVAL *2, headerV.frame.size.height)];
    ruleTitleL.font = [UIFont systemFontOfSize:FONT_SIZE];
    ruleTitleL.text = @"播放规则:";
    [headerV addSubview:ruleTitleL];
    return headerV;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.ruleArr.count > 0) {
        return nil;
    }
    else {
        UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, RuleCellRow)];
        [footerV addSubview:self.noRuleBtn];
        NSLog(@"self.noRuleBtn = %@",self.noRuleBtn);
        return footerV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RuleCellRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.ruleArr.count > 0) {
        return CGFLOAT_MIN;
    }
    else {
        return RuleCellRow;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RuleCellRow;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ruleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *showCell = [tableView dequeueReusableCellWithIdentifier:SYSTEM_CELL_ID];
    
    if (showCell == nil) {
        showCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYSTEM_CELL_ID];
    }
    return showCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJAdvertisementModel *advertisementM = [_ruleArr objectAtIndex:indexPath.row];
    NSString *ruleText = advertisementM.serviceRegular;
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn = [UIButton addWithFrame:CGRectMake(G_INTERVAL*2, 0, tableView.frame.size.width - G_INTERVAL*3, RuleCellRow)
                           textColor:[UIColor blackColor]
                            fontSize:FONT_SIZE - 2
                             imgName:nil
                                text:nil];
    ruleBtn.tag = indexPath.row + BTN_START_TAG;
    [ruleBtn setState:UIControlStateSelected imgName:@"adressGou" text:ruleText];
    [ruleBtn setState:UIControlStateNormal imgName:@"adressKuang" text:ruleText];
    [ruleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [ruleBtn addTarget:self action:@selector(clickBtnForRuleChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    ruleBtn.selected = advertisementM.isSelected;
    [cell.contentView addSubview:ruleBtn];
}

@end
