//
//  BingingXQModel.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//
typedef NS_ENUM(NSUInteger, XQRenZhengType) {
    XQRenZhengTypeWaitCheck = 1,
    XQRenZhengTypeSuccess,
    XQRenZhengTypeFailCheck,
    XQRenZhengTypeNone
};

#import "BaseEntity.h"

@interface BingingXQModel : BaseEntity

@property(nonatomic,strong)NSArray *list; //集合对象

@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *xqNo;

@property(nonatomic,copy)NSString *orderBy; //排序方式
@property(nonatomic,copy)NSString *orderType; //逆序、顺序
@property(nonatomic,copy)NSString *merberId;        //会员ID
@property(nonatomic,copy)NSString *xqAdress; //小区地址(省市区)

@property(nonatomic,copy)NSString *propCommunityhouse; //小区信息
@property(nonatomic,copy)NSString *xqName;          //小区名称
@property(nonatomic,copy)NSString *cityid;          //城市ID
@property(nonatomic,copy)NSString *bindingId; //小区绑定ID
@property(nonatomic,copy)NSString *smstype; //业务类型
@property(nonatomic,copy)NSString *identity; //与业主的关系

@property(nonatomic,copy)NSString *wyId; //物业ID
@property(nonatomic,copy) NSString *userName; //用户名字
@property(nonatomic,copy) NSString *userPhone; //用户电话
@property(nonatomic,copy)NSString *code;//验证码
@property(nonatomic,strong)NSArray *imgPath; //小区图片
@property(nonatomic,copy)NSString *longitude; //经度
@property(nonatomic,copy)NSString *latitude; //纬度
@property(nonatomic,copy)NSString *xqHouse; //小区楼栋，单元，房号

@property(nonatomic,copy)NSString *isBinding;   //是否已绑定
@property(nonatomic,copy)NSString *isCheckPass; //是否验证通过 1：待认证 2：已认证：3认证失败
@property(nonatomic,assign)XQRenZhengType isCheckPassType; //自己添加的状态 ，标示验证的状态,通过此字段判断目前的验证情况

@property(nonatomic,copy)NSString *isCustomized; //是否定制
@property(nonatomic,copy)NSString *isSupport; //是否物业商家模块自营

//权限控制
@property(nonatomic,copy)NSString *propertyConst; //物业管理费是否有权限
@property(nonatomic,copy)NSString *parkingFees; //停车费是否有权限
@property(nonatomic,copy)NSString *pass; //通行证是否有权限
@property(nonatomic,copy)NSString *complaints; //投诉是否有权限
@property(nonatomic,copy)NSString *repair; //报修是否有权限
@property(nonatomic,copy)NSString *opinion; //意见和建议是否有权限

@property(nonatomic,copy)NSString *floorNumber;
@property(nonatomic,copy)NSString *unitNumber;
@property(nonatomic,copy)NSString *roomNumber;   //房号
@property(nonatomic,copy)NSString *floorName;   //楼栋
@property(nonatomic,copy)NSString *unitName;    //单元

@property(nonatomic,copy)NSString *roomId;//房号ID


@property(nonatomic,copy)NSString *cityName;        //市区名称
@property(nonatomic,copy)NSString *areaname;        //区域名称


@end
