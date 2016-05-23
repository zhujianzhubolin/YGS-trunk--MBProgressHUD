//
//  ChargeOrderE.h
//  O2OIntelligentCommunity
//
//  Created by user on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ChargeOrderE : BaseEntity

@property (nonatomic, copy) NSString *saleAmount; //面额
@property (nonatomic, copy) NSString *memberInfoPid; //用户登录id
@property (nonatomic, copy) NSString *usernumber; //手机号码
@property (nonatomic, copy) NSString *payAmount; //用户支付的价格
@property (nonatomic, copy) NSString *totalFee; 

@property (nonatomic, copy) NSString *spbillCreateIp; //手机ip地址
@property (nonatomic, copy) NSString *body; //
@property (nonatomic, copy) NSString *appid; //AppId
@property (nonatomic, copy) NSString *mchId; //商户Id
@property (nonatomic, copy) NSString *tradeType; //交易类型
@property (nonatomic, copy) NSString *key; //商户秘钥
@property (nonatomic, copy) NSString *infoId; //数据库ID，用于提交多个物业单和罚款单等
@property (nonatomic, copy) NSString *pay_company;//支付公司
@property (nonatomic, copy) NSString *pay_method;//支付方式
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *infoNo; 
@property (nonatomic, copy) NSString *userToken;

@property (nonatomic, copy) NSString *licenseNumber;//车牌号
@property (nonatomic, copy) NSString *attach;//

@property (nonatomic, copy) NSString *mouths;//缴费时长
@property (nonatomic, copy) NSString *monthlyFee;//缴费方式下的缴费额度
@property (nonatomic, copy) NSString *parkingType;//缴费方式
@property (nonatomic, copy) NSString *endDate; //缴费时间

@property (nonatomic, copy) NSString *domesticWasteFee; //垃圾处理费
@property (nonatomic, copy) NSString *ontologyGold; //本体金
@property (nonatomic, copy) NSString *dischargeFee; //排污费
@property (nonatomic, copy) NSString *managementFee; //管理费
@property (nonatomic, copy) NSString *electricity;
@property (nonatomic, copy) NSString *water;
@property (nonatomic, copy) NSString *coal;
@property (nonatomic, copy) NSString *overdueFine;

@property (nonatomic, copy) NSString *chargeUnit; //水电燃缴费单位
@property (nonatomic, copy) NSString *userName;//用户姓名
@property (nonatomic, copy) NSString *sdmType; //水电燃类型
@property (nonatomic, copy) NSString *userNumber; //用户编号
@property (nonatomic, copy) NSString *contNo; //订单号
@property (nonatomic, copy) NSString *contentNo; //明细id
@property (nonatomic, copy) NSString *prepaIdFlag; //缴费类型
@property (nonatomic, copy) NSString *address; //返回地址

@property (nonatomic, copy) NSString *xqNo; //小区ID
@property (nonatomic, copy) NSString *wyNo; //物业ID
@property (nonatomic, copy) NSString *buildNo;//楼栋Id
@property (nonatomic, copy) NSString *unitNo;//单元Id
@property (nonatomic, copy) NSString *houseNo;//房屋Id
@property (nonatomic, copy) NSString *cityNo;//cityID
@property (nonatomic, copy) NSString *orderSource;//交易类型 订单来源 IOS、安卓传 APP 、微信传WX 、终端传 ZD

@end
