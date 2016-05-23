//
//  LocalUtils.m
//  O2OIntelligentCommunity
//
//  Created by user on 15/7/29.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//


#import "LocalUtils.h"
#import "UserManager.h"
#import "NSString+wrapper.h"    

@implementation LocalUtils

+ (NSString *)stringFotFilePostType:(FilePostType)type {
    switch (type) {
        case FilePostTypeNotice:
            return @"NOTICE";
        case FilePostTypeRepair:
            return @"REPAIR";
        case FilePostTypeComplaint:
            return @"COMPLAINT";
        case FilePostTypePlayTogether:
            return @"PLAYTOGETHER";
        case FilePostTypeHelpGroup:
            return @"HELPGROUP";
        case FilePostTypeSecondhandgoods:
            return @"SECONDHANDGOOGS";
        case FilePostTypeGossip:
            return @"GOSSIP";
        default:
            return nil;
    }
}

+ (NSString *)titleForChargeType:(ChargeType)type {
    switch (type) {
        case ChargeTypeWater:
            return @"水费";
        case ChargeTypeElec:
            return @"电费";
        case ChargeTypeCoal:
            return @"燃气费";
        case ChargeTypeProperty:
            return @"物业管理费";
        case ChargeTypePark:
            return @"停车费";
        case ChargeTypeTraffic:
            return @"交通罚款费";
        case ChargeTypePhone:
            return @"话费充值";
        default:
            return nil;
    }
}

//缴费body参数
+ (NSString *)chargeBodyForCharegeType:(ChargeType)chargeType {
    switch (chargeType) {
        case ChargeTypeWater:
        case ChargeTypeElec:
        case ChargeTypeCoal:
            return @"生活缴费";
        case ChargeTypeTraffic:
            return @"交通罚款";
            break;
        case ChargeTypePhone:
            return @"话费充值";
            break;
        case ChargeTypeProperty:
            return @"物业费";
            break;
        case ChargeTypePark:
            return @"停车费";
            break;
        case ChargeTypeOnlineShop:
            return @"网购";
            break;
        case ChargeTypeWalletRecharge:
            return @"钱包充值";
            break;
        default:
            break;
    }
}

+ (NSString *)chargeStrForChargeType:(ChargeType)type {
    switch (type) {
        case ChargeTypeWater:
            return @"6011";
        case ChargeTypeElec:
            return @"6012";
        case ChargeTypeCoal:
            return @"6013";
        default:
            break;
    }
    return nil;
}

+ (NSString *)merchantsCategoryForCategoryID:(NSUInteger)categoryId {
    switch (categoryId) {
        case 2600:
            return @"全部分类";
        case 2601:
            return @"便利店";
        case 2602:
            return @"家政服务";
        case 2603:
            return @"网上商城";
        case 2604:
            return @"教育培训";
        case 2650:
            return @"美容美甲";
        case 2651:
            return @"休闲娱乐";
        case 2652:
            return @"汽车美容";
        case 2653:
            return @"运动健身";
        case 2654:
            return @"婚庆摄影";
        case 2655:
            return @"鲜花礼品";
        case 2656:
            return @"景点门票";
        case 2657:
            return @"旅游酒店";
        case 2658:
            return @"飞机票";
        case 2659:
            return @"火车";
        case 2700:
            return @"叫外卖";
        default:
            return @"";
            break;
    }
    return nil;
}

+ (NSString *)payTypeStrForPayType:(PayType)payType {
    switch (payType) {
        case PayTypeQianBao:
            return @"qbPay";
        case PayTypeWeiXin:
            return @"wxPay";
        default:
            break;
    }
    return nil;
}

+ (BOOL)isSepcialCity:(NSString *)city {
    NSArray *specialCitys = @[@"京",@"沪",@"津",@"渝"];
    
    __block BOOL isSepcialCity = NO;
    
    [specialCitys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([city isEqualToString:obj]) {
            isSepcialCity = YES;
            *stop = YES;
        }
    }];
    return isSepcialCity;
}

@end
