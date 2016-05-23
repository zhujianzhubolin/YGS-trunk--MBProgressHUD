//
//  WeChatPayClass.h
//  O2OIntelligentCommunity
//
//  Created by app on 15/8/5.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
#import "WXApi.h"

//支付结果回调页面
#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"

//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

@interface WeChatPayClass : NSObject

//预支付网关url地址
@property (nonatomic,strong) NSString* payUrl;

//debug信息
@property (nonatomic,strong) NSMutableString *debugInfo;
@property (nonatomic,assign) NSInteger lastErrCode;//返回的错误码

//商户关键信息
@property (nonatomic,strong) NSString *appId,*mchId,*spKey;


//初始化函数
-(id)initWithAppID:(NSString*)appID
             mchID:(NSString*)mchID
             spKey:(NSString*)key;

//获取当前的debug信息
-(NSString *) getDebugInfo;

//获取预支付订单信息（核心是一个prepayID）
- (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name
                                         price:(NSString*)price
                                        device:(NSString*)device

                                         order:(NSString *)order;
+ (void)wxPayWithOrderName:(NSString*)name price:(NSString*)price order:(NSString *)order;
@end
