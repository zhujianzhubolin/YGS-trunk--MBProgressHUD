//
//  AppUtils.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/18.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

//数字
#define NUM @"0123456789"
//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh.h>
@interface AppUtils : NSObject

/********************** System Utils ***********************/
+ (CGFloat)systemVersion;
//获取没有文字的导航栏返回按钮
+ (UIBarButtonItem *)navigationBackButtonWithNoTitle;
//是否不是表情符号
+ (BOOL)isNotLanguageEmoji;
//弹出UIAlertView
+ (void)showAlertMessage:(NSString *)msg;
+ (void)showAlertMessageTimerClose:(NSString *)msg; //定时关闭
//关闭键盘
+ (void)closeKeyboard;
//给某个View添加点击手势关闭键盘
+ (void)addTapCloseKeyboardInView:(UIView *)view;
////判断当前控制器是否在显示
//+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;
//拨打电话
+ (void)callPhone:(NSString *)mobileNum;
//获取手机的IP地址
+ (NSString *)deviceIPAdress;

//得到此view 所在的viewController
+ (UIViewController*)viewControllerForView:(UIView *)view;

/******* UITableView & UINavigationController Utils *******/
//判断tableView是否还有更多的数据，无则隐藏底部的文字提示
+ (void)tableViewFooterPromptWithPNumber:(NSInteger)pNumber
                              withPCount:(NSInteger)pCount
                               forTableV:(UITableView *)tableV;
//停止上下拉刷新
+ (void)tableViewEndMJRefreshWithTableV:(UITableView *)tableV;
//返回View覆盖多余的tableview cell线条
+ (UIView *)tableViewsFooterView;
//返回UILabel作为UITableView的header
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message;

/********************* SVProgressHUD **********************/
//弹出操作错误信息提示框
+ (void)showErrorMessage:(NSString *)message;

//是否弹出操作错误信息提示框
+ (void)showErrorMessage:(NSString *)message isShow:(BOOL)isShow;

//弹出操作成功信息提示框
+ (void)showSuccessMessage:(NSString *)message;
//弹出加载提示框
+ (void)showProgressMessage:(NSString *) message;
+ (void)showProgressMessage:(NSString *) message withType:(SVProgressHUDMaskType)type;

//取消弹出框
+ (void)dismissHUD;

/********************** NSDate Utils ***********************/
//根据指定格式将NSDate转换为NSString
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;
//根据指定格式将NSString转换为NSDate
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

//获取当前的日期
+ (NSString *)currentDate;
//获取从1970年到现在的总秒数
+ (NSTimeInterval)currentTimeSince1970;
//根据传入的总秒数获取从1970年算到现在的日期
+ (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval;
//根据传入的日期字符串返回从1970年距离传入日期的总秒数
+ (NSTimeInterval)timeIntervalFromTimeString:(NSString *)dateString;


/********************* Category Utils **********************/
//根据颜色码取得颜色对象
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//获取随机颜色
+ (UIColor *)colorForRandom;

/********************* Verification Utils **********************/
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//验证身份证号码的合法性
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;
//单个字符是否是数字或者英文字母
+ (BOOL)isNumberOrAlpha:(NSString *)inputSingleStr;

/********************* Calculate Utils **********************/
// 动态计算高度和宽度
+ (CGSize)sizeWithString:(NSString *)string
                    font:(UIFont *)font
                    size:(CGSize)size;

/********************* DataFormatLimit Utils **********************/
//输入框中的金额限制几位小数点
+ (BOOL)textFieldLimitDecimalPointWithDigits:(NSUInteger)digits //小数点位数
                                    WithText:(NSString *)text
               shouldChangeCharactersInRange:(NSRange)range
                           replacementString:(NSString *)string;


//中文输入限制,先注册通知才能使用,textField
+ (void)textFieldLimitChinaMaxLength:(NSUInteger)kMaxLength
                         inTextField:(UITextField *)textField;

//中文输入限制,先注册通知才能使用,textView
+ (void)textFieldLimitChinaMaxLength:(NSUInteger)kMaxLength
                          inTextView:(UITextView *)textView;

@end
