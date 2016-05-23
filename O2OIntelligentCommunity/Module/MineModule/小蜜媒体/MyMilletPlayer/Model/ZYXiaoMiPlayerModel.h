//
//  ZYMilletPlayerModel.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/3/22.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface ZYXiaoMiPlayerModel : BaseEntity

@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *pageNumber;
@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *totalCount;
@property(nonatomic,copy)NSString *pageCount;
@property(nonatomic,strong)NSArray *list;

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *ggTitle;//标题
@property(nonatomic,copy)NSString *status;//状态
@property(nonatomic,copy)NSString *ggServiceDateStart;//开始时间
@property(nonatomic,copy)NSString *ggServiceDateEnd;//结束时间
@property(nonatomic,copy)NSString *dateCreated;//下单时间
@property(nonatomic,copy)NSString *saleAmount;//价格

@property(nonatomic,copy)NSString *chargeConfigName;//广告播放规则
@property(nonatomic,copy)NSString *filePath;//合成后的图片
@property(nonatomic,copy)NSString *ggImgSrc;//合成后的图片
@property(nonatomic,copy)NSString *ggImgSrcSlt;//合成后的缩略图
@property(nonatomic,copy)NSString *linkmanName;//姓名
@property(nonatomic,copy)NSString *linkmanPhone;//手机号
@property(nonatomic,copy)NSString *remarkUser;//用户留言
@property(nonatomic,copy)NSString *orderIdPay;//流水号
@property(nonatomic,copy)NSString *ggText1;//规则
@property(nonatomic,copy)NSString *ggText2;//客服留言
@property(nonatomic,copy)NSString *ggText3;



@property(nonatomic,copy)NSString *ggImgSrcBefore;//图片
@end
