//
//  AppUtils.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/18.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "AppUtils.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "NSString+wrapper.h"
#import "UserManager.h"

#define DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation AppUtils

/********************* System Utils **********************/
+ (UIViewController*)viewControllerForView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (CGFloat)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)isNotLanguageEmoji {
    return ![NSString isEmptyOrNull:[[UIApplication sharedApplication]textInputMode].primaryLanguage];
}

+ (void)showAlertMessage:(NSString *)msg
{
    [AppUtils dismissHUD];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringFromat:msg] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)showAlertMessageTimerClose:(NSString *)msg
{
    [AppUtils showErrorMessage:msg];
}

+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

+ (void)closeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+ (void)addTapCloseKeyboardInView:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[AppUtils class] action:@selector(closeKeyboard)];
    [view addGestureRecognizer:tap];
}

/******* UITableView & UINavigationController Utils *******/
+ (void)tableViewEndMJRefreshWithTableV:(UITableView *)tableV {
    if (tableV.header.isRefreshing) {
        [tableV.header endRefreshing];
    }
    
    if (tableV.footer.isRefreshing) {
        [tableV.footer endRefreshing];
    }
}

//用在tableview只刷新一次的地方
+ (void)tableViewFooterPromptWithPNumber:(NSInteger)pNumber
                              withPCount:(NSInteger)pCount
                               forTableV:(UITableView *)tableV {
    if (pNumber >= pCount) {
        [tableV.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
        [tableV.footer noticeNoMoreData];
        tableV.footer.hidden = YES;
    }
    else {
        tableV.footer.hidden = NO;
        [tableV.footer resetNoMoreData];
    }
}

+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message
{
    UILabel *headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
    headTitleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    headTitleLabel.textColor = [UIColor darkGrayColor];
    headTitleLabel.textAlignment = NSTextAlignmentCenter;
    headTitleLabel.text = message;
    return headTitleLabel;
}

+ (UIView *)tableViewsFooterView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

+ (UIBarButtonItem *)navigationBackButtonWithNoTitle
{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

/********************* SVProgressHUD **********************/
+ (void)showSuccessMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:[NSString stringFromat:message]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

+ (void)showErrorMessage:(NSString *)message isShow:(BOOL)isShow {
    if (isShow) {
        [AppUtils showErrorMessage:message];
    }
    else {
        [AppUtils dismissHUD];
    }
}

+ (void)showErrorMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:[NSString stringFromat:message]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

+ (void)showProgressMessage:(NSString *) message
{
    [AppUtils showProgressMessage:message withType:SVProgressHUDMaskTypeClear];
}

+ (void)showProgressMessage:(NSString *) message withType:(SVProgressHUDMaskType)type
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:[NSString stringFromat:message]];
    [SVProgressHUD setDefaultMaskType:type];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

/********************** NSDate Utils ***********************/
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    return [dateFormatter stringFromDate:date];
}

+ (NSTimeInterval)currentTimeSince1970 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    NSDate *startDate = [dateFormatter dateFromString:[AppUtils currentDate]];
    return [startDate timeIntervalSince1970] * 1000;
}

+ (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    return [dateFormatter stringFromDate:date];
}

+ (NSTimeInterval)timeIntervalFromTimeString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970] * 1000;
}

/********************* Category Utils **********************/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
        //去掉字符串前后两端的空格
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorForRandom {
    return [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
}

+ (void)callPhone:(NSString *)mobileNum {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"是否拨打电话?" delegate:[UserManager shareManager] cancelButtonTitle:@"取消" destructiveButtonTitle:mobileNum otherButtonTitles:nil, nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

//单个字符是否是数字或者英文字母
+ (BOOL)isNumberOrAlpha:(NSString *)inputSingleStr {
    NSString * regex = @"^[A-Za-z0-9]{1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:inputSingleStr];
}

//获取手机的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *mobile = @"1[3,4,5,7,8]{1}\\d{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    return [predicate evaluateWithObject:mobileNum];
}

//验证身份证号码的合法性
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(size.width, size.height)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

+ (BOOL)textFieldLimitDecimalPointWithDigits:(NSUInteger)digits //小数点位数
                                    WithText:(NSString *)text
               shouldChangeCharactersInRange:(NSRange)range
                           replacementString:(NSString *)string;
{
    BOOL isHaveDian = YES;
    if ([text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian = NO;
    }
    
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if (!((single >='0' && single<='9') || single=='.')) {
            [text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        
        //首字母不能为小数点
        if([text length]==0 && single == '.'){
            [text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    
        if (single=='.')
        {
            if(!isHaveDian)//text中还没有小数点
            {
                isHaveDian=YES;
                return YES;
            }else
            {
                [text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            if (isHaveDian)//存在小数点
            {
                //判断小数点的位数
                NSRange ran=[text rangeOfString:@"."];
                int tt=range.location-ran.location;
                if (tt <= digits){
                    return YES;
                }
                return NO;
            }
            return YES;
        }
    }
    return YES;
}

+ (void)textFieldLimitChinaMaxLength:(NSUInteger)kMaxLength
                         inTextField:(UITextField *)textField {
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > kMaxLength) {
            textField.text= [toBeString substringToIndex:kMaxLength];
        }
    }
}

//中文输入限制,先注册通知才能使用,textView
+ (void)textFieldLimitChinaMaxLength:(NSUInteger)kMaxLength
                          inTextView:(UITextView *)textView {
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(toBeString.length > kMaxLength) {
            textView.text= [toBeString substringToIndex:kMaxLength];
        }
    }
}

@end
