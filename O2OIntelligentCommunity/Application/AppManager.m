//
//  AppManager.m
//  O2OIntelligentCommunity
//
//  Created by user on 16/4/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef NS_ENUM(NSUInteger,AlertTagForUpgrade) {
    AlertTagForUpgradeDefault = 100,
    AlertTagForUpgradeForce,
    AlertTagForOpenURLFail
};

#import "AppManager.h"
#import "UserManager.h"

@implementation AppManager
{
    AppModel *upgradeM;
}

+ (instancetype)shareManager {
    static AppManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppManager alloc] init];
    });
    return manager;
}

- (void)getSystemVersionInfo {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    AppModel *appm = [AppModel new];
    appm.dqVersioncode = infoDictionary[@"versionCode"];
    appm.appname = APP_versionName;
    appm.versionSource = @"APP";

    NSDictionary *paraDic = @{@"dqVersioncode":appm.dqVersioncode,
                              @"appname":appm.appname,
                              @"versionSource":appm.versionSource};
    
    [AppManager zj_requestForGetAppInfoWithModel:[AppModel class] paraDic:paraDic Success:^(id obj) {
        upgradeM = obj;
        if (appm.dqVersioncode.integerValue < upgradeM.versioncode.integerValue) {
            if (upgradeM.isforceupgrade) {
                [self alertForUpgradeForce];
            }
        }
    } failed:^(id obj) {

    }];
}

+ (void)zj_requestForGetAppInfoWithModel:(Class)modelClass
                                 paraDic:(NSDictionary *)paraDic
                                 Success:(SuccessBlock)success
                                  failed:(FailedBlock)failed {
    NSLog(@"zj_requestForGetAppStoreInfoWithModel paraDic  = %@",[NSString jsonStringWithDictionary:paraDic]);
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_SUP WithPort:A_PORT_SUP WithPath:API_VersionInfo] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *recvDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"get appStore info RecDic = %@",recvDic);
        if (![NSString isEmptyOrNull:recvDic[@"code"]] && [recvDic[@"code"] isEqualToString:@"success"]) {
            id recvM = [AppManager decodeJsonDataFromAppStoreInfo:recvDic
                                                        withModel:modelClass];
            success(recvM);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"get appStore info fail");
    }];

}

+ (id)decodeJsonDataFromAppStoreInfo:(NSDictionary *)jsonDic
                           withModel:(Class)modelClass{
    if ([NSDictionary isDicEmptyOrNull:jsonDic]) {
        return nil;
    }
    
    if (modelClass == [AppModel class]) {
        NSDictionary *beanDic = jsonDic[@"bean"];
        if (![NSDictionary isDicEmptyOrNull:beanDic]) {
            AppModel *appM = [AppModel new];
            appM.appUrl         = [NSString stringFromat:beanDic[@"appUrl"]];
            appM.descript    = [NSString stringFromat:beanDic[@"description"]];
            appM.devicename     = [NSString stringFromat:beanDic[@"devicename"]];
            appM.devicetype     = [NSString stringFromat:beanDic[@"devicetype"]];
            appM.isforceupgrade = [beanDic[@"isforceupgrade"] boolValue];
            appM.upgradesize    = [NSString stringFromat:beanDic[@"upgradesize"]];
            appM.upgradeurl     = [NSString stringFromat:beanDic[@"upgradeurl"]];
            appM.versioncode    = [NSString stringFromat:beanDic[@"versioncode"]];
            appM.versionname    = [NSString stringFromat:beanDic[@"versionname"]];
            return appM;
        }
    }
    return nil;
}

#pragma mark - Alert
- (void)alertForUpgradeForce {
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"立即更新"
                                           otherButtonTitles:nil, nil];
    
    UILabel *textL = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:13];
    textL.font = font;
    textL.textColor = [UIColor blackColor];
    textL.lineBreakMode = NSLineBreakByWordWrapping;
    textL.numberOfLines = 0;
    textL.textAlignment = NSTextAlignmentLeft;
 
    textL.text = upgradeM.descript;
    [alertV setValue:textL forKey:@"accessoryView"];
    alertV.tag = AlertTagForUpgradeForce;
    [alertV show];
}

- (void)alertForOpenURLFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"无法打开下载链接"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag = AlertTagForOpenURLFail;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex");
    if (alertView.tag == AlertTagForUpgradeForce) {
        if ([[UIApplication sharedApplication]
                canOpenURL:[NSURL URLWithString:upgradeM.upgradeurl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upgradeM.upgradeurl]];
        }
        else {
            [self alertForOpenURLFail];
        }
    }
    else if (alertView.tag == AlertTagForOpenURLFail) {
        [self alertForUpgradeForce];
    }
}

@end
