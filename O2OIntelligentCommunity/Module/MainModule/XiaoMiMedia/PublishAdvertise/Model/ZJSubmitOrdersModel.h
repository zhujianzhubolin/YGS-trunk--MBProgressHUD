//
//  ZJSubmitOrdersModel.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/31.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseHandler.h"

@interface ZJSubmitOrdersModel : BaseHandler

@property(nonatomic,copy) NSString * ytOrTemplate;          //原图还是模版
@property(nonatomic,copy) NSString * templateConfigId;      //模版id
@property(nonatomic,copy) NSString * ggImgSrcBefore;
@property(nonatomic,copy) NSString * ggSizePxBefore;
@property(nonatomic,copy) NSString * ggSizeMBefore;
@property(nonatomic,copy) NSString * chargeConfigId;        //规则id，逗号隔开
@property(nonatomic,copy) NSString * terminalNo;            //终端机编号，逗号隔开
@property(nonatomic,copy) NSString * memberId;
@property(nonatomic,copy) NSString * ID;
@property(nonatomic,copy) NSString * wyNo;
@property(nonatomic,copy) NSString * xqNo;
@property(nonatomic,copy) NSString * ggServiceDateStart;     //预约播放时间-开始
@property(nonatomic,copy) NSString * ggServiceDateEnd;       //预约播放时间-开始
@property(nonatomic,copy) NSString * ggTitle;                //广告标题
@property(nonatomic,copy) NSString * linkmanName;            //姓名
@property(nonatomic,copy) NSString * linkmanPhone;           //手机号码
@property(nonatomic,copy) NSString * remarkUser;             //用户留言
@property(nonatomic,copy) NSString * tradeType;              //交易类型
@property(nonatomic,copy) NSString * payType;                //支付方式
@property(nonatomic,copy) NSString * attach;                 //下单时用来区分收款帐号的那个参数
@property(nonatomic,copy) NSString * appId;                  //应用id
@property(nonatomic,copy) NSString * userToking;
@property(nonatomic,copy) NSString * ggText1;                //图片上的文本1
@property(nonatomic,copy) NSString * ggText1Xy;              //图片上的文本1位置坐标:格式(x,y),(x,y)。
@property(nonatomic,copy) NSString * ggText1Zt;              //图片上的文本1的字体：st：宋体。
@property(nonatomic,copy) NSString * ggText1Fontsize;        //图片上的文本1的字号大小：20到80之间的整数
@property(nonatomic,copy) NSString * ggText2;
@property(nonatomic,copy) NSString * ggText2Xy;
@property(nonatomic,copy) NSString * ggText2Zt;
@property(nonatomic,copy) NSString * ggText2Fontsize;
@property(nonatomic,copy) NSString * ggText3;
@property(nonatomic,copy) NSString * ggText3Xy;
@property(nonatomic,copy) NSString * ggText3Zt;
@property(nonatomic,copy) NSString * ggText3Fontsize;
@property(nonatomic,copy) NSString * chargeAmout;            //金额



@end
