//
//  ZhifuModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ZhifuModel : BaseEntity

@property (nonatomic,copy)NSString *appid;  //公众账号
@property (nonatomic,copy)NSString *mch_id; //商户号
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *trade_type;//交易类型
@property (nonatomic,copy)NSString *openid;//用户标识
@property (nonatomic,copy)NSString *attach; //附加数据
@property (nonatomic,copy)NSString *body;   //商品描述
@property (nonatomic,copy)NSString *nonce_str;//随机字符串
@property (nonatomic,copy)NSString *spbill_create_ip;//终端ip
@property (nonatomic,copy)NSString *total_fee;//总金额
@property (nonatomic,copy)NSString *payType;//支付方式(wxPay:微信支付 hbPay:荷包支付)
@property (nonatomic,copy)NSString *orderNo;//本系统订单号

@property (nonatomic,copy)NSString *device_info;//设备号
@property (nonatomic,copy)NSString *userToken;//待支付手机号
@end
