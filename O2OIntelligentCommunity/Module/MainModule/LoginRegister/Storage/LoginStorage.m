//
//  LoginStorage.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/18.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "LoginStorage.h"
#import "UserDefaultsUtils.h"
#import "ZJSandboxHelper.h" 

static NSString * const User_Name           = @"username";
static NSString * const User_ID             = @"userID";
static NSString * const User_Phone          = @"phone";
static NSString * const User_Info           = @"Info";
static NSString * const User_firstUse       = @"firstUse";
static NSString * const kArchivingDataKey   = @"ArchivingData";
static NSString * const UserInfoFile        = @"userInfo.txt";

@implementation LoginStorage

+ (void)saveUserName:(NSString *)userName
{
    [UserDefaultsUtils saveValue:userName forKey:User_Name];
}

+ (NSString *)userName
{
    return [UserDefaultsUtils valueWithKey:User_Name];
}

+ (void)saveUid:(NSString *)uid {
    [UserDefaultsUtils saveValue:uid forKey:User_ID];
}

+ (NSString *)userID {
    return [UserDefaultsUtils valueWithKey:User_ID];
}

+ (void)savePhone:(NSString *)phone {
    [UserDefaultsUtils saveValue:phone forKey:User_Phone];
}

+ (NSString *)userPhone {
    return [UserDefaultsUtils valueWithKey:User_Phone];
}

+ (void)saveUserNoFirstUse:(BOOL)isFirst {
    [UserDefaultsUtils saveBoolValue:isFirst withKey:User_firstUse];
}

+ (BOOL)userNoFisrtUse {
     return [UserDefaultsUtils boolValueWithKey:User_firstUse];
}

+ (void)saveUserInfo:(NSDictionary *)userInfo {
    [UserDefaultsUtils saveObject:userInfo forKey:User_Info];
}

+ (NSDictionary *)userInfo {
    return [UserDefaultsUtils objectWithKey:User_Info];
}

+ (void)encodeUserDic:(NSDictionary *)dicJson {
    //存储数据到类
    UserArchive *archivingData = [[UserArchive alloc] init];
    archivingData.userInfo = dicJson;
    
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:archivingData forKey:kArchivingDataKey]; // archivingDate的encodeWithCoder方法被调用
    [archiver finishEncoding];
    //写入文件
    
    [data writeToFile:[[ZJSandboxHelper docPath] stringByAppendingPathComponent:UserInfoFile] atomically:YES];
}

+ (NSDictionary *)decodeUserDic {
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[[ZJSandboxHelper docPath] stringByAppendingPathComponent:UserInfoFile]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //获得类
    UserArchive *archivingData = [unarchiver decodeObjectForKey:kArchivingDataKey];// initWithCoder方法被调用
    [unarchiver finishDecoding];
    
    //读取的数据
    return archivingData.userInfo;
}

@end
