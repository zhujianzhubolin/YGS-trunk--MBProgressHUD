//
//  PaycostModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface PaycostModel : BaseEntity

@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *xqNo;

@property (nonatomic,copy)NSString *updateTime;//时间
@property (nonatomic,copy)NSString *money;//金额
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *consumeCycle;//当前月份
@property (nonatomic,copy)NSString *dateCreated;//物业费交费时间
@property (nonatomic,copy)NSString *createTime;//电话费缴费时间
@property (nonatomic,copy)NSString *name;//用户名称
@property (nonatomic,copy)NSString *saleAmount;//金额
@property (nonatomic,copy)NSString *sdmStatus;//缴费状态
@property (nonatomic,copy)NSString *statusCN;//缴费状态
@property (nonatomic,copy)NSString *userNumber;//用户编号
@property (nonatomic,copy)NSString *chargeUnit;//缴费单位  1：水、电、燃气费预缴费  2:水、电、燃气费后缴费
@property (nonatomic,copy)NSString *preapidFlag; //水电燃缴费类型
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic, copy) NSString *consumeType;//6031：物业 6032：停车
@property (nonatomic,copy)NSString *sdmType;//SDM类型
@property (nonatomic,copy)NSString *parkingType;//停车类型
@property (nonatomic,copy)NSString *licenseNumber;//停车号码
@property (nonatomic,copy)NSString *dischargeFee;//物业排污费
@property (nonatomic,copy)NSString *ontologyGold;//物业本体金
@property (nonatomic,copy)NSString *domesticWasteFee;//物业垃圾处理费
@property (nonatomic,copy)NSString *ManagementFee;//物业管理费
@property (nonatomic,copy)NSString *dateUpdated;//时间
@property (nonatomic,copy)NSString *ctype;
@property (nonatomic,copy)NSString *payMonths;
//@property (nonatomic,copy)NSString *lastUpdateTime;
@property (nonatomic,copy)NSString *payAmount;
@property (nonatomic,copy)NSString *usernumber;//手机号
@property (nonatomic,copy)NSString *poundage;//交通罚款的手续费

@property (nonatomic,copy)NSString *carType;
@property (nonatomic,copy)NSString *carnumber;
@property (nonatomic,copy)NSString *count;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *refund;//客服留言


//@property (nonatomic,strong)NSDictionary *ctSDic;//水的字典
//@property (nonatomic,strong)NSDictionary *ctDDic;//电的字典
//@property (nonatomic,strong)NSDictionary *ctMDic;//燃的字典
//@property (nonatomic,strong)NSDictionary *ctWDic;//物的字典
//@property (nonatomic,strong)NSDictionary *ctTDic;//停的类型


@end
