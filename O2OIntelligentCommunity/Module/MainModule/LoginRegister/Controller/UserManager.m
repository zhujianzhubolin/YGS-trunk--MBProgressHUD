//
//  UserManager.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/24.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
#define ISBINDING_ALERT_TAG 10
#define ISAUTHON_ALERT_TAG 11

#import "UserManager.h"
#import "LoginStorage.h"
#import "NSString+wrapper.h"
#import "NSDictionary+wrapper.h"
#import "HousingViewController.h"

@implementation UserManager
{
    UINavigationController *comBindingFromVC;
}

+ (UserManager *)shareManager
{
    static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
    });
    return manager;
}

- (void)showLoginViewFromVC:(UIViewController *)controller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil];
    UIViewController *loginVC = [storyboard instantiateInitialViewController];
    [controller presentViewController:loginVC animated:YES completion:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void) initData
{
    self.comModel = [BingingXQModel new];
    self.userModel = [UserOwnEntity new];
    self.userModel.memberId = [LoginStorage userID];
    self.userModel.phone = [LoginStorage userPhone];
}

- (BOOL) isLogin
{
    if (![NSDictionary isDicEmptyOrNull:[LoginStorage decodeUserDic]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isBinding {
    if (![NSString isEmptyOrNull:self.comModel.isCheckPass] && [self.comModel.isCheckPass isEqualToString:@"2"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isAuthenting {
    if (![NSString isEmptyOrNull:self.comModel.isCheckPass] && [self.comModel.isCheckPass isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isOpenWallet {
    if (![NSString isEmptyOrNull:self.userModel.isCardActivate] && [self.userModel.isCardActivate isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)showCommunityAlertIsBindingFromNav:(UINavigationController *)navVC {
    if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.xqNo]) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,请选定一个默认小区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertV.delegate = self;
        alertV.tag = 1;
        [alertV show];
        return YES;
    }
    
    if (![UserManager shareManager].isBinding) {
        if ([UserManager shareManager].isAuthenting) {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,该小区还在审核中" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertV.delegate = self;
            alertV.tag = ISAUTHON_ALERT_TAG;
            [alertV show];
            return YES;
        }
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:W_ALL_NO_BINDING delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
        comBindingFromVC = navVC;
        alertV.delegate = self;
        alertV.tag = ISBINDING_ALERT_TAG;
        [alertV show];
        return YES;
    }
    
    return NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == ISBINDING_ALERT_TAG) {
        if (comBindingFromVC) {
            HousingViewController *bindingVC = [HousingViewController  new];
            bindingVC.xqModel = [UserManager shareManager].comModel;
            [comBindingFromVC pushViewController:bindingVC animated:YES];
            comBindingFromVC = nil;
        }
    }
    else if (alertView.tag == ISAUTHON_ALERT_TAG) {
        
    }
}

#pragma UIActionsheetdelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:actionSheet.destructiveButtonIndex]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }

    NSLog(@"%ld",(long)buttonIndex);
}

@end
