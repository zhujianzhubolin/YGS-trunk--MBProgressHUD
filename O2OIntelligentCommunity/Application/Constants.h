//
//  Constants.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/6/17.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_CELL_ID @"systemCell"
#define SYSTEM_CELL_Col_ID @"systemColCellID"
//COLOR
#define COLOR_MAIN @"eeeeea"

//APP INFO
#define APP_NAME @"AppName"
#define VERSION @"v0.1.0"
//#define COPYRIGHT @"Copyright @2014 ZLYCARE All Rights Reserved"
#define SYSTEMVERYION [[UIDevice currentDevice].systemVersion doubleValue]
//FONT SIZE
#define FONT_SIZE 15.0f

//常用间隔
#define G_INTERVAL                      10
#define G_INTERVAL_BIG                  15
///// NSError userInfo key that will contain response data
//#define JSONResponseSerializerWithDataKey @"JSONResponseSerializerWithDataKey"

//Notification key
#define k_NOTI_NETWORK_ERROR @"k_NOTI_NETWORK_ERROR"        //网络异常
#define k_NOTI_VERSION_UPDATE @"k_NOTI_VERSION_UPDATE"      //版本更新通知

//信息提示
#define TEXT_NETWORK_ERROR @"网络异常，请检查网络连接"
#define TEXT_SERVER_NOT_RESPOND @"服务器或网络异常,请稍后重试"

#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

#define VIEW_IPhone4_INCH ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO) //判断是3.5英寸的屏

#define VIEW_IPhone5_INCH ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //判断是4.0英寸的屏

#define VIEW_IPhone6_INCH ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO) //判断是4.7英寸的屏

#define VIEW_IPhone6P_INCH ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//判断是不是 6P

@interface Constants : NSObject

@end
