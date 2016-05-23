//
//  AppModel.h
//  O2OIntelligentCommunity
//
//  Created by user on 16/4/21.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//

#import "BaseEntity.h"

@interface AppModel : BaseEntity

@property (nonatomic,copy) NSString *dqVersioncode; //当前版本号
@property (nonatomic,copy) NSString *appname; //版本应用名称
@property (nonatomic,copy) NSString *versionSource; //版本来源

@property (nonatomic,copy) NSString *appUrl;
@property (nonatomic,copy) NSString *descript;
@property (nonatomic,copy) NSString *devicename;
@property (nonatomic,copy) NSString *devicetype;
@property (nonatomic,assign) BOOL isforceupgrade;
@property (nonatomic,copy) NSString *upgradesize;
@property (nonatomic,copy) NSString *upgradeurl;
@property (nonatomic,copy) NSString *versioncode;
@property (nonatomic,copy) NSString *versionname;

@end
