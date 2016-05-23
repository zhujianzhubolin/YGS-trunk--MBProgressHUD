//
//  LiJiFuKuanVC.h
//  O2OIntelligentCommunity
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 yiGongShe. All rights reserved.
//



#import "O2OBaseViewController.h"
#import "MineBuyShopsM.h"

typedef void(^PaySuccessBlock)();

@interface LiJiFuKuanVC : O2OBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)MineBuyShopsM *buyshopsM;
@property (nonatomic,copy)NSString *mobPhoneNum;//收货人手机号
@property (nonatomic,strong)PaySuccessBlock paySuccessBlock;

@end
