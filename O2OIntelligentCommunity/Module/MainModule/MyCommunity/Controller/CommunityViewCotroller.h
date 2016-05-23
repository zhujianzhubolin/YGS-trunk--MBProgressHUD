//
//  CommunityViewCotroller.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//

#import "O2OBaseViewController.h"
#import "BingingXQModel.h"

typedef void(^GetXQinfoBLock)(BingingXQModel *comModel);

@interface CommunityViewCotroller : O2OBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
//判断是main界面跳转过来的，还是自己界面跳转的
@property (assign,nonatomic) CommunityChooseType communityType; //
@property (assign,nonatomic) BOOL isLoginShow; //是否从登录页面跳转过来
@property (nonatomic, strong) GetXQinfoBLock comBlock;//切换小区后的block
@property (nonatomic, assign) ComLimitsClassify comLimits; //小区权限,在communityType为CommunityChooseTypeBinding状态下才有效
@end
