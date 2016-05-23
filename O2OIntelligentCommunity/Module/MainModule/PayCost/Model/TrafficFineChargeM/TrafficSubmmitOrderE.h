//
//  TrafficSubmmitOrderE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface TrafficSubmmitOrderE : BaseEntity

@property (nonatomic, copy) NSString *carnumber;//违章车牌号
@property (nonatomic, copy) NSString *carcode;//违章车架号
@property (nonatomic, copy) NSString *cardrivenumber;//违章发动机号
@property (nonatomic, copy) NSString *Archive;//通知书编号
@property (nonatomic, copy) NSString *count;//违章罚款金额
@property (nonatomic, copy) NSString *Location;//违章地点
@property (nonatomic, copy) NSString *poundage;//手续费
@property (nonatomic, copy) NSString *reason;//违章原因
@property (nonatomic, copy) NSString *secondaryUniqueCode;//违章记录ID
@property (nonatomic, copy) NSString *time;//违章时间
@property (nonatomic, copy) NSString *sn;//终端sn号
@property (nonatomic, copy) NSString *memberInfoPid;//用户Id
@property (nonatomic, copy) NSString *appid;//公众账号ID
@property (nonatomic, copy) NSString *body;//商品描述
@property (nonatomic, copy) NSString *device_info;//设备号
@property (nonatomic, copy) NSString *mch_id;//商户号
@property (nonatomic, copy) NSString *nonce_str;//随机字符串
@property (nonatomic, copy) NSString *attach;//附加数据
@property (nonatomic, copy) NSString *openid;//用户标识
@property (nonatomic, copy) NSString *trade_type;//交易类型
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *spbill_create_ip;//终端IP
@property (nonatomic, copy) NSString *total_fee;//总金额
@property (nonatomic, copy) NSString *pay_company;//tx:腾讯 cm:移动
@property (nonatomic, copy) NSString *pay_method;//weixin：微信支付； cmhb：移动的和包支付
@property (nonatomic, copy) NSString *degree;//违章扣分
@property (nonatomic, copy) NSString *code; //违章代码
@property (nonatomic, copy) NSString *wyNo; //物业ID
@property (nonatomic, copy) NSString *orderSource;//交易类型 订单来源 IOS、安卓传 APP 、微信传WX 、终端传 ZD
@property (nonatomic, copy) NSString *merchantName;//商家名称（增值业务没有商家名称的情况下传增值业务名称）
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *xqNo;

@end
