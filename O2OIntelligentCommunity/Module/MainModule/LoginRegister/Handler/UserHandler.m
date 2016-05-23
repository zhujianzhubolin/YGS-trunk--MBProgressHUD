//
//  LoginHandler.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "UserHandler.h"
#import "NetworkRequest.h"  
#import "APIConfig.h"
#import "BaseHandler.h"
#import <SVProgressHUD.h>
#import "UserEntity.h"
#import "UserManager.h"
#import "bindingHandler.h"
#import "AppDelegate.h"
#import "MainTBViewController.h"
#import "LoginStorage.h"

@implementation UserHandler
- (void)executeLoginTaskWithUser:(UserEntity *)user
                         success:(SuccessBlock)success
                          failed:(FailedBlock)failed {
       NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                user.accountName,@"accountName",
                                user.password,@"password",
                                user.loginType,@"loginType",
                                user.reference,@"reference",
                                nil];
    NSLog(@"LoginparaDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerDefailt];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_LOGIN] requestType:ZJHttpRequestPost parameters:paraDic prepareExecute:^{

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"LoginTask dic_json = %@",dic_json);
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success) {
            if (![NSString isEmptyOrNull:dic_json[@"code"]]) {
                if ((self.loginMode == LoginModeYFB && [dic_json[@"code"] isEqualToString:@"303"]) ||
                    (self.loginMode == LoginModeYGS && [dic_json[@"code"] isEqualToString:@"success"])) {
                    [LoginStorage encodeUserDic:dic_json];
                    [UserHandler decodeLoginUser:dic_json];
                    success([UserManager shareManager].userModel);
                    return;
                }
            }
        }
        
        UserOwnEntity *userEntity = [UserOwnEntity new];
        userEntity.code = dic_json[@"code"];
        userEntity.message = dic_json[@"message"];
        failed(userEntity);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UserOwnEntity *userEntity = [UserOwnEntity new];
        userEntity.message = W_ALL_FAIL_GET_DATA;
        failed(userEntity);
        NSLog(@"request failed = %@",error);
    }];
}

+ (void)decodeLoginUser:(NSDictionary *)dicJson {
    [UserManager shareManager].userModel.code       = [NSString stringFromat:dicJson[@"code"]];
    [UserManager shareManager].userModel.message    = [NSString stringFromat:dicJson[@"message"]];
    
    [UserManager shareManager].comModel = [BingingXQModel new];
    NSDictionary *userDic = dicJson[@"member"];

    if ([NSDictionary isDicEmptyOrNull:userDic]) {
        return;
    }
    
    if (![NSString isEmptyOrNull:userDic[@"memberId"]]) {
        [UserManager shareManager].userModel.memberId = userDic[@"memberId"];
    }
    
    [UserManager shareManager].comModel.xqAdress    = [NSString stringFromat:userDic[@"xqAdress"]];
    [UserManager shareManager].comModel.wyId        = [NSString stringFromat:userDic[@"wyId"]];
    [UserManager shareManager].comModel.xqName      = [NSString stringFromat:userDic[@"xqName"]];
    [UserManager shareManager].comModel.bindingId   = [NSString stringFromat:userDic[@"bindingId"]];
    [UserManager shareManager].comModel.xqNo        = [NSString stringFromat:userDic[@"xqId"]];
    [UserManager shareManager].userModel.isCardActivate       = [NSString stringFromat:userDic[@"isCardActivate"]];
    [UserManager shareManager].userModel.memberId             = [NSString stringFromat:userDic[@"memberId"]];
    [UserManager shareManager].userModel.phone                = [NSString stringFromat:userDic[@"phone"]];
    [UserManager shareManager].userModel.accountName          = [NSString stringFromat:userDic[@"accountName"]];
    [UserManager shareManager].userModel.nickName             = [NSString stringFromat:userDic[@"nickName"]];
    [UserManager shareManager].userModel.photoUrl             = [NSString stringFromat:userDic[@"photoUrl"]];
    [UserManager shareManager].userModel.optCounter           = [NSString stringFromat:userDic[@"optCounter"]];
    
    NSDictionary *mbHouseBindingDic = userDic[@"mbHouseBinding"];
    if (![NSDictionary isDicEmptyOrNull:mbHouseBindingDic]) {
        [UserManager shareManager].comModel.isCheckPass     = [NSString stringFromat:mbHouseBindingDic[@"isCheckPass"]];
        [UserManager shareManager].comModel.isBinding       = [NSString stringFromat:mbHouseBindingDic[@"isBinding"]];

        [UserManager shareManager].comModel.merberId        = [NSString stringFromat:mbHouseBindingDic[@"memberId"]];
        
        [UserManager shareManager].comModel.floorNumber     = [NSString stringFromat:mbHouseBindingDic[@"floorNumber"]];
        
        if (![NSString isEmptyOrNull:mbHouseBindingDic[@"unitNumber"]]) {
            [UserManager shareManager].comModel.unitNumber  = [NSString stringFromat:mbHouseBindingDic[@"unitNumber"]];
        }
        
        if (![NSString isEmptyOrNull:mbHouseBindingDic[@"unitName"]]) {
            [UserManager shareManager].comModel.unitName    = [NSString stringFromat:mbHouseBindingDic[@"unitName"]];
        }
        
        [UserManager shareManager].comModel.unitNumber      = [NSString stringFromat:mbHouseBindingDic[@"unitNumber"]];
        [UserManager shareManager].comModel.roomNumber      = [NSString stringFromat:mbHouseBindingDic[@"roomNumber"]];
        [UserManager shareManager].comModel.floorName       = [NSString stringFromat:mbHouseBindingDic[@"floorName"]];
        
        if ([NSString isEmptyOrNull:[UserManager shareManager].comModel.unitName]) {
            [UserManager shareManager].comModel.xqHouse         = [NSString stringWithFormat:@"%@%@",[UserManager shareManager].comModel.floorName,[UserManager shareManager].comModel.roomNumber];
        }
        else {
            [UserManager shareManager].comModel.xqHouse         = [NSString stringWithFormat:@"%@%@%@",[UserManager shareManager].comModel.floorName,[UserManager shareManager].comModel.unitName,[UserManager shareManager].comModel.roomNumber];
        }
    }
    
    NSDictionary *memberProfileBeanDic = userDic[@"memberProfileBean"];
    if (![NSDictionary isDicEmptyOrNull:memberProfileBeanDic]) {
        [UserManager shareManager].userModel.realName             = [NSString stringFromat:userDic[@"memberProfileBean"][@"realName"]];
    }
    
    NSDictionary *xqDic = userDic[@"propCommunityhouse"];
    if (![NSDictionary isDicEmptyOrNull:xqDic]) {
        [UserManager shareManager].comModel.cityid              = [NSString stringFromat:xqDic[@"cityId"]];
        [UserManager shareManager].comModel.longitude           = [NSString stringFromat:xqDic[@"longitudu"]];
        [UserManager shareManager].comModel.latitude            = [NSString stringFromat:xqDic[@"latitude"]];

        //小区的部分权限
        [UserManager shareManager].comModel.propertyConst       =[NSString stringFromat:xqDic[@"propertyConst"]];
        [UserManager shareManager].comModel.parkingFees         =[NSString stringFromat:xqDic[@"parkingFees"]];
        [UserManager shareManager].comModel.pass                =[NSString stringFromat:xqDic[@"pass"]];
        [UserManager shareManager].comModel.complaints          =[NSString stringFromat:xqDic[@"complaints"]];
        [UserManager shareManager].comModel.repair              =[NSString stringFromat:xqDic[@"repair"]];
        [UserManager shareManager].comModel.opinion             =[NSString stringFromat:xqDic[@"opinion"]];
        
        NSDictionary *propAreaDic = xqDic[@"propArea"];
        if (![NSDictionary isDicEmptyOrNull:propAreaDic]) {
            [UserManager shareManager].comModel.areaname = [NSString stringFromat:propAreaDic[@"areaname"]];
        }
        
        NSDictionary *propCityDic = xqDic[@"propCity"];
        if (![NSDictionary isDicEmptyOrNull:propCityDic]) {
            [UserManager shareManager].comModel.cityName = [NSString stringFromat:propCityDic[@"areaname"]];
        }
        
        NSDictionary *propCompanynDic = xqDic[@"propCompany"];
        if (![NSDictionary isDicEmptyOrNull:propCompanynDic]) {
            [UserManager shareManager].userModel.telphone             = [NSString stringFromat:propCompanynDic[@"telphone"]];
        }
    }
    
    NSDictionary *memberVipcardBeanDic = userDic[@"memberVipcardBean"];
    if (![NSDictionary isDicEmptyOrNull:memberVipcardBeanDic]) {
        [UserManager shareManager].userModel.integral                     = [NSString stringFromat:memberVipcardBeanDic[@"integral"]];
        [UserManager shareManager].userModel.tradeMenoy                   = [NSString stringFromat:memberVipcardBeanDic[@"tradeMenoy"]];
    }
}

+ (void)logout {
    [UserManager shareManager].comModel     = [BingingXQModel new];
    [UserManager shareManager].userModel    = [UserOwnEntity new];
    [LoginStorage encodeUserDic:[NSDictionary new]];
}

//获取用户信息参数
+ (void)executeGetUserInfoSuccess:(SuccessBlock)success
                           failed:(FailedBlock)failed {
    
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UserManager shareManager].userModel.memberId,@"memberId",
                             nil];
    
    NSLog(@"paraDic = %@",paraDic);
    [[NetworkRequest defaultRequest] requestSerializerJson];
    [[NetworkRequest defaultRequest] requestWithPath:[BaseHandler requestUrlWithHost:A_HOST_MDM WithPort:A_PORT_MDM WithPath:A_PATH_GET_MEMBERINFO] requestType:ZJHttpRequestGet parameters:paraDic prepareExecute:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([NSJSONSerialization isValidJSONObject:dic_json] && success && ![NSString isEmptyOrNull:dic_json[@"code"]] && [dic_json[@"code"] isEqualToString:@"success"]) {
            NSLog(@"executeGetUserInfoWithModeldic_json = %@",dic_json);
            [LoginStorage encodeUserDic:dic_json];
            [UserHandler decodeLoginUser:dic_json];
            success(nil);
            return;
        }
        failed(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil);
        NSLog(@"request failed = %@",error);
    }];
}
@end
