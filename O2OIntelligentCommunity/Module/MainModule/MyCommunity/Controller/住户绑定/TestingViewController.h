//
//  TestingViewController.h
//  O2OIntelligentCommunity
//
//  Created by zhaoyang on 16/4/19.
//  Copyright © 2016年 yiGongShe. All rights reserved.
//
typedef void (^CommunityBindingFinishedBlock)();

#import "O2OBaseViewController.h"
#import "BingingXQModel.h"

@interface TestingViewController : O2OBaseViewController
@property(nonatomic,copy)NSString *louDongStr;
@property(nonatomic,copy)NSString *danYanStr;
@property(nonatomic,copy)NSString *fangHaoStr;
@property(nonatomic,copy)NSString *guanXiStr;
@property(nonatomic,copy)NSString *phoneStr;
@property(nonatomic,copy)NSString *roomIdStr;
@property (nonatomic,strong)BingingXQModel *xqModel;

@property (nonatomic,strong)CommunityBindingFinishedBlock comBindingFinishedBlock;



@end
