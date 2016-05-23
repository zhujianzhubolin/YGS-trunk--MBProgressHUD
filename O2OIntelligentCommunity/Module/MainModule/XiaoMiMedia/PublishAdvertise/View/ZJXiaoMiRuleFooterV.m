//
//  ZJXiaoMiRuleFooterV.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/3/23.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "ZJXiaoMiRuleFooterV.h"
#import "ChangePostionButton.h"
#import "MHDatePicker.h"
#import "ZJXiaoMiRuleDelegate.h"

@implementation ZJXiaoMiRuleFooterV
{
    __weak IBOutlet UIButton *startDateBtn;
    __weak IBOutlet UIButton *endDateBtn;
    __weak IBOutlet UILabel *totalDaysL;
    __weak IBOutlet UILabel *totalCountL;
    
    NSString *startTitle;
    NSString *endTitle;
    
    NSDate *seletedStartDate;
    NSDate *seletedEndDate;
    
    NSInteger _jiquNum;
}

- (void)setRuleDays:(NSUInteger)ruleDays {
    _ruleDays = ruleDays;
    [self updateUIForTotalDays];
    [self updateUIForTotalCount];
}

- (void)setRuleCount:(CGFloat)ruleCount {
    _ruleCount = ruleCount;
    [self updateUIForTotalCount];
}

- (NSString *)getTotalCount {
    return [NSString stringWithFormat:@"%.2f",self.ruleCount *self.ruleDays *_jiquNum];
}

- (NSString *)getStartDateStr {
    NSString *startStr = [AppUtils stringFromDate:seletedStartDate formatter:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@ 00:00:00",startStr];
}

- (NSString *)getEndDateStr {
    NSString *endStr = [AppUtils stringFromDate:seletedEndDate formatter:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@ 23:59:59",endStr];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_ruleChange object:nil];
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeForRuleChange:) name:Noti_ruleChange object:nil];
    startTitle = @"开始日期";
    endTitle = @"结束日期";
    
    CGFloat startBtnImgWidth = startDateBtn.imageView.frame.size.width;
    CGFloat startBtnLWidth = startDateBtn.frame.size.width - startBtnImgWidth - 12;
    [startDateBtn setTitle:startTitle forState:UIControlStateNormal];
    startDateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, startBtnLWidth, 0, -startBtnLWidth);
    startDateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -startBtnImgWidth, 0, startBtnImgWidth);
    startDateBtn.layer.cornerRadius = 5;
    startDateBtn.layer.borderWidth = 1;
    startDateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    startDateBtn.layer.borderColor = [AppUtils colorWithHexString:@"dfd2be"].CGColor;
    
    
    CGFloat endDateBtnImgWidth = endDateBtn.imageView.frame.size.width;
    CGFloat endDateBtnLWidth = endDateBtn.frame.size.width - endDateBtnImgWidth - 12;
    [endDateBtn setTitle:endTitle forState:UIControlStateNormal];
    endDateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, endDateBtnLWidth, 0, -endDateBtnLWidth);
    endDateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -endDateBtnImgWidth, 0, endDateBtnImgWidth);
    endDateBtn.layer.cornerRadius = 5;
    endDateBtn.layer.borderWidth = 1;
    endDateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    endDateBtn.layer.borderColor = [AppUtils colorWithHexString:@"dfd2be"].CGColor;
    
    [self updateUIForTotalDays];
}

#pragma mark - Update
- (void)updateDataForXiaoMiJiQiNum:(NSInteger)jiqiNum {
    _jiquNum = jiqiNum;
    [self updateUIForTotalCount];
}

- (void)updateDataForRuleDays {
    if (seletedStartDate && seletedEndDate) {
        NSLog(@"seletedStartDate = %@,seletedEndDate = %@",seletedStartDate,seletedEndDate);
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setFirstWeekday:2];
        
        NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:seletedStartDate toDate:seletedEndDate options:0];
        
        self.ruleDays = (long)dayComponents.day + 1;
    }
}

- (void)updateUIForTotalDays {
    totalDaysL.text = [NSString stringWithFormat:@"共%lu天,",(unsigned long)self.ruleDays];
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:totalDaysL.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(1, str.length - 3)];
    totalDaysL.attributedText=str;
}

- (void)updateUIForTotalCount {
    totalCountL.text = [NSString stringWithFormat:@"合计%@元",[self getTotalCount]];
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc]initWithString:totalCountL.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, str.length - 3)];
    totalCountL.attributedText=str;
}

- (void)updateUIForDateBtn:(UIButton *)btn
                   forDate:(NSDate *)date{
    btn.imageEdgeInsets = UIEdgeInsetsZero;
    btn.titleEdgeInsets = UIEdgeInsetsZero;
    [btn setImage:nil forState:UIControlStateNormal];
    [btn setTitle:[AppUtils stringFromDate:date formatter:@"MM-dd"] forState:UIControlStateNormal];
}

#pragma mark - event
- (void)noticeForRuleChange:(NSNotification *)noti {
    self.ruleCount = [noti.object floatValue];
    NSLog(@"noticeForRuleChange,self.ruleCount = %f",self.ruleCount);
}

- (IBAction)clickBtnForChooseStartDate:(id)sender {
    MHDatePicker *datePicker = [[MHDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setTitle:startTitle
                   color:[UIColor blackColor]
                    font:[UIFont systemFontOfSize:FONT_SIZE]];
    
    __block UIButton *startBlockBtn = startDateBtn;
    [datePicker didFinishSelectedDate:^(NSDate *selectDataTime) {
        seletedStartDate = selectDataTime;
        seletedStartDate = [AppUtils dateFromString:[self getStartDateStr] formatter:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"seletedStartDate = %@",seletedStartDate);
        [self updateUIForDateBtn:startBlockBtn
                         forDate:selectDataTime];
        [self updateDataForRuleDays];
    }];
    
    NSDate *nowDate = [NSDate date];
    NSDate *minDate = [NSDate dateWithTimeInterval:3*24*3600 sinceDate:nowDate];
    if (seletedStartDate) {
        datePicker.selectDate = seletedStartDate;
    }
    else {
        datePicker.selectDate = minDate;
    }

    datePicker.minSelectDate = minDate;
    datePicker.maxSelectDate = [NSDate dateWithTimeInterval:29*24*3600 sinceDate:nowDate];
}

- (IBAction)clickBtnForChooseEndDate:(id)sender {
    if (!seletedStartDate) {
        return;
    }
    
    MHDatePicker *datePicker = [[MHDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setTitle:endTitle
                   color:[UIColor blackColor]
                    font:[UIFont systemFontOfSize:FONT_SIZE]];
    
    __block UIButton *endBlockBtn = endDateBtn;
    [datePicker didFinishSelectedDate:^(NSDate *selectDataTime) {
        seletedEndDate = selectDataTime;
        NSLog(@"endSelectDataTime = %@",selectDataTime);
        [self updateUIForDateBtn:endBlockBtn
                         forDate:selectDataTime];
        [self updateDataForRuleDays];
    }];
  
    if (seletedEndDate) {
        datePicker.selectDate = seletedEndDate;
    }
    else {
        datePicker.selectDate = seletedStartDate;
    }
    
    datePicker.minSelectDate = seletedStartDate;
    datePicker.maxSelectDate = [NSDate dateWithTimeInterval:89*24*3600 sinceDate:seletedStartDate];
}

@end
